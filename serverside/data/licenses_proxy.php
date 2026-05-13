<?php
/**
 * License API Proxy
 * 
 * This proxy handles license API requests securely.
 * The actual remote API URL is encrypted and never exposed to frontend.
 */
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
header('Content-Type: application/json');

// Response caching for performance
$cache_file = __DIR__ . '/../../includes/backup/licenses_proxy_cache.json';
$cache_ttl = 300; // 5 minutes

// Check cache first - avoid external request if cached (GET only)
if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET') {
    if (file_exists($cache_file) && (time() - filemtime($cache_file)) < $cache_ttl) {
        $cached = @file_get_contents($cache_file);
        if ($cached !== false) {
            echo $cached;
            exit;
        }
    }
}

require_once '../../includes/functions.php';

// Get encrypted API URL (decrypted server-side only)
$base_api_url = function_exists('getBaseApiUrl') ? getBaseApiUrl() : $db->base_url();
$local_fallback = rtrim($base_api_url, '/') . '/serverside/data/licenses_api.php';

// Use encrypted URL from secure storage (defined in config.php)
$remote = defined('LICENSE_API_URL') ? LICENSE_API_URL : '';

// Fallback to local if encrypted URL not available
if (empty($remote) || !filter_var($remote, FILTER_VALIDATE_URL)) {
    $remote = $local_fallback;
}

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$ch = curl_init();

// Build target URL with original query string
$qs = $_SERVER['QUERY_STRING'] ?? '';
$target = $remote . ($qs ? (strpos($remote,'?')===false?'?':'&') . $qs : '');

curl_setopt($ch, CURLOPT_URL, $target);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 2);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 1);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

if ($method === 'POST') {
    $body = file_get_contents('php://input');
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
    // Pass JSON content-type if present
    if (isset($_SERVER['CONTENT_TYPE'])) {
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: ' . $_SERVER['CONTENT_TYPE']]);
    }
}

$resp = curl_exec($ch);
$err  = curl_error($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($err || $resp === false) {
    if (ob_get_length()) { ob_clean(); }
    http_response_code(502);
    echo json_encode(['response'=>0,'msg'=>'Proxy connection failed','error'=>$err]);
    exit;
}

if (ob_get_length()) { ob_clean(); }
http_response_code($code ?: 200);

// Cache successful GET responses
if (($method === 'GET') && $code >= 200 && $code < 300 && !empty($resp)) {
    @file_put_contents($cache_file, $resp);
}

echo $resp;
