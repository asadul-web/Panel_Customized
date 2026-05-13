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

// Get subscriber statistics with error handling
try {
    $stats_query = "SELECT 
        COUNT(*) as total_subscribers,
        COUNT(CASE WHEN status = 'active' THEN 1 END) as active_subscribers,
        COUNT(CASE WHEN status = 'unsubscribed' THEN 1 END) as unsubscribed,
        COUNT(CASE WHEN status = 'bounced' THEN 1 END) as bounced,
        COUNT(CASE WHEN DATE(subscribed_date) = CURDATE() THEN 1 END) as today_subscribers,
        COUNT(CASE WHEN DATE(subscribed_date) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as week_subscribers
        FROM email_subscribers";

    $stats_result = $db->sql_query($stats_query);
    
    if($stats_result) {
        $stats = $db->sql_fetchrow($stats_result);
    } else {
        // Default stats if query fails
        $stats = array(
            'total_subscribers' => 0,
            'active_subscribers' => 0,
            'unsubscribed' => 0,
            'bounced' => 0,
            'today_subscribers' => 0,
            'week_subscribers' => 0
        );
    }
} catch(Exception $e) {
    // Default stats on error
    $stats = array(
        'total_subscribers' => 0,
        'active_subscribers' => 0,
        'unsubscribed' => 0,
        'bounced' => 0,
        'today_subscribers' => 0,
        'week_subscribers' => 0
    );
}

$smarty->assign('bulk_email_active', 'active');
$smarty->assign('email_subscribers_active', 'active');
$smarty->assign('stats', $stats);
$smarty->display('email-subscribers.tpl');
?>

