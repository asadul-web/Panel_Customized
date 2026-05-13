<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../includes/functions.php';
 
 if(isset($_GET['username'],$_GET['password'])){
 	$username = strip_tags(trim($_GET['username']));
 	$password = strip_tags(trim($_GET['password']));
 
 	if(empty($_GET['username'])){
 		$LenzData[value] = '';
        $LenzData[msg] = 'Error occured.';
        $LenzData[param] = 'username';
        $LenzData[location] = 'query';
        $data[] = $LenzData;
        $json_data = array(
    			        "status" => 'invalid',
    			        "errors" => ( $data ));
        echo json_encode($json_data);
 	}elseif(empty($_GET['password'])){
 		$LenzData[value] = '';
        $LenzData[msg] = 'Error occured.';
        $LenzData[param] = 'password';
        $LenzData[location] = 'query';
        $data[] = $LenzData;
        $json_data = array(
    			        "status" => 'invalid',
    			        "errors" => ( $data ));
        echo json_encode($json_data);
 	}elseif(!empty($_GET['username']) && !empty($_GET['password'])){
 		
 		$sql = "SELECT user_name  FROM users WHERE user_name='$username' AND auth_vpn=md5('$password') AND is_freeze=0 AND duration > 0";
 		$result = $db->sql_query($sql);
 		
 		if ($db->sql_fetchrow($result) > 0){
 		    
 		        $sql2 = $db->sql_query("SELECT device_id FROM users WHERE user_name='$username' AND auth_vpn=md5('$password')");
 		        $result2 = $db->sql_fetchrow($sql2);
 		        
 		        $dev_id = $result2['device_id'];
 		        $dev_model = $result2['device_model'];
                    
                $update = $db->sql_query("UPDATE users SET device_id = '', device_model = '' WHERE user_name='$username'");
                
                if($update){
                    
                    $json_data = array(
                                "status" => true,
                                "message" => 'Device reset successful.');
                    echo json_encode($json_data);
                }else{
             		$json_data = array(
                                "status" => false,
                                "message" => 'Device reset failed.');
                    echo json_encode($json_data);
                }
 		}else{
         		    
         			$json_data = array(
                                    "status" => false,
                                    "message" => 'User credential incorrect.');
                    echo json_encode($json_data);
         		}
 	}else{
 	    
 		$json_data = array(
                        "status" => false,
                        "message" => 'System error.');
        echo json_encode($json_data);
 	}
 }else{
     
 	$json_data = array(
                    "status" => false,
                    "message" => 'Data not found.');
    echo json_encode($json_data);
 }
 
 ?>