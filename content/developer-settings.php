<?php
chkSession();
if($user_id_2 == 2 || $user_level_2 == 'developer'){
	
}else{
	header("Location: /dashboard");	
}

// Get base URL from saved config or current domain
$base_url = getBaseApiUrl();

// API endpoints
$api_endpoints = [
	'notice_link' => $base_url . '/serverside/data/notice_api.php',
	'popup_notice' => $base_url . '/serverside/data/popup_notice_api.php',
	'license_api' => $base_url . '/serverside/data/licenses_api.php',
	'validate_license' => $base_url . '/serverside/data/validate_license.php',
	'licenses_proxy' => $base_url . '/serverside/data/licenses_proxy.php'
];

$smarty->assign('devsetting_active', 'active');
$smarty->assign('api_endpoints', $api_endpoints);
$smarty->assign('base_url_full', $base_url);
$smarty->display("developer-settings.tpl");
?>