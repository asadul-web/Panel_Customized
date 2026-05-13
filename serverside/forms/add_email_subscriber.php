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
$email = $db->Sanitize(trim($_POST['email']));
$name = $db->Sanitize(trim($_POST['name']));
$tags = $db->Sanitize(trim($_POST['tags']));
$source = $db->Sanitize(trim($_POST['source']));

// Validate email
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

// Check if email already exists
$check_query = "SELECT id FROM email_subscribers WHERE email = '".$db->SanitizeForSQL($email)."'";
$check_result = $db->sql_query($check_query);

if($db->sql_numrows($check_result) > 0) {
    $values['response'] = 2;
    $values['msg'] = 'This email address is already subscribed';
    echo json_encode($values);
    exit;
}

// Insert new subscriber
$insert_query = "INSERT INTO email_subscribers (email, name, tags, source, subscribed_date, ip_address) 
                VALUES ('".$db->SanitizeForSQL($email)."', 
                        '".$db->SanitizeForSQL($name)."', 
                        '".$db->SanitizeForSQL($tags)."', 
                        '".$db->SanitizeForSQL($source)."', 
                        '".date('Y-m-d H:i:s')."',
                        '".$_SERVER['REMOTE_ADDR']."')";

if($db->sql_query($insert_query)) {
    
    // Log activity
    $action = "Added email subscriber: $email";
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
    
    $values['response'] = 1;
    $values['msg'] = 'Subscriber added successfully';
    
} else {
    $values['response'] = 2;
    $values['msg'] = 'Failed to add subscriber';
}

echo json_encode($values);
?>

