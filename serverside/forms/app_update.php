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
  
    $download1_name = $db->Sanitize(trim($_POST['download1_name']));
    $download1_url = $db->Sanitize(trim($_POST['download1_url']));
    $download2_name = $db->Sanitize(trim($_POST['download2_name']));
    $download2_url = $db->Sanitize(trim($_POST['download2_url']));
    $download3_name = $db->Sanitize(trim($_POST['download3_name']));
    $download3_url = $db->Sanitize(trim($_POST['download3_url']));
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'app_update'){
        $valid = true;
        
        if(strlen($download1_name) > 15){
            $errormsg[] = 'Download Name No.1 is too long.'.PHP_EOL;
            $valid = false;
        }
        
        if(strlen($download2_name) > 15){
            $errormsg[] = 'Download Name No.2 is too long.'.PHP_EOL;
            $valid = false;
        }
        
        if(strlen($download3_name) > 15){
            $errormsg[] = 'Download Name No.3 is too long.'.PHP_EOL;
            $valid = false;
        }
        
        if($download1_url != ''){
            if(!filter_var($download1_url, FILTER_VALIDATE_URL)){
        	    $errormsg[] = 'Download Link No.1 is invalid.'.PHP_EOL;
                $valid = false;
        	}
        }
    	
    	if($download2_url != ''){
        	if(!filter_var($download2_url, FILTER_VALIDATE_URL)){
        	    $errormsg[] = 'Download Link No.2 is invalid.'.PHP_EOL;
                $valid = false;
        	}
    	}
    	
    	if($download3_url != ''){
        	if(!filter_var($download3_url, FILTER_VALIDATE_URL)){
        	    $errormsg[] = 'Download Link No.3 is invalid.'.PHP_EOL;
                $valid = false;
        	}
    	}
        
        if($valid){
            if($get_key == 'firenetdev'){
                $update1 = $db->sql_query("UPDATE application SET name='$download1_name', link='$download1_url', date='".date('Y-m-d h:i:s')."' WHERE id=1");
                $update2 = $db->sql_query("UPDATE application SET name='$download2_name', link='$download2_url', date='".date('Y-m-d h:i:s')."' WHERE id=2");
                $update3 = $db->sql_query("UPDATE application SET name='$download3_name', link='$download3_url', date='".date('Y-m-d h:i:s')."' WHERE id=3");

                if($update1 && $update2 && $update3){
                    $success_message = 'App download links updated.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'App download links update failed!';
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
