<?php
chkSession();

$smarty->assign('manage_active', 'active');
$smarty->assign('manage_reseller_active', 'active');
$smarty->display("view-reseller.tpl");
?>