<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
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
	
	$username = $db->Sanitize(trim($_POST['username']));
	$password = $db->Sanitize(trim($_POST['password']));
	$amount = $db->Sanitize(trim($_POST['amount']));
	$userlevel = 'reseller';
	$user_email = $username.'@email.com';
	$is_groupname = 'reseller';
	$duration = 0;
	$full_name = 'Reseller User';
	$is_active = 1;
	
    if(isset($_POST['submitted'])  == 'add_reseller'){
        $valid = true;
    	if(empty($username)){
            $errormsg[] = 'Username is required.<br>';
            $valid = false;
        }
        
        if(empty($password)){
            $errormsg[] = 'Password is required.<br>';
            $valid = false;
        }
        
        if(strlen($username) < 3){
            $errormsg[] = 'Username is too short.<br>';
            $valid = false;
        }
        
        if(strlen($password) < 3){
            $errormsg[] = 'Password is too short.<br>';
            $valid = false;
        }
            
    	if(preg_match('/[^a-z-A-Z-0-9]/', $username)){
    	    $errormsg[] = 'Only letters/numbers allowed in username.<br>';
            $valid = false;
    	}
    	
    	if(preg_match('/[^a-z-A-Z-0-9]/', $password)){
    	    $errormsg[] = 'Only letters/numbers allowed in password.<br>';
            $valid = false;
    	}
    	
    	//Get my info
    	$my_qry = $db->sql_query("SELECT user_name, credits FROM users WHERE user_id='$user_id_2'");
    	$my_chk = $db->sql_numrows($my_qry);
    	$my_row = $db->sql_fetchrow($my_qry);
    	$my_credit = $my_row['credits'];
    	$my_username = $my_row['user_name'];
    	
    	$username_qry = $db->sql_query("SELECT user_name FROM users WHERE user_name='$username'");
    	$username_chk = $db->sql_numrows($username_qry);
    	if($username_chk > 0){
            $errormsg[] = 'Username is already taken.<br>';
            $valid = false;
    	}
    	
    	$blocked_qry = $db->sql_query("SELECT is_freeze FROM users WHERE user_id='$user_id_2'");
    	$blocked_row = $db->sql_fetchrow($blocked_qry);
    	if($blocked_row['is_freeze'] == 1){
            $errormsg[] = 'You are blocked, contact your upline.<br>';
            $valid = false;
    	}
    	
        if($valid){
            if($get_key == 'firenetdev')
            {
                if($amount>0){
                    $user_pass = $db->encryptor('encrypt',$password);
                    $auth_vpn = md5($password);
                    $code = rand(0,999999999);
                    
                    if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
                        $result = $db->sql_query("INSERT INTO users 
                        			            ( user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze,  user_level, code, is_ban, is_validated, upline, duration, credits)
                        			        VALUES
                        			            ('".$db->SanitizeForSQL($username)."','".$db->SanitizeForSQL($user_pass)."','".$db->SanitizeForSQL($auth_vpn)."',
                        			            '".$db->SanitizeForSQL($user_email)."','".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d h:i:s')."','".$db->SanitizeForSQL($is_groupname)."', '".$db->SanitizeForSQL($is_active)."', 0,
                        			            '".$db->SanitizeForSQL($userlevel)."','".$db->SanitizeForSQL($code)."', 0, 1, '".$user_id_2."', '".$duration."', '".$amount."')");
                        $insert_id = $db->sql_nextid();
            			$insert_profile = $db->sql_query("INSERT INTO users_profile (profile_id, first_name, last_name, profile_number) VALUES ('".$insert_id."', 'Reseller', 'Account', '09123456789')");
            			$action = 'Added <code>'.$username.'</code> as new reseller with <code>'.$amount.'</code> credit balance.';
                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
        								(user_id, date, action, ipaddress, device_os, device_client) 
        								values
        								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
        				$addactivity2 = $db->sql_query("INSERT INTO credits_logs 
        								(credits_id, credits_id2, credits_type, credits_qty, credits_date) 
        								values
        								('$user_id_2', '$username', 'add','$amount', '".date('Y-m-d H:i:s')."')");
                        if($result && $insert_profile && $addactivity && $addactivity2){
                            $success_message = 'Added <code>'.$username.'</code> as new reseller with <code>'.$amount.'</code> credit balance.<br><br> <button class="btn btn-copy btn-lg btn-primary swal2-popup" data-clipboard-text="Reseller Details

Username : '.$username.'
Password : '.$password.'
Credits : '.$amount.'
Reseller URL : '.$base_url.'">Copy</button> <button class="btn btn-info btn-lg swal2-popup" onclick="swal.close();">Close</button>';
                            $values['response'] = 1;
                            $values['msg'] = $success_message;
                        }else{
                            $error_message = 'Failed creating reseller!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
                        }
                    }else{
                        if($my_credit == 0){
        					$error_message = 'Not enough credits.';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
        				}elseif($my_credit < $amount){
        					$error_message = 'Not enough credits.';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
        				}else{
                            $result = $db->sql_query("INSERT INTO users 
                            			            ( user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze,  user_level, code, is_ban, is_validated, upline, duration, credits)
                            			        VALUES
                            			            ('".$db->SanitizeForSQL($username)."','".$db->SanitizeForSQL($user_pass)."','".$db->SanitizeForSQL($auth_vpn)."',
                            			            '".$db->SanitizeForSQL($user_email)."','".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d h:i:s')."','".$db->SanitizeForSQL($is_groupname)."', '".$db->SanitizeForSQL($is_active)."', 0,
                            			            '".$db->SanitizeForSQL($userlevel)."','".$db->SanitizeForSQL($code)."', 0, 1, '".$user_id_2."', '".$duration."', '".$amount."')");
                            $insert_id = $db->sql_nextid();
            			    $insert_profile = $db->sql_query("INSERT INTO users_profile (profile_id) VALUES ('".$insert_id."')");
            			    $action = 'Added <code>'.$username.'</code> as new reseller with <code>'.$amount.'</code> credit balance.';
                            $addactivity = $db->sql_query("INSERT INTO activity_logs 
            								(user_id, date, action, ipaddress, device_os, device_client) 
            								values
            								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
            			    $addactivity2 = $db->sql_query("INSERT INTO credits_logs 
        								(credits_id, credits_id2, credits_type, credits_qty, credits_date) 
        								values
        								('$user_id_2', '$username', 'add','$amount', '".date('Y-m-d H:i:s')."')");
                            if($result && $insert_profile && $addactivity && $addactivity2){
                                $success_message = 'Added <code>'.$username.'</code> as new reseller with <code>'.$amount.'</code> credit balance.<br><br> <button class="btn btn-copy btn-lg btn-primary swal2-popup" data-clipboard-text="Reseller Details

Username : '.$username.'
Password : '.$password.'
Credits : '.$amount.'
Reseller URL : '.$base_url.'">Copy</button> <button class="btn btn-info btn-lg swal2-popup" onclick="swal.close();">Close</button>';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
                            }else{
                                $error_message = 'Failed creating reseller!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                            $db->sql_query("UPDATE users SET credits = credits-'".$amount."' WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
        				}
                    }
                }else{
                    $error_message = 'Enter a valid amount.';
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