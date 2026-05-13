<?php
chkSession();

$smarty->assign('ads_active', 'active');
$smarty->assign('ads_manage_active', 'active');
$smarty->display("ads-manage.tpl");
?>
