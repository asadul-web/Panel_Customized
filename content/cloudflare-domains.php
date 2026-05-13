<?php
chkSession();

if($user_id_2 == 2 || $user_level_2 == 'developer'){
    $smarty->assign('cloudflare_domains_active', 'active');
    $smarty->display("cloudflare_domains.tpl");
}else{
    $db->RedirectToURL($db->base_url());
    exit;
}
?>
