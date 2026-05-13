<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();

if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

    if(isset($_POST['submitted'])  == 'server_delete'){
    	$chk = $_POST['serverxlist'];
    	$key = $db->encryptor('decrypt', $_POST['_key']);
    	
    	$chk_array = explode(",", $chk);
        $chkcount = count($chk_array); 

        $serverip = explode(',', $chk);
        
        $dns_qry = $db->sql_query("SELECT dns_domain, dns_global, dns_zone, dns_email FROM site_options WHERE id='1'") OR die();
    	$dns_row = $db->sql_fetchrow($dns_qry);
    
        $cf_domain = $dns_row['dns_domain'];
    	$cloudflaredomain = $db->decrypt_key2($cf_domain);
    	$dns_domain = $db->encryptor2('decrypt', $cloudflaredomain);
    	
    	$cf_zone = $dns_row['dns_zone'];
    	$cloudflarezone = $db->decrypt_key2($cf_zone);
    	$dns_zone = $db->encryptor2('decrypt', $cloudflarezone);
    	
    	$cf_global = $dns_row['dns_global'];
    	$cloudflareglobal = $db->decrypt_key2($cf_global);
    	$dns_global = $db->encryptor2('decrypt', $cloudflareglobal);
    	
    	$cf_email = $dns_row['dns_email'];
    	$cloudflareemail = $db->decrypt_key2($cf_email);
    	$dns_email = $db->encryptor2('decrypt', $cloudflareemail);
        
    	if(!isset($chk)){
            $error_message = 'You need to check the checkbox! At least one checkbox Must be Selected !!!';
            $values['response'] = 2;
            $values['msg'] = $error_message;
    	}else{
    		for($i=0; $i<$chkcount; $i++)
    		{	
    			$chk_ip = $serverip[$i];
    			//$chk_id = $db->encryptor('decrypt',$chk_id);
    			$chk_qry = $db->sql_query("SELECT * FROM server_list WHERE server_ip='".$chk_ip."'");
    			while($chk_rows = $db->sql_fetchrow($chk_qry))
    			{
    			    $servip = $chk_rows['server_ip'];
    			    $servname = $chk_rows['server_name'];
    			    $a_id = $chk_rows['a_id'];
                    $ns_id = $chk_rows['ns_id'];
    			    
    			    if($a_id == '' && $ns_id == ''){
                        $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                    }elseif($a_id != '' && $ns_id == ''){
                        $ch = curl_init();
                		curl_setopt($ch, CURLOPT_URL, "https://api.cloudflare.com/client/v4/zones/".$dns_zone."/dns_records/".$a_id);
                		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
                		curl_setopt($ch, CURLOPT_VERBOSE, 1);
                		curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                        'X-Auth-Email: '.$dns_email.'',
                        'X-Auth-Key: '.$dns_global.'',
                        'Cache-Control: no-cache',
                        // 'Content-Type: multipart/form-data; charset=utf-8',
                        'Content-Type:application/json'
                        
                        ));
                		$content  = curl_exec($ch);
                		curl_close($ch);
                		/* PARSING RESPONSE */
                		$response = json_decode($content,true);
                        
                        if($response['success'] == true){
                            $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                        }elseif($response['code'] == 1001){
                            $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                        }else{
                            $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                        }
                    }elseif($a_id == '' && $ns_id != ''){
                        $ch = curl_init();
                		curl_setopt($ch, CURLOPT_URL, "https://api.cloudflare.com/client/v4/zones/".$dns_zone."/dns_records/".$ns_id);
                		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
                		curl_setopt($ch, CURLOPT_VERBOSE, 1);
                		curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                        'X-Auth-Email: '.$dns_email.'',
                        'X-Auth-Key: '.$dns_global.'',
                        'Cache-Control: no-cache',
                        // 'Content-Type: multipart/form-data; charset=utf-8',
                        'Content-Type:application/json'
                        
                        ));
                		$content  = curl_exec($ch);
                		curl_close($ch);
                		/* PARSING RESPONSE */
                		$response = json_decode($content,true);
                        
                        if($response['success'] == true){
                            $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                        }elseif($response['code'] == 1001){
                            $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                        }else{
                            $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                        }  
                    }elseif($a_id != '' && $ns_id != ''){
                        $ch = curl_init();
                		curl_setopt($ch, CURLOPT_URL, "https://api.cloudflare.com/client/v4/zones/".$dns_zone."/dns_records/".$a_id);
                		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
                		curl_setopt($ch, CURLOPT_VERBOSE, 1);
                		curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                        'X-Auth-Email: '.$dns_email.'',
                        'X-Auth-Key: '.$dns_global.'',
                        'Cache-Control: no-cache',
                        // 'Content-Type: multipart/form-data; charset=utf-8',
                        'Content-Type:application/json'
                        
                        ));
                		$content  = curl_exec($ch);
                		curl_close($ch);
                		/* PARSING RESPONSE */
                		$response = json_decode($content,true);
                        
                        if($response['success'] == true){
                            $ch = curl_init();
                    		curl_setopt($ch, CURLOPT_URL, "https://api.cloudflare.com/client/v4/zones/".$dns_zone."/dns_records/".$ns_id);
                    		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                    		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
                    		curl_setopt($ch, CURLOPT_VERBOSE, 1);
                    		curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                            'X-Auth-Email: '.$dns_email.'',
                            'X-Auth-Key: '.$dns_global.'',
                            'Cache-Control: no-cache',
                            // 'Content-Type: multipart/form-data; charset=utf-8',
                            'Content-Type:application/json'
                            
                            ));
                    		$content  = curl_exec($ch);
                    		curl_close($ch);
                    		/* PARSING RESPONSE */
                    		$response = json_decode($content,true);
                            
                            if($response['success'] == true){
                                $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                            }elseif($response['code'] == 1001){
                                $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                            }else{
                                $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                            }
                        }elseif($response['code'] == 1001){
                            $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                        }else{
                            $delete = $db->sql_query("DELETE FROM server_list WHERE server_ip='$servip'");
                        }
                    }
    			    
    				$success_message = $chkcount.' servers has been deleted.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
    			}
    		}		
    	}
    }else{
    	$error_message = 'Transaction Failed!';
        $values['response'] = 2;
        $values['msg'] = $error_message;
    }
    echo json_encode($values);
?>

