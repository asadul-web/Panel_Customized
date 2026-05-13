<?php
chkSession();

$smarty->assign('notification_active', 'active');
$smarty->display("notification.tpl");
?>