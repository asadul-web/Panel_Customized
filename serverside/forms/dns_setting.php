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
	
	$dnsdomain = $db->Sanitize(trim($_POST['dns_domain']));
	$dnszone = $db->Sanitize(trim($_POST['dns_zone']));
	$dnsglobal = $db->Sanitize(trim($_POST['dns_global']));
	$dnsemail = $db->Sanitize(trim($_POST['dns_email']));
	
    if(isset($_POST['submitted'])  == 'dns_update'){
        $valid = true;
        
        if(empty($dnsdomain)){
            $errormsg[] = 'Enter dns domain.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($dnszone)){
            $errormsg[] = 'Enter dns zone id.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($dnsglobal)){
            $errormsg[] = 'Enter dns global api.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($dnsemail)){
            $errormsg[] = 'Enter cloudflare email.'.PHP_EOL;
            $valid = false;
        }
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $dns_domain = $db->encrypt_key2($db->encryptor2('encrypt',$dnsdomain));
                $dns_zone = $db->encrypt_key2($db->encryptor2('encrypt',$dnszone));
                $dns_global = $db->encrypt_key2($db->encryptor2('encrypt',$dnsglobal));
                $dns_email = $db->encrypt_key2($db->encryptor2('encrypt',$dnsemail));
                
                $update = $db->sql_query("UPDATE site_options SET 
                            dns_domain='".$db->SanitizeForSQL($dns_domain)."', dns_global='".$db->SanitizeForSQL($dns_global)."', dns_zone='".$db->SanitizeForSQL($dns_zone)."', dns_email='".$db->SanitizeForSQL($dns_email)."'"); 
                if($update){
                    $success_message = 'Dns settings updated.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed updating dns settings!';
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
