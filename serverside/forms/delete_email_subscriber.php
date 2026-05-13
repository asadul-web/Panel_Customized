<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

$values = array();

// Check if user is logged in and has proper permissions
if(!is_logged_in($user)) {
    $values['response'] = 2;
    $values['msg'] = 'Unauthorized';
    echo json_encode($values);
    exit;
}

if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    $values['response'] = 2;
    $values['msg'] = 'Insufficient permissions';
    echo json_encode($values);
    exit;
}

// Get form data
$subscriber_id = intval($_POST['subscriber_id']);

// Validate input
if(empty($subscriber_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing subscriber ID';
    echo json_encode($values);
    exit;
}

// Check if subscriber exists and get email for logging
$check_query = "SELECT email FROM email_subscribers WHERE id = $subscriber_id";
$check_result = $db->sql_query($check_query);

if($db->sql_numrows($check_result) == 0) {
    $values['response'] = 2;
    $values['msg'] = 'Subscriber not found';
    echo json_encode($values);
    exit;
}

$subscriber = $db->sql_fetchrow($check_result);

// Delete subscriber
$delete_query = "DELETE FROM email_subscribers WHERE id = $subscriber_id";

if($db->sql_query($delete_query)) {
    
    // Log activity
    $action = "Deleted email subscriber: " . $subscriber['email'];
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
    
    $values['response'] = 1;
    $values['msg'] = 'Subscriber deleted successfully';
    
} else {
    $values['response'] = 2;
    $values['msg'] = 'Failed to delete subscriber';
}

echo json_encode($values);
?>

