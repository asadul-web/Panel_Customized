<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
header('Content-Type: application/json');

require_once '../../includes/functions.php';

$store_file = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'licenses.json';
$settings_file = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'panel_license.json';

function load_licenses($file) {
    // Fetch from remote API using encrypted URL
    $remote_url = defined('LICENSE_API_URL') ? LICENSE_API_URL : '';
    
    // Fallback to local if encrypted URL not available
    if (empty($remote_url) || !filter_var($remote_url, FILTER_VALIDATE_URL)) {
        // Use local fallback
        if (file_exists($file) && filesize($file) > 0) {
            $raw = @file_get_contents($file);
            $data = json_decode($raw, true);
            if (is_array($data)) return $data;
        }
        return [];
    }
    
    $ch = curl_init($remote_url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    $response = curl_exec($ch);
    $error = curl_error($ch);
    curl_close($ch);
    
    if ($error || empty($response)) {
        // Fallback to local file if remote fails
        if (file_exists($file) && filesize($file) > 0) {
            $raw = @file_get_contents($file);
            $data = json_decode($raw, true);
            if (is_array($data)) return $data;
        }
        return [];
    }
    
    $result = json_decode($response, true);
    if (is_array($result) && isset($result['response']) && $result['response'] == 1 && isset($result['data'])) {
        return $result['data'];
    }
    
    return [];
}

function load_panel_license($file) {
    if (!file_exists($file) || filesize($file) === 0) {
        return ['license_key' => '', 'activated_at' => 0, 'domain' => ''];
    }
    $raw = @file_get_contents($file);
    $data = json_decode($raw, true);
    return is_array($data) ? $data : ['license_key' => '', 'activated_at' => 0, 'domain' => ''];
}

function save_panel_license($file, $data) {
    return @file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES), LOCK_EX) !== false;
}

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'GET') {
    // Get current panel license status
    $panel_license = load_panel_license($settings_file);
    $license_key = $panel_license['license_key'] ?? '';
    
    if (empty($license_key)) {
        if (ob_get_length()) { ob_clean(); }
        echo json_encode([
            'response' => 1,
            'status' => 'no_license',
            'message' => 'No license activated',
            'data' => null
        ]);
        exit;
    }
    
    // Find license in licenses.json
    $licenses = load_licenses($store_file);
    $found = null;
    foreach ($licenses as $lic) {
        if (isset($lic['key']) && $lic['key'] === $license_key) {
            $found = $lic;
            break;
        }
    }
    
    if (!$found) {
        if (ob_get_length()) { ob_clean(); }
        echo json_encode([
            'response' => 0,
            'status' => 'invalid',
            'message' => 'License key not found',
            'data' => null
        ]);
        exit;
    }
    
    // Check expiry
    $now = time();
    $expires_at = (int)($found['expires_at'] ?? 0);
    $is_expired = $expires_at > 0 && $expires_at < $now;
    $status = $found['status'] ?? 'active';
    
    $days_remaining = 0;
    if ($expires_at > $now) {
        $days_remaining = ceil(($expires_at - $now) / 86400);
    }
    
    $is_valid = ($status === 'active' && !$is_expired);
    
    if (ob_get_length()) { ob_clean(); }
    echo json_encode([
        'response' => 1,
        'status' => $is_valid ? 'valid' : ($is_expired ? 'expired' : 'blocked'),
        'message' => $is_valid ? 'License is valid' : ($is_expired ? 'License has expired' : 'License is blocked'),
        'data' => [
            'key' => $found['key'],
            'status' => $status,
            'domain' => $found['domain'] ?? '',
            'expires_at' => $expires_at,
            'expiry_date' => date('Y-m-d H:i:s', $expires_at),
            'days_remaining' => $days_remaining,
            'is_expired' => $is_expired,
            'is_valid' => $is_valid,
            'created_at' => $found['created_at'] ?? 0,
            'duration_days' => $found['duration_days'] ?? 0
        ]
    ]);
    exit;
}

if ($method === 'POST') {
    // Activate license
    $raw = file_get_contents('php://input') ?: '';
    $payload = json_decode($raw, true);
    if (!is_array($payload)) { $payload = $_POST; }
    
    $license_key = trim((string)($payload['license_key'] ?? ''));
    $current_domain = $_SERVER['HTTP_HOST'] ?? 'localhost';
    
    if (empty($license_key)) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(400);
        echo json_encode(['response' => 0, 'msg' => 'License key is required']);
        exit;
    }
    
    // Find license from remote API
    $licenses = load_licenses($store_file);
    $found_index = null;
    $found = null;
    foreach ($licenses as $idx => $lic) {
        if (isset($lic['key']) && $lic['key'] === $license_key) {
            $found_index = $idx;
            $found = $lic;
            break;
        }
    }
    
    if (!$found) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(404);
        echo json_encode(['response' => 0, 'msg' => 'License key not found']);
        exit;
    }
    
    // STRICT: Check if license is already assigned to another domain
    if (!empty($found['domain']) && $found['domain'] !== $current_domain) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(400);
        echo json_encode(['response' => 0, 'msg' => 'This license is already assigned to domain: ' . $found['domain'] . '. One license can only be used on one domain.']);
        exit;
    }
    
    // STRICT: Check if current domain is already using another license
    foreach ($licenses as $lic) {
        if (isset($lic['domain']) && $lic['domain'] === $current_domain && $lic['key'] !== $license_key) {
            if (ob_get_length()) { ob_clean(); }
            http_response_code(400);
            echo json_encode(['response' => 0, 'msg' => 'This domain is already using another license: ' . $lic['key'] . '. One domain can only use one license.']);
            exit;
        }
    }
    
    // Check expiry
    $now = time();
    $expires_at = (int)($found['expires_at'] ?? 0);
    if ($expires_at > 0 && $expires_at < $now) {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(400);
        echo json_encode(['response' => 0, 'msg' => 'License has expired on ' . date('Y-m-d', $expires_at)]);
        exit;
    }
    
    // Check status
    if (($found['status'] ?? 'active') !== 'active') {
        if (ob_get_length()) { ob_clean(); }
        http_response_code(400);
        echo json_encode(['response' => 0, 'msg' => 'License is blocked or disabled']);
        exit;
    }
    
    // Assign domain to license via remote API if not already assigned
    if (empty($found['domain'])) {
        // Update via remote API using encrypted URL
        $update_url = defined('LICENSE_API_URL') ? LICENSE_API_URL : '';
        $update_data = json_encode([
            'action' => 'update',
            'key' => $license_key,
            'domain' => $current_domain
        ]);
        
        $ch = curl_init($update_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $update_data);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_exec($ch);
        curl_close($ch);
    }
    
    // Save panel license
    $panel_license = [
        'license_key' => $license_key,
        'activated_at' => $now,
        'domain' => $current_domain
    ];
    save_panel_license($settings_file, $panel_license);
    
    // Clear license cache so changes reflect immediately
    $cache_file = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'license_check_cache.json';
    @unlink($cache_file);
    
    if (ob_get_length()) { ob_clean(); }
    echo json_encode([
        'response' => 1,
        'msg' => 'License activated successfully',
        'data' => [
            'key' => $license_key,
            'domain' => $current_domain,
            'expires_at' => $expires_at,
            'expiry_date' => date('Y-m-d H:i:s', $expires_at)
        ]
    ]);
    exit;
}

http_response_code(405);
echo json_encode(['response' => 0, 'msg' => 'Method Not Allowed']);
