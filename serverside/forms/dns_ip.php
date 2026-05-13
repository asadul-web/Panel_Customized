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
    $hostname = $db->Sanitize(trim($_POST['hostname']));
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'dns_ip'){
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
                
                $get_ip = gethostbyname(''.$hostname.'');
                $apiURL = 'http://ip-api.com/json/'.$get_ip.'?fields=status,message,continent,continentCode,country,countryCode,region,regionName,city,district,zip,lat,lon,timezone,isp,org,as,asname,reverse,mobile,proxy,hosting,query'; 
                $ch = curl_init($apiURL); 
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
                $apiResponse = curl_exec($ch); 
                curl_close($ch); 
                
                $ipData = json_decode($apiResponse, true); 
                 
                if(!empty($ipData)){ 
                    $status = $ipData['status']; 
                    if($status == 'success'){
                        $continent = $ipData['continent']; 
                        $continentCode = $ipData['continentCode']; 
                        $country = $ipData['country']; 
                        $countryCode = $ipData['countryCode']; 
                        $region = $ipData['region']; 
                        $regionName = $ipData['regionName']; 
                        $city = $ipData['city']; 
                        $district = $ipData['district']; 
                        $zip = $ipData['zip']; 
                        $lat = $ipData['lat']; 
                        $lon = $ipData['lon']; 
                        $timezone = $ipData['timezone']; 
                        $isp = $ipData['isp']; 
                        $org = $ipData['org']; 
                        $as = $ipData['as']; 
                        $asname = $ipData['asname']; 
                        $reverse_ = $ipData['reverse']; 
                            if($reverse_ == ''){
                                $reverse = 'none';
                            }else{
                                $reverse = $reverse_;
                            }
                        $mobile = $ipData['mobile']; 
                        $proxy = $ipData['proxy']; 
                        $hosting_ = $ipData['hosting']; 
                            if($hosting_ == false){
                                $hosting = 'false';
                            }else{
                                $hosting = 'true';
                            }
                        $query = $ipData['query']; 
                    }else{
                        $continent = 'undefined'; 
                        $continentCode = 'undefined'; 
                        $country = 'undefined'; 
                        $countryCode = 'undefined'; 
                        $region = 'undefined'; 
                        $regionName = 'undefined'; 
                        $city = 'undefined'; 
                        $district = 'undefined'; 
                        $zip = 'undefined'; 
                        $lat = 'undefined'; 
                        $lon = 'undefined'; 
                        $timezone = 'undefined'; 
                        $isp = 'undefined'; 
                        $org = 'undefined'; 
                        $as = 'undefined'; 
                        $asname = 'undefined'; 
                        $reverse = 'undefined'; 
                        $mobile = 'undefined'; 
                        $proxy = 'undefined'; 
                        $hosting = 'undefined'; 
                        $query = 'undefined'; 
                    }
                }else{ 
                    $status = 'undefined'; 
                    $continent = 'undefined'; 
                    $continentCode = 'undefined'; 
                    $country = 'undefined'; 
                    $countryCode = 'undefined'; 
                    $region = 'undefined'; 
                    $regionName = 'undefined'; 
                    $city = 'undefined'; 
                    $district = 'undefined'; 
                    $zip = 'undefined'; 
                    $lat = 'undefined'; 
                    $lon = 'undefined'; 
                    $timezone = 'undefined'; 
                    $isp = 'undefined'; 
                    $org = 'undefined'; 
                    $as = 'undefined'; 
                    $asname = 'undefined'; 
                    $reverse = 'undefined'; 
                    $mobile = 'undefined'; 
                    $proxy = 'undefined'; 
                    $hosting = 'undefined'; 
                    $query = 'undefined'; 
                } 
                
                if($get_ip){
                    $success_message = 'Hostname: <code>'.$hostname.'</code><br>
                    Ip Address: <code>'.$get_ip.'</code><br>
                    Ip Continent: <code>'.$continent.'</code><br>
                    Ip Country: <code>'.$country.'</code><br>
                    Ip City: <code>'.$city.'</code><br>
                    Ip Region : <code>'.$regionName.'</code><br>
                    Ip Hosting/Vps : <code>'.$hosting.'</code><br>
                    Ip Reverse Dns : <code>'.$reverse.'</code><br>
                    Ip ISP : <code>'.$isp.'</code><br>
                    Ip Organization : <code>'.$org.'</code><br>
                    Ip As : <code>'.$as.'</code>';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $success_message = 'Hostname: <code>'.$hostname.'</code><br>
                    Ip Address: <code>'.$hostname.'</code><br>
                    Ip Continent: <code>'.$continent.'</code><br>
                    Ip Country: <code>'.$country.'</code><br>
                    Ip City: <code>'.$city.'</code><br>
                    Ip Region : <code>'.$regionName.'</code><br>
                    Ip Hosting/Vps : <code>'.$hosting.'</code><br>
                    Ip Reverse Dns : <code>'.$reverse.'</code><br>
                    Ip ISP : <code>'.$isp.'</code><br>
                    Ip Organization : <code>'.$org.'</code><br>
                    Ip As : <code>'.$as.'</code>';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
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
