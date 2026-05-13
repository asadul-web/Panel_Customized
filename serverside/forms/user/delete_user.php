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
    
    if(isset($_POST['submitted'])  == 'delete_user'){
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
                $chk_qry = $db->sql_query("SELECT * FROM users WHERE user_id!=1 AND user_id='$uid'");
                $chk_rows = $db->sql_fetchrow($chk_qry);   
				$thirtydays = time() + 2592000;
				$u_upline = $chk_rows['upline'];
				$u_level = $chk_rows['user_level'];
				
				$update = $db->sql_query("INSERT INTO users_delete
						(delete_timestamp,
						user_id,
						user_name,
						user_pass,
						auth_vpn,
						user_email,
						full_name,
						regdate,
						ipaddress,
						lastlogin,
						timestamp,
						code,
						reset_code,
						is_groupname,
						is_active,
						is_freeze,
						last_freeze_date,
						is_validated,
						is_connected,
						is_offense,
						is_ban,
						suspended_date,
						duration,
						vip_duration,
						is_vip,
						private_duration,
						is_private,
						private_slot,
						private_control,
						credits,
						upline,
						login_status,
						last_active_time,
						user_level,
						status,
						device_id,
						device_model,
						device_connected)
						VALUES
						('".$thirtydays."',
						'".$chk_rows['user_id']."',
						'".$chk_rows['user_name']."',
						'".$chk_rows['user_pass']."',
						'".$chk_rows['auth_vpn']."',
						'".$chk_rows['user_email']."',
						'".$chk_rows['full_name']."',
						'".$chk_rows['regdate']."',
						'".$chk_rows['ipaddress']."',
						'".$chk_rows['lastlogin']."',
						'".$chk_rows['timestamp']."',
						'".$chk_rows['code']."',
						'".$chk_rows['reset_code']."',
						'".$chk_rows['is_groupname']."',
						'".$chk_rows['is_active']."',
						'".$chk_rows['is_freeze']."',
						'".$chk_rows['last_freeze_date']."',
						'".$chk_rows['is_validated']."',
						'".$chk_rows['is_connected']."',
						'".$chk_rows['is_offense']."',
						'".$chk_rows['is_ban']."',
						'".$chk_rows['suspended_date']."',
						'".$chk_rows['duration']."',
						'".$chk_rows['vip_duration']."',
						'".$chk_rows['is_vip']."',
						'".$chk_rows['private_duration']."',
						'".$chk_rows['is_private']."',
						'".$chk_rows['private_slot']."',
						'".$chk_rows['private_control']."',
						'".$chk_rows['credits']."',
						'".$chk_rows['upline']."',
						'".$chk_rows['login_status']."',
						'".$chk_rows['last_active_time']."',
						'".$chk_rows['user_level']."',
						'".$chk_rows['status']."',
						'".$chk_rows['device_id']."',
						'".$chk_rows['device_model']."',
						'".$chk_rows['device_connected']."')");
				$action = 'User <code>'.$username.'</code> was deleted.';
                $addactivity = $db->sql_query("INSERT INTO activity_logs 
    							(user_id, date, action, ipaddress, device_os, device_client) 
    							values
    							('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
    			$addactivity2 = $db->sql_query("INSERT INTO deleted_logs 
        						(user_id, user_upline, user_level, date) 
        						values
        						('$uid', '$u_upline', '$u_level', '".date('Y-m-d H:i:s')."')");
				if($update && $addactivity && $addactivity2){
					$deleted = $db->sql_query("DELETE from users WHERE user_id!=1 AND user_id='$uid'");
					$deleted2 = $db->sql_query("DELETE from radcheck WHERE username='$username'");
						if($deleted && $deleted2){
                            $success_message = 'User <code>'.$username.'</code> deleted successfully!';
                            $values['response'] = 1;
                            $values['msg'] = $success_message;
						}else{
						    $error_message = 'User <code>'.$username.'</code> delete failed!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
						}
                }else{
                    $error_message = 'User <code>'.$username.'</code> delete failed!';
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
