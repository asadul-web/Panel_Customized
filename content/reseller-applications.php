<?php
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

// Get applications data
$applications_query = "SELECT * FROM reseller_applications ORDER BY applied_date DESC";
$applications_result = $db->sql_query($applications_query);
$applications = array();

if($applications_result) {
    while($app = $db->sql_fetchrow($applications_result)) {
        $applications[] = $app;
    }
}

// Calculate statistics
$total_applications = count($applications);
$approved_applications = 0;
$pending_applications = 0;
$rejected_applications = 0;

foreach($applications as $app) {
    switch(strtolower($app['status'])) {
        case 'approved':
            $approved_applications++;
            break;
        case 'pending':
        case 'under_review':
            $pending_applications++;
            break;
        case 'rejected':
            $rejected_applications++;
            break;
    }
}

// Assign variables to template
$smarty->assign('reseller_applications_active', 'active');
$smarty->assign('applications', $applications);
$smarty->assign('total_applications', $total_applications);
$smarty->assign('approved_applications', $approved_applications);
$smarty->assign('pending_applications', $pending_applications);
$smarty->assign('rejected_applications', $rejected_applications);
$smarty->display('reseller-applications.tpl');
?>
