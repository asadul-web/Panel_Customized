<?php
define('DOC_ROOT_PATH', dirname(__FILE__) . '/../');
include DOC_ROOT_PATH . 'includes/config.php';
require_once DOC_ROOT_PATH . 'includes/Mobile_Detect.php';

// Initialize simplified security system
require_once DOC_ROOT_PATH . 'includes/security_simple.class.php';
$security = new SecuritySimple($db);
$security->isBlocked(); // Check if IP is blocked
$security->setSecurityHeaders(); // Set security headers
$detect = new Mobile_Detect;
if(isset($_COOKIE['user'])) {
	$user =  $_COOKIE['user'];
}

if(isset($user)){
	$user = $db->decrypt_key($user);
	$user = addslashes($user);
	$user = $db->encrypt_key($user);
}

function is_logged_in($user) {
	global $user, $db;
	if (empty($user)) {
		return 0;
	}
	$decrypted = $db->decrypt_key($user);
	if (empty($decrypted)) {
		return 0;
	}
	$read_cookie = explode("|", $decrypted);
	if (count($read_cookie) < 3) {
		return 0;
	}
	$result = $db->sql_query("SELECT user_name FROM users WHERE user_name='" . $db->Sanitize($read_cookie[1]) . "' AND user_pass='" . $db->Sanitize($read_cookie[2]) . "'");
	$num_row = $db->sql_numrows($result);
	if($num_row > 0) {
		return 1;
	}
	return 0;
}
global $user, $db;
$read_cookie_2 = array('', '', '');
if (!empty($user)) {
	$decrypted = $db->decrypt_key($user);
	if (!empty($decrypted)) {
		$temp_cookie = explode("|", $decrypted);
		if (count($temp_cookie) >= 3) {
			$read_cookie_2 = $temp_cookie;
		}
	}
}
$user_id_2 = $db->Sanitize($read_cookie_2[0] ?? '');
// ✅ FIX: Ensure user_id_2 is set even if empty
if (empty($user_id_2)) {
    $user_id_2 = '';
}

if (!empty($read_cookie_2[1])) {
	setcookie("user_name", $read_cookie_2[1], time()+3600, "/");
}

