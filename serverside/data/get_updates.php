<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'reseller' || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $valid = true;
    $site_qry = $db->sql_query("SELECT site_status FROM site_options") OR die();
    $site_row = $db->sql_fetchrow($site_qry);
    $site_status = $site_row['site_status'];
        
    $install_permit = false;
    if($site_status == 1){
        $install_permit = true;
    }else{
        $install_permit = false;
    }
        
    if($valid == true){
        $values['allowinstall'] = $install_permit;
        $values['response'] = 1;
    }else{
        $values['response'] = 0;
    }
    echo json_encode($values);
?>
