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
	
	$github_username = $db->Sanitize(trim($_POST['github_username']));
	$github_token = $db->Sanitize(trim($_POST['github_token']));
	$github_repo = $db->Sanitize(trim($_POST['github_repo'] ?? ''));
	// Support both old and new field names
	$update_json = isset($_POST['base_api_url']) ? $db->Sanitize(trim($_POST['base_api_url'])) : $db->Sanitize(trim($_POST['upnotice'] ?? ''));
	$license = $db->Sanitize(trim($_POST['license']));
	$turnstile_key = $db->Sanitize(trim($_POST['turnstile']));
	$turnstile_secret = $db->Sanitize(trim($_POST['turnstilesecret']));
	$whois = $db->Sanitize(trim($_POST['whois']));
	
    if(isset($_POST['submitted'])  == 'git_settings'){
        $valid = true;
        
        if(empty($github_username)){
            $errormsg[] = 'Enter github username.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($github_token)){
            $errormsg[] = 'Enter github token.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($update_json)){
            $errormsg[] = 'Enter base API URL.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($turnstile_key)){
            $errormsg[] = 'Enter turnstile key.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($turnstile_secret)){
            $errormsg[] = 'Enter turnstile secret.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($whois)){
            $errormsg[] = 'Enter whois api.'.PHP_EOL;
            $valid = false;
        }
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $update = $db->sql_query("UPDATE site_options SET 
                            github_username='".$db->SanitizeForSQL($github_username)."', github_token='".$db->SanitizeForSQL($github_token)."', github_repo='".$db->SanitizeForSQL($github_repo)."', update_json='".$db->SanitizeForSQL($update_json)."', license='".$db->SanitizeForSQL($license)."', turnstile_key='".$db->SanitizeForSQL($turnstile_key)."', turnstile_secret='".$db->SanitizeForSQL($turnstile_secret)."', whois_api='".$db->SanitizeForSQL($whois)."'"); 
                if($update){
                    // Save base URL to config file for APIs to use
                    $config_file = __DIR__ . '/../../includes/backup/api_config.json';
                    $config_data = [
                        'base_url' => $update_json,
                        'updated_at' => time(),
                        'updated_by' => 'developer'
                    ];
                    @file_put_contents($config_file, json_encode($config_data, JSON_PRETTY_PRINT));
                    
                    $success_message = 'General settings updated.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed updating general settings!';
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
