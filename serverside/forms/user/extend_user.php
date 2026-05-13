<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';
chkSession();
$valid = true;
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
	
	$uid = $db->Sanitize(trim($_POST['id']));
    $duration = $db->Sanitize(trim($_POST['duration']));
    $one_month = 2592000;
    
    if($duration == '1m'){
        $duration_time = $one_month;
        $credit_deduct = 1;
    }elseif($duration == '2m'){
        $duration_time = $one_month*2;
        $credit_deduct = 2;
    }elseif($duration == '3m'){
        $duration_time = $one_month*3;
        $credit_deduct = 3;
    }elseif($duration == '4m'){
        $duration_time = $one_month*4;
        $credit_deduct = 4;
    }elseif($duration == '5m'){
        $duration_time = $one_month*5;
        $credit_deduct = 5;
    }
    
    $qry = $db->sql_query("SELECT user_name FROM users WHERE user_id='$uid'");
    $row = $db->sql_fetchrow($qry);
    $usercheck = $db->sql_numrows($qry);
    $username = $row['user_name'];
    
    if($usercheck < 1){
        $errormsg = 'Error occured.';
        $valid = false;
    }else{
        $valid = true;
    }
    
    if(isset($_POST['submitted'])  == 'device_reset'){
        
        $blocked_qry = $db->sql_query("SELECT is_freeze FROM users WHERE user_id='$user_id_2'");
    	$blocked_row = $db->sql_fetchrow($blocked_qry);
    	if($blocked_row['is_freeze'] == 1){
            $errormsg[] = 'You are blocked, contact your upline.<br>';
            $valid = false;
    	}
    	
        if($valid){
            if($get_key == 'firenetdev')
            {
                if($credits_2 == 0 && $user_id_2 != 1 && $user_level_2 != 'superadmin'
    			|| $credits_2 < $credit_deduct && $user_id_2 != 1 && $user_level_2 != 'superadmin')
    			{
    				$error_message = 'Not enough credits to extend <code>'.$credit_deduct.' month(s)</code> for <code>'.$username.'</code>.<br>Your credit balance is <code>'.$credits_2.'</code>.';
                    $values['response'] = 2;
                    $values['msg'] = $error_message;
    			}else{
    			    if($user_id_2 == 1 || $user_level_2 == 'superadmin')
				    {
                        $update = $db->sql_query("UPDATE users SET duration=duration+$duration_time WHERE user_id!=1 AND user_id='$uid'");
                        $action = 'Extended <code>'.$username.'</code> expiration for <code>'.$credit_deduct.' month(s)</code> month(s)';
                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
            							(user_id, date, action, ipaddress, device_os, device_client) 
            							values
            							('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                            if($update && $addactivity){
                                $success_message = 'User <code>'.$username.'</code> duration extended for <code>'.$credit_deduct.' month(s)</code>!';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
                            }else{
                                $error_message = 'User <code>'.$username.'</code> duration extend failed!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
				    }elseif($user_level_2 == 'administrator' || $user_level_2 == 'subadmin' || $user_level_2 == 'reseller' || $user_level_2 == 'subreseller'){
				        $update = $db->sql_query("UPDATE users SET duration=duration+$duration_time WHERE user_id!=1 AND user_id='$uid'");
				        $action = 'Extended <code>'.$username.'</code> expiration for <code>'.$credit_deduct.' month(s)</code> month(s)';
                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
            							(user_id, date, action, ipaddress, device_os, device_client) 
            							values
            							('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                            if($update && $addactivity){
                                $deduct = $db->sql_query("UPDATE users SET credits=credits-$credit_deduct WHERE user_id!=1 AND user_id='$user_id_2'");
                                    if($deduct){
                                        $success_message = 'User <code>'.$username.'</code> duration extended for <code>'.$credit_deduct.' month(s)</code>!';
                                        $values['response'] = 1;
                                        $values['msg'] = $success_message;
                                    }else{
                                        $error_message = 'User <code>'.$username.'</code> duration extend failed!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                            }else{
                                $error_message = 'User <code>'.$username.'</code> duration extend failed!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
				    }
    			}
            }else{
                $error_message = 'Site key invalid!';
                $values['response'] = 2;
                $values['msg'] = $error_message;
            }
        }else{
            $values['response'] = 3;
            $values['errormsg'] = $errormsg;
        }
    }
    echo json_encode($values);
?>
