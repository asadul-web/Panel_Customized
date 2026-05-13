<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
header('Content-Type: application/json');

require_once '../../includes/functions.php';

// Always check session to get user variables
chkSession();

// Allow all users to GET; restrict write to admin roles
$user_level_2 = $user_level_2 ?? '';
$user_name_2 = $user_name_2 ?? '';
$user_id_2 = $user_id_2 ?? 0;
$can_write = in_array($user_level_2, ['administrator','superadmin','developer']) || $user_id_2 == 2;

$store_dir  = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup';
$store_file = $store_dir . DIRECTORY_SEPARATOR . 'notice.json';
if (!is_dir($store_dir)) { @mkdir($store_dir, 0777, true); }

function now_ts() { return time(); }
function safe_bool($v) { return filter_var($v, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE) ?? false; }

function load_notice($file, $updated_by_default) {
    if (!file_exists($file) || filesize($file) === 0) {
        return [
            'title' => 'Panel News Update',
            'message' => '',
            'active' => false,
            'severity' => 'info', // info|warning|danger
            'billing' => [
                'cycle_day' => null,      // 1-28 typically
                'due_date'  => null,      // ISO 8601 string
                'grace_days'=> 3,
                'auto_down' => false
            ],
            'updated_at' => now_ts(),
            'updated_by' => $updated_by_default
        ];
    }
    $raw = @file_get_contents($file);
    $data = json_decode($raw, true);
    if (!is_array($data)) { return load_notice('', $updated_by_default); }
    return $data;
}

function compute_next_due_from_cycle($cycle_day, \DateTime $base): ?\DateTime {
    if (!is_numeric($cycle_day)) { return null; }
    $day = max(1, min(28, (int)$cycle_day));
    $tz = $base->getTimezone();
    $d  = new \DateTime($base->format('Y-m-01 00:00:00'), $tz);
    $curDay = (int)$base->format('j');
    if ($curDay <= $day) {
        $d->setDate((int)$base->format('Y'), (int)$base->format('n'), $day);
    } else {
        $d->modify('first day of next month');
        $d->setDate((int)$d->format('Y'), (int)$d->format('n'), $day);
    }
    return $d;
}

function compute_status(array $data): array {
    $now = new \DateTime('now');
    $billing = $data['billing'] ?? [];
    $grace = isset($billing['grace_days']) ? (int)$billing['grace_days'] : 3;
    $autoDown = safe_bool($billing['auto_down'] ?? false);

    $dueDT = null;
    if (!empty($billing['due_date'])) {
        try { $dueDT = new \DateTime($billing['due_date']); } catch (\Throwable $e) { $dueDT = null; }
    }
    if (!$dueDT && !empty($billing['cycle_day'])) {
        $dueDT = compute_next_due_from_cycle($billing['cycle_day'], $now);
    }

    $status = 'ok';
    $panel_down = false;
    $days_remaining = null;
    $next_due_iso = null;

    if ($dueDT instanceof \DateTime) {
        $next_due_iso = $dueDT->format(DATE_ISO8601);
        $interval = $now->diff($dueDT);
        $days_remaining = (int)$interval->format('%r%a');
        if ($days_remaining < 0) {
            $status = 'past_due';
            if ($grace > 0) {
                $overdue_days = abs($days_remaining);
                if ($overdue_days > $grace) {
                    $status = 'down';
                    $panel_down = $autoDown ? true : false;
                }
            } else {
                $status = 'down';
                $panel_down = $autoDown ? true : false;
            }
        } elseif ($days_remaining <= 5) {
            $status = 'due_soon';
        } else {
            $status = 'ok';
        }
    }

    return [
        'status' => $status,
        'panel_down' => $panel_down,
        'next_due' => $next_due_iso,
        'days_remaining' => $days_remaining
    ];
}

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'GET') {
    $data = load_notice($store_file, $user_name_2 ?? 'system');
    $comp = compute_status($data);
    $data['billing'] = array_merge($data['billing'] ?? [], $comp);
    $resp = ['response' => 1, 'data' => $data];
    if (ob_get_length()) { ob_clean(); }
    echo json_encode($resp);
    exit;
}

if ($method === 'POST') {
    // Debug log
    $debug_log = dirname(__DIR__, 2) . '/logs/notice_debug.log';
    $debug_info = [
        'timestamp' => date('Y-m-d H:i:s'),
        'user_id' => $user_id_2,
        'user_level' => $user_level_2,
        'user_name' => $user_name_2,
        'can_write' => $can_write ? 'YES' : 'NO'
    ];
    @file_put_contents($debug_log, json_encode($debug_info, JSON_PRETTY_PRINT) . "\n\n", FILE_APPEND);
    
    if (!$can_write) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(403);
        echo json_encode(['response' => 0, 'msg' => 'Forbidden']);
        exit;
    }

    $raw = file_get_contents('php://input') ?: '';
    $payload = json_decode($raw, true);
    if (!is_array($payload)) { $payload = $_POST; }

    $data = load_notice($store_file, $user_name_2 ?? 'system');

    // Accept fields
    if (isset($payload['title']))   { $data['title'] = trim((string)$payload['title']); }
    if (isset($payload['message'])) { $data['message'] = (string)$payload['message']; }
    if (isset($payload['active']))  { $data['active'] = safe_bool($payload['active']); }
    if (isset($payload['severity'])){
        $sev = strtolower((string)$payload['severity']);
        if (in_array($sev, ['info','warning','danger'])) { $data['severity'] = $sev; }
    }

    if (!isset($data['billing']) || !is_array($data['billing'])) { $data['billing'] = []; }
    if (isset($payload['billing']) && is_array($payload['billing'])) {
        $b = $payload['billing'];
        if (array_key_exists('cycle_day', $b)) {
            $cd = $b['cycle_day'];
            $data['billing']['cycle_day'] = (is_numeric($cd) ? max(1, min(28, (int)$cd)) : null);
        }
        if (array_key_exists('due_date', $b)) {
            $dd = trim((string)$b['due_date']);
            $data['billing']['due_date'] = ($dd === '' ? null : $dd);
        }
        if (array_key_exists('grace_days', $b)) {
            $gd = $b['grace_days'];
            $data['billing']['grace_days'] = (is_numeric($gd) ? max(0, (int)$gd) : 3);
        }
        if (array_key_exists('auto_down', $b)) {
            $data['billing']['auto_down'] = safe_bool($b['auto_down']);
        }
    }

    $data['updated_at'] = now_ts();
    $data['updated_by'] = $user_name_2 ?? 'system';

    // Recompute and include computed fields for client convenience
    $comp = compute_status($data);
    $data['billing'] = array_merge($data['billing'] ?? [], $comp);

    $ok = @file_put_contents($store_file, json_encode($data, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE), LOCK_EX) !== false;
    if (!$ok) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(500);
        echo json_encode(['response' => 0, 'msg' => 'Failed to save notice']);
        exit;
    }

    // Log change
    $logfile = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'logs' . DIRECTORY_SEPARATOR . 'notice_api.log';
    $entry = '['.date('Y-m-d H:i:s').'] by '.($user_name_2 ?? 'system')."\n";
    @file_put_contents($logfile, $entry, FILE_APPEND);

    if (ob_get_length()) { ob_clean(); }
    echo json_encode(['response' => 1, 'msg' => 'Saved', 'data' => $data]);
    exit;
}

// Unsupported method
http_response_code(405);
echo json_encode(['response' => 0, 'msg' => 'Method Not Allowed']);
