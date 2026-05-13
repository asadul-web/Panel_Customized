<?php
chkSession();

$smarty->assign('manage_active', 'active');
$smarty->assign('manage_user_active', 'active');
$smarty->display("view-user.tpl");
?>