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
  
    $title = $db->Sanitize(trim($_POST['title']));
    $type = $db->Sanitize(trim($_POST['type']));
    $content = $db->Sanitize(trim($_POST['post']));
    
    $filename = generateRandomString();
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'add_notification'){
        $valid = true;
        
        if(empty($content)){
        	$errormsg[] = 'Enter notification post.'.PHP_EOL;
            $valid = false;
        }
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $file = fopen($_SERVER['DOCUMENT_ROOT'] . "/uploads/notification/$filename","w");
                ob_end_clean();
                $fwrite = fwrite($file,$content);
                $fclose = fclose($file);
                
                $result = $db->sql_query("INSERT INTO notification 
                    	( title, filename, type, date)
                    	VALUES
                    	('".$db->SanitizeForSQL($title)."','".$db->SanitizeForSQL($filename)."','".$db->SanitizeForSQL($type)."',
                    	'".date('Y-m-d H:i:s')."')");

                if($fwrite && $fclose && $result){
                    $success_message = 'Success adding new notification.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed adding new notification.';
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
