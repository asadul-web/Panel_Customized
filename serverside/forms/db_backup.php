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
	
	$recipient_email = $db->Sanitize(trim($_POST['recipient_email']));
	$cc_email = $db->Sanitize(trim($_POST['cc_email']));
	
    if(isset($_POST['submitted'])  == 'database_backup'){
        $valid = true;
        
        if(empty($recipient_email)){
            $errormsg[] = 'Enter recipient email.'.PHP_EOL;
            $valid = false;
        }
        
        if(!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i", $recipient_email))
    	{
    		//print the error message and load the form.
    		$db->HandleError('Invalid recipient email address!');
    		$valid = false;
    	}
    	
    	if(!empty($cc_email)){
        	if(!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i", $cc_email))
        	{
        		//print the error message and load the form.
        		$db->HandleError('Invalid cc email address!');
        	}
    	}
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $update = $db->sql_query("UPDATE site_options SET 
                            bak_to='".$db->SanitizeForSQL($recipient_email)."', bak_cc='".$db->SanitizeForSQL($cc_email)."'"); 
                if($update){
                    $success_message = 'Database backup successfuly set.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed setting database backup!';
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