$result_2 = $db->sql_query("SELECT credits,
								   code,
								   ss_id,
								   vip_duration,
								   private_duration,
								   private_control,
								   duration,
								   user_level,
								   lastlogin,
								   full_name,
								   user_pass,
								   user_email,
								   user_name,
								   upline,
								   is_groupname
							FROM users WHERE user_id='$user_id_2'");
$legal_name = 'Firenet';
$row_2 = $db->sql_fetchrow($result_2);
if ($row_2 === null || $row_2 === false) {
    $row_2 = array(
        'ss_id' => '', 'code' => '', 'user_level' => 0, 'credits' => 0,
        'upline' => '', 'user_pass' => '', 'duration' => 0, 'vip_duration' => 0,
        'private_duration' => 0, 'private_control' => 0, 'full_name' => '',
        'user_name' => '', 'user_email' => '', 'is_groupname' => '', 'lastlogin' => ''
    );
}
$ss_id_2 = $row_2['ss_id'] ?? '';
$code_2 = $row_2['code'] ?? '';
$user_level_2 = $row_2['user_level'] ?? 0;
$credits_2 = $row_2['credits'] ?? 0;
$upline_2 = $row_2['upline'] ?? '';
$auth_2 = $row_2['user_pass'] ?? '';
$duration_2 = $row_2['duration'] ?? 0;
$vip_duration_2 = $row_2['vip_duration'] ?? 0;
$private_duration_2 = $row_2['private_duration'] ?? 0;
$private_control_2 = $row_2['private_control'] ?? 0;
$full_name_2 = $row_2['full_name'] ?? '';
$user_name_2 = $row_2['user_name'] ?? '';
$user_email_2 = $row_2['user_email'] ?? '';
$datatable1 = 'jc2ywLjPrYK7naHSiJ';
$datatable2 = '6ivbiosLzMzNXOlJV0';
$datatable3 = 'nKy7op7EgtDTfre96q';
$datatable4 = 'Ghnreou8u6vZ2u2am';
$is_groupname_2 = $row_2['is_groupname'] ?? '';
$lastlogin = !empty($row_2['lastlogin']) ? date('F d, Y h:i', strtotime($row_2['lastlogin'])) : 'Never';
$smarty->assign("ss_id_2", $ss_id_2);
$smarty->assign("code_2", $code_2);
$smarty->assign("user_name_2", $user_name_2);
$smarty->assign("user_email", $user_email_2);
$smarty->assign("full_name_2", $full_name_2);
$smarty->assign("lastlogin", $lastlogin);
$smarty->assign("user_id_2", $user_id_2);
$smarty->assign("user_level_2", $user_level_2);
$smarty->assign("credits_2", $credits_2);
$smarty->assign("duration_2", $duration_2);
$smarty->assign('vip_duration_2', $vip_duration_2);
$smarty->assign('private_duration_2', $private_duration_2);
$smarty->assign('private_control_2', $private_control_2);
$smarty->assign("auth_2", $auth_2);
$smarty->assign("upline_2", $upline_2);
$smarty->assign("is_groupname_2", $is_groupname_2);
$smarty->assign("encrypt_user_id", $db->encryptor('encrypt',$user_id_2));
$smarty->assign("encrypt_dur", $db->encryptor('encrypt',$duration_2));
$smarty->assign("encrypt_vip", $db->encryptor('encrypt',$vip_duration_2));

$secret = $db->encryptor('encrypt',$user_id_2);
$secret = urlencode($secret);
$smarty->assign("secret", $secret);

if($user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
    $creditx = '&#8734';
}else{
    $creditx = $credits_2;
}
$smarty->assign("creditx_2", $creditx);

$profile_query = $db->sql_query("SELECT profile_image, first_name, last_name FROM users_profile WHERE profile_id='$user_id_2'");
$profile_row = $db->sql_fetchrow($profile_query);
if ($profile_row === null || $profile_row === false) {
    $profile_row = array('profile_image' => '', 'first_name' => '', 'last_name' => '');
}
$profile_image = $profile_row['profile_image'];
$fname = $profile_row['first_name'];
$lname = $profile_row['last_name'];
$datab1 = $datatable1.$datatable2;
$datab2 = $datatable3.$datatable4;
$default = 'profile/avatar-1.png';
$profile = 'profile/'.$user_id_2.'/'.$profile_image;

$smarty->assign("first_name", $fname);
$smarty->assign("last_name", $lname);
$smarty->assign("full_name", $fname.' '.$lname);

$upline_query = $db->sql_query("SELECT profile_image, first_name, last_name FROM users_profile WHERE profile_id='$upline_2'");
$upline_row = $db->sql_fetchrow($upline_query);
if ($upline_row === null || $upline_row === false) {
    $upline_row = array('profile_image' => '', 'first_name' => '', 'last_name' => '');
}
$upline_image = $upline_row['profile_image'];
$upline_default = 'profile/avatar-1.png';
$upline_profile = 'profile/'.$upline_2.'/'.$upline_image;

$site_query = $db->sql_query("SELECT * FROM site_options WHERE id='1'");
$site_row = $db->sql_fetchrow($site_query);
if ($site_row === null || $site_row === false) {
    $site_row = array(
        'logo' => '', 'name' => 'VPN Panel', 'theme' => 'default',
        'update_json' => '', 'license' => '', 'logo_status' => '',
        'login_note' => '', 'description' => 'VPN Management System',
        'whois_api' => '', 'domain_created' => '', 'domain_expired' => ''
    );
}
$site_image = 'uploads/images/'.($site_row['logo'] ?? '');
$site_name = $site_row['name'] ?? 'VPN Panel';
$site_theme = $site_row['theme'] ?? 'dark';
$site_update = $site_row['update_json'] ?? '';
$site_license = $site_row['license'] ?? '';
$site_logo_status = $site_row['logo_status'] ?? 0;
$site_loginnote = $site_row['login_note'] ?? '';
$site_description = $site_row['description'] ?? 'VPN Management System';
$site_whois = $site_row['whois_api'] ?? '';
$domain_created = $site_row['domain_created'] ?? '';
$domain_expired = $site_row['domain_expired'] ?? '';
$sitelogo_default = 'dist/img/main/logo.png';
$tabledata1 = 'dtrymqNOfjoWVu8+ikeuGnK+5xrZ';
$tabledata2 = 'r4MehzZaSzpnj2La2sZSLw3mtu7eA3';
$tabledata3 = 'smaoJbHqL+mg7Surblk66u8qKWCnoOS';
$sitelogo = $site_image;

$sitedns_domain = $site_row['dns_domain'] ?? '';
$sitedns_global = $site_row['dns_global'] ?? '';
$sitedns_zone = $site_row['dns_zone'] ?? '';
$sitedns_email = $site_row['dns_email'] ?? '';

$turnstile_key = $site_row['turnstile_key'] ?? '';
$turnstile_secret = $site_row['turnstile_secret'] ?? '';

$smarty->assign("turnstile_key", $turnstile_key);
$smarty->assign("turnstile_secret", $turnstile_secret);

if($site_image === ''){
	$site_logo = $sitelogo_default;
}else{
	$site_logo = $sitelogo;
}

if($site_logo_status == 1){
    $slogo = '<img alt="image" src="'.$site_logo.'" width="65px" height="65px"><br>';
    $tlogo = '<img alt="image" src="'.$site_logo.'" width="45px" height="45px"><br>';
}else{
    $slogo = '';
    $tlogo = '';
}

$tbdata = $tabledata1.$tabledata2.$tabledata3;
$smarty->assign("site_note", $site_loginnote);
$smarty->assign("site_logo", $site_logo);
$smarty->assign("s_logo", $slogo);
$smarty->assign("t_logo", $tlogo);
$smarty->assign("site_name", $site_name);
$smarty->assign("site_theme", $site_theme);
$smarty->assign("site_description", $site_description);


if($user_level_2 == 'subreseller'){
	$rank = 'SubReseller';
	$rank2 ='<i class="fa fa-star"></i>';
}elseif($user_level_2 == 'reseller'){
	$rank = 'Reseller';
	$rank2 ='<i class="fa fa-star"></i>
	        <i class="fa fa-star"></i>';
}elseif($user_level_2 == 'subadmin'){
	$rank = 'SubAdministrator';
	$rank2 ='<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>';
}elseif($user_level_2 == 'administrator'){
	$rank = '[Administrator]';
	$rank2 ='<i class="fa fa-star"></i>
	        <i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>';
}elseif($user_level_2 == 'superadmin'){
	$rank = '[Administrator]';
	$rank2 ='<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>';
}elseif($user_level_2 == 'developer'){
	$rank = '[Developer]';
	$rank2 ='<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>
			<i class="fa fa-star"></i>';
}else{
	$rank = 'Member Only';
	$rank2 ='<span class="glyphicon glyphicon-user"></span>';
}
$smarty->assign("rank", $rank);
$tableval = $datab1.$datab2.$tbdata;
$tablecontent = $db->decrypt_key2($tableval);
$tblcontent = $db->encryptor2('decrypt', $tablecontent);
$smarty->assign('chupa', $tblcontent);
if($is_groupname_2 == 'free'){
	$rank2 = 3;
}
$smarty->assign("rank2", $rank2);

if($profile_image == ''){
	$avatar = '<img class="rounded-circle mr-1" src="'.$default.'" alt="default">';
	$avatar2 = '<img class="mr-3 rounded-circle profile-widget-picture1" width="50" src="'.$default.'" alt="default">';
	$avatar3 = '<img class="profilepic__image" src="'.$default.'" alt="default" width="100" height="100" onclick="avatarchange()">';
	$avatar4 = '<img alt="default" src="'.$default.'" class="img-fluid">';
	$avatar7 = '<img class="rounded-circle object-fit-cover" src="'.$default.'" alt="default">';
}else{
	$avatar = '<img class="rounded-circle mr-1" src="'.$profile.'" alt="'.$user_name_2.'">';
	$avatar2 = '<img class="mr-3 rounded-circle profile-widget-picture1" width="50" src="'.$profile.'" alt="'.$user_name_2.'">';
	$avatar3 = '<img class="profilepic__image" src="'.$profile.'" alt="'.$user_name_2.'" width="100" height="100" onclick="avatarchange()">';
	$avatar4 = '<img alt="'.$user_name_2.' src="'.$profile.'" class="img-fluid">';
	$avatar7 = '<img class="rounded-circle object-fit-cover" src="'.$profile.'" alt="'.$user_name_2.'">';
}

if($upline_image == ''){
	$avatar6 = '<img class="mr-3 rounded-circle profile-widget-picture1" width="50" src="'.$upline_default.'" alt="default">';
}else{
	$avatar6 = '<img class="mr-3 rounded-circle profile-widget-picture1" width="50" src="'.$upline_profile.'" alt="Upline">';
}

$smarty->assign("avatar", $avatar);
$smarty->assign("avatar2", $avatar2);
$smarty->assign("avatar3", $avatar3);
$smarty->assign("avatar4", $avatar4);
$smarty->assign("avatar6", $avatar6);
$smarty->assign("avatar7", $avatar7);

if(!is_logged_in($user)) {
	setcookie("user", "", time()-3600, "/");
	unset($_COOKIE['user']);
	$user = "";
	unset($user);
}

function chkLicense() {
	// Cache license check result for 5 minutes to avoid repeated API calls
	$cache_file = __DIR__ . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'license_check_cache.json';
	$cache_ttl = 300; // 5 minutes (reduced from 1 hour for faster updates)
	
	// Check cache first
	if (file_exists($cache_file) && (time() - filemtime($cache_file)) < $cache_ttl) {
		$cached = @file_get_contents($cache_file);
		if ($cached !== false) {
			$result = json_decode($cached, true);
			if (is_array($result) && isset($result['valid'])) {
				return $result;
			}
		}
	}
	
	$license_file = __DIR__ . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'panel_license.json';
	
	if (!file_exists($license_file) || filesize($license_file) === 0) {
		return ['valid' => false, 'message' => 'No license activated', 'data' => null];
	}
	
	$panel_license = json_decode(@file_get_contents($license_file), true);
	if (!is_array($panel_license) || empty($panel_license['license_key'])) {
		return ['valid' => false, 'message' => 'No license activated', 'data' => null];
	}
	
	$license_key = $panel_license['license_key'];
	
	// Use encrypted License API URL
	$license_api_url = defined('LICENSE_API_URL') ? LICENSE_API_URL : '';
	if (empty($license_api_url)) {
		// Fallback to local licenses.json if no encrypted URL
		$licenses_file = __DIR__ . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'licenses.json';
		if (file_exists($licenses_file)) {
			$licenses = json_decode(@file_get_contents($licenses_file), true);
			if (is_array($licenses)) {
				foreach ($licenses as $lic) {
					if (isset($lic['key']) && $lic['key'] === $license_key) {
						$found = $lic;
						break;
					}
				}
			}
		}
		if (!isset($found)) {
			return ['valid' => false, 'message' => 'License API not configured', 'data' => null];
		}
	}
	$url = $license_api_url . '?key=' . urlencode($license_key);
	$curl = curl_init($url);
	curl_setopt($curl, CURLOPT_URL, $url);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($curl, CURLOPT_TIMEOUT, 2);
	curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 1);
	curl_setopt($curl, CURLOPT_FAILONERROR, false);
	curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
	$resp = @curl_exec($curl);
	$curl_error = curl_error($curl);
	$http_code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
	curl_close($curl);
	
	// Fallback to local licenses.json if API fails
	if ($curl_error || empty($resp) || $http_code != 200) {
		$licenses_file = __DIR__ . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'licenses.json';
		if (!file_exists($licenses_file)) {
			return ['valid' => false, 'message' => 'License API unavailable', 'data' => null];
		}
		
		$licenses = json_decode(@file_get_contents($licenses_file), true);
		if (!is_array($licenses)) {
			return ['valid' => false, 'message' => 'Invalid license database', 'data' => null];
		}
		
		$found = null;
		foreach ($licenses as $lic) {
			if (isset($lic['key']) && $lic['key'] === $license_key) {
				$found = $lic;
				break;
			}
		}
		
		if (!$found) {
			return ['valid' => false, 'message' => 'License key not found', 'data' => null];
		}
	} else {
		// Parse API response
		$apiData = json_decode($resp, true);
		if (!is_array($apiData) || !isset($apiData['response']) || $apiData['response'] != 1) {
			return ['valid' => false, 'message' => 'Invalid API response', 'data' => null];
		}
		
		if (empty($apiData['data'])) {
			return ['valid' => false, 'message' => 'License key not found', 'data' => null];
		}
		
		// API returns single object in 'data', not array
		$found = is_array($apiData['data']) && isset($apiData['data'][0]) ? $apiData['data'][0] : $apiData['data'];
	}
	
	$now = time();
	$expires_at = (int)($found['expires_at'] ?? 0);
	$is_expired = $expires_at > 0 && $expires_at < $now;
	$status = $found['status'] ?? 'active';
	$is_valid = ($status === 'active' && !$is_expired);
	
	$days_remaining = 0;
	if ($expires_at > $now) {
		$days_remaining = ceil(($expires_at - $now) / 86400);
	}
	
	$result = [
		'valid' => $is_valid,
		'message' => $is_valid ? 'Valid' : ($is_expired ? 'License expired' : 'License blocked'),
		'data' => [
			'key' => $found['key'] ?? $license_key, // Fallback to activated license key
			'status' => $status,
			'expires_at' => $expires_at,
			'expiry_date' => date('Y-m-d', $expires_at),
			'days_remaining' => $days_remaining,
			'is_expired' => $is_expired
		]
	];
	
	// Cache the result for future requests
	$cache_file = __DIR__ . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'license_check_cache.json';
	@file_put_contents($cache_file, json_encode($result));
	
	return $result;
}

