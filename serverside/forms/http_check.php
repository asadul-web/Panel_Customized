<?php
$timeout = ini_set("default_socket_timeout", 5);
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
    $hostname = $db->Sanitize(trim($_POST['hostname']));
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'http_check'){
        $valid = true;
        
        if(empty($hostname)){
            $errormsg[] = 'Enter hostname.'.PHP_EOL;
            $valid = false;
        }
        
        if(!preg_match('/([a-z0-9A-Z]\.)*[a-z0-9-]+\.([a-z0-9]{2,24})+(\.co\.([a-z0-9]{2,24})|\.([a-z0-9]{2,24}))*/', $hostname)){
    	    $errormsg[] = 'Invalid hostname.'.PHP_EOL;
            $valid = false;
    	}
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $time_start = microtime(true); 
                $response = getHTTPResponseStatusCode('http://'.$hostname.'');

                $response_array = explode(' ',$response);
                    for($i = 0; $i < count($response_array); $i++){
                        ${'var'.$i} = $response_array[$i];
                    }
                if($response){
                    $status_code = $var0;
                    $status_msg = $var1.' '.$var2;
                }else{
                    $status_code = 'undefined';
                    $status_msg = 'undefined';
                }
                $time_end = microtime(true);
                $execution_time = ($time_end - $time_start)/60;
                
                if($execution_time < 3){
                        $success_message = 'Hostname: <code>'.$hostname.'</code><br>Http Status Code: <code>'.$status_code.'</code><br>Http Status Message: <code>'.$status_msg.'</code>';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                }else{
                    $error_message = 'Error checking http.';
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
