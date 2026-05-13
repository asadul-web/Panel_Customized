<?php
chkSession();

$smarty->assign('ads_active', 'active');
$smarty->assign('ads_view_active', 'active');
$smarty->display("ads-view.tpl");
?>
