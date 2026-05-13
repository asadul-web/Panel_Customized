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
} catch (Exception $e) {
    ob_clean();
    header('Content-Type: application/json');
    echo json_encode(array('response' => 0, 'msg' => 'System error'));
    exit;
}

if(isset($_POST['submitted'])) {
    $app_name = trim($_POST['app_name']);
    $app_package = trim($_POST['app_package']);
    $admob_app_id = trim($_POST['admob_app_id']);
    $banner_ad_id = trim($_POST['banner_ad_id']);
    $interstitial_ad_id = trim($_POST['interstitial_ad_id']);
    $rewarded_ad_id = trim($_POST['rewarded_ad_id']);
    $native_advanced_ad_id = trim($_POST['native_advanced_ad_id']);
    $app_open_ad_id = trim($_POST['app_open_ad_id']);
    $app_status = $_POST['app_status'];
    
    // Validation
    if(empty($app_name) || empty($app_package) || empty($admob_app_id)) {
        $values['response'] = 0;
        $values['msg'] = 'App name, package name, and AdMob App ID are required.';
        echo json_encode($values);
        exit;
    }
    
    // Check if app name already exists
    $check_query = $db->sql_query("SELECT id FROM ads_apps WHERE app_name = '".$db->SanitizeForSQL($app_name)."'");
    if($db->sql_numrows($check_query) > 0) {
        $values['response'] = 0;
        $values['msg'] = 'App name already exists. Please choose a different name.';
        echo json_encode($values);
        exit;
    }
    
    // Check if package name already exists
    $check_package_query = $db->sql_query("SELECT id FROM ads_apps WHERE package_name = '".$db->SanitizeForSQL($app_package)."'");
    if($db->sql_numrows($check_package_query) > 0) {
        $values['response'] = 0;
        $values['msg'] = 'Package name already exists. Please choose a different package name.';
        echo json_encode($values);
        exit;
    }
    
    // Insert new app configuration
    $insert_query = "INSERT INTO ads_apps (app_name, package_name, admob_app_id, banner_ad_id, interstitial_ad_id, rewarded_ad_id, native_advanced_ad_id, app_open_ad_id, status) VALUES (
        '".$db->SanitizeForSQL($app_name)."',
        '".$db->SanitizeForSQL($app_package)."',
        '".$db->SanitizeForSQL($admob_app_id)."',
        '".$db->SanitizeForSQL($banner_ad_id)."',
        '".$db->SanitizeForSQL($interstitial_ad_id)."',
        '".$db->SanitizeForSQL($rewarded_ad_id)."',
        '".$db->SanitizeForSQL($native_advanced_ad_id)."',
        '".$db->SanitizeForSQL($app_open_ad_id)."',
        '".$db->SanitizeForSQL($app_status)."'
    )";
    
    $result = $db->sql_query($insert_query);
    
    if($result) {
        $values['response'] = 1;
        $values['msg'] = 'App configuration created successfully! API URL: ' . $db->base_url() . 'api/ads/' . urlencode($app_name) . '/config';
    } else {
        $values['response'] = 0;
        $values['msg'] = 'Failed to create app configuration. Please try again.';
    }
    
} else {
    $values['response'] = 0;
    $values['msg'] = 'Invalid request.';
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
