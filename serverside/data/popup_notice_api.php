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
$store_file = $store_dir . DIRECTORY_SEPARATOR . 'popup_notice.json';
if (!is_dir($store_dir)) { @mkdir($store_dir, 0777, true); }

function now_ts() { return time(); }
function safe_bool($v) { return filter_var($v, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE) ?? false; }

function load_popup_notice($file, $updated_by_default) {
    if (!file_exists($file) || filesize($file) === 0) {
        return [
            'title' => 'Important Notice',
            'message' => '',
            'active' => false,
            'icon' => 'success', // success|info|warning|error
            'show_on_login' => true,
            'show_on_dashboard' => false,
            'updated_at' => now_ts(),
            'updated_by' => $updated_by_default
        ];
    }
    $raw = @file_get_contents($file);
    $data = json_decode($raw, true);
    if (!is_array($data)) { return load_popup_notice('', $updated_by_default); }
    return $data;
}

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'GET') {
    $data = load_popup_notice($store_file, $user_name_2 ?? 'system');
    $resp = ['response' => 1, 'data' => $data];
    if (ob_get_length()) { ob_clean(); }
    echo json_encode($resp);
    exit;
}

if ($method === 'POST') {
    if (!$can_write) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(403);
        echo json_encode(['response' => 0, 'msg' => 'Forbidden']);
        exit;
    }

    $raw = file_get_contents('php://input') ?: '';
    $payload = json_decode($raw, true);
    if (!is_array($payload)) { $payload = $_POST; }

    $data = load_popup_notice($store_file, $user_name_2 ?? 'system');

    // Accept fields
    if (isset($payload['title']))   { $data['title'] = trim((string)$payload['title']); }
    if (isset($payload['message'])) { $data['message'] = (string)$payload['message']; }
    if (isset($payload['active']))  { $data['active'] = safe_bool($payload['active']); }
    if (isset($payload['show_on_login']))  { $data['show_on_login'] = safe_bool($payload['show_on_login']); }
    if (isset($payload['show_on_dashboard']))  { $data['show_on_dashboard'] = safe_bool($payload['show_on_dashboard']); }
    if (isset($payload['icon'])){
        $icon = strtolower((string)$payload['icon']);
        if (in_array($icon, ['success','info','warning','error'])) { $data['icon'] = $icon; }
    }

    $data['updated_at'] = now_ts();
    $data['updated_by'] = $user_name_2 ?? 'system';

    $ok = @file_put_contents($store_file, json_encode($data, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE), LOCK_EX) !== false;
    if (!$ok) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(500);
        echo json_encode(['response' => 0, 'msg' => 'Failed to save popup notice']);
        exit;
    }

    // Log change
    $logfile = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'logs' . DIRECTORY_SEPARATOR . 'popup_notice_api.log';
    $entry = '['.date('Y-m-d H:i:s').'] by '.($user_name_2 ?? 'system')."\n";
    @file_put_contents($logfile, $entry, FILE_APPEND);

    if (ob_get_length()) { ob_clean(); }
    echo json_encode(['response' => 1, 'msg' => 'Saved', 'data' => $data]);
    exit;
}

// Unsupported method
http_response_code(405);
echo json_encode(['response' => 0, 'msg' => 'Method Not Allowed']);
