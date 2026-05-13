<?php
chkSession();

$smarty->assign('create_active', 'active');
$smarty->assign('create_reseller_active', 'active');
$smarty->display("add-reseller.tpl");
?>