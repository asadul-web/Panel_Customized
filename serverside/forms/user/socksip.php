<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';
chkSession();
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
	$action_socksip = $db->Sanitize(trim($_POST['confirmsocksip']));
	
	$qry = $db->sql_query("SELECT user_name FROM users WHERE user_id='$uid'");
    $row = $db->sql_fetchrow($qry);
    $username = $row['user_name'];
    
    if(isset($_POST['submitted'])  == 'enable_socksip'){
        $valid = true;
        if(empty($uid)){
            $errormsg[] = 'Empty Field.<br>';
            $valid = false;
        }
        
        $blocked_qry = $db->sql_query("SELECT is_freeze FROM users WHERE user_id='$user_id_2'");
    	$blocked_row = $db->sql_fetchrow($blocked_qry);
    	if($blocked_row['is_freeze'] == 1){
            $errormsg[] = 'You are blocked, contact your upline.<br>';
            $valid = false;
    	}
    	
    	$socksip_qry = $db->sql_query("SELECT user_name, is_socksip FROM users WHERE user_id='$uid'");
    	$socksip_row = $db->sql_fetchrow($socksip_qry);
    	$socksip_username = $socksip_row['user_name'];
        
        //if (preg_match('/^[0-9]+$/', $socksip_username)) {
        //    $errormsg[] = ''.$socksip_username.' is numeric, Please contact administrator.<br>';
        //    $valid = false;
        //}
        
        if($valid){
            if($get_key == 'firenetdev')
            {
                if($action_socksip == 'doenable'){
                    $update = $db->sql_query("UPDATE users SET is_socksip=1, device_connected=1 WHERE user_id='$uid'");
                        if($update){
                        $action = 'User <code>'.$username.'</code> socksip access enabled.';
                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
                						(user_id, date, action, ipaddress, device_os, device_client) 
                						values
                						('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                        }else{
                            $error_message = 'User <code>'.$username.'</code> socksip activation failed!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
                        }
                    if($addactivity){
                        $success_message = 'User <code>'.$username.'</code> socksip activated successfully!';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'User <code>'.$username.'</code> socksip activation failed!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }elseif($action_socksip == 'dodisable'){
                    $update = $db->sql_query("UPDATE users SET is_socksip=0 WHERE user_id='$uid'");
                        if($update){
                        $action = 'User <code>'.$username.'</code> socksip access disabled.';
                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
                						(user_id, date, action, ipaddress, device_os, device_client) 
                						values
                						('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                        }else{
                            $error_message = 'User <code>'.$username.'</code> socksip activation failed!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
                        }
                    if($addactivity){
                        $success_message = 'User <code>'.$username.'</code> socksip deactivated successfully!';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'User <code>'.$username.'</code> socksip deactivation failed!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }

            }else{
                $error_message = 'Site key invalid!';
                $values['response'] = 2;
                $values['msg'] = $error_message;
            }
        }else{
            $values['response'] = 3;
            $errors = implode('',$errormsg);
            $values['errormsg'] = $errors;
        }
    }
    echo json_encode($values);
?>
