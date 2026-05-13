<?php
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
	
}else{
	header("Location: /dashboard");	
}

$smarty->assign('application_active', 'active');
$smarty->display("application.tpl");
?>