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
$status = $db->Sanitize(trim($_POST['status']));

// Validate input
if(empty($subscriber_id) || empty($status)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing required parameters';
    echo json_encode($values);
    exit;
}

// Validate status
$valid_statuses = array('active', 'unsubscribed', 'bounced');
if(!in_array($status, $valid_statuses)) {
    $values['response'] = 2;
    $values['msg'] = 'Invalid status';
    echo json_encode($values);
    exit;
}

// Check if subscriber exists
$check_query = "SELECT email FROM email_subscribers WHERE id = $subscriber_id";
$check_result = $db->sql_query($check_query);

if($db->sql_numrows($check_result) == 0) {
    $values['response'] = 2;
    $values['msg'] = 'Subscriber not found';
    echo json_encode($values);
    exit;
}

$subscriber = $db->sql_fetchrow($check_result);

// Update subscriber status
$update_query = "UPDATE email_subscribers SET 
                status = '".$db->SanitizeForSQL($status)."'";

if($status == 'unsubscribed') {
    $update_query .= ", unsubscribed_date = '".date('Y-m-d H:i:s')."'";
} elseif($status == 'active') {
    $update_query .= ", unsubscribed_date = NULL";
}

$update_query .= " WHERE id = $subscriber_id";

if($db->sql_query($update_query)) {
    
    // Log activity
    $action = "Updated subscriber status: " . $subscriber['email'] . " to " . $status;
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
    
    $values['response'] = 1;
    $values['msg'] = 'Subscriber status updated successfully';
    
} else {
    $values['response'] = 2;
    $values['msg'] = 'Failed to update subscriber status';
}

echo json_encode($values);
?>