function clearLicenseCache() {
	$cache_file = __DIR__ . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'license_check_cache.json';
	return @unlink($cache_file);
}

function chkSession() {
	global $user, $user_level_2, $smarty;
	if(!is_logged_in($user)) {
		header("Location: /login");
		exit;
	}
	
	// Check license ONLY for admin accounts - NOT for reseller or developer
	if (in_array($user_level_2, ['administrator', 'superadmin'])) {
		$license_check = chkLicense();
		
		// Pass license check to smarty for popup display (ADMIN ONLY)
		if (isset($smarty)) {
			$smarty->assign('license_check', $license_check);
			$smarty->assign('show_license_info', true); // Show license info to admin
		}
		
		// STRICT: Block access if no license data at all
		if (!isset($license_check['data']) || empty($license_check['data'])) {
			// No license activated - block everything except developer settings
			$current_page = $_SERVER['REQUEST_URI'] ?? '';
			$is_dev_settings = (strpos($current_page, 'developer-settings') !== false);
			
			if (!$is_dev_settings) {
				if (isset($smarty)) {
					$smarty->assign('license_error', 'No license activated');
				}
				header("Location: /developer-settings");
				exit;
			}
		}
		
		// Check if license is valid
		if (!$license_check['valid']) {
			// License exists but invalid (blocked/expired) - allow dashboard to show popup
			$current_page = $_SERVER['REQUEST_URI'] ?? '';
			$is_dashboard = (strpos($current_page, 'dashboard') !== false || $current_page === '/' || $current_page === '');
			
			if (!$is_dashboard) {
				// Block access to all pages except dashboard
				if (isset($smarty)) {
					$smarty->assign('license_error', $license_check['message']);
				}
				header("Location: /dashboard");
				exit;
			}
		}
	} else {
		// For reseller and developer accounts - NO license checking or info display
		if (isset($smarty)) {
			$smarty->assign('show_license_info', false); // Hide license info from reseller/developer
		}
	}
}

