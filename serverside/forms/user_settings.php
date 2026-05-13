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
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
	
	$prefix_status = $db->Sanitize(trim($_POST['prefix']));
	$uprefix = $db->Sanitize(trim($_POST['uprefix']));
	$trialdur = $db->Sanitize(trim($_POST['trialdur']));
	
    if(isset($_POST['submitted'])  == 'user_settings'){
        $valid = true;
        
        if(empty($trialdur)){
            $errormsg[] = 'Invalid trial duration.'.PHP_EOL;
            $valid = false;
        }
        
        if($trialdur == '1'){
            $tduration = '3600';
        }elseif($trialdur == '2'){
            $tduration = '7200';
        }elseif($trialdur == '3'){
            $tduration = '86400';
        }elseif($trialdur == '4'){
            $tduration = '1800';
        }elseif($trialdur == '5'){
            $tduration = '259200';
        }elseif($trialdur == '6'){
            $tduration = '432000';
        }else{
            $errormsg[] = 'Invalid transaction.'.PHP_EOL;
            $valid = false;
        }
    	
        if($valid){
            if($get_key == 'firenetdev'){
    		
                $update = $db->sql_query("UPDATE site_options SET 
                            prefix_status='".$db->SanitizeForSQL($prefix_status)."', prefix='".$db->SanitizeForSQL($uprefix)."',
                            trial_duration='".$db->SanitizeForSQL($tduration)."'"); 
                if($update){
                    $success_message = 'User settings updated.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed updating user settings!';
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
