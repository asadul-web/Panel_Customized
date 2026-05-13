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

// Initialize auto_fix_result as empty (no automatic fixing)
$auto_fix_result = array('fixed' => 0, 'campaigns' => array());

// Get campaign statistics with error handling
try {
    $stats_query = "SELECT
        COUNT(*) as total_campaigns,
        COUNT(CASE WHEN status = 'draft' THEN 1 END) as draft_campaigns,
        COUNT(CASE WHEN status = 'sent' THEN 1 END) as sent_campaigns,
        COUNT(CASE WHEN status = 'sending' THEN 1 END) as sending_campaigns,
        SUM(CASE WHEN status = 'sent' THEN emails_sent ELSE 0 END) as total_emails_sent,
        SUM(CASE WHEN status = 'sent' THEN opens ELSE 0 END) as total_opens
        FROM email_campaigns";

    $stats_result = $db->sql_query($stats_query);

    if($stats_result) {
        $stats = $db->sql_fetchrow($stats_result);

        // Calculate open rate
        $open_rate = $stats['total_emails_sent'] > 0 ?
            round(($stats['total_opens'] / $stats['total_emails_sent']) * 100, 2) : 0;

        $stats['open_rate'] = $open_rate;
    } else {
        // Default stats if query fails
        $stats = array(
            'total_campaigns' => 0,
            'draft_campaigns' => 0,
            'sent_campaigns' => 0,
            'sending_campaigns' => 0,
            'total_emails_sent' => 0,
            'total_opens' => 0,
            'open_rate' => 0
        );
    }
} catch(Exception $e) {
    // Default stats on error
    $stats = array(
        'total_campaigns' => 0,
        'draft_campaigns' => 0,
        'sent_campaigns' => 0,
        'sending_campaigns' => 0,
        'total_emails_sent' => 0,
        'total_opens' => 0,
        'open_rate' => 0
    );
}

$smarty->assign('bulk_email_active', 'active');
$smarty->assign('email_campaigns_active', 'active');
$smarty->assign('stats', $stats);
$smarty->assign('auto_fix_result', $auto_fix_result);
$smarty->display('email-campaigns.tpl');
?>