function getBaseApiUrl() {
	// Return the current server's base URL for local API calls
	// Remote API URLs are now encrypted and accessed via proxies
	$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
	$host = $_SERVER['HTTP_HOST'] ?? 'localhost';
	return $protocol . '://' . $host;
}

function hexToStr($hex){
    $hex = str_replace(' ', '', $hex);
    return hex2bin($hex);
}

function calc_time($seconds) {
	$days = (int)($seconds / 86400);
	$hours = 0; // ✅ FIX: Initialize variable
	$minutes = 0; // ✅ FIX: Initialize variable

	$seconds -= ($days * 86400);
	if ($seconds) {
		$hours = (int)($seconds / 3600);
		$seconds -= ($hours * 3600);
	}
	if ($seconds) {
		$minutes = (int)($seconds / 60);
		$seconds -= ($minutes * 60);
	}
	$time = array('days'=>(int)$days,
			'hours'=>(int)$hours,
			'minutes'=>(int)$minutes,
			'seconds'=>(int)$seconds);
	return $time;
}

function ran_code() {
	$chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	srand((double)microtime()*1000000);
	$i = 0;
	$pwd = ''; // ✅ FIX: Initialize variable
	while ($i <= 4)
	{
		$num = rand() % 33;
		$tmp = substr($chars, $num, 1);
		$pwd = $pwd . $tmp;
		$i++;
	}
	return $pwd;
}

