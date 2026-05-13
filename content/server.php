<?php
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
	
}else{
	header("Location: /dashboard");	
}

$smarty->assign('server_active', 'active');
$smarty->display("server.tpl");
?>