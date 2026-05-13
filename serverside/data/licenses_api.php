<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
header('Content-Type: application/json');

require_once '../../includes/functions.php';
// Removed session check - allow public access
// chkSession();

$user_level_2 = $user_level_2 ?? '';
$role = $user_level_2;
$can_write = in_array($role, ['administrator','superadmin','developer']);

$store_dir  = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup';
$store_file = $store_dir . DIRECTORY_SEPARATOR . 'licenses.json';
$log_file   = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'logs' . DIRECTORY_SEPARATOR . 'licenses_api.log';
if (!is_dir($store_dir)) { @mkdir($store_dir, 0777, true); }

function load_licenses($file) {
    if (!file_exists($file) || filesize($file) === 0) {
        return [];
    }
    $raw = @file_get_contents($file);
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

function save_licenses($file, array $data) {
    return @file_put_contents($file, json_encode(array_values($data), JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES), LOCK_EX) !== false;
}

function gen_key($prefix = 'LIC', $bytes = 8) {
    try { $rand = bin2hex(random_bytes($bytes)); }
    catch (Throwable $e) { $rand = bin2hex(openssl_random_pseudo_bytes($bytes)); }
    if (!$rand) { $rand = bin2hex(uniqid('', true)); }
    $rand = strtoupper($rand);
    return ($prefix ? strtoupper($prefix) . '-' : '') . substr($rand,0,8) . '-' . substr($rand,8,8);
}

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'GET') {
    $list = load_licenses($store_file);
    $status = $_GET['status'] ?? '';
    $key    = $_GET['key'] ?? '';

    if ($key !== '') {
        foreach ($list as $item) {
            if (isset($item['key']) && hash_equals($item['key'], $key)) {
                if (ob_get_length()) { ob_clean(); }
                echo json_encode(['response'=>1,'data'=>$item]);
                exit;
            }
        }
        if (ob_get_length()) { ob_clean(); }
        http_response_code(404);
        echo json_encode(['response'=>0,'msg'=>'Not found']);
        exit;
    }

    if ($status !== '') {
        $list = array_values(array_filter($list, function($i) use ($status){ return ($i['status'] ?? '') === $status; }));
    }

    if (ob_get_length()) { ob_clean(); }
    echo json_encode(['response'=>1,'data'=>$list]);
    exit;
}