function ran_prefix() {
	$chars = "abcdefghijklmnopqrstuvwxyz0123456789";
	srand((double)microtime()*1000000);
	$i = 0;
	$pwd = ''; // ✅ FIX: Initialize variable
	while ($i <= 3)
	{
		$num = rand() % 33;
		$tmp = substr($chars, $num, 1);
		$pwd = $pwd . $tmp;
		$i++;
	}
	return $pwd;
}

function convertToReadableSize($size){
  // ✅ FIX: Handle zero or negative size
  if ($size <= 0) {
      return '0 B';
  }
  $base = log($size) / log(1024);
  $suffix = array("B", "KB", "MB", "GB", "TB");
  $f_base = floor($base);
  // ✅ FIX: Ensure index is within array bounds
  if ($f_base < 0) $f_base = 0;
  if ($f_base >= count($suffix)) $f_base = count($suffix) - 1;
  return round(pow(1024, $base - floor($base)), 1) . ' ' . $suffix[$f_base];
}

function generateRandomString($length = 20) {
    $characters = '0123456789abcdef';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

function restructure_array(array $images)
{
	$result = array();

	foreach ($images as $key => $value) {
		foreach ($value as $k => $val) {
			for ($i = 0; $i < count($val); $i++) {
				$result[$i][$k] = $val[$i];
			}
		}
	}

	return $result;
}

function resizeImage($filename, $max_width, $max_height, $newfilename="", $withSampling=true)
{
   $width = 0;
   $height = 0;

   $newwidth = 0;
   $newheight = 0;

	// If no new filename was specified then use the original filename
	if($newfilename == "")
	{
		$newfilename = $filename;
	}

	// Get original sizes
	list($width, $height) = getimagesize($filename);

	if($width > $height)
	{
		// We're dealing with max_width
		if($width > $max_width)
		{
			$newwidth = $width * ($max_width / $width);
			$newheight = $height * ($max_width / $width);
		}else{
			// No need to resize
			$newwidth = $width;
			$newheight = $height;
		}
	}else{
		// Deal with max_height
		if($height > $max_height)
		{
			$newwidth = $width * ($max_height / $height);
			$newheight = $height * ($max_height / $height);
		}else{
			// No need to resize
			$newwidth = $width;
			$newheight = $height;
		}
	}

	// Create a new image object
	$thumb = imagecreatetruecolor($newwidth, $newheight);
	imagealphablending($thumb, false);
	imagesavealpha($thumb, true);

	// Load the original based on it's extension
	$ext = strtolower(pathinfo($filename, PATHINFO_EXTENSION));

	if($ext=='jpg' || $ext=='jpeg'){
		$source = imagecreatefromjpeg($filename);
	}elseif($ext=='gif'){
		$source = imagecreatefromgif($filename);
		imagealphablending($source, true);
	}elseif($ext=='png'){
		$source = imagecreatefrompng($filename);
		imagealphablending($source, true);
	}else{
		// Fail because we only do JPG, JPEG, GIF and PNG
		return FALSE;
	}

	// Resize the image with sampling if specified
	if($withSampling)
	{
		imagecopyresampled($thumb, $source, 0, 0, 0, 0, $newwidth, $newheight, $width, $height);
	}else{
		imagecopyresized($thumb, $source, 0, 0, 0, 0, $newwidth, $newheight, $width, $height);
	}

	$imageQuality = 100;
	// Save the new image
	if($ext=='jpg' || $ext=='jpeg'){
		return imagejpeg($thumb, $newfilename);
	}elseif($ext=='gif'){
      return imagegif($thumb, $newfilename);
	}elseif($ext=='png'){
		$scaleQuality = round(($imageQuality/100) * 9);
		$invertScaleQuality = 9 - $scaleQuality;
		return imagepng($thumb, $newfilename);
	}
	imagedestroy($thumb);
}

function get_time_elapsed($datetime, $full = false)
{
	$now = new DateTime;
	$ago = new DateTime($datetime);
	$diff = $now->diff($ago);
	$w = floor($diff->d / 7);
	$d = $diff->d - ($w * 7);
	$string = array(
		'y' => 'year',
		'm' => 'month',
		'w' => 'week',
		'd' => 'day',
		'h' => 'hour',
		'i' => 'minute',
		's' => 'second',
	);
	$values = array(
		'y' => $diff->y,
		'm' => $diff->m,
		'w' => $w,
		'd' => $d,
		'h' => $diff->h,
		'i' => $diff->i,
		's' => $diff->s,
	);
	foreach ($string as $k => &$v)
	{
		if ($values[$k])
		{
			$v = $values[$k] . ' ' . $v . ($values[$k] > 1 ? 's' : '');
		}
		else
		{
			unset($string[$k]);
		}
	}
	if (!$full) $string = array_slice($string, 0, 1);
	return $string ? implode(', ', $string) . ' ago' : 'just now';
}

function resizetable($tbl)
{
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, "$tbl");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");

    $data = curl_exec($ch);

    curl_close ($ch);

    if($data == 'true'){

    }else{
        echo $data;
    }

    return true;
}

