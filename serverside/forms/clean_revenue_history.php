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

if(isset($_POST['action']) && !empty($_POST['action'])) {
    $action = $_POST['action'];
    $app_filter = isset($_POST['app_name']) && !empty($_POST['app_name']) ? $_POST['app_name'] : '';
    
    $delete_query = "";
    $description = "";
    
    switch($action) {
        case 'clean_30_days':
            $delete_query = "DELETE FROM ads_revenue WHERE date < DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
            $description = "data older than 30 days";
            break;
            
        case 'clean_90_days':
            $delete_query = "DELETE FROM ads_revenue WHERE date < DATE_SUB(CURDATE(), INTERVAL 90 DAY)";
            $description = "data older than 90 days";
            break;
            
        case 'clean_1_year':
            $delete_query = "DELETE FROM ads_revenue WHERE date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR)";
            $description = "data older than 1 year";
            break;
            
        case 'clean_all':
            $delete_query = "DELETE FROM ads_revenue";
            $description = "all revenue history data";
            break;
            
        default:
            $values['response'] = 0;
            $values['msg'] = 'Invalid action specified.';
            ob_clean();
            header('Content-Type: application/json');
            echo json_encode($values);
            exit;
    }
    
    // Add app filter if specified
    if(!empty($app_filter) && $action !== 'clean_all') {
        $delete_query .= " AND app_name = '" . $db->SanitizeForSQL($app_filter) . "'";
        $description .= " for app: " . $app_filter;
    }
    
    // Get count before deletion for reporting
    $count_query = str_replace("DELETE FROM ads_revenue", "SELECT COUNT(*) as count FROM ads_revenue", $delete_query);
    $count_result = $db->sql_query($count_query);
    $count_data = $db->sql_fetchrow($count_result);
    $records_to_delete = $count_data['count'];
    
    if($records_to_delete == 0) {
        $values['response'] = 1;
        $values['msg'] = 'No records found to clean with the specified criteria.';
    } else {
        // Execute the deletion
        $result = $db->sql_query($delete_query);
        
        if($result) {
            $values['response'] = 1;
            $values['msg'] = "Successfully cleaned $records_to_delete revenue history records ($description).";
            $values['records_deleted'] = $records_to_delete;
        } else {
            $values['response'] = 0;
            $values['msg'] = 'Failed to clean revenue history. Please try again.';
        }
    }
    
} else {
    $values['response'] = 0;
    $values['msg'] = 'Invalid request. Action is required.';
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
