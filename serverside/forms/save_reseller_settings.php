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

if(!isset($_POST['submitted']) || $_POST['submitted'] != 'reseller_settings') {
    $values['response'] = 2;
    $values['msg'] = 'Invalid request';
    echo json_encode($values);
    exit;
}

$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);

if($get_key != 'firenetdev') {
    $values['response'] = 2;
    $values['msg'] = 'Invalid security key';
    echo json_encode($values);
    exit;
}

// Settings to update
$settings = array(
    // Company branding settings
    'company_name' => $db->Sanitize(trim($_POST['company_name'] ?? '')),
    'panel_domain' => $db->Sanitize(trim($_POST['panel_domain'] ?? '')),
    'company_website' => $db->Sanitize(trim($_POST['company_website'] ?? '')),
    'company_phone' => $db->Sanitize(trim($_POST['company_phone'] ?? '')),
    'company_address' => $db->Sanitize(trim($_POST['company_address'] ?? '')),
    // Email settings
    'email_notifications' => isset($_POST['email_notifications']) ? '1' : '0',
    'auto_approval' => isset($_POST['auto_approval']) ? '1' : '0',
    'admin_email' => $db->Sanitize(trim($_POST['admin_email'])),
    'smtp_enabled' => isset($_POST['smtp_enabled']) ? '1' : '0',
    'smtp_type' => $db->Sanitize(trim($_POST['smtp_type'] ?? 'gmail')),
    // Legacy SMTP settings (for backward compatibility)
    'smtp_host' => $db->Sanitize(trim($_POST['smtp_host'] ?? '')),
    'smtp_port' => $db->Sanitize(trim($_POST['smtp_port'] ?? '587')),
    'smtp_security' => $db->Sanitize(trim($_POST['smtp_security'] ?? 'tls')),
    'smtp_username' => $db->Sanitize(trim($_POST['smtp_username'] ?? '')),
    'smtp_password' => $db->Sanitize(trim($_POST['smtp_password'] ?? '')),
    'smtp_from_email' => $db->Sanitize(trim($_POST['smtp_from_email'] ?? '')),
    'smtp_from_name' => $db->Sanitize(trim($_POST['smtp_from_name'] ?? 'VPN Panel')),
    // Gmail SMTP settings
    'gmail_enabled' => isset($_POST['gmail_enabled']) ? '1' : '0',
    'gmail_username' => $db->Sanitize(trim($_POST['gmail_username'] ?? 'datasoftcaresales@gmail.com')),
    'gmail_from_name' => $db->Sanitize(trim($_POST['gmail_from_name'] ?? 'VPN Panel System')),
    // Webmail SMTP settings
    'webmail_host' => $db->Sanitize(trim($_POST['webmail_host'] ?? 'mail.ruzain.com')),
    'webmail_port' => $db->Sanitize(trim($_POST['webmail_port'] ?? '587')),
    'webmail_security' => $db->Sanitize(trim($_POST['webmail_security'] ?? 'tls')),
    'webmail_username' => $db->Sanitize(trim($_POST['webmail_username'] ?? 'info@ruzain.com')),
    'webmail_password' => $db->Sanitize(trim($_POST['webmail_password'] ?? '')),
    'webmail_from_name' => $db->Sanitize(trim($_POST['webmail_from_name'] ?? 'VPN Panel')),
    // Email templates
    'welcome_email_subject' => $db->Sanitize(trim($_POST['welcome_email_subject'] ?? 'Welcome to Our Reseller Program')),
    'welcome_email_body' => $db->Sanitize(trim($_POST['welcome_email_body'])),
    'approval_email_subject' => $db->Sanitize(trim($_POST['approval_email_subject'])),
    'approval_email_body' => $db->Sanitize(trim($_POST['approval_email_body'])),
    'rejection_email_subject' => $db->Sanitize(trim($_POST['rejection_email_subject'])),
    'rejection_email_body' => $db->Sanitize(trim($_POST['rejection_email_body'])),
    'auto_reply_email_subject' => $db->Sanitize(trim($_POST['auto_reply_email_subject'] ?? 'Thank You! Your Application has been Received')),
    'auto_reply_email_body' => $db->Sanitize(trim($_POST['auto_reply_email_body']))
);

// Validate email if provided
if(!empty($settings['admin_email']) && !filter_var($settings['admin_email'], FILTER_VALIDATE_EMAIL)) {
    $values['response'] = 2;
    $values['msg'] = 'Please enter a valid admin email address';
    echo json_encode($values);
    exit;
}

$success = true;

foreach($settings as $setting_name => $setting_value) {
    
    // Check if setting exists
    $check_query = "SELECT id FROM reseller_settings WHERE setting_name = '".$db->SanitizeForSQL($setting_name)."'";
    $check_result = $db->sql_query($check_query);
    
    if($db->sql_numrows($check_result) > 0) {
        // Update existing setting
        $update_query = "UPDATE reseller_settings SET 
                        setting_value = '".$db->SanitizeForSQL($setting_value)."',
                        updated_date = '".date('Y-m-d H:i:s')."'
                        WHERE setting_name = '".$db->SanitizeForSQL($setting_name)."'";
        $result = $db->sql_query($update_query);
    } else {
        // Insert new setting
        $insert_query = "INSERT INTO reseller_settings (setting_name, setting_value) 
                        VALUES ('".$db->SanitizeForSQL($setting_name)."', '".$db->SanitizeForSQL($setting_value)."')";
        $result = $db->sql_query($insert_query);
    }
    
    if(!$result) {
        $success = false;
        break;
    }
}

if($success) {
    
    // Log activity
    $action = "Updated reseller settings";
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
    
    $values['response'] = 1;
    $values['msg'] = 'Settings saved successfully';
    
} else {
    $values['response'] = 2;
    $values['msg'] = 'Failed to save settings';
}

echo json_encode($values);
?>

