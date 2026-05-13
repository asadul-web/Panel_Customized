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
  
    $currentpassword = $db->Sanitize(trim($_POST['currentpassword']));
    $newpassword = $db->Sanitize(trim($_POST['newpassword']));
    $confirmpassword = $db->Sanitize(trim($_POST['confirmpassword']));
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'account_settings'){
        $valid = true;
        
        if(empty($currentpassword)){
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
        
        if(strlen($newpassword) < 5){
            $errormsg[] = '<li>Minimum of 5 characters in password!</li>';
            $valid = false;
        }
        
        if(strlen($confirmpassword) < 5){
            $errormsg[] = '<li>Minimum of 5 characters in password!</li>';
            $valid = false;
        }
        
        $password_qry = $db->sql_query("SELECT user_pass FROM users WHERE user_id='$user_id_2'");
    	$password_row = $db->sql_fetchrow($password_qry);
    	$oldpass = $password_row['user_pass'];
    	// Use single decryption to match database encryption
	    $userpass = $db->encryptor('decrypt', $oldpass);
        
        if($valid){
            if($get_key == 'firenetdev'){
                if($currentpassword != $userpass){
                    $error_message = 'Old password is incorrect.';
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