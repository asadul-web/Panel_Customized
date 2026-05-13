<?php
chkSession();

$smarty->assign('dns_active', 'active');
$smarty->display("dns.tpl");
?>