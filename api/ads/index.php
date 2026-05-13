<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

// Get the URL path
$request_uri = $_SERVER['REQUEST_URI'];
$path = parse_url($request_uri, PHP_URL_PATH);

// Remove the base path to get the API path
$api_path = str_replace('/api/ads/', '', $path);
$path_parts = explode('/', trim($api_path, '/'));

// Check if we have the correct structure: app_name/config
if (count($path_parts) >= 2 && $path_parts[1] === 'config') {
    $app_name = $path_parts[0];
    
    // Sanitize the app name
    $app_name = $db->SanitizeForSQL($app_name);
    
    // Log the API request
    $ip_address = $_SERVER['REMOTE_ADDR'];
    $user_agent = $_SERVER['HTTP_USER_AGENT'];
    $endpoint = $_SERVER['REQUEST_URI'];
    
    $log_sql = "INSERT INTO ads_api_logs (app_name, endpoint, ip_address, user_agent, request_data, response_code, created_date) 
                VALUES ('$app_name', '$endpoint', '$ip_address', '" . $db->SanitizeForSQL($user_agent) . "', '$endpoint', 200, NOW())";
    $db->sql_query($log_sql);
    
    // Query to get ads configuration for the app
    $sql = "SELECT * FROM ads_apps WHERE app_name = '$app_name' AND status = 'active'";
    $query = $db->sql_query($sql);
    
    if ($db->sql_numrows($query) > 0) {
        $row = $db->sql_fetchrow($query);
        
        // Prepare the response
        $response = array(
            'status' => 'success',
            'app_name' => $row['app_name'],
            'package_name' => $row['package_name'],
            'admob_app_id' => $row['admob_app_id'],
            'banner_ad_id' => $row['banner_ad_id'],
            'interstitial_ad_id' => $row['interstitial_ad_id'],
            'rewarded_ad_id' => $row['rewarded_ad_id'],
            'native_advanced_ad_id' => $row['native_advanced_ad_id'],
            'app_open_ad_id' => $row['app_open_ad_id'],
            'created_date' => $row['created_date'],
            'updated_date' => $row['updated_date']
        );
        
        // Set JSON header
        header('Content-Type: application/json');
        echo json_encode($response, JSON_PRETTY_PRINT);
    } else {
        // Log 404 response
        $log_sql_404 = "UPDATE ads_api_logs SET response_code = 404 WHERE app_name = '$app_name' AND endpoint = '$endpoint' ORDER BY id DESC LIMIT 1";
        $db->sql_query($log_sql_404);
        
        // App not found or no ads configuration
        header('Content-Type: application/json');
        http_response_code(404);
        echo json_encode(array(
            'status' => 'error',
            'message' => 'Ads configuration not found for app: ' . $app_name
        ), JSON_PRETTY_PRINT);
    }
} else {
    // Invalid API endpoint
    header('Content-Type: application/json');
    http_response_code(400);
    echo json_encode(array(
        'status' => 'error',
        'message' => 'Invalid API endpoint. Use format: /api/ads/{app_name}/config'
    ), JSON_PRETTY_PRINT);
}
?>

