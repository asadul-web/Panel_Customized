<?php
/**
 * Notice API Proxy
 * 
 * This proxy handles notice API requests by directly including the local API.
 * No remote connection needed - everything runs locally for better performance.
 */
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
header('Content-Type: application/json');

// Response caching for performance (GET only)
$cache_file = __DIR__ . '/../../includes/backup/notice_proxy_cache.json';
$cache_ttl = 300; // 5 minutes

// Check cache first - avoid processing if cached (GET only)
if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET') {
    if (file_exists($cache_file) && (time() - filemtime($cache_file)) < $cache_ttl) {
        $cached = @file_get_contents($cache_file);
        if ($cached !== false) {
            if (ob_get_length()) { ob_clean(); }
            echo $cached;
            exit;
        }
    }
}

// Directly include the local notice API - no cURL needed
$local_api = __DIR__ . '/notice_api.php';

if (file_exists($local_api)) {
    // Capture the API output
    ob_start();
    include $local_api;
    $resp = ob_get_clean();
    
    // Cache successful GET responses
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET' && !empty($resp)) {
        @file_put_contents($cache_file, $resp);
    }
    
    if (ob_get_length()) { ob_clean(); }
    echo $resp;
} else {
    if (ob_get_length()) { ob_clean(); }
    http_response_code(500);
    echo json_encode(['response'=>0,'msg'=>'Notice API not found']);
}