if ($method === 'POST') {
    if (!$can_write) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(403);
        echo json_encode(['response'=>0,'msg'=>'Forbidden']);
        exit;
    }

    // Accept JSON or form
    $raw = file_get_contents('php://input') ?: '';
    $payload = json_decode($raw, true);
    if (!is_array($payload)) { $payload = $_POST; }

    $action = $payload['action'] ?? 'create';
    $list = load_licenses($store_file);

    if ($action === 'create') {
        $count  = (int)($payload['count'] ?? 1);
        $prefix = trim((string)($payload['prefix'] ?? 'LIC'));
        $duration = (int)($payload['duration'] ?? 30); // Default 30 days
        if ($count < 1) $count = 1; if ($count > 50) $count = 50;

        $out = [];
        for ($i=0; $i<$count; $i++) {
            $key = gen_key($prefix);
            // Ensure uniqueness in current list
            $tries = 0;
            while ($tries < 5 && array_reduce($list, function($carry,$it) use ($key){ return $carry || (isset($it['key']) && $it['key']===$key); }, false)) {
                $key = gen_key($prefix);
                $tries++;
            }
            $created_time = time();
            $expires_time = $created_time + ($duration * 86400); // Convert days to seconds
            $item = [
                'key' => $key,
                'status' => 'active',
                'created_at' => $created_time,
                'expires_at' => $expires_time,
                'duration_days' => $duration,
                'domain' => '', // Empty until assigned
                'notes' => (string)($payload['notes'] ?? ''),
                'created_by' => $user_name_2 ?? 'system'
            ];
            $list[] = $item;
            $out[] = $item;
        }
        $ok = save_licenses($store_file, $list);
        if (!$ok) {
            if (ob_get_length()) { ob_clean(); }
            http_response_code(500);
            echo json_encode(['response'=>0,'msg'=>'Failed to save']);
            exit;
        }
        @file_put_contents($log_file, '['.date('Y-m-d H:i:s').'] create x'.$count.' by '.($user_name_2 ?? 'system')."\n", FILE_APPEND);
        if (ob_get_length()) { ob_clean(); }
        echo json_encode(['response'=>1,'data'=>$out]);
        exit;
    }

    if ($action === 'update') {
        $key = (string)($payload['key'] ?? '');
        if ($key==='') { if (ob_get_length()) { ob_clean(); } http_response_code(400); echo json_encode(['response'=>0,'msg'=>'Missing key']); exit; }
        $updated = false;
        foreach ($list as &$item) {
            if (isset($item['key']) && hash_equals($item['key'], $key)) {
                if (isset($payload['status']) && in_array($payload['status'], ['active','disabled'])) { $item['status'] = $payload['status']; }
                if (array_key_exists('domain', $payload)) { 
                    $new_domain = trim((string)$payload['domain']);
                    // Check if domain is already used by another license
                    if ($new_domain !== '') {
                        foreach ($list as $check_item) {
                            if (isset($check_item['domain']) && $check_item['domain'] === $new_domain && $check_item['key'] !== $key) {
                                if (ob_get_length()) { ob_clean(); }
                                http_response_code(400);
                                echo json_encode(['response'=>0,'msg'=>'Domain already assigned to another license']);
                                exit;
                            }
                        }
                    }
                    $item['domain'] = $new_domain;
                }
                if (array_key_exists('notes', $payload)) { $item['notes'] = (string)$payload['notes']; }
                $updated = true;
                break;
            }
        }
        unset($item);
        if (!$updated) { if (ob_get_length()) { ob_clean(); } http_response_code(404); echo json_encode(['response'=>0,'msg'=>'Not found']); exit; }
        $ok = save_licenses($store_file, $list);
        if (!$ok) { if (ob_get_length()) { ob_clean(); } http_response_code(500); echo json_encode(['response'=>0,'msg'=>'Failed to save']); exit; }
        
        // Clear license cache so updates reflect immediately
        $cache_file = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'license_check_cache.json';
        @unlink($cache_file);
        
        @file_put_contents($log_file, '['.date('Y-m-d H:i:s').'] update '.$key.' by '.($user_name_2 ?? 'system')."\n", FILE_APPEND);
        if (ob_get_length()) { ob_clean(); }
        echo json_encode(['response'=>1,'msg'=>'Updated']);
        exit;
    }
    
    if ($action === 'renew') {
        $key = (string)($payload['key'] ?? '');
        $renew_duration = (int)($payload['duration'] ?? 30); // Duration in days
        if ($key==='') { if (ob_get_length()) { ob_clean(); } http_response_code(400); echo json_encode(['response'=>0,'msg'=>'Missing key']); exit; }
        $renewed = false;
        foreach ($list as &$item) {
            if (isset($item['key']) && hash_equals($item['key'], $key)) {
                $current_expiry = (int)($item['expires_at'] ?? time());
                // If already expired, renew from now, otherwise extend from current expiry
                $base_time = ($current_expiry > time()) ? $current_expiry : time();
                $item['expires_at'] = $base_time + ($renew_duration * 86400);
                $item['duration_days'] = $renew_duration;
                $item['renewed_at'] = time();
                $item['renewed_by'] = $user_name_2 ?? 'system';
                $renewed = true;
                break;
            }
        }
        unset($item);
        if (!$renewed) { if (ob_get_length()) { ob_clean(); } http_response_code(404); echo json_encode(['response'=>0,'msg'=>'Not found']); exit; }
        $ok = save_licenses($store_file, $list);
        if (!$ok) { if (ob_get_length()) { ob_clean(); } http_response_code(500); echo json_encode(['response'=>0,'msg'=>'Failed to save']); exit; }
        
        // Clear license cache so renewal reflects immediately
        $cache_file = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'license_check_cache.json';
        @unlink($cache_file);
        
        @file_put_contents($log_file, '['.date('Y-m-d H:i:s').'] renew '.$key.' ('.$renew_duration.' days) by '.($user_name_2 ?? 'system')."\n", FILE_APPEND);
        if (ob_get_length()) { ob_clean(); }
        echo json_encode(['response'=>1,'msg'=>'License renewed for '.$renew_duration.' days']);
        exit;
    }

    if ($action === 'delete') {
        $key = (string)($payload['key'] ?? '');
        if ($key==='') { if (ob_get_length()) { ob_clean(); } http_response_code(400); echo json_encode(['response'=>0,'msg'=>'Missing key']); exit; }
        $orig = count($list);
        $list = array_values(array_filter($list, function($it) use ($key){ return !isset($it['key']) || !hash_equals($it['key'], $key); }));
        if (count($list) === $orig) { if (ob_get_length()) { ob_clean(); } http_response_code(404); echo json_encode(['response'=>0,'msg'=>'Not found']); exit; }
        $ok = save_licenses($store_file, $list);
        if (!$ok) { if (ob_get_length()) { ob_clean(); } http_response_code(500); echo json_encode(['response'=>0,'msg'=>'Failed to save']); exit; }
        
        // Clear license cache so deletion reflects immediately
        $cache_file = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'license_check_cache.json';
        @unlink($cache_file);
        
        @file_put_contents($log_file, '['.date('Y-m-d H:i:s').'] delete '.$key.' by '.($user_name_2 ?? 'system')."\n", FILE_APPEND);
        if (ob_get_length()) { ob_clean(); }
        echo json_encode(['response'=>1,'msg'=>'Deleted']);
        exit;
    }

    if (ob_get_length()) { ob_clean(); }
    http_response_code(400);
    echo json_encode(['response'=>0,'msg'=>'Unknown action']);
    exit;
}

http_response_code(405);
echo json_encode(['response'=>0,'msg'=>'Method Not Allowed']);
