<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';

$values = array();

    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
	
	$username = $db->Sanitize(trim($_POST['username']));
	
	$turnstile = $db->Sanitize(trim($_POST['cf-turnstile-response']));
    
    $url = "https://challenges.cloudflare.com/turnstile/v0/siteverify";

    $curl = curl_init($url);
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    
    $headers = array(
       "Content-Type: application/x-www-form-urlencoded",
    );
    curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
    
    $data = "secret=$turnstile_secret&response=$turnstile";
    
    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
    
    // SSL verification settings
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 2);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, true);
    
    $resp = curl_exec($curl);
    curl_close($curl);
    $response = json_decode($resp,true);
    
    if(isset($_POST['submitted'])  == 'device_reset'){
        $valid = true;
        
        if($response['success'] == true){
            
        }else{
            $errormsg[] = '<li>Site verification failed. Please try again.</li>';
            $valid = false;
        }  
        
    	if(empty($username)){
            $errormsg[] = '<li>Username is required.</li>';
            $valid = false;
        }
        
        if(strlen($username) < 5){
            $errormsg[] = '<li>Username is too short.</li>';
            $valid = false;
        }
            
    	if(preg_match('/[^a-z-A-Z-0-9]/', $username)){
    	    $errormsg[] = '<li>Only letters/numbers allowed in username.</li>';
            $valid = false;
    	}
    	
    	$username_qry = $db->sql_query("SELECT user_id, user_name, user_level FROM users WHERE user_name='$username'");
    	$row = $db->sql_fetchrow($username_qry);
    	$username_chk = $db->sql_numrows($username_qry);

    	$userlevel = $row['user_level'];
    	$userid = $row['user_id'];
    	
    	if($username_chk < 1){
            $errormsg[] = '<li>User not found.</li>';
            $valid = false;
    	}elseif($username_chk > 0){
    	    if($userlevel != 'normal' && $userlevel != 'trial' && $userlevel != 'bulk'){
                $errormsg[] = '<li>User is not valid.</li>';
                $valid = false;
            }
    	}
        
        if($valid){
            if($get_key == 'firenetdev')
            {
                
            	$update = $db->sql_query("UPDATE users SET device_id='', device_model='' WHERE user_id!=1 AND user_id='$userid'");
                        
                    if($update){
                        $success_message = 'User <code>'.$username.'</code> device was reset!';
                        $values['response'] = 1;
                        $values['msg'] = $success_message;
                    }else{
                        $error_message = 'User <code>'.$username.'</code> device reset failed!';
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
