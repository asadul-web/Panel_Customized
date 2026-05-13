<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/config.php';
require_once '../../includes/Mobile_Detect.php';
require_once '../../includes/security_simple.class.php';
$detect = new Mobile_Detect;
$security = new SecuritySimple($db);

$category = $db->Sanitize($_POST['category']);
$category = $db->encryptor('decrypt', $category);
$spam = $db->encryptor('encrypt', 'try to hack');
$spam = $db->encryptor('encrypt', $spam);		
		
// define the values from the form.
$username = trim($_POST['user_name']);
$username = $db->Sanitize($username );
$password = trim($_POST['user_pass']);
$password = $db->Sanitize($password);
$password = $db->encryptor('encrypt',$password);
$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);

function rancode() {
	$chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	srand((double)microtime()*1000000);
	$i = 0;
	while ($i <= 8)
	{
		$num = rand() % 33;
		$tmp = substr($chars, $num, 1);
		$pwd = $pwd . $tmp;
		$i++;
	}
	return $pwd;
}

if(isset($_POST['submitted']) == 'login_account') {
    $valid = true;
		
	if(empty($username)){
		$errormsg[] = '<li>Enter your username.';
        $valid = false;
	}

	if(empty($password)){
		$errormsg[] = '<li>Enter your password.';
        $valid = false;
	}
	
	//if(preg_match('/[^a-z-A-Z-0-9]/', $username)){
    //	$errormsg[] = '<li>Only letters/numbers allowed in username.</li>';
    //    $valid = false;
    //}
    
    //if(preg_match('/[^a-z-A-Z-0-9]/', $password)){
    //	$errormsg[] = '<li>Only letters/numbers allowed in password.</li>';
    //    $valid = false;
    //}
		
		if($valid){
			
			if($get_key == 'firenetdev'){
				// Security: Check login attempts before processing
				if (!$security->checkLoginAttempts($username)) {
					$error_message = 'Too many login attempts. Try again in 15 minutes.';
					$values['response'] = 2;
					$values['msg'] = $error_message;
					echo json_encode($values);
					exit;
				}
				
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
					$user_2fa = $row['user_2fa'];
					
					$user_2fa_otp = $row['user_2fa_otp'];
					$user_2fa_id = $row['user_2fa_id'];
					$user_2fa_duration = $row['user_2fa_duration'];
					
					if($category == 'Login Account')
					{
					    if($user_2fa == 1){
				
					        if($user_pass == $password && $user_name == $username && $is_freeze==0){
    							
    							if($user_2fa_duration == 0 && $user_2fa_id == '' && $user_2fa_otp == ''){
    							
                                    $code = rancode();
                                    $otpid = rancode();
        							$qryotp = $db->sql_query("UPDATE users SET user_2fa_otp='$code', user_2fa_id='$otpid', user_2fa_duration='600' WHERE user_email = '$user_email'");
        							
        							$msgz = "Hello " . $username . ",\r\n\r\n";
                        			$msgz .= "Copy the confirmation code given below and paste it in confirmation page. \r\n \r\n";
                        			$msgz .= "Confirmation Code: ".$code . "\r\n \r\n";
                        			$msgz .= "Regards, \r\n";
                        			$msgz .= "Security Department\r\n";
                        			$subject = $db->sitename . ' - Account Confirmation';
                        			
                        			#set email headers  to aviod spam filters
                        			$headers  = 'MIME-Version: 1.0' . "\r\n";
                        			$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
                        			//$headers .= "From: ".$db->siteTitle." <no-reply@".$db->sitename.">".$eol;
                        			$headers = 'From: support@no-reply.net' . "\r\n" .
                        			'Reply-To: support@no-reply.net' . "\r\n" .
                        			'X-Mailer: PHP/' . phpversion();
                        			
                        			mail($user_email, $subject, $msgz, $headers);	
    			
        							if($qryotp){
            							$success_message = 'Welcome back '.$username.'!';
                                        $values['response'] = 4;
                                        $values['msg'] = $success_message;
                                        $values['id'] = $otpid;
        							}else{
        							    $error_message = 'Sorry! invalid transaction!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
        							}
    							}else{
    							    $success_message = 'Welcome back '.$username.'!';
                                    $values['response'] = 4;
                                    $values['msg'] = $success_message;
                                    $values['id'] = $user_2fa_id;
    							}
    						}elseif($user_pass == $password && $user_name == $username && $is_freeze!=0){
    						    $error_message = 'You are blocked, contact your upline.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
    						}else{
    						    // Security: Log failed login attempt
    						    $security->logFailedLogin($username);
    						    
    						    $error_message = 'Wrong Username/Password.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
    						}
					    }else{
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
    							
    							// Security: Clear login attempts on successful login
    							$security->clearLoginAttempts($username);
    							
    							$qry2 = $db->sql_query("DELETE FROM login_attempts WHERE ip='".$_SERVER['REMOTE_ADDR']."'");
    							$qry3 = $db->sql_query("DELETE FROM login_banned_ip WHERE ip='".$_SERVER['REMOTE_ADDR']."'");
    							$qry4 = $db->sql_query("INSERT INTO activity_logs 
    								(user_id, date, action, ipaddress, device_os, device_client) 
    								values
    								('$user_id', '".date('Y-m-d H:i:s')."', 'Website Login', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
    							
    							$success_message = 'Welcome back '.$username.'!';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
    						}elseif($user_pass == $password && $user_name == $username && $is_freeze!=0){
    						    $error_message = 'You are blocked, contact your upline.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
    						}else{
    						    // Security: Log failed login attempt
    						    $security->logFailedLogin($username);
    						    
    						    $error_message = 'Wrong Username/Password.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
    						}
					    }
					}else{
						$error_message = 'Sorry! invalid transaction!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
					}

				}else{
					// Security: Log failed login attempt for non-existent user
					$security->logFailedLogin($username);
					
					$error_message = 'Wrong Username/Password.';
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