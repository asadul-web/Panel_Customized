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
$settings = array(
    'bulk_email_enabled' => isset($_POST['bulk_email_enabled']) ? $_POST['bulk_email_enabled'] : '0',
    'email_tracking_enabled' => isset($_POST['email_tracking_enabled']) ? $_POST['email_tracking_enabled'] : '0',
    'bulk_email_per_batch' => intval($_POST['bulk_email_per_batch']),
    'bulk_email_delay' => intval($_POST['bulk_email_delay']),
    'bulk_email_from_name' => $db->Sanitize(trim($_POST['bulk_email_from_name'])),
    'bulk_email_reply_to' => $db->Sanitize(trim($_POST['bulk_email_reply_to']))
);

// Validate settings
if($settings['bulk_email_per_batch'] < 1 || $settings['bulk_email_per_batch'] > 500) {
    $values['response'] = 2;
    $values['msg'] = 'Emails per batch must be between 1 and 500';
    echo json_encode($values);
    exit;
}

if($settings['bulk_email_delay'] < 1 || $settings['bulk_email_delay'] > 60) {
    $values['response'] = 2;
    $values['msg'] = 'Delay must be between 1 and 60 seconds';
    echo json_encode($values);
    exit;
}

if(empty($settings['bulk_email_from_name'])) {
    $values['response'] = 2;
    $values['msg'] = 'From name is required';
    echo json_encode($values);
    exit;
}

if(!empty($settings['bulk_email_reply_to']) && !filter_var($settings['bulk_email_reply_to'], FILTER_VALIDATE_EMAIL)) {
    $values['response'] = 2;
    $values['msg'] = 'Please enter a valid reply-to email address';
    echo json_encode($values);
    exit;
}

$updated_count = 0;

// Update each setting
foreach($settings as $setting_name => $setting_value) {
    // Check if setting exists
    $check_query = "SELECT id FROM reseller_settings WHERE setting_name = '".$db->SanitizeForSQL($setting_name)."'";
    $check_result = $db->sql_query($check_query);
    
    if($db->sql_numrows($check_result) > 0) {
        // Update existing setting
        $update_query = "UPDATE reseller_settings SET 
                        setting_value = '".$db->SanitizeForSQL($setting_value)."' 
                        WHERE setting_name = '".$db->SanitizeForSQL($setting_name)."'";
        
        if($db->sql_query($update_query)) {
            $updated_count++;
        }
    } else {
        // Insert new setting
        $insert_query = "INSERT INTO reseller_settings (setting_name, setting_value) 
                        VALUES ('".$db->SanitizeForSQL($setting_name)."', '".$db->SanitizeForSQL($setting_value)."')";
        
        if($db->sql_query($insert_query)) {
            $updated_count++;
        }
    }
}

if($updated_count > 0) {
    // Log activity
    $action = "Updated bulk email settings";
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
    
    $values['response'] = 1;
    $values['msg'] = 'Bulk email settings saved successfully';
} else {
    $values['response'] = 2;
    $values['msg'] = 'Failed to save settings';
}

echo json_encode($values);
?>

