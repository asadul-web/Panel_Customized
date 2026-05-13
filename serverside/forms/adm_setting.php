<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 2 || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
	
	$admusername = $db->Sanitize(trim($_POST['admusername']));
	$admpassword = $db->Sanitize(trim($_POST['admpassword']));
	$user_pass = $db->encryptor('encrypt',$admpassword);
    $auth_vpn = md5($admpassword);
	
    if(isset($_POST['submitted'])  == 'edit_admin'){
        $valid = true;
        
        if(empty($admusername)){
            $errormsg[] = 'Enter admin username.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($admpassword)){
            $errormsg[] = 'Enter admin password.'.PHP_EOL;
            $valid = false;
        }
        
        if(preg_match('/[^a-z-A-Z-0-9]/', $admusername)){
    	    $errormsg[] = '<li>Only letters/numbers allowed in admin username.</li>';
            $valid = false;
    	}
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                // Update admin account (user_id=1) from Administrator settings
                $update = $db->sql_query("UPDATE users SET 
                            user_name='".$db->SanitizeForSQL($admusername)."', user_pass='".$db->SanitizeForSQL($user_pass)."', auth_vpn='".$db->SanitizeForSQL($auth_vpn)."' WHERE user_id='1'"); 
                if($update){
                    $success_message = 'Administrator account updated successfully.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed updating admin user!';
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
