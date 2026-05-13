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
  
    $dnshostname = $db->Sanitize(trim(strtolower($_POST['dnshostname'])));
    $dnsip = $db->Sanitize(trim($_POST['dnsip']));
    $domain_id = $db->Sanitize(trim($_POST['domain_id']));

    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    // Get Cloudflare credentials from selected domain
    $dns_qry = $db->sql_query("SELECT domain_name, zone_id, global_api, email FROM cloudflare_domains WHERE id='".$db->SanitizeForSQL($domain_id)."' AND is_active=1") OR die();
	$dns_row = $db->sql_fetchrow($dns_qry);

    if(!$dns_row){
        echo json_encode(['response' => 2, 'msg' => 'Selected domain not found or inactive!']);
        exit;
    }

    $dns_domain = $dns_row['domain_name'];
    $cf_domain = $dns_row['domain_name'];
	
	$cf_zone = $dns_row['zone_id'];
	$cloudflarezone = $db->decrypt_key2($cf_zone);
	$dns_zone = $db->encryptor2('decrypt', $cloudflarezone);
	
	$cf_global = $dns_row['global_api'];
	$cloudflareglobal = $db->decrypt_key2($cf_global);
	$dns_global = $db->encryptor2('decrypt', $cloudflareglobal);
	
	$cf_email = $dns_row['email'];
	$cloudflareemail = $db->decrypt_key2($cf_email);
	$dns_email = $db->encryptor2('decrypt', $cloudflareemail);
    
    $dns_type = 'A';
    $dns_ttl = 1;
    $dns_proxied = false;
    
    // Create full hostname with domain
    $dnshost = $dnshostname . '.' . $dns_domain;
    if(isset($_POST['submitted'])  == 'add_dns'){
        $valid = true;
        
        if(empty($domain_id)){
        	$errormsg[] = 'Select a domain.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($dnshostname)){
        	$errormsg[] = 'Enter dns hostname.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($dnsip)){
        	$errormsg[] = 'Enter dns ip.'.PHP_EOL;
            $valid = false;
        }
        
        if(!preg_match('/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/', $dnsip)){
            $errormsg[] = 'Invalid ip address.'.PHP_EOL;
            $valid = false;
        }
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $ch = curl_init();		
    		    $apiURL = json_encode(  array( "type"=> $dns_type,"name" => $dnshost, "content" => $dnsip, "ttl" => $dns_ttl, "proxied" => $dns_proxied ));
    		    curl_setopt( $ch, CURLOPT_POSTFIELDS, $apiURL );
    		    curl_setopt($ch, CURLOPT_URL, "https://api.cloudflare.com/client/v4/zones/".$dns_zone."/dns_records/");
    		    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    		    curl_setopt($ch, CURLOPT_VERBOSE, 1);
    		    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                'X-Auth-Email: '.$dns_email.'',
                'X-Auth-Key: '.$dns_global.'',
                'Cache-Control: no-cache',
                // 'Content-Type: multipart/form-data; charset=utf-8',
                'Content-Type:application/json',
                'purge_everything: true'
                ));
    		    $content  = curl_exec($ch);
    		    curl_close($ch);
    		    /* PARSING RESPONSE */
    		    $response = json_decode($content,true);
    		    /* RETURN */
                
                if($response['success'] == true){
                    $dns_id = $response['result']['id'];
                    $dns_error = '';
                    
                    $result = $db->sql_query("INSERT INTO dns 
                            	(record_id, host_name, domain_name, ip_address, record_type, status, global_api, zone_id, email)
                            	VALUES
                            	('".$db->SanitizeForSQL($dns_id)."','".$db->SanitizeForSQL($dnshost)."','".$db->SanitizeForSQL($cf_domain)."',
                            	'".$db->SanitizeForSQL($dnsip)."','".$db->SanitizeForSQL($dns_type)."',
                            	0,'".$db->SanitizeForSQL($cf_global)."',
                            	'".$db->SanitizeForSQL($cf_zone)."','".$db->SanitizeForSQL($cf_email)."')");
                }else{
                    $dns_id = '';
                    $dns_error = $response['errors']['0']['message'];
                }
                
                if($result){
                    $success_message = 'Dns <code>'.$dnshost.'.'.$dns_domain.'</code> was added successfully!';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Dns <code>'.$dnshost.'.'.$dns_domain.'</code> adding failed!';
                    $values['response'] = 2;
                    $values['msg'] = $dns_error;
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
