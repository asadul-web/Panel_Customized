<?php
chkSession();

$smarty->assign('ads_active', 'active');
$smarty->assign('ads_revenue_active', 'active');
$smarty->display("ads-revenue.tpl");
?>
