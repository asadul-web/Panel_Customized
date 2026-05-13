<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../includes/functions.php';
$values = array();
$valid = true;

//If username contains special characters
if(preg_match('/[^a-z-A-Z-0-9]/',$_GET['username'])){
    $errormsg[] = array(
                    "value" => $_GET['username'] !== null ? $_GET['username'] : '',
                    "msg" => 'Error occured.',
                    "param" => 'username',
                    "location" => 'query');          
    $valid = false;
}

//If username is empty
if(!isset($_GET['username']) || empty($_GET['username']) && $_GET['username'] !== '0'){
    $errormsg[] = array(
                    "msg" => 'Error occured.',
                    "param" => 'username',
                    "location" => 'body');
    $errormsg[] = array(
                    "value" => $_GET['username'] !== null ? $_GET['username'] : '',
                    "msg" => 'Error occured.',
                    "param" => 'username',
                    "location" => 'body');          
    $valid = false;
}

if($valid){
 	$username = strip_tags(trim($_GET['username']));

 	$query = $db->sql_query("SELECT duration, device_connected FROM users WHERE user_name='".$username."' LIMIT 1") or die('Database Error.');
    $row = $db->sql_fetchrow($query);
 	$check_user = $db->sql_numrows($query);
 	    
 	$is_active = $row['device_connected'];
 	    
 	if($check_user > 0){
 	    if($is_active == 1){
         	$dur = $db->calc_time($row['duration']);
            $pdays = $dur['days'] . " days";
            $phours = $dur['hours'] . " hours";
        	$pminutes = $dur['minutes'] . " minutes";
        	$pseconds = $dur['seconds'] . " seconds";
        		
        	$premuim_duration = strtotime($pdays . $phours . $pminutes . $pseconds);
            $premuim_duration = date('Y-m-d H:i:s', $premuim_duration);
         	    
         	$json_data = array(
                            "status" => true,
                            "message" => $premuim_duration);
            $values = $json_data;
 	    }else{
 	        $json_data = array(
                            "status" => true,
                            "message" => 'none');
            $values = $json_data;
 	    }
 	}else{
 	    $json_data = array(
                        "status" => false,
                        "message" => 'Invalid request');
        $values = $json_data;
 	}
 	echo json_encode($values);
}else{
 	die('Access denied.');
}
?>