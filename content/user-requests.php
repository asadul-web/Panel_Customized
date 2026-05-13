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

// Get pending user requests (is_validated = 0 means pending approval)
$pending_query = "SELECT user_id, user_name, full_name, user_email, mobile, regdate, duration, user_level 
                  FROM users 
                  WHERE is_validated = 0 AND user_level IN ('normal', 'bulk')
                  ORDER BY regdate DESC";
$pending_result = $db->sql_query($pending_query);
$pending_requests = array();

if($pending_result) {
    while($request = $db->sql_fetchrow($pending_result)) {
        // Calculate duration in months
        $duration_months = round($request['duration'] / 2592000);
        $request['duration_months'] = $duration_months;
        $pending_requests[] = $request;
    }
}

// Get approved users (only API-created users with mobile number)
$approved_query = "SELECT user_id, user_name, full_name, user_email, mobile, regdate, duration, user_level, is_active 
                   FROM users 
                   WHERE is_validated = 1 AND user_level IN ('normal', 'bulk') AND mobile IS NOT NULL AND mobile != ''
                   ORDER BY regdate DESC
                   LIMIT 50";
$approved_result = $db->sql_query($approved_query);
$approved_requests = array();

if($approved_result) {
    while($request = $db->sql_fetchrow($approved_result)) {
        $duration_months = round($request['duration'] / 2592000);
        $request['duration_months'] = $duration_months;
        $approved_requests[] = $request;
    }
}

// Get payment pending users (is_validated = 2 means pending payment verification)
$payment_query = "SELECT user_id, user_name, full_name, user_email, mobile, regdate, duration, user_level 
                  FROM users 
                  WHERE is_validated = 2 AND user_level IN ('normal', 'bulk')
                  ORDER BY regdate DESC";
$payment_result = $db->sql_query($payment_query);
$payment_pending = array();

if($payment_result) {
    while($request = $db->sql_fetchrow($payment_result)) {
        $duration_months = round($request['duration'] / 2592000);
        $request['duration_months'] = $duration_months;
        $payment_pending[] = $request;
    }
}

// Calculate statistics
$total_pending = count($pending_requests);
$total_approved = count($approved_requests);
$total_payment_pending = count($payment_pending);

// Get admin's API key for AJAX calls
$api_key_query = $db->sql_query("SELECT api_key FROM users WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
$api_key_row = $db->sql_fetchrow($api_key_query);
$api_key = $api_key_row['api_key'] ?? '';

// Assign variables to template
$smarty->assign('user_requests_active', 'active');
$smarty->assign('reseller_management_active', 'active');
$smarty->assign('pending_requests', $pending_requests);
$smarty->assign('approved_requests', $approved_requests);
$smarty->assign('payment_pending', $payment_pending);
$smarty->assign('total_pending', $total_pending);
$smarty->assign('total_approved', $total_approved);
$smarty->assign('total_payment_pending', $total_payment_pending);
$smarty->assign('api_key', $api_key);
$smarty->display('user-requests.tpl');
?>
