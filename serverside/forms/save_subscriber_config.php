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
$email_frequency = $db->sql_escape_string($_POST['email_frequency']);
$email_format = $db->sql_escape_string($_POST['email_format']);
$marketing_emails = intval($_POST['marketing_emails']);
$newsletter = intval($_POST['newsletter']);
$product_updates = intval($_POST['product_updates']);

// Validate input
if(empty($subscriber_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing subscriber ID';
    echo json_encode($values);
    exit;
}

// Validate email frequency
$valid_frequencies = array('daily', 'weekly', 'monthly', 'never');
if(!in_array($email_frequency, $valid_frequencies)) {
    $values['response'] = 2;
    $values['msg'] = 'Invalid email frequency';
    echo json_encode($values);
    exit;
}

// Validate email format
$valid_formats = array('html', 'text');
if(!in_array($email_format, $valid_formats)) {
    $values['response'] = 2;
    $values['msg'] = 'Invalid email format';
    echo json_encode($values);
    exit;
}

// Check if subscriber exists
$check_query = "SELECT id FROM email_subscribers WHERE id = $subscriber_id";
$check_result = $db->sql_query($check_query);

if(!$check_result || $db->sql_numrows($check_result) == 0) {
    $values['response'] = 2;
    $values['msg'] = 'Subscriber not found';
    echo json_encode($values);
    exit;
}

// Check if configuration already exists
$config_check_query = "SELECT subscriber_id FROM subscriber_config WHERE subscriber_id = $subscriber_id";
$config_check_result = $db->sql_query($config_check_query);

if($config_check_result && $db->sql_numrows($config_check_result) > 0) {
    // Update existing configuration
    $update_query = "UPDATE subscriber_config SET 
                     email_frequency = '$email_frequency',
                     email_format = '$email_format',
                     marketing_emails = $marketing_emails,
                     newsletter = $newsletter,
                     product_updates = $product_updates,
                     updated_date = NOW()
                     WHERE subscriber_id = $subscriber_id";
    
    $update_result = $db->sql_query($update_query);
    
    if($update_result) {
        $values['response'] = 1;
        $values['msg'] = 'Subscriber configuration updated successfully';
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to update subscriber configuration';
    }
} else {
    // Insert new configuration
    $insert_query = "INSERT INTO subscriber_config 
                     (subscriber_id, email_frequency, email_format, marketing_emails, newsletter, product_updates, created_date, updated_date) 
                     VALUES 
                     ($subscriber_id, '$email_frequency', '$email_format', $marketing_emails, $newsletter, $product_updates, NOW(), NOW())";
    
    $insert_result = $db->sql_query($insert_query);
    
    if($insert_result) {
        $values['response'] = 1;
        $values['msg'] = 'Subscriber configuration saved successfully';
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to save subscriber configuration';
    }
}

echo json_encode($values);
?>

