<?php
// Suppress warnings for clean JSON output
error_reporting(0);
ini_set('display_errors', '0');

// Start output buffering to catch any unwanted output
ob_start();

try {
    require_once '../../includes/config.php';
    
    // Simple authentication check - just check if we can access the database
    if(!isset($db) || !is_object($db)) {
        throw new Exception("Database not available");
    }
    
    $query = $db->sql_query("SELECT * FROM ads_apps ORDER BY app_name ASC");
    
    $data = array();
    
    while($row = $db->sql_fetchrow($query)) {
        // Generate API URL with proper host detection (RESTful URL format)
        $host = isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : 'localhost';
        $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http';
        $api_url = $protocol . '://' . $host . '/api/ads/' . urlencode($row['app_name']) . '/config';
        
        $data[] = array(
            'id' => $row['id'],
            'app_name' => $row['app_name'],
            'package_name' => $row['package_name'],
            'admob_app_id' => $row['admob_app_id'],
            'banner_ad_id' => $row['banner_ad_id'] ?: '',
            'interstitial_ad_id' => $row['interstitial_ad_id'] ?: '',
            'rewarded_ad_id' => $row['rewarded_ad_id'] ?: '',
            'native_advanced_ad_id' => $row['native_advanced_ad_id'] ?: '',
            'app_open_ad_id' => $row['app_open_ad_id'] ?: '',
            'status' => $row['status'],
            'api_url' => $api_url,
            'created_date' => date('Y-m-d H:i', strtotime($row['created_date']))
        );
    }
    
    $values['data'] = $data;
    
} catch (Exception $e) {
    $values['data'] = array();
    $values['error'] = $e->getMessage();
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
