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
	$userlevel = $db->Sanitize(trim($_POST['subscription']));
	$user_email = $username.'gmail.com';
	
	if($userlevel == 'normal'){
	    $is_groupname = 'normal';
	    $duration = 2592000;
	    $full_name = 'Normal User';
	    $is_active = 0;
	    $creditz = 1;
	}elseif($userlevel == 'trial'){
	    $is_groupname = 'trial';
	    $full_name = 'Trial User';
	    $is_active = 1;
	    $creditz = 0;
	    
	    $trial_qry = $db->sql_query("SELECT trial_duration FROM site_options");
        $trial_row = $db->sql_fetchrow($trial_qry);
    	$duration = $trial_row['trial_duration'];
	}
	
    if(isset($_POST['submitted'])  == 'add_user'){
        $valid = true;
    	if(empty($username)){
            $errormsg[] = 'Username is required.<br>';
            $valid = false;
        }
        
        if(empty($password)){
            $errormsg[] = 'Password is required.<br>';
            $valid = false;
        }
        
        if(strlen($username) < 5){
            $errormsg[] = 'Username is too short.<br>';
            $valid = false;
        }
        
        if(strlen($password) < 5){
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
                $user_pass = $db->encryptor('encrypt',$password);
                $auth_vpn = md5($password);
                $code = rand(0,999999999);
                if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
                    $result = $db->sql_query("INSERT INTO users 
                    			            ( user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze,  user_level, code, is_ban, is_validated, upline, duration)
                    			        VALUES
                    			            ('".$db->SanitizeForSQL($username)."','".$db->SanitizeForSQL($user_pass)."','".$db->SanitizeForSQL($auth_vpn)."',
                    			            '".$db->SanitizeForSQL($user_email)."','".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d h:i:s')."','".$db->SanitizeForSQL($is_groupname)."', '".$db->SanitizeForSQL($is_active)."', 0,
                    			            '".$db->SanitizeForSQL($userlevel)."','".$db->SanitizeForSQL($code)."', 0, 1, '".$user_id_2."', '".$duration."')");
                    
                    $result2 = $db->sql_query("INSERT INTO radcheck 
                    			            ( username, attribute, op, value)
                    			        VALUES
                    			            ('".$db->SanitizeForSQL($username)."','Cleartext-Password',':=','".$db->SanitizeForSQL($password)."')");
                    $action = 'Added new user <code>'.$username.' - '.$userlevel.'</code>';
                    $addactivity = $db->sql_query("INSERT INTO activity_logs 
    								(user_id, date, action, ipaddress, device_os, device_client) 
    								values
    								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                    if($result && $result2 && $addactivity){
                        $success_message = '<code>'.$username.' - '.$userlevel.'</code> user was successfully created! <br><br><button class="btn btn-copy btn-primary swal2-confirm swal2-styled" data-clipboard-text="User Details

Username : '.$username.'
Password : '.$password.'
Subscription : '.$userlevel.'" tabindex="-1">Copy</button> <button class="btn btn-info swal2-confirm swal2-styled" onclick="swal.close();" tabindex="-1">Close</button>';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'Failed creating account!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }else{
                    if($userlevel == 'normal'){
                        if($credits_2 == 0 || $credits_2 < 0){
        					$error_message = 'Not enough credits.';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
        				}else{
        				    $result = $db->sql_query("INSERT INTO users 
                            			            ( user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze,  user_level, code, is_ban, is_validated, upline, duration)
                            			        VALUES
                            			            ('".$db->SanitizeForSQL($username)."','".$db->SanitizeForSQL($user_pass)."','".$db->SanitizeForSQL($auth_vpn)."',
                            			            '".$db->SanitizeForSQL($user_email)."','".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d h:i:s')."','".$db->SanitizeForSQL($is_groupname)."', '".$db->SanitizeForSQL($is_active)."', 0,
                            			            '".$db->SanitizeForSQL($userlevel)."','".$db->SanitizeForSQL($code)."', 0, 1, '".$user_id_2."', '".$duration."')");
                            $result2 = $db->sql_query("INSERT INTO radcheck 
                            			            ( username, attribute, op, value)
                            			        VALUES
                            			            ('".$db->SanitizeForSQL($username)."','Cleartext-Password',':=','".$db->SanitizeForSQL($password)."')");
                            $action = 'Added new user <code>'.$username.' - '.$userlevel.'</code>';
                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
        								(user_id, date, action, ipaddress, device_os, device_client) 
        								values
        								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                        if($result && $result2 && $addactivity){
                            $success_message = '<code>'.$username.' - '.$userlevel.'</code> user was successfully created! <br><br><button class="btn btn-copy btn-primary swal2-confirm swal2-styled" data-clipboard-text="User Details

Username : '.$username.'
Password : '.$password.'
Subscription : '.$userlevel.'" tabindex="-1">Copy</button> <button class="btn btn-info swal2-confirm swal2-styled" onclick="swal.close();" tabindex="-1">Close</button>';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
                            }else{
                                $error_message = 'Failed creating account!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                            $db->sql_query("UPDATE users SET credits = credits-'".$creditz."' WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
        				}
                    }elseif($userlevel == 'trial'){
                        $result = $db->sql_query("INSERT INTO users 
                            			            ( user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze,  user_level, code, is_ban, is_validated, upline, duration)
                            			        VALUES
                            			            ('".$db->SanitizeForSQL($username)."','".$db->SanitizeForSQL($user_pass)."','".$db->SanitizeForSQL($auth_vpn)."',
                            			            '".$db->SanitizeForSQL($user_email)."','".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d h:i:s')."','".$db->SanitizeForSQL($is_groupname)."', '".$db->SanitizeForSQL($is_active)."', 0,
                            			            '".$db->SanitizeForSQL($userlevel)."','".$db->SanitizeForSQL($code)."', 0, 1, '".$user_id_2."', '".$duration."')");
                            $result2 = $db->sql_query("INSERT INTO radcheck 
                            			            ( username, attribute, op, value)
                            			        VALUES
                            			            ('".$db->SanitizeForSQL($username)."','Cleartext-Password',':=','".$db->SanitizeForSQL($password)."')");
                            $action = 'Added new user <code>'.$username.' - '.$userlevel.'</code>';
                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
        								(user_id, date, action, ipaddress, device_os, device_client) 
        								values
        								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                        if($result && $result2 && $addactivity){
                            $success_message = '<code>'.$username.' - '.$userlevel.'</code> user was successfully created! <br><br><button class="btn btn-copy btn-primary btn-lg swal2-popup" data-clipboard-text="User Details

Username : '.$username.'
Password : '.$password.'
Subscription : '.$userlevel.'">Copy</button> <button class="btn btn-info btn-lg swal2-popup" onclick="swal.close();">Close</button>';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
                            }else{
                                $error_message = 'Failed creating account!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                            $db->sql_query("UPDATE users SET credits = credits-'".$creditz."' WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
                    }else{
                        $error_message = 'Invalid transaction';
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