<?php
chkSession();

$smarty->assign('logs_active', 'active');
$smarty->assign('logs_bulk_active', 'active');
$smarty->display("log-bulk.tpl");
?>