<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    // Cache file for license data (6 hour cache)
    $cache_dir = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'cache';
    $cache_file = $cache_dir . DIRECTORY_SEPARATOR . 'get_data_cache.json';
    $cache_duration = 21600; // 6 hours
    
    // Check if cache is valid
    if (file_exists($cache_file) && (time() - filemtime($cache_file)) < $cache_duration) {
        $cached_data = @file_get_contents($cache_file);
        if ($cached_data) {
            if (ob_get_length()) { ob_clean(); }
            header('Content-Type: application/json');
            echo $cached_data;
            exit;
        }
    }
    
    // Use encrypted License API URL
    $url = defined('LICENSE_API_URL') ? LICENSE_API_URL : '';
    if (empty($url)) {
        // Fallback to local if no encrypted URL configured
        $base_url = function_exists('getBaseApiUrl') ? getBaseApiUrl() : 'http://localhost';
        $url = rtrim($base_url, '/') . '/serverside/data/licenses_api.php';
    }
    // Diagnostic logging (only log actual API calls, not cache hits)
    $logfile = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'logs' . DIRECTORY_SEPARATOR . 'api_debug.log';
    $entry = "[".date('Y-m-d H:i:s')."] LICENSE CHECK (get_data) - Fetching from API (cache expired)\n";
    @file_put_contents($logfile, $entry, FILE_APPEND);

    $curl = curl_init($url);
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_TIMEOUT, 1);
    curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 1);
    curl_setopt($curl, CURLOPT_NOSIGNAL, 1);
    
    $resp = curl_exec($curl);
    $curl_error = curl_error($curl);
    curl_close($curl);
                
    $apiData = json_decode($resp, true);
    if (is_array($apiData) && isset($apiData['response']) && isset($apiData['data']) && is_array($apiData['data'])) {
        // Interpret licenses API list: success if any active key, else error
        $hasActive = false; $soonest = null;
        foreach ($apiData['data'] as $it) {
            if (($it['status'] ?? '') === 'active') {
                $hasActive = true;
                if (!empty($it['expires_at'])) {
                    $t = strtotime($it['expires_at']);
                    if ($t && ($soonest===null || $t < $soonest)) { $soonest = $t; }
                }
            }
        }
        if ($hasActive) {
            $statusCode = 1;
            if ($soonest) {
                $sec = max(0, $soonest - time());
                $MSG = 'OK (' . $sec . 's left)';
            } else {
                $MSG = 'OK';
            }
        } else {
            $statusCode = 2;
            $MSG = 'No active license';
        }
    } else {
        // Fallback: local/dev skip to avoid blocking UI
        $host = $_SERVER['HTTP_HOST'] ?? ($_SERVER['SERVER_NAME'] ?? '');
        $is_local = in_array($host, ['localhost', '127.0.0.1']) || preg_match('/^127\.0\.0\.1|^::1$/', $host);
        if ($is_local) {
            $statusCode = 1;
            $MSG = 'OK (license check skipped in local environment)';
        } else {
            $statusCode = 2;
            $MSG = 'API returned invalid data';
        }
        // Log invalid
        $entry = "[".date('Y-m-d H:i:s')."] LICENSE CHECK DEBUG - URL: $url\n";
        $entry .= "CURL_ERROR: " . ($curl_error ?: 'none') . "\n";
        $entry .= "RESPONSE_RAW: " . substr((string)$resp, 0, 2000) . "\n\n";
        @file_put_contents($logfile, $entry, FILE_APPEND);
    }
    
    if($statusCode === 1){
		$values['response'] = 1;
		$values['licmsg'] = $MSG;
    }elseif($statusCode === 2){
        $values['response'] = 2;
        $values['licmsg'] = $MSG;
    }elseif($statusCode === 3){
        $values['response'] = 3;
        $values['licmsg'] = $MSG;
    }

    // Ensure clean JSON output
    if (ob_get_length()) { ob_clean(); }
    header('Content-Type: application/json');
    $json_output = json_encode($values);
    
    // Save to cache for future requests
    @file_put_contents($cache_file, $json_output, LOCK_EX);
    
    echo $json_output;
?>