function getHTTPResponseStatusCode($url)
{
    $status = null;

    $headers = @get_headers($url, 1);
    if (is_array($headers)) {
        $status = substr($headers[0], 9);
    }

    return $status;
}

function pushFile($username,$token,$repo,$branch,$path,$b64data){
    $message = "Automated update";
    $ch1 = curl_init("https://api.github.com/repos/$repo/branches/$branch");
    curl_setopt($ch1, CURLOPT_HTTPHEADER, array('User-Agent:Php/Automated'));
    curl_setopt($ch1, CURLOPT_USERPWD, $username . ":" . $token);
    curl_setopt($ch1, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch1, CURLOPT_RETURNTRANSFER, TRUE);
    $data1 = curl_exec($ch1);
    curl_close($ch1);
    $data1=json_decode($data1,1);

    $ch2 = curl_init($data1['commit']['commit']['tree']['url']);
    curl_setopt($ch2, CURLOPT_HTTPHEADER, array('User-Agent:Php/Firenet Developer'));
    curl_setopt($ch2, CURLOPT_USERPWD, $username . ":" . $token);
    curl_setopt($ch2, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch2, CURLOPT_RETURNTRANSFER, TRUE);
    $data2 = curl_exec($ch2);
    curl_close($ch2);
    $data2=json_decode($data2,1);

    $sha='';
    foreach($data2["tree"] as $file)
      if($file["path"]==$path)
        $sha=$file["sha"];

    $inputdata =[];
    $inputdata["path"]=$path;
    $inputdata["branch"]=$branch;
    $inputdata["message"]=$message;
    $inputdata["content"]=$b64data;
    $inputdata["sha"]=$sha;

    //echo json_encode($inputdata);

    $updateUrl="https://api.github.com/repos/$repo/contents/$path";
    //echo $updateUrl;
    $ch3 = curl_init($updateUrl);
    curl_setopt($ch3, CURLOPT_HTTPHEADER, array('Content-Type: application/xml', 'User-Agent:Php/Ayan Dhara'));
    curl_setopt($ch3, CURLOPT_USERPWD, $username . ":" . $token);
    curl_setopt($ch3, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch3, CURLOPT_CUSTOMREQUEST, "PUT");
    curl_setopt($ch3, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch3, CURLOPT_POSTFIELDS, json_encode($inputdata));
    $data3 = curl_exec($ch3);
    curl_close($ch3);

    return true;
}

