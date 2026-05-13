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
    $record_id = $db->Sanitize(trim($_POST['record_id']));
    $newip = $db->Sanitize(trim($_POST['ip']));
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    $dns_qry = $db->sql_query("SELECT host_name, domain_name, ip_address, global_api, zone_id, email FROM dns WHERE record_id='$record_id'") OR die();
	$dns_row = $db->sql_fetchrow($dns_qry);
    $host_name = $dns_row['host_name'];
    $ip_address = $dns_row['ip_address'];
    
    $cf_domain = $dns_row['domain_name'];
	$cloudflaredomain = $db->decrypt_key2($cf_domain);
	$domain_name = $db->encryptor2('decrypt', $cloudflaredomain);
	
	$cf_zone = $dns_row['zone_id'];
	$cloudflarezone = $db->decrypt_key2($cf_zone);
	$zone_id = $db->encryptor2('decrypt', $cloudflarezone);
	
	$cf_global = $dns_row['global_api'];
	$cloudflareglobal = $db->decrypt_key2($cf_global);
	$global_api = $db->encryptor2('decrypt', $cloudflareglobal);
	
	$cf_email = $dns_row['email'];
	$cloudflareemail = $db->decrypt_key2($cf_email);
	$email = $db->encryptor2('decrypt', $cloudflareemail);
    
    $dns_type = 'A';
    $dns_ttl = 1;
    $dns_proxied = false;
    
    if(isset($_POST['submitted'])  == 'dns_update'){
        $valid = true;
        
        if(empty($newip)){
            $errormsg[] = 'Enter dns ip.'.PHP_EOL;
            $valid = false;
        }
        
        if(!preg_match('/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/', $newip)){
            $errormsg[] = 'Invalid ip address.'.PHP_EOL;
            $valid = false;
        }
        
        if($valid){
            if($get_key == 'firenetdev'){
                
                $ch = curl_init(); 		
        		$apiURL = json_encode( array( "type"=> $dns_type,"name" => $host_name, "content" => $newip, "ttl" => $dns_ttl, "proxied" => $dns_proxied ) );
        		curl_setopt( $ch, CURLOPT_POSTFIELDS, $apiURL );
        		curl_setopt($ch, CURLOPT_URL, "https://api.cloudflare.com/client/v4/zones/".$zone_id."/dns_records/".$record_id);
        		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
        		curl_setopt($ch, CURLOPT_VERBOSE, 1);
        		curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                'X-Auth-Email: '.$email.'',
                'X-Auth-Key: '.$global_api.'',
                'Cache-Control: no-cache',
                'Content-Type: multipart/form-data; charset=utf-8',
                'Content-Type:application/json',
                'purge_everything: true'
                
                ));	
        		$content  = curl_exec($ch);
        		curl_close($ch);
        		/* PARSING RESPONSE */
        		$response = json_decode($content,true);
        		/* RETURN */
                
                if($response['success'] == true){
                    $dns_error = '';
                    
                    $update = $db->sql_query("UPDATE dns SET ip_address='$newip' WHERE record_id='$record_id'");
                }else{
                    $dns_error = $response['errors']['0']['message'];
                }
                
                if($update){
                    $success_message = '<code>'.$host_name.'.'.$domain_name.'</code> ip was updated successfully!';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Dns <code>'.$host_name.'.'.$domain_name.'</code> update failed!';
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
