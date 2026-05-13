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
	
	$prefix = $db->Sanitize(trim($_POST['prefix']));
	$amount = $db->Sanitize(trim($_POST['amount']));
	$userlevel = 'bulk';
	$is_groupname = 'bulk';
	$bulk_group = rand(0,99919);
	$date_created = date('Y-m-d h:i:s');
	
    if(isset($_POST['submitted'])  == 'add_bulk'){
        $num = 0;
        $int = 0;
    	$count = $db->Sanitize($amount);
    	
        $valid = true;
        if(preg_match('/[^a-z-A-Z-0-9]/', $prefix)){
    	    $errormsg[] = 'Only letters/numbers allowed in prefix.<br>';
            $valid = false;
    	}
        
    	if(empty($prefix)){
            $errormsg[] = 'Prefix is required.<br>';
            $valid = false;
        }
    	
		if($amount > 1000){
            $errormsg[] = 'Max 1000 bulk user per request!<br>';
            $valid = false;
        }
        
        if(strlen($prefix) > 7){
            $errormsg[] = 'Maximum of 5 letters/numbers in prefix!<br>';
            $valid = false;
        }
		
		//Get my info
    	$my_qry = $db->sql_query("SELECT user_name, credits FROM users WHERE user_id='$user_id_2'");
    	$my_chk = $db->sql_numrows($my_qry);
    	$my_row = $db->sql_fetchrow($my_qry);
    	$my_credit = $my_row['credits'];
    	$my_username = $my_row['user_name'];
    	
    	$blocked_qry = $db->sql_query("SELECT is_freeze FROM users WHERE user_id='$user_id_2'");
    	$blocked_row = $db->sql_fetchrow($blocked_qry);
    	if($blocked_row['is_freeze'] == 1){
            $errormsg[] = 'You are blocked, contact your upline.<br>';
            $valid = false;
    	}
    	
    	$check_qry = $db->sql_query("SELECT user_name FROM users WHERE user_name LIKE '$prefix%' ORDER BY user_id DESC LIMIT 1");
    	$check_row = $db->sql_fetchrow($check_qry);
    	
    	// Initialize variables with default values
    	$str = isset($check_row["user_name"]) ? $check_row["user_name"] : $prefix."0";
        $int = preg_replace('/[^0-9]/', '',$str);//to get the Int from string '250532'
        $int = ($int !== '') ? (int)$int : 0; // Convert to integer, default to 0
    	
    	if ($db->sql_numrows($check_qry)>0 && isset($check_row["user_name"])) {
            $pure_str = str_replace($int, "", $str);// tog get only the string word 'IVISA'
        }else{
            $pure_str = $prefix;
        }
    	
        if($valid){
            if($get_key == 'firenetdev')
            {
                if($count>0){
                    if($user_id_2 == 1 && $user_level_2 == 'superadmin'){
                        
                        // Optimize: Batch insert instead of individual inserts
                        $users_values = array();
                        $radcheck_values = array();
                        
                        while($num<$count){
                            $num++;
                            $user_random = rand(0,999919);
                        	$pass_random = rand(0,999919);
                        	$username = $prefix.$user_random;
                        	$password = $pass_random;
                        	$user_email = $username.'gmail.com';
                        	
                        	// Use single encryption to match database
                       	$user_pass = $db->encryptor('encrypt', $password);
                            $auth_vpn = md5($password);
                            $code = rand(0,999999999);
                        	$duration = 2592000;
                        	$full_name = 'Bulk User';
                            
                            $next_user_name = $pure_str.($int+1);
                            $int++;
                            
                            // Build batch insert values
                            $users_values[] = "('".$db->SanitizeForSQL($next_user_name)."','".$db->SanitizeForSQL($user_pass)."','".$db->SanitizeForSQL($auth_vpn)."',
                            			            '".$db->SanitizeForSQL($user_email)."','".$db->SanitizeForSQL($full_name)."', '".$db->SanitizeForSQL($date_created)."','".$db->SanitizeForSQL($is_groupname)."', 0, 0,
                            			            '".$db->SanitizeForSQL($userlevel)."','".$db->SanitizeForSQL($code)."', 0, 1, '".$user_id_2."', '".$duration."', '".$bulk_group."', '".$prefix."')";
                            
                            $radcheck_values[] = "('".$db->SanitizeForSQL($next_user_name)."','Cleartext-Password',':=','".$db->SanitizeForSQL($password)."')";
                        }
                        
                        // Execute batch inserts (much faster)
                        $result = $db->sql_query("INSERT INTO users 
                            			            ( user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze,  user_level, code, is_ban, is_validated, upline, duration, user_group, username_prefix)
                            			        VALUES " . implode(',', $users_values));
                        $result2 = $db->sql_query("INSERT INTO radcheck 
                            			            ( username, attribute, op, value)
                            			        VALUES " . implode(',', $radcheck_values));
                        $action = 'Added new <code>'.$count.'</code> bulk users';
                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
            							(user_id, date, action, ipaddress, device_os, device_client) 
            							values
            							('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                        if($result && $result2 && $addactivity){
                            $last_user = isset($check_row['user_name']) ? $check_row['user_name'] : 'successfully';
                            $success_message = 'Added new <code>'.$count.'</code> bulk users '.$last_user;
                            $values['response'] = 1;
                            $values['msg'] = $success_message;
                        }else{
                            $error_message = 'Failed generating bulk!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
                        }
                    }elseif($user_level_2 == 'reseller'){
                        if($my_credit == 0){
    						$error_message = 'Not enough credits.';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
    					}elseif($my_credit < $count){
    						$error_message = 'Not enough credits.';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
    					}else{
                            while($num<$count){
                                $num++;
                                $user_random = rand(0,999919);
                            	$pass_random = rand(0,999919);
                            	$username = $prefix.$user_random;
                            	$password = $prefix.$pass_random;
                            	$user_email = $username.'gmail.com';
                            	
                            	// Use single encryption to match database
                            	$user_pass = $db->encryptor('encrypt', $password);
                                $auth_vpn = md5($password);
                                $code = rand(0,999999999);
                            	$duration = 2592000;
                            	$full_name = 'Bulk User';
                                
                                $int++;
                                $next_user_name = $pure_str.($int+1);
                            
                                $result = $db->sql_query("INSERT INTO users 
                                			            ( user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze,  user_level, code, is_ban, is_validated, upline, duration, user_group)
                                			        VALUES
                                			            ('".$db->SanitizeForSQL($next_user_name)."','".$db->SanitizeForSQL($user_pass)."','".$db->SanitizeForSQL($auth_vpn)."',
                                			            '".$db->SanitizeForSQL($user_email)."','".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d h:i:s')."','".$db->SanitizeForSQL($is_groupname)."', 0, 0,
                                			            '".$db->SanitizeForSQL($userlevel)."','".$db->SanitizeForSQL($code)."', 0, 1, '".$user_id_2."', '".$duration."', '".$bulk_group."')");
                                $result2 = $db->sql_query("INSERT INTO radcheck 
                                			            ( username, attribute, op, value)
                                			        VALUES
                                			            ('".$db->SanitizeForSQL($next_user_name)."','Cleartext-Password',':=','".$db->SanitizeForSQL($password)."')");
                            }
                            $action = 'Added new <code>'.$count.'</code> bulk users';
                            $addactivity = $db->sql_query("INSERT INTO activity_logs 
                							(user_id, date, action, ipaddress, device_os, device_client) 
                							values
                							('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                            if($result && $result2 && $addactivity){
                                $success_message = 'Added new <code>'.$count.'</code> bulk users';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
                            }else{
                                $error_message = 'Failed generating bulk!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                            $db->sql_query("UPDATE users SET credits = credits-'".$count."' WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
    					}
                    }else{
                        $error_message = 'Site key invalid!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
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