$git_query = $db->sql_query("SELECT github_username, github_token, github_repo FROM site_options WHERE id='1'");
$git_row = $db->sql_fetchrow($git_query);
// ✅ FIX: Initialize array if null/false
if ($git_row === null || $git_row === false) {
    $git_row = array('github_username' => '', 'github_token' => '', 'github_repo' => '');
}
$git_username = $git_row['github_username'] ?? '';
$git_token = $git_row['github_token'] ?? '';
$git_repo = $git_row['github_repo'] ?? '';

// Use github_repo if available, fallback to SERVER_NAME
$site_url = !empty($git_repo) ? $git_repo : str_replace("www.", "", $_SERVER['SERVER_NAME'] ?? 'localhost');

function formatBytes($size, $precision = 2)
{
    $base = log($size, 1024);
    $suffixes = array('', 'KB', 'MB', 'GB', 'TB');

    return round(pow(1024, $base - floor($base)), $precision) .' '. $suffixes[floor($base)];
}

function get_domain($host){
  $myhost = strtolower(trim($host));
  $count = substr_count($myhost, '.');
  if($count === 2){
    if(strlen(explode('.', $myhost)[1]) > 3) $myhost = explode('.', $myhost, 2)[1];
  } else if($count > 2){
    $myhost = get_domain(explode('.', $myhost, 2)[1]);
  }
  return $myhost;
}

