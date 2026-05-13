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
	$socksip_info = '';
	
    $sql = "SELECT * FROM users WHERE user_id!='$user_id_2' AND user_id='$uid'";
    $qry = $db->sql_query("$sql") OR die();
	$row = $db->sql_fetchrow($qry);
	$username = $row['user_name'];
	$password = $row['user_pass'];
	// Use single decryption to match database encryption
	$userpass = $db->encryptor('decrypt', $password);
	$userlevel = $row['user_level'];
	$userduration = $row['duration'];
	$userupline = $row['upline'];
	$device_id = $row['device_id'];
	$device_model = $row['device_model'];
	$is_activated = $row['is_active'];
	$is_freeze = $row['is_freeze'];
	$is_socksip = $row['is_socksip'];
	
	$dur = $db->calc_time($userduration);	
	$pdays = $dur['days'] . " days";
	$phours = $dur['hours'] . " hours";
	$pminutes = $dur['minutes'] . " minutes";
	$pseconds = $dur['seconds'] . " seconds";
	
	if($userduration == 0){
	    $duration = 'Expired';
	}else{
		$duration = strtotime($pdays . $phours . $pminutes . $pseconds);
		$duration = date('Y-m-d H:m:s', $duration);
	}
	
	if($userlevel == 'normal'){
	    $user_level = 'Normal';
	}elseif($userlevel == 'bulk'){
	    $user_level = 'Bulk';
	}elseif($userlevel == 'trial'){
	    $user_level = 'Trial';
	}
	
	if($is_activated == 1){
	    $expiration = $duration;
	    $devicemodel = $device_model;
	}else{
	    $expiration = 'none';
	    $devicemodel = 'none';
	}
	
	if($is_freeze == 1){
	    $blockstat = 'Yes';
	    $user_freeze_status = 'Unblock';
	    $user_freeze_color = 'danger';
	    $proceed_block = 'unblock';
	    $confirm_block = 'dounblock';
	}else{
	    $blockstat = 'No';
	    $user_freeze_status = 'Block';
	    $user_freeze_color = 'primary';
	    $proceed_block = 'block';
	    $confirm_block = 'doblock';
	}
	
	if($is_socksip == 1){
	    $socksipstat = 'Yes';
	    $user_socksip_status = 'Disable';
	    $user_socksip_color = 'danger';
	    $proceed_socksip = 'disable';
	    $confirm_socksip = 'dodisable';
	    $socksip_info = 'd-none';
	}else{
	    $socksipstat = 'No';
	    $user_socksip_status = 'Enable';
	    $user_socksip_color = 'primary';
	    $proceed_socksip = 'enable';
	    $confirm_socksip = 'doenable';
	    $socksip_info = '';
	}
	
	$upline_qry = $db->sql_query("SELECT user_name FROM users WHERE upline='$userupline'") OR die();
	$upline_row = $db->sql_fetchrow($upline_qry);
	$upline = $upline_row['user_name'];
	
	$values = array();
	$valid = true;
    
	if($row){
		$values['username'] = $username;
		$values['userpass'] = $userpass;
		$values['subscription'] = $user_level;
		$values['expired'] = $expiration;
		$values['upline'] = $upline;
		$values['device'] = $devicemodel;
		
		$values['blockstatus'] = $blockstat;
		$values['freezestatus'] = $user_freeze_status;
		$values['freezecolor'] = $user_freeze_color;
		$values['proceedblock'] = $proceed_block;
		$values['confirmblock'] = $confirm_block;
        
        $values['socksipstatus'] = $user_socksip_status;
        $values['socksipcolor'] = $user_socksip_color;
        $values['proceedsocksip'] = $proceed_socksip;
		$values['confirmsocksip'] = $confirm_socksip;
		$values['socksipinfo'] = $socksip_info;

		$values['response'] = 1;
	}else{
		$values['response'] = 2;
	}
	if($valid == false){
		$values['response'] = 0;
	}
	echo json_encode($values);
}
?>
