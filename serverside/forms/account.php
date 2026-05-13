<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
  
    $oldpassword = $db->Sanitize(trim($_POST['oldpassword']));
    $newpassword = $db->Sanitize(trim($_POST['newpassword']));
    $confirmpassword = $db->Sanitize(trim($_POST['confirmpassword']));
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'account_settings'){
        $valid = true;
        
        if(empty($oldpassword)){
            $errormsg[] = '<li>Enter current password.</li>';
            $valid = false;
        }
        
        if(empty($newpassword)){
            $errormsg[] = '<li>Enter new password.</li>';
            $valid = false;
        }
        
        if(empty($confirmpassword)){
            $errormsg[] = '<li>Enter confirm password.</li>';
            $valid = false;
        }
        
        if(preg_match('/[^a-z-A-Z-0-9]/', $oldpassword)){
    	    $errormsg[] = '<li>Only letters/numbers are allowed in old password.</li>';
            $valid = false;
    	}
    	
    	if(preg_match('/[^a-z-A-Z-0-9]/', $newpassword)){
    	    $errormsg[] = '<li>Only letters/numbers are allowed in new password.</li>';
            $valid = false;
    	}
    	
    	if(preg_match('/[^a-z-A-Z-0-9]/', $confirmpassword)){
    	    $errormsg[] = '<li>Only letters/numbers are allowed in confirm password.</li>';
            $valid = false;
    	}
        
        $password_qry = $db->sql_query("SELECT user_pass FROM users WHERE user_id='$user_id_2'");
    	$password_row = $db->sql_fetchrow($password_qry);
    	
    	// Debug: Check if user was found
    	if(!$password_row) {
    	    $error_message = 'User not found in database. User ID: '.$user_id_2;
    	    $values['response'] = 2;
            $values['msg'] = $error_message;
            echo json_encode($values);
            exit;
    	}
    	
    	$oldpass = $password_row['user_pass'];
    	// Use single decryption to match database encryption
	    $userpass = $db->encryptor('decrypt', $oldpass);
	    
	    // Debug: Log what we're comparing
	    error_log("Password Change Debug - User ID: $user_id_2");
	    error_log("Encrypted from DB: $oldpass");
	    error_log("Decrypted password: $userpass");
	    error_log("Entered password: $oldpassword");
        
        if($valid){
            if($get_key == 'firenetdev'){
                // Debug: Check if passwords match
                if(trim($oldpassword) != trim($userpass)){
                    $error_message = 'Old password is incorrect. [Debug: Entered="'.htmlspecialchars($oldpassword).'", Expected="'.htmlspecialchars($userpass).'"]';
                    $values['response'] = 2;
                    $values['msg'] = $error_message;
                }else{
                    if($newpassword != $confirmpassword){
                        $error_message = 'New password and confirm password didn&#39;t match.';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }else{
                        $user_pass = $db->encryptor('encrypt',$newpassword);
                        $auth_vpn = md5($newpassword);
                            
                        $update = $db->sql_query("UPDATE users SET user_pass='$user_pass', auth_vpn='$auth_vpn' WHERE user_id='$user_id_2'");
        
                        if($update){
                            $success_message = 'Password was successfully updated.';
                            $values['response'] = 1;
                            $values['msg'] = $success_message;
                        }else{
                            $error_message = 'Failed updating password.';
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
            $errors = implode('',$errormsg);
            $values['errormsg'] = $errors;
        }
    }
    echo json_encode($values);
?>