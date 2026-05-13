<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'reseller' || $user_level_2 == 'developer'){
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
	$device_connected = $row['device_connected'];
	
	$sql_bio = "SELECT bio_link FROM users_profile WHERE profile_id='$uid'";
    $qry_bio = $db->sql_query("$sql_bio") OR die();
	$row_bio = $db->sql_fetchrow($qry_bio);
	$blink = $row_bio['bio_link'];
	
	$file = fopen($_SERVER['DOCUMENT_ROOT'] . "/profile/$uid/$blink", "r");
	$content_ = fread($file,filesize($_SERVER['DOCUMENT_ROOT'] . "/profile/$uid/$blink"));
	if($content_ == ''){
	    $content = 'I am a freelance based in Saudi Arabia, passionate about career development and helping people find new roles.';
	}else{
	    $content = $content_;
	}
	fclose($file);
	
	$dur = $db->calc_time($userduration);	
	$pdays = $dur['days'] . " days";
	$phours = $dur['hours'] . " hours";
	$pminutes = $dur['minutes'] . " minutes";
	$pseconds = $dur['seconds'] . " seconds";
	
	if($userduration == 0){
	    $duration = 'Expired';
	}else{
		$duration = strtotime($pdays . $phours . $pminutes . $pseconds);
		$duration = date('M-d-Y', $duration);
	}
	
	if($userlevel == 'normal'){
	    $user_level = 'Normal';
	}elseif($userlevel == 'bulk'){
	    $user_level = 'Bulk';
	}elseif($userlevel == 'trial'){
	    $user_level = 'Trial';
	}
	
	if($device_model == ''){
	    $devicemodel = 'none';
	}else{
	    $devicemodel = $device_model;
	}
	
	if($device_connected == 1){
	    $expiration = $duration;
	}else{
	    $expiration = 'none';
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
	
	$sql2 = "SELECT profile_image FROM users_profile WHERE profile_id!='$user_id_2' AND profile_id='$uid'";
    $qry2 = $db->sql_query("$sql2") OR die();
	$row2 = $db->sql_fetchrow($qry2);
	
	$prof2_image = $row2['profile_image'];
	$prof_profile = 'profile/'.$uid.'/'.$prof2_image;
	$prof_default = 'profile/avatar-1.png';
	
	if($prof2_image == ''){
	    $upic = '<img class="rounded-circle profile-widget-picture" width="250" src="'.$prof_default.'" alt="default">';
	}else{
	    $upic = '<img class="rounded-circle profile-widget-picture" width="250" src="'.$prof_profile.'" alt="'.$username.'">';
	}
	
	$upline_qry = $db->sql_query("SELECT user_name FROM users WHERE user_id='$userupline'") OR die();
	$upline_row = $db->sql_fetchrow($upline_qry);
	$uupline = $upline_row['user_name'];
	
	//Get normal downlines
	$downline_normal = $db->sql_query("SELECT user_name FROM users WHERE user_id!=1 AND user_level='normal' AND upline='$uid'") OR die();
	$d_normal = $db->sql_numrows($downline_normal);
	
	//Get bulk downlines
	$downline_bulk = $db->sql_query("SELECT user_name FROM users WHERE user_id!=1 AND user_level='bulk' AND upline='$uid'") OR die();
	$d_bulk = $db->sql_numrows($downline_bulk);
	
	//Get trial downlines
	$downline_trial = $db->sql_query("SELECT user_name FROM users WHERE user_id!=1 AND user_level='trial' AND upline='$uid'") OR die();
	$d_trial = $db->sql_numrows($downline_trial);
	
	//Get reseller downlines
	$downline_reseller = $db->sql_query("SELECT user_name FROM users WHERE user_id!=1 AND user_level='reseller' AND upline='$uid'") OR die();
	$d_reseller = $db->sql_numrows($downline_reseller);
	
	//Get total downlines
	$d_total = $d_normal + $d_bulk + $d_trial + $d_reseller;
	
	$values = array();
	$valid = true;
    
	if($row){
		$values['username'] = $username;
		$values['userpass'] = $userpass;
		$values['subscription'] = $user_level;
		$values['userlevel'] = $userlevel;
		$values['expired'] = $expiration;
		$values['upline'] = $uupline;
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
		
        $values['bio'] = $content;
        
        $values['dnormal'] = $d_normal;
        $values['dbulk'] = $d_bulk;
        $values['dtrial'] = $d_trial;
        $values['dreseller'] = $d_reseller;
        $values['dtotal'] = $d_total;
        
        $values['upic'] = $upic;
        
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