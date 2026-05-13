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
    
    $qry = $db->sql_query("SELECT user_name FROM users WHERE user_id='$uid'");
    $row = $db->sql_fetchrow($qry);
    $username = $row['user_name'];
    
    if(isset($_POST['submitted'])  == 'session_reset'){
        $valid = true;
        
        $blocked_qry = $db->sql_query("SELECT is_freeze FROM users WHERE user_id='$user_id_2'");
    	$blocked_row = $db->sql_fetchrow($blocked_qry);
    	if($blocked_row['is_freeze'] == 1){
            $errormsg[] = '<li>You are blocked, contact your upline.</li>';
            $valid = false;
    	}
    	
        if($valid){
            if($get_key == 'firenetdev')
            {
                $update = $db->sql_query("UPDATE users SET is_active=0 WHERE user_id!=1 AND user_id='$uid'");
                $action = 'Updated <code>'.$username.'</code> session.';
                $addactivity = $db->sql_query("INSERT INTO activity_logs 
    							(user_id, date, action, ipaddress, device_os, device_client) 
    							values
    							('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                if($update && $addactivity){
                    $success_message = 'User <code>'.$username.'</code> vpn session(s) reloaded!';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'User <code>'.$username.'</code> vpn session(s) reload failed!';
                    $values['response'] = 2;
                    $values['msg'] = $error_message;
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
