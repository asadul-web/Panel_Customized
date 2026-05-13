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

// Get template statistics with error handling
try {
    $stats_query = "SELECT 
        COUNT(*) as total_templates,
        COUNT(CASE WHEN template_type = 'welcome' THEN 1 END) as welcome_templates,
        COUNT(CASE WHEN template_type = 'newsletter' THEN 1 END) as newsletter_templates,
        COUNT(CASE WHEN template_type = 'promotion' THEN 1 END) as promotion_templates,
        COUNT(CASE WHEN is_active = 1 THEN 1 END) as active_templates
        FROM email_templates";

    $stats_result = $db->sql_query($stats_query);
    
    if($stats_result) {
        $stats = $db->sql_fetchrow($stats_result);
    } else {
        // Default stats if query fails
        $stats = array(
            'total_templates' => 0,
            'welcome_templates' => 0,
            'newsletter_templates' => 0,
            'promotion_templates' => 0,
            'active_templates' => 0
        );
    }
} catch(Exception $e) {
    // Default stats on error
    $stats = array(
        'total_templates' => 0,
        'welcome_templates' => 0,
        'newsletter_templates' => 0,
        'promotion_templates' => 0,
        'active_templates' => 0
    );
}

$smarty->assign('bulk_email_active', 'active');
$smarty->assign('email_templates_active', 'active');
$smarty->assign('stats', $stats);
$smarty->display('email-templates.tpl');
?>

