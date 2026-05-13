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

if(!isset($_GET['uid']) || empty($_GET['uid'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
    $uid = $_GET['uid'];
	$values = array();
    
    $mycredit = $db->sql_query("SELECT credits FROM users WHERE user_id='$user_id_2'");
    $myrow = $db->sql_fetchrow($mycredit);
    $my_credit = $myrow['credits'];
    
    if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
        $mycred = '99999';
    }else{
        $mycred = $my_credit;
    }
    
    $clientcredit = $db->sql_query("SELECT credits FROM users WHERE user_id='$uid'");
    $clientrow = $db->sql_fetchrow($clientcredit);
    $client_credit = $clientrow['credits'];
    
    $values['mycredit'] = $mycred;
    $values['clientcredit'] = $client_credit;

	echo json_encode($values);
}
?>
