<?php
chkSession();

$smarty->assign('logs_active', 'active');
$smarty->assign('logs_deleted_active', 'active');
$smarty->display("log-deleted.tpl");
?>