<?php
chkSession();

$smarty->assign('create_active', 'active');
$smarty->assign('create_user_active', 'active');
$smarty->display("add-user.tpl");
?>