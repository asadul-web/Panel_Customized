<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';

$values = array();

    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
	
	$username = $db->Sanitize(trim($_POST['username']));
	$password = $db->Sanitize(trim($_POST['password']));
	$userlevel = 'trial';
	$is_groupname = 'trial';
	$user_email = $username.'@gmail.com';
	$full_name = 'Trial User';
	$is_active = 1;
	$trial_qry = $db->sql_query("SELECT trial_duration FROM site_options");
    $trial_row = $db->sql_fetchrow($trial_qry);
    $duration = $trial_row['trial_duration'];
	
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
    
    //for debug only!
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    
    $resp = curl_exec($curl);
    curl_close($curl);
    $response = json_decode($resp,true);
    
    if(isset($_POST['submitted'])  == 'create_trial'){
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
        
        if(empty($password)){
            $errormsg[] = '<li>Password is required.</li>';
            $valid = false;
        }
        
        if(strlen($username) < 5){
            $errormsg[] = '<li>Username is too short.</li>';
            $valid = false;
        }
        
        if(strlen($password) < 5){
            $errormsg[] = '<li>Password is too short.</li>';
            $valid = false;
        }
            
    	if(preg_match('/[^a-z-A-Z-0-9]/', $username)){
    	    $errormsg[] = '<li>Only letters/numbers allowed in username.</li>';
            $valid = false;
    	}
    	
    	if(preg_match('/[^a-z-A-Z-0-9]/', $password)){
    	    $errormsg[] = '<li>Only letters/numbers allowed in password.</li>';
            $valid = false;
    	}
    	
    	$username_qry = $db->sql_query("SELECT user_name FROM users WHERE user_name='$username'");
    	$username_chk = $db->sql_numrows($username_qry);
    	if($username_chk > 0){
            $errormsg[] = '<li>Username is already taken. Please re-submit request.</li>';
            $valid = false;
    	}

        if($valid){
            if($get_key == 'firenetdev')
            {
                // Use single encryption to match database
                $user_pass = $db->encryptor('encrypt', $password);
                $auth_vpn = md5($password);
                $code = rand(0,999999999);
                
                    {
                        $result = $db->sql_query("INSERT INTO users 
                            			            ( user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze,  user_level, code, is_ban, is_validated, upline, duration, device_connected)
                            			        VALUES
                            			            ('".$db->SanitizeForSQL($username)."','".$db->SanitizeForSQL($user_pass)."','".$db->SanitizeForSQL($auth_vpn)."',
                            			            '".$db->SanitizeForSQL($user_email)."','".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d h:i:s')."','".$db->SanitizeForSQL($is_groupname)."', '".$db->SanitizeForSQL($is_active)."', 0,
                            			            '".$db->SanitizeForSQL($userlevel)."','".$db->SanitizeForSQL($code)."', 0, 1, 1, '".$duration."', 1)");
                            $result2 = $db->sql_query("INSERT INTO radcheck 
                            			            ( username, attribute, op, value)
                            			        VALUES
                            			            ('".$db->SanitizeForSQL($username)."','Cleartext-Password',':=','".$db->SanitizeForSQL($password)."')");
                            
                        
                        if($result && $result2){
                            $success_message = '<code>'.$username.' - '.$userlevel.'</code> user was successfully created! <button class="btn btn-copy btn-sm btn-warning" data-clipboard-text="User Details
    
Username : '.$username.'
Password : '.$password.'
Subscription : '.$userlevel.'">Copy</button>';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
                            }else{
                                $error_message = 'Failed creating account!';
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
