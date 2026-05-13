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
$uid = trim($_POST['id']);
$otp = trim($_POST['verification']);
$otp = $db->Sanitize($otp );

$devsql = $db->sql_query("SELECT user_name FROM users WHERE user_id='$uid' LIMIT 1");
$devrow = $db->sql_fetchrow($devsql);

$username = trim($devrow['user_name']);

$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);

if(isset($_POST['submitted']) == 'verify_email') {
    $valid = true;
		
	if(empty($otp)){
		$errormsg[] = '<li>Enter your otp.';
        $valid = false;
	}
		
		if($valid){
			
			if($get_key == 'firenetdev'){
			    
			    $otpsql = $db->sql_query("SELECT user_2fa_otp FROM users WHERE user_id='$uid'");
			    $otprow = $db->sql_fetchrow($otpsql);
			    $u_otp = $otprow['user_2fa_otp'];
			    
			    if($u_otp == $otp){
			        
			        $otp_update = $db->sql_query("UPDATE users SET user_2fa_otp='', user_2fa_id='', user_2fa_duration='0', user_email_verified='1' WHERE user_id = '$uid'");
    				if($otp_update){
        				$success_message = 'Email verified!';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
    				}else{
    				    $error_message = 'Database error, Please contact administrator.';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
    				}
        		}else{
        			$error_message = 'Email verification failed.';
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
