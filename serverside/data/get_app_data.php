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
    
    $app_id = isset($_GET['app_id']) ? (int)$_GET['app_id'] : 0;
    
    if($app_id > 0) {
        $query = $db->sql_query("SELECT * FROM ads_apps WHERE id = $app_id");
        
        if($db->sql_numrows($query) > 0) {
            $app_data = $db->sql_fetchrow($query);
            
            $values['response'] = 1;
            $values['data'] = array(
                'id' => $app_data['id'],
                'app_name' => $app_data['app_name'],
                'package_name' => $app_data['package_name'],
                'admob_app_id' => $app_data['admob_app_id'],
                'banner_ad_id' => $app_data['banner_ad_id'],
                'interstitial_ad_id' => $app_data['interstitial_ad_id'],
                'rewarded_ad_id' => $app_data['rewarded_ad_id'],
                'native_advanced_ad_id' => $app_data['native_advanced_ad_id'],
                'app_open_ad_id' => $app_data['app_open_ad_id'],
                'status' => $app_data['status']
            );
        } else {
            $values['response'] = 0;
            $values['msg'] = 'App not found';
        }
    } else {
        $values['response'] = 0;
        $values['msg'] = 'Invalid app ID';
    }
    
} catch (Exception $e) {
    $values['response'] = 0;
    $values['msg'] = 'Error retrieving app data';
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
