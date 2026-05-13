<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/config.php';
require_once '../../includes/Mobile_Detect.php';
$detect = new Mobile_Detect;

$spam = $db->encryptor('encrypt', 'try to hack');
$spam = $db->encryptor('encrypt', $spam);		
$category = $db->Sanitize($_POST['category']);
$category = $db->encryptor('decrypt', $category);

// define the values from the form.
$otp = trim($_POST['otp']);
$otp = $db->Sanitize($otp );

$usql = $db->sql_query("SELECT user_name, user_pass FROM users WHERE user_2fa_otp='$otp'");
$urow = $db->sql_fetchrow($usql);

$username = trim($urow['user_name']);
$password = trim($urow['user_pass']);

$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);

if(isset($_POST['submitted']) == 'confirmation') {
    $valid = true;
		
	if(empty($otp)){
		$errormsg[] = '<li>Enter your confirmation code.';
        $valid = false;
	}
		
		if($valid){
			
			if($get_key == 'firenetdev'){
			    
			    $otpsql = $db->sql_query("SELECT user_email FROM users WHERE user_2fa_otp='".$db->SanitizeForSQL($otp)."' LIMIT 1");
			    $otprow = $db->sql_fetchrow($otpsql);
			    
			    if($db->sql_numrows($otpsql) > 0){
    				
    				$sql = $db->sql_query("SELECT * FROM users WHERE user_name='".$db->SanitizeForSQL($username)."' AND user_pass='".$db->SanitizeForSQL($password)."' LIMIT 1");					
    				$row = $db->sql_fetchrow($sql);
    				
    				if($sql || $row == 1)
    				{
    					$user_id = $row['user_id'];
    					$user_name = stripslashes($row['user_name']);
    					$user_pass = $row['user_pass'];
    					$full_name = $row['full_name'];
    					$user_email = $row['user_email'];
    					$ipaddress = $row['ipaddress'];
    					$user_level = $row['user_level'];
    					$status = $row['status'];
    					$is_freeze = $row['is_freeze'];
    					
    					if($category == 'Login Account')
    					{
    					    
        					if($user_pass == $password && $user_name == $username && $is_freeze==0){
        						$lastlogin = explode(" ", $row['lastlogin']);
        						$lastlogin_date =  $lastlogin[0];
        						$lastlogin_time = $lastlogin[1];
        
        						$info = $db->encrypt_key("$user_id|$user_name|$user_pass|$ipaddress|$lastlogin_date|$lastlogin_time|$user_level");
        						if (isset($remember)){
        							setcookie("user","$info", time()+86400, "$db->base_url()");
        						}else{
        							setcookie('user', $info, time()+86400, '/');
        							setcookie('user_id', $db->encrypt_key($user_id), time()+86400, '/');
        							setcookie('full_name', $db->encrypt_key($full_name), time()+86400, '/');
        							setcookie('user_email', $db->encrypt_key($user_email), time()+86400, '/');
        						}
        							
        						$deviceOS = $db->getOS()." - ".$db->getBrowserM();
        						$androidModel = $db->getDeviceModel();
        						$useragent = $_SERVER['HTTP_USER_AGENT'];
                                $str = $useragent;
                                    
                                if($detect->isAndroidOS()){
                                    $pos1 = strpos($str, '(')+1;
                                    $pos2 = strpos($str, ')')-$pos1;
                                    $part = substr($str, $pos1, $pos2);
                                    $parts = explode(" ", $part);
                                    $device_client = 'Smartphone ('.$androidModel.')';
                                }elseif(!$detect->isMobile() && !$detect->isTablet()){
                                    $device_client = 'Desktop';
                                }
                                    
        						$qry1 = $db->sql_query("UPDATE users SET ipaddress='$_SERVER[REMOTE_ADDR]', lastlogin=NOW(), login_status='online', last_active_time=NOW() WHERE user_id='".$user_id."'");
        						$qry2 = $db->sql_query("DELETE FROM login_attempts WHERE ip='".$_SERVER['REMOTE_ADDR']."'");
        						$qry3 = $db->sql_query("DELETE FROM login_banned_ip WHERE ip='".$_SERVER['REMOTE_ADDR']."'");
        						$qry4 = $db->sql_query("INSERT INTO activity_logs 
        							(user_id, date, action, ipaddress, device_os, device_client) 
        							values
        							('$user_id', '".date('Y-m-d H:i:s')."', 'Website Login', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
        						$qry5 = $db->sql_query("UPDATE users SET user_2fa_otp='', user_2fa_id='', user_2fa_duration='' WHERE user_2fa_otp='".$otp."'");
        						
        						$success_message = 'Welcome back '.$username.'!';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
        					}elseif($user_pass == $password && $user_name == $username && $is_freeze!=0){
        						$error_message = 'You are blocked, contact your upline.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
        					}else{
        						$error_message = 'Wrong Username/Password.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
        					}
    					}else{
    						$error_message = 'Sorry! invalid transaction!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
    					}
    
    				}else{
    					$error_message = 'Database error, please contact developer!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
    				}
			    }else{
			        $error_message = 'Confirmation code error!';
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
	
	echo json_encode($values);
}else{
	if(empty($_POST['user_name'])){
		$db->RedirectToURL($db->base_url());
		exit;	
	}
	if(empty($_POST['user_pass'])){
		$db->RedirectToURL($db->base_url());
		exit;	
	}
}
?>
