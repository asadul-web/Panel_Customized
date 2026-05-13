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
$email = $db->Sanitize(trim($_POST['email']));
$name = $db->Sanitize(trim($_POST['name']));
$tags = $db->Sanitize(trim($_POST['tags']));
$source = $db->Sanitize(trim($_POST['source']));
$status = $db->Sanitize(trim($_POST['status']));

// Validate input
if(empty($subscriber_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing subscriber ID';
    echo json_encode($values);
    exit;
}

if(empty($email)) {
    $values['response'] = 2;
    $values['msg'] = 'Email address is required';
    echo json_encode($values);
    exit;
}

if(!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $values['response'] = 2;
    $values['msg'] = 'Please enter a valid email address';
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

$old_subscriber = $db->sql_fetchrow($check_result);

// Check if email is already used by another subscriber
if($email != $old_subscriber['email']) {
    $email_check_query = "SELECT id FROM email_subscribers WHERE email = '".$db->SanitizeForSQL($email)."' AND id != $subscriber_id";
    $email_check_result = $db->sql_query($email_check_query);
    
    if($db->sql_numrows($email_check_result) > 0) {
        $values['response'] = 2;
        $values['msg'] = 'This email address is already used by another subscriber';
        echo json_encode($values);
        exit;
    }
}

// Update subscriber
$update_query = "UPDATE email_subscribers SET 
                email = '".$db->SanitizeForSQL($email)."',
                name = '".$db->SanitizeForSQL($name)."',
                tags = '".$db->SanitizeForSQL($tags)."',
                source = '".$db->SanitizeForSQL($source)."',
                status = '".$db->SanitizeForSQL($status)."'";

// Update unsubscribed_date based on status
if($status == 'unsubscribed') {
    $update_query .= ", unsubscribed_date = '".date('Y-m-d H:i:s')."'";
} elseif($status == 'active') {
    $update_query .= ", unsubscribed_date = NULL";
}

$update_query .= " WHERE id = $subscriber_id";

if($db->sql_query($update_query)) {
    
    // Log activity
    $action = "Updated email subscriber: $email";
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
    
    $values['response'] = 1;
    $values['msg'] = 'Subscriber updated successfully';
    
} else {
    $values['response'] = 2;
    $values['msg'] = 'Failed to update subscriber';
}

echo json_encode($values);
?>

