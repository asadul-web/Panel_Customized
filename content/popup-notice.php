<?php
chkSession();
if($user_id_2 == 2 || $user_level_2 == 'developer'){
	
}else{
	header("Location: /dashboard");	
}

$smarty->assign('popup_notice_active', 'active');
$smarty->assign('popup_notice_proxy', $db->base_url() . 'serverside/data/popup_notice_proxy.php');
$smarty->display("popup-notice.tpl");
