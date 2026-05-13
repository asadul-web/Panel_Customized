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
    $json = $db->Sanitize(trim($_POST['hash']));
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'json_delete'){
        $valid = true;
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $file = $_SERVER['DOCUMENT_ROOT'] . "/uploads/json/$json.json";
                if (file_exists($file)){
                    $delete_file = unlink($file);
                    if($delete_file){
                        $delete = $db->sql_query("DELETE FROM json_update WHERE encryption='$json'");
                        if($delete){
                            $success_message = 'Json <code>'.$json.'</code> was deleted.';
                            $values['response'] = 1;
                            $values['msg'] = $success_message;
                        }else{
                            $error_message = 'Json <code>'.$json.'</code> delete failed!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
                        }
                    }else{
                        $error_message = 'Json <code>'.$json.'</code> file not found!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }else{
                    $delete = $db->sql_query("DELETE FROM json_update WHERE encryption='$json'");
                
                    if($delete){
                        $success_message = 'Json <code>'.$json.'</code> was deleted.';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'Json <code>'.$json.'</code> delete failed!';
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
