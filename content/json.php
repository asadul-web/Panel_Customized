<?php
chkSession();

$smarty->assign('json_active', 'active');
$smarty->display("json.tpl");
?>