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
    $uid = $db->Sanitize(trim($_POST['id']));
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    $sql = "SELECT * FROM notification WHERE id='$uid'";
    $qry = $db->sql_query("$sql") OR die();
	$row = $db->sql_fetchrow($qry);
    $filename = $row['filename'];
    
    if(isset($_POST['submitted'])  == 'notification_delete'){
        $valid = true;
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $file = $_SERVER['DOCUMENT_ROOT'] . "/uploads/notification/$filename";
                if (file_exists($file)){
                    $delete_file = unlink($file);
                    if($delete_file){
                        $delete = $db->sql_query("DELETE FROM notification WHERE id='$uid'");
                        if($delete){
                            $success_message = 'Notification was deleted.';
                            $values['response'] = 1;
                            $values['msg'] = $success_message;
                        }else{
                            $error_message = 'Deleting notification failed!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
                        }
                    }else{
                        $error_message = 'notification file not found!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }else{
                    $delete = $db->sql_query("DELETE FROM notification WHERE id='$uid'");
                
                    if($delete){
                        $success_message = 'Notification was deleted.';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'Deleting notification failed!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
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
