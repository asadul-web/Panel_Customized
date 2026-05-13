<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
	$values = array();
    
    $mycredit = $db->sql_query("SELECT credits FROM users WHERE user_id='$user_id_2' AND (user_level='reseller' || user_level='superadmin')");
    $rowc = $db->sql_fetchrow($mycredit);
    $usercredit = $rowc['credits'];
    $prefixgen = ran_prefix();
    
    if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
        $mycred = '99999';
    }else{
        $mycred = $usercredit;
    }
    
    $values['mycredit'] = $mycred;
    $values['prefix'] = $prefixgen;

	echo json_encode($values);
?>
