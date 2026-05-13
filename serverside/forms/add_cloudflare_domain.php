<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();

if($user_id_2 == 2 || $user_level_2 == 'developer'){
}else{
    echo json_encode(['response' => 2, 'msg' => 'Sorry, you dont have permission to access this page.']);
    exit;
}

$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);

$domain = $db->Sanitize(trim($_POST['domain']));
$zone_id = $db->Sanitize(trim($_POST['zone_id']));
$global_api = $db->Sanitize(trim($_POST['global_api']));
$email = $db->Sanitize(trim($_POST['email']));

if(isset($_POST['submitted']) == 'add_cloudflare_domain'){
    $valid = true;
    
    if(empty($domain)){
        $errormsg[] = 'Enter domain name.'.PHP_EOL;
        $valid = false;
    }
    
    if(empty($zone_id)){
        $errormsg[] = 'Enter Zone ID.'.PHP_EOL;
        $valid = false;
    }
    
    if(empty($global_api)){
        $errormsg[] = 'Enter Global API key.'.PHP_EOL;
        $valid = false;
    }
    
    if(empty($email)){
        $errormsg[] = 'Enter Cloudflare email.'.PHP_EOL;
        $valid = false;
    }
    
    if($valid){
        if($get_key == 'firenetdev'){
            
            // Check if domain already exists
            $check_query = $db->sql_query("SELECT id FROM cloudflare_domains WHERE domain_name='".$db->SanitizeForSQL($domain)."'");
            if($db->sql_numrows($check_query) > 0){
                $values['response'] = 2;
                $values['msg'] = 'Domain already exists!';
            }else{
                // Encrypt sensitive data
                $encrypted_zone = $db->encrypt_key2($db->encryptor2('encrypt', $zone_id));
                $encrypted_api = $db->encrypt_key2($db->encryptor2('encrypt', $global_api));
                $encrypted_email = $db->encrypt_key2($db->encryptor2('encrypt', $email));
                
                $insert = $db->sql_query("INSERT INTO cloudflare_domains 
                    (domain_name, zone_id, global_api, email, is_active)
                    VALUES
                    ('".$db->SanitizeForSQL($domain)."', 
                     '".$db->SanitizeForSQL($encrypted_zone)."', 
                     '".$db->SanitizeForSQL($encrypted_api)."', 
                     '".$db->SanitizeForSQL($encrypted_email)."', 
                     1)");
                
                if($insert){
                    $values['response'] = 1;
                    $values['msg'] = 'Cloudflare domain added successfully!';
                }else{
                    $values['response'] = 2;
                    $values['msg'] = 'Failed to add domain!';
                }
            }
        }else{
            $values['response'] = 2;
            $values['msg'] = 'Site key invalid!';
        }
    }else{
        $values['response'] = 3;
        $errors = implode('', $errormsg);
        $values['errormsg'] = $errors;
    }
}

echo json_encode($values);
?>