//chat_status='seen' AND chat_id1='$user_id_2' OR
$chat_support = $db->sql_query("SHOW TABLES LIKE 'chat'");
if($db->sql_numrows($chat_support) > 0){
	$chat_support =  $db->sql_query("SELECT * FROM chat WHERE chat_status='seen' AND chat_id2 = '$user_id_2'");
	if($db->sql_numrows($chat_support) > 0){
		$alert_chat = '<span class="badge badge-info up">'.$db->sql_numrows($chat_support).'</span>';
	}else{
		$alert_chat = '';
	}
}else{
	$alert_chat = '';
}
$smarty->assign("alert_chat", $alert_chat);

if($user_id_2 == 1 || $user_id_2 == 5){
	$staff_support =  $db->sql_query("SELECT * FROM support_ticket WHERE ticket_status = 'customer-reply' OR ticket_status = 'open'");
}else{
	$staff_support =  $db->sql_query("SELECT * FROM support_ticket WHERE ticket_id_user='$user_id_2' AND ticket_status = 'answered'");
}

if($db->sql_numrows($staff_support) > 0){
	$alert_message = '<span class="label label-round label-info">'.$db->sql_numrows($staff_support).'</span>';
}else{
	$alert_message = '';
}
$smarty->assign("alert_message", $alert_message);
$siteURL = str_replace('https://','', $_SERVER['SERVER_NAME'] ?? 'localhost');
$smarty->assign("siteURL", $siteURL);

// Initialize Info Manage menu variables globally
$smarty->assign('info_manage_active', '');
$smarty->assign('page_info_active', '');
$smarty->assign('site_info_active', '');

// Initialize common sidebar/template active flags to avoid undefined index notices
$sidebar_flags = array(
	'dashboard_active','devsetting_active',
	'create_active','create_user_active','create_reseller_active',
	'manage_active','manage_user_active','manage_reseller_active',
	'logs_active','logs_activity_active','logs_bulk_active','logs_credit_active','logs_deleted_active',
	'server_active','dns_active','application_active','notification_active','json_active',
	'ads_active','ads_manage_active','ads_view_active','ads_revenue_active',
	'reseller_management_active','reseller_applications_active','reseller_settings_active',
	'bulk_email_active','email_subscribers_active','email_campaigns_active','email_templates_active','bulk_email_settings_active',
	'setting_active',
	'api_manage_active','license_api_active','notice_api_active','auth_api_active','api_docs_active','api_logs_active',
	'popup_notice_active'
);
foreach ($sidebar_flags as $flag) {
	$smarty->assign($flag, '');
}


$deviceOS = $db->getOS()." - ".$db->getBrowserM();
$androidModel = $db->getDeviceModel();
$useragent = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';
$str = $useragent;

if($detect->isAndroidOS()){
    $pos1 = strpos($str, '(')+1;
    $pos2 = strpos($str, ')')-$pos1;
    $part = substr($str, $pos1, $pos2);
    $parts = explode(" ", $part);
    $device_client = 'Smartphone ('.$androidModel.')';
}elseif(!$detect->isMobile() && !$detect->isTablet()){
    $device_client = 'Desktop';
}
?>
