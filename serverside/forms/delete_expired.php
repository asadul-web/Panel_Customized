<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'delete_expired'){
        $valid = true;
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $del_qry = $db->sql_query("SELECT user_name FROM users WHERE duration = 0 AND user_level != 'reseller' AND user_level != 'superadmin' AND user_level != 'developer'");
                $tot_expired = $db->sql_numrows($del_qry);
                
                if ($tot_expired > 0){
                    while($del_row = $db->sql_fetchrow($del_qry)) {
                        $del_username = $del_row['user_name'];
                        $u_delete = $db->sql_query("DELETE FROM radcheck WHERE username = '$del_username'");
                        $u_delete2 = $db->sql_query("DELETE FROM users WHERE user_name = '$del_username'");
                    }
                    
                    if($u_delete && $u_delete2){
                        $success_message = ''.$tot_expired.' expired users deleted.';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'Expired users delete failed!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }else{
                    $error_message = 'No expired users in database.';
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
