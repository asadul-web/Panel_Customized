<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../includes/functions.php';
$values = array();
$valid = true;

//If username contains special characters
if(preg_match('/[^a-z-A-Z-0-9]/',$_GET['username'])){
    $valid = false;
}

//If device_id contains special characters
if(preg_match('/[^a-z-A-Z-0-9]/',$_GET['device_id'])){
    $valid = false;
}

//If username is empty
if(!isset($_GET['username']) || empty($_GET['username']) && $_GET['username'] !== '0'){
    $valid = false;
}

//If device_id is empty
if(!isset($_GET['device_id']) || empty($_GET['device_id']) && $_GET['device_id'] !== '0'){
    $valid = false;
}

//If device_model is empty
if(!isset($_GET['device_model']) || empty($_GET['device_model']) && $_GET['device_model'] !== '0'){
    $valid = false;
}

if($valid){
 	$username = strip_tags(trim($_GET['username']));
 	$device_id = strip_tags(trim($_GET['device_id']));
 	$device_model = strip_tags(trim($_GET['device_model']));
 
 	$query = $db->sql_query("SELECT duration, device_id, device_model, device_connected FROM users WHERE user_name='".$username."' LIMIT 1") or die('Database Error.');
    $row = $db->sql_fetchrow($query);
 	$check_user = $db->sql_numrows($query);
 	    
 	$is_active = $row['device_connected'];
 	$deviceid = $row['device_id'];
 	$devicemodel = $row['device_model'];
 	    
 	$dur = $db->calc_time($row['duration']);
    $pdays = $dur['days'] . " days";
    $phours = $dur['hours'] . " hours";
    $pminutes = $dur['minutes'] . " minutes";
    $pseconds = $dur['seconds'] . " seconds";
            		
    $premuim_duration = strtotime($pdays . $phours . $pminutes . $pseconds);
    $premuim_duration = date('Y-m-d H:i:s', $premuim_duration);
 	    
 	if($is_active == 1){
 	    $duration = $premuim_duration;
 	}else{
 	    $duration = 'none';
 	}
 	    
 	if($check_user > 0){
 	    if($deviceid == '' && $devicemodel == ''){
 	        $update = $db->sql_query("UPDATE users SET device_id = '$device_id', device_model = '$device_model' WHERE user_name='$username'");
 	        if($update){
     	        $json_data = array(
                                "expiry" => $duration,
                                "device_match" => true);
                $values = $json_data;
 	        }else{
 	            die('Update error.');
 	        }
 	    }else{
         	if($device_id == $deviceid){
                $json_data = array(
                                "expiry" => $duration,
                                "device_match" => true);
                $values = $json_data;
         	}else{
         	    $json_data = array(
                                "expiry" => $duration,
                                "device_match" => 'false');
                $values = $json_data;
         	}
 	    }
 	}else{
 	    $json_data = array(
                        "expiry" => $duration,
                        "device_match" => 'none');
        $values = $json_data;
 	}
 	echo json_encode($values);
}else{
 	die('Access denied.');
}
?>