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

if(isset($_POST['app_id']) && !empty($_POST['app_id'])) {
    $app_id = (int)$_POST['app_id'];
    
    // First, get the app name for logging
    $app_query = $db->sql_query("SELECT app_name FROM ads_apps WHERE id = $app_id");
    if($db->sql_numrows($app_query) > 0) {
        $app_data = $db->sql_fetchrow($app_query);
        $app_name = $app_data['app_name'];
        
        // Delete the app configuration
        $delete_query = "DELETE FROM ads_apps WHERE id = $app_id";
        $result = $db->sql_query($delete_query);
        
        if($result) {
            // Also delete related revenue data
            $delete_revenue_query = "DELETE FROM ads_revenue WHERE app_id = $app_id";
            $db->sql_query($delete_revenue_query);
            
            // Delete related API logs
            $delete_logs_query = "DELETE FROM ads_api_logs WHERE app_name = '" . $db->SanitizeForSQL($app_name) . "'";
            $db->sql_query($delete_logs_query);
            
            $values['response'] = 1;
            $values['msg'] = 'App configuration "' . $app_name . '" deleted successfully!';
        } else {
            $values['response'] = 0;
            $values['msg'] = 'Failed to delete app configuration. Please try again.';
        }
    } else {
        $values['response'] = 0;
        $values['msg'] = 'App configuration not found.';
    }
} else {
    $values['response'] = 0;
    $values['msg'] = 'Invalid request. App ID is required.';
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
