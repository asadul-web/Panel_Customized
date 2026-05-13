<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

if(!isset($_GET['type']) || empty($_GET['type'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
	$type = $_GET['type'];
	
	//Get all Active clients
    if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
        $sqlActive = "SELECT * FROM users WHERE 1=1 AND user_id!='$user_id_2' AND user_level='$type' AND device_connected!=''";
    }else{
    	$sqlActive = "SELECT * FROM users WHERE 1=1 AND user_id!='$user_id_2' AND upline='$user_id_2' AND user_level='$type' AND device_connected!=''";
    }
    $qryActive = $db->sql_query("$sqlActive") OR die();
	$rowActive = $db->sql_numrows($qryActive);
	
	//Get all Inactive clients
    if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
        $sqlInactive = "SELECT * FROM users WHERE 1=1 AND user_id!='$user_id_2' AND user_level='$type' AND device_connected=''";
    }else{
    	$sqlInactive = "SELECT * FROM users WHERE 1=1 AND user_id!='$user_id_2' AND upline='$user_id_2' AND user_level='$type' AND device_connected=''";
    }
    $qryInactive = $db->sql_query("$sqlInactive") OR die();
	$rowInactive = $db->sql_numrows($qryInactive);
	
	//Get all Inactive2 clients
    if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
        $sqlInactive2 = "SELECT * FROM users WHERE 1=1 AND user_id!='$user_id_2' AND (user_level='normal' OR user_level='bulk' OR user_level='trial') AND device_connected=''";
    }else{
    	$sqlInactive2 = "SELECT * FROM users WHERE 1=1 AND user_id!='$user_id_2' AND upline='$user_id_2' AND (user_level='normal' OR user_level='bulk' OR user_level='trial') AND device_connected=''";
    }
    $qryInactive2 = $db->sql_query("$sqlInactive2") OR die();
	$rowInactive2 = $db->sql_numrows($qryInactive2);
	
    $rowTotal = $rowActive + $rowInactive;
	
	$values = array();
	$valid = true;
    
	if($row){
		$values['active'] = $rowActive;
		$values['inactive'] = $rowInactive;
		$values['inactive2'] = $rowInactive2;
		$values['total'] = $rowTotal;
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