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

    $sql = "SELECT * FROM users WHERE user_id='$user_id_2'";
    $qry = $db->sql_query("$sql") OR die();
	$row = $db->sql_fetchrow($qry);
	
	$username = $row['user_name'];
	$password = $row['user_pass'];
	// Use single decryption to match database encryption
	$userpass = $db->encryptor('decrypt', $password);
	$userlevel = $row['user_level'];
	$userupline = $row['upline'];
	$usercredits = $row['credits'];
	$device_id = $row['device_id'];
	$device_model = $row['device_model'];
	$is_activated = $row['is_active'];
	$is_freeze = $row['is_freeze'];
	$device_connected = $row['device_connected'];
	
	$values = array();
	$valid = true;
    
    $upline_qry = $db->sql_query("SELECT user_name FROM users WHERE upline='$userupline'") OR die();
	$upline_row = $db->sql_fetchrow($upline_qry);
	$upline_ = $upline_row['user_name'];
	
	if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
	    $upline = $username;
	}else{
	    $upline = $upline_;
	}
    
	if($valid == true){
		$values['myusername'] = $username;
		$values['myuserpass'] = $userpass;
		$values['mydevice'] = $device_model;
		$values['myupline'] = $upline;
		$values['mycredit'] = $usercredits;
		$values['response'] = 1;
	}else{
		$values['response'] = 2;
	}
	if($valid == false){
		$values['response'] = 0;
	}
	echo json_encode($values);

?>
