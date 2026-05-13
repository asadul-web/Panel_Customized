<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json; charset=utf-8');

require_once '../../includes/functions.php';

$values = array();

// Check if user is logged in and has proper permissions
if(!isset($user) || !is_logged_in($user)) {
    $values['response'] = 2;
    $values['msg'] = 'Unauthorized - Please login as admin';
    echo json_encode($values);
    exit;
}

if(!isset($user_level_2) || ($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator')) {
    $values['response'] = 2;
    $values['msg'] = 'Insufficient permissions - Admin access required';
    echo json_encode($values);
    exit;
}

// Get campaign ID
$campaign_id = isset($_POST['campaign_id']) ? intval($_POST['campaign_id']) : 0;

if(empty($campaign_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing campaign ID';
    echo json_encode($values);
    exit;
}

try {
    // Get campaign details before deletion for logging
    $query = "SELECT id, name, status FROM email_campaigns WHERE id = $campaign_id";
    $result = $db->sql_query($query);
    
    if(!$result || $db->sql_numrows($result) == 0) {
        $values['response'] = 2;
        $values['msg'] = 'Campaign not found';
        echo json_encode($values);
        exit;
    }
    
    $campaign = $db->sql_fetchrow($result);
    $campaign_name = $campaign['name'];
    
    // Allow deletion of all campaigns, but warn about sending campaigns
    // Note: In a production environment, you might want to implement campaign pausing
    // before allowing deletion of sending campaigns
    
    // Delete the campaign
    $delete_query = "DELETE FROM email_campaigns WHERE id = $campaign_id";
    
    if($db->sql_query($delete_query)) {
        
        // Log activity
        $action = "Deleted email campaign: $campaign_name (ID: $campaign_id)";
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                      VALUES ($user_id_2, '" . date('Y-m-d H:i:s') . "', '" . addslashes($action) . "', 
                      '" . $_SERVER['REMOTE_ADDR'] . "', '', '')";
        $db->sql_query($log_query);
        
        $values['response'] = 1;
        $values['msg'] = "Campaign '$campaign_name' deleted successfully!";
        
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to delete campaign. Database error: ' . $db->sql_error();
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['response'] = 2;
    $values['msg'] = 'Fatal Error: ' . $e->getMessage();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

