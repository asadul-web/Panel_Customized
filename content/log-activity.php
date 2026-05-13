<?php
chkSession();

$smarty->assign('logs_active', 'active');
$smarty->assign('logs_activity_active', 'active');
$smarty->display("log-activity.tpl");
?>