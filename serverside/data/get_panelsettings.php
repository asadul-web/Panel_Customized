<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 2 || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
	$values = array();
	$valid = true;
	
    $qry = $db->sql_query("SELECT * FROM site_options WHERE id='1'") OR die();
	$row = $db->sql_fetchrow($qry);
	
	$cloudflareprefix = $db->decrypt_key2($row['dns_prefix']);
	$cloudflare_prefix = $db->encryptor2('decrypt', $cloudflareprefix);
	
	$cf_domain = $row['dns_domain'];
	$cloudflaredomain = $db->decrypt_key2($cf_domain);
	$cloudflare_domain = $db->encryptor2('decrypt', $cloudflaredomain);
	
	$cf_zone = $row['dns_zone'];
	$cloudflarezone = $db->decrypt_key2($cf_zone);
	$cloudflare_zone = $db->encryptor2('decrypt', $cloudflarezone);
	
	$cf_global = $row['dns_global'];
	$cloudflareglobal = $db->decrypt_key2($cf_global);
	$cloudflare_global = $db->encryptor2('decrypt', $cloudflareglobal);
	
	$cf_email = $row['dns_email'];
	$cloudflareemail = $db->decrypt_key2($cf_email);
	$cloudflare_email = $db->encryptor2('decrypt', $cloudflareemail);
	
	$dbbak_email = $row['bak_to'];
	$dbbakcc_email = $row['bak_cc'];
	
	$github_username = $row['github_username'];
	$github_token = $row['github_token'];
	$github_repo = $row['github_repo'];
	$updatenotice = $row['update_json'];
	$license_ = $row['license'];
	$turnstile_ = $row['turnstile_key'];
	$turnstile_secret = $row['turnstile_secret'];
	$whois = $row['whois_api'];
	
    $userqry = $db->sql_query("SELECT user_name FROM users WHERE user_level='normal' || user_level='bulk' || user_level='trial'") OR die();
	$totalusers = $db->sql_numrows($userqry);
	
	$resellerqry = $db->sql_query("SELECT user_name FROM users WHERE user_level='reseller'") OR die();
	$totalresellers = $db->sql_numrows($resellerqry);
	
	$activeqry = $db->sql_query("SELECT user_name FROM users WHERE device_connected='1'") OR die();
	$totalactive = $db->sql_numrows($activeqry);
    
    // Get admin data for Administrator settings page
    $uqry = $db->sql_query("SELECT user_name, user_pass FROM users WHERE user_id='1'") OR die();
	$urow = $db->sql_fetchrow($uqry);
	$admin_username = $urow['user_name'];
	$upass = $urow['user_pass'];
	
	// Use single decryption to match database encryption
	$admin_password = '';
	if(!empty($upass)){
	    try {
	        $admin_password = $db->encryptor('decrypt', $upass);
	        // If decryption fails, set empty
	        if($admin_password === false){
	            $admin_password = '';
	        }
	    } catch (Exception $e) {
	        $admin_password = '';
	    }
	}
    
	if($row){
		$values['totaluser'] = $totalusers;
		$values['totalreseller'] = $totalresellers;
		$values['totalactive'] = $totalactive;
		$values['dns_prefix'] = $cloudflare_prefix;
		$values['dns_domain'] = $cloudflare_domain;
		$values['dns_zone'] = $cloudflare_zone;
		$values['dns_global'] = $cloudflare_global;
		$values['dns_email'] = $cloudflare_email;
		
		$values['recipient_email'] = $dbbak_email;
		$values['cc_email'] = $dbbakcc_email;
		
		$values['admin_user'] = $admin_username;
		$values['admin_pass'] = $admin_password;
		$values['github_username'] = $github_username;
		$values['github_token'] = $github_token;
		$values['github_repo'] = $github_repo;
		$values['update_link'] = $updatenotice;
		$values['license'] = $license_;
		$values['turnstile'] = $turnstile_;
		$values['turnstilesecret'] = $turnstile_secret;
		$values['whois'] = $whois;
		
		$values['response'] = 1;
	}else{
		$values['response'] = 2;
	}
	if($valid == false){
		$values['response'] = 0;
	}
	echo json_encode($values);
?>
