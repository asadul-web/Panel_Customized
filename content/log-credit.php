<?php
chkSession();

$smarty->assign('logs_active', 'active');
$smarty->assign('logs_credit_active', 'active');
$smarty->display("log-credit.tpl");
?>