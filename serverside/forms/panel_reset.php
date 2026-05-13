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
	
    if(isset($_POST['submitted'])  == 'reset_panel'){
        $valid = true;
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $delete1 = $db->sql_query("DELETE FROM users WHERE user_level != 'superadmin' AND user_level != 'developer'"); 
                $delete2 = $db->sql_query("DELETE FROM users_profile WHERE profile_id > 2"); 
                $delete3 = $db->sql_query("DELETE FROM radcheck");
                $delete4 = $db->sql_query("DELETE FROM deleted_logs"); 
                $delete5 = $db->sql_query("DELETE FROM activity_logs"); 
                $delete6 = $db->sql_query("DELETE FROM users_delete"); 
                $delete7 = $db->sql_query("DELETE FROM credits_logs"); 
                $delete8 = $db->sql_query("DELETE FROM dns"); 
                $delete9 = $db->sql_query("DELETE FROM notification"); 
                
                if($delete1 && $delete2 && $delete3 && $delete4 && $delete5 && $delete6 && $delete7 && $delete8 && $delete9){
                    $success_message = 'Panel data has been cleared.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed clearing panel data!';
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
