<?php
require_once '../includes/functions.php';

if(!is_logged_in($user)) {
	header("Location: /login");
	exit;
}

// Allow developer to access this page
if ($user_level_2 === 'developer') {
	header("Location: /developer-settings");
	exit;
}

$license_check = chkLicense();

// Check if no license at all
$no_license = !isset($license_check['data']) || empty($license_check['data']);

$smarty->assign('license_status', $license_check);
$smarty->assign('no_license', $no_license);
$smarty->display("license-blocked.tpl");
