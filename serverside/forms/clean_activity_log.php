<?php
// Suppress warnings for clean JSON output
error_reporting(0);
ini_set('display_errors', '0');

// Start output buffering to catch any unwanted output
ob_start();

try {
    require_once '../../includes/functions.php';
    chkSession();
    
    // Check admin permissions
    if($user_id_2 != '1' && $user_level_2 != 'superadmin' && $user_level_2 != 'developer') {
        throw new Exception("Access denied");
    }
} catch (Exception $e) {
    ob_clean();
    header('Content-Type: application/json');
    echo json_encode(array('response' => 0, 'msg' => 'Access denied or system error'));
    exit;
}

if(isset($_POST['action']) && !empty($_POST['action'])) {
    $action = $_POST['action'];
    
    $delete_query = "";
    $description = "";
    
    switch($action) {
        case 'clean_7_days':
            $delete_query = "DELETE FROM activity_logs WHERE date < DATE_SUB(NOW(), INTERVAL 7 DAY)";
            $description = "entries older than 7 days";
            break;
            
        case 'clean_30_days':
            $delete_query = "DELETE FROM activity_logs WHERE date < DATE_SUB(NOW(), INTERVAL 30 DAY)";
            $description = "entries older than 30 days";
            break;
            
        case 'clean_90_days':
            $delete_query = "DELETE FROM activity_logs WHERE date < DATE_SUB(NOW(), INTERVAL 90 DAY)";
            $description = "entries older than 90 days";
            break;
            
        case 'clean_1_year':
            $delete_query = "DELETE FROM activity_logs WHERE date < DATE_SUB(NOW(), INTERVAL 1 YEAR)";
            $description = "entries older than 1 year";
            break;
            
        case 'clean_all':
            $delete_query = "DELETE FROM activity_logs";
            $description = "all activity log entries";
            break;
            
        default:
            $values['response'] = 0;
            $values['msg'] = 'Invalid action specified.';
            ob_clean();
            header('Content-Type: application/json');
            echo json_encode($values);
            exit;
    }
    
    // Get count before deletion for reporting
    $count_query = str_replace("DELETE FROM activity_logs", "SELECT COUNT(*) as count FROM activity_logs", $delete_query);
    $count_result = $db->sql_query($count_query);
    $count_data = $db->sql_fetchrow($count_result);
    $records_to_delete = $count_data['count'];
    
    if($records_to_delete == 0) {
        $values['response'] = 1;
        $values['msg'] = 'No activity log entries found to clean with the specified criteria.';
    } else {
        // Execute the deletion
        $result = $db->sql_query($delete_query);
        
        if($result) {
            $values['response'] = 1;
            $values['msg'] = "Successfully cleaned $records_to_delete activity log entries ($description).";
            $values['records_deleted'] = $records_to_delete;
        } else {
            $values['response'] = 0;
            $values['msg'] = 'Failed to clean activity log. Please try again.';
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
