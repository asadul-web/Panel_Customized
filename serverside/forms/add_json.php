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
  
    $name = $db->Sanitize(trim($_POST['name']));
    $type = $db->Sanitize(trim($_POST['type']));
    $json = $_POST['json'];
    $encryption = generateRandomString();
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'add_json'){
        $valid = true;
        
        if(empty($json)){
        	$errormsg[] = 'Enter json code.'.PHP_EOL;
            $valid = false;
        }
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $file = fopen($_SERVER['DOCUMENT_ROOT'] . "/uploads/json/$encryption.json","w");
                ob_end_clean();
                $fwrite = fwrite($file,$json);
                $fclose = fclose($file);
                
                $result = $db->sql_query("INSERT INTO json_update 
                    	( name, type, encryption, date)
                    	VALUES
                    	('".$db->SanitizeForSQL($name)."','".$db->SanitizeForSQL($type)."','".$db->SanitizeForSQL($encryption)."',
                    	'".date('Y-m-d H:i:s')."')");

                if($fwrite && $fclose && $result){
                    $success_message = 'Success adding new json.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed adding new json.';
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
