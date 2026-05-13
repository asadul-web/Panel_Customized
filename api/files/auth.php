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

//If password contains special characters
if(preg_match('/[^a-z-A-Z-0-9]/',$_GET['password'])){
    $errormsg[] = array(
                    "value" => $_GET['password'] !== null ? $_GET['password'] : '',
                    "msg" => 'Error occured.',
                    "param" => 'password',
                    "location" => 'query');          
    $valid = false;
}

//If device_id contains special characters - DISABLED to allow underscores
/*if(preg_match('/[^a-z-A-Z-0-9]/',$_GET['device_id'])){
    $errormsg[] = array(
                    "value" => $_GET['device_id'] !== null ? $_GET['device_id'] : '',
                    "msg" => 'Error occured.',
                    "param" => 'device_id',
                    "location" => 'query');          
    $valid = false;
}*/

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

//If password is empty
if(!isset($_GET['password']) || empty($_GET['password']) && $_GET['password'] !== '0'){
    $errormsg[] = array(
                    "msg" => 'Error occured.',
                    "param" => 'password',
                    "location" => 'body');
    $errormsg[] = array(
                    "value" => $_GET['password'] !== null ? $_GET['password'] : '',
                    "msg" => 'Error occured.',
                    "param" => 'password',
                    "location" => 'body');          
    $valid = false;
}

//If device_id is empty
if(!isset($_GET['device_id']) || empty($_GET['device_id']) && $_GET['device_id'] !== '0'){
    $errormsg[] = array(
                    "msg" => 'Error occured.',
                    "param" => 'device_id',
                    "location" => 'body');
    $errormsg[] = array(
                    "value" => $_GET['device_id'] !== null ? $_GET['device_id'] : '',
                    "msg" => 'Error occured.',
                    "param" => 'device_id',
                    "location" => 'body');          
    $valid = false;
}

//If device_model is empty
if(!isset($_GET['device_model']) || empty($_GET['device_model']) && $_GET['device_model'] !== '0'){
    $errormsg[] = array(
                    "msg" => 'Error occured.',
                    "param" => 'device_model',
                    "location" => 'body');
    $valid = false;
}

if($valid){
    $username = strip_tags(trim($_GET['username']));
 	$password = strip_tags(trim($_GET['password']));
 	$device_id = strip_tags(trim($_GET['device_id']));
 	$device_model = strip_tags(trim($_GET['device_model']));
 	
    $qry = $db->sql_query("SELECT duration, device_connected FROM users WHERE user_name='".$username."' LIMIT 1");
    $row = $db->sql_fetchrow($qry);
    
    $dur = $db->calc_time($row['duration']);
    $pdays = $dur['days'] . " days";
	$phours = $dur['hours'] . " hours";
	$pminutes = $dur['minutes'] . " minutes";
	$pseconds = $dur['seconds'] . " seconds";
		
	$premuim_duration = strtotime($pdays . $phours . $pminutes . $pseconds);
    $premuim_duration = date('Y-m-d h:i:s', $premuim_duration);
 	
 	if($row['device_connected'] == 1){
 	    $duration = $premuim_duration;
 	}else{
 	    $duration = 'none';
 	}
 		
 	$sql = "SELECT user_name  FROM users WHERE user_name='$username' AND auth_vpn=md5('$password') AND is_freeze=0 AND duration > 0";
 	$result = $db->sql_query($sql);
 	$auth_check = $db->sql_fetchrow($result);
 	
 	if ($auth_check){
 	    $sql_query = $db->sql_query("SELECT device_id FROM users WHERE user_name='$username' AND auth_vpn=md5('$password')");
 		$row_query = $db->sql_fetchrow($sql_query);
 		$deviceid = $row_query['device_id'];
 		$devicemodel = $row_query['device_model'];
 		
 		if($deviceid == $device_id && !empty($deviceid)){
         	$json_data = array(
                            "auth" => true,
                            "expiry" => $duration,
                            "device_match" => true);
            $values = $json_data;
                    
            $db->sql_query("UPDATE users SET device_id = '$device_id', device_model = '$device_model', device_connected=1 WHERE user_name='$username'");
        }elseif($deviceid != $device_id && !empty($deviceid)){
         	$json_data = array(
                            "auth" => true,
                            "expiry" => $duration,
                            "device_match" => false);
            $values = $json_data;
                    
            $db->sql_query("UPDATE users SET device_id = '$device_id', device_model = '$device_model', device_connected=1 WHERE user_name='$username'");
        }elseif(empty($deviceid)){
         	$json_data = array(
                            "auth" => true,
                            "expiry" => $duration,
                            "device_match" => true);
            $values = $json_data;
                    
            $db->sql_query("UPDATE users SET device_id = '$device_id', device_model = '$device_model', device_connected=1 WHERE user_name='$username'");
        }else{
         	$json_data = array(
                            "auth" => false,
                            "expiry" => $duration,
                            "device_match" => "none");
            $values = $json_data;
                    
            $db->sql_query("UPDATE users SET device_id = '$device_id', device_model = '$device_model', device_connected=1 WHERE user_name='$username'");
        }
 	}else{
 	    $json_data = array(
                        "auth" => false,
                        "expiry" => "none",
                        "device_match" => "none");
        $values = $json_data;
 	}
}else{
    $errors = $errormsg;
    $values['status'] = 'invalid';
    $values['errors'] = $errors;
}

echo json_encode($values);
?>