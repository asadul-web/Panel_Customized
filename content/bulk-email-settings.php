<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Check if user is logged in and has proper permissions
if(!isset($user) || empty($user) || !is_logged_in($user)) {
    $db->RedirectToURL($db->base_url().'login');
    exit;
}

// Check if user has admin permissions
if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    $db->RedirectToURL($db->base_url().'dashboard');
    exit;
}

// Get bulk email settings with error handling
try {
    $settings_query = "SELECT setting_name, setting_value FROM reseller_settings WHERE setting_name LIKE 'bulk_email_%' OR setting_name LIKE 'email_%'";
    $settings_result = $db->sql_query($settings_query);
    $settings = array();

    if($settings_result) {
        while($setting = $db->sql_fetchrow($settings_result)) {
            $settings[$setting['setting_name']] = $setting['setting_value'];
        }
    }
} catch(Exception $e) {
    $settings = array();
}

// Set default values if settings don't exist
$default_settings = array(
    'bulk_email_enabled' => '1',
    'bulk_email_per_batch' => '50',
    'bulk_email_delay' => '5',
    'bulk_email_from_name' => 'VPN Panel',
    'bulk_email_reply_to' => '',
    'email_tracking_enabled' => '1',
    'email_unsubscribe_enabled' => '1'
);

// Merge with defaults
foreach($default_settings as $key => $default_value) {
    if(!isset($settings[$key])) {
        $settings[$key] = $default_value;
    }
}

$smarty->assign('bulk_email_active', 'active');
$smarty->assign('bulk_email_settings_active', 'active');
$smarty->assign('settings', $settings);
$smarty->display('bulk-email-settings.tpl');
?>

