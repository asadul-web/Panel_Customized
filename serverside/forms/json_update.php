<?php
ob_start();
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
    $content = $_POST['json'];
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'json_update'){
        $valid = true;
        
        if(empty($content)){
            $errormsg[] = 'Enter json code.'.PHP_EOL;
            $valid = false;
        }
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $file = fopen($_SERVER['DOCUMENT_ROOT'] . "/uploads/json/$json.json","w");
                ob_end_clean();
                $fwrite = fwrite($file,$content);
                $fclose = fclose($file);
                
                $update = $db->sql_query("UPDATE json_update SET date='".date('Y-m-d h:i:s')."' WHERE encryption='$json'");
                
                if($fwrite && $fclose && $update){
                    $success_message = 'Json <code>'.$json.'</code> updated successfully.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Json <code>'.$json.'</code> update failed!';
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
