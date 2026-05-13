<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $sessions = $db->Sanitize(trim($_POST['sessions']));
    $resetsessions = $db->Sanitize(trim($_POST['resetvpnsessions']));
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'vpn_session'){
        $valid = true;
        
        if(empty($sessions)){
            $errormsg[] = 'Enter no. of sessions.'.PHP_EOL;
            $valid = false;
        }
        
        if(preg_match('/[^0-9]/', $sessions)){
    	    $errormsg[] = 'Only numbers allowed.';
            $valid = false;
    	}
    	
        if($valid){
            if($get_key == 'firenetdev'){
                if($resetsessions == 1){
                    $update1 = $db->sql_query("UPDATE site_options SET session_limit='$sessions'");
                    $update2 = $db->sql_query("UPDATE users SET session=0");
                    if($update1 && $update2){
                        $success_message = 'Vpn settings updated.';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'Vpn settings update failed!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }elseif($resetsessions == 0){
                    $update = $db->sql_query("UPDATE site_options SET session_limit='$sessions'");
                    if($update){
                        $success_message = 'Vpn settings updated.';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'Vpn settings update failed!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }else{
                    $error_message = 'Invalid transaction!';
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
