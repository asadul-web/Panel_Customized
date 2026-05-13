<?php
//skip the functions file if somebody call it directly from the browser.
if (preg_match("/config.php/i", $_SERVER['SCRIPT_NAME'])) {
    Header("Location: /"); die();
}

// ✅ FIX: Define DOC_ROOT_PATH if not already defined
if (!defined('DOC_ROOT_PATH')) {
    define('DOC_ROOT_PATH', dirname(__FILE__) . '/../');
}

// Production error handling - log errors but don't display them
error_reporting(E_ALL & ~E_DEPRECATED & ~E_STRICT);
ini_set('display_errors', '0');
ini_set('log_errors', '1');
$__logs_dir = DOC_ROOT_PATH . 'logs';
if (!is_dir($__logs_dir)) { @mkdir($__logs_dir, 0777, true); }
ini_set('error_log', $__logs_dir . '/php_errors.log');

// Load security configuration first
require 'security_config.php';

// Load performance optimizations
require 'php_optimization.php';
require 'query_cache.php'; // Query caching helper
require 'smarty/Smarty.class.php';
require 'cache.class.php';
require 'cache_cleanup.php';

$smarty = new Smarty;

// Add security protection script to all pages with cache busting
$smarty->assign('security_protection_js', '/includes/security_protection.js?v=' . time());

// Smarty performance optimization
$smarty->caching = 0; // Disable caching for dynamic content
$smarty->cache_lifetime = 3600;
$smarty->compile_check = false; // Disable compile check in production for speed
$smarty->force_compile = false; // Don't force recompile every time

include 'db_config.php';
require "mysql.class.php";
$db = new mysql_db();
$db->InitDB($DB_host,$DB_user,$DB_pass,$DB_name);

// Get site options
$bak_query = $db->sql_query("SELECT name, owner, description, bak_to, bak_cc FROM site_options WHERE id='1'");
$site_options = $db->sql_fetchrow($bak_query);
// ✅ FIX: Initialize array if null/false
if ($site_options === null || $site_options === false) {
    $site_options = array('name' => 'VPN Panel', 'owner' => '', 'description' => 'VPN Management System', 'bak_to' => '', 'bak_cc' => '');
}

$bak_to = $site_options['bak_to'] ?? '';
$bak_cc = $site_options['bak_cc'] ?? '';
$bak_sitename = $site_options['name'] ?? 'VPN Panel';
$bak_siteowner = $site_options['owner'] ?? '';
$bak_sitedesc = $site_options['description'] ?? 'VPN Management System';

$db->SetWebsiteName($bak_sitename);
$db->SetWebsiteTitle($bak_sitedesc);
$db->SetBakTo($bak_to);
$db->SetBakCC($bak_cc);

$ua = $db->getBrowser();
$browser = "" . $ua['name'] . " " . $ua['version'] . "" ; 
$ipadd = "" . $db->get_client_ip() . ""; 
$base_url = $db->base_url();
$smarty->assign('getIP', $ipadd);
$smarty->assign('getBrowser', $browser);
$smarty->assign('base_url', $db->base_url());
$smarty->assign('GetSelfScript', $db->GetSelfScript());
$smarty->assign('siteTitle', $db->siteTitle);
$smarty->assign('sitename', $db->sitename);

$date = new DateTime();
$current_timestamp = $date->getTimestamp();
$smarty->assign('current_timestamp', $current_timestamp);

// ✅ PERFORMANCE FIX: Cache static encryption values to avoid repeated encryption operations
$static_encrypt_cache = DOC_ROOT_PATH . 'cache/static_encrypt_cache.json';
$static_encrypt_valid = false;

if (file_exists($static_encrypt_cache) && (time() - filemtime($static_encrypt_cache)) < 86400) {
    $cached_encrypts = @json_decode(file_get_contents($static_encrypt_cache), true);
    if (is_array($cached_encrypts) && isset($cached_encrypts['premium'])) {
        $static_encrypt_valid = true;
    }
}

if (!$static_encrypt_valid) {
    $cached_encrypts = [
        'premium' => $db->encryptor('encrypt', 'premium'),
        'vip' => $db->encryptor('encrypt', 'vip'),
        'private' => $db->encryptor('encrypt', 'private'),
        'add' => $db->encryptor('encrypt', 'add'),
        'substract' => $db->encryptor('encrypt', 'substract'),
        'login' => $db->encryptor('encrypt', 'Login Account'),
        'unfreeze' => $db->encryptor('encrypt', 'Unfreeze Account'),
        'firenet' => $db->encryptor('encrypt', 'firenetdev')
    ];
    @file_put_contents($static_encrypt_cache, json_encode($cached_encrypts));
}

$smarty->assign("premium_encrypt", $cached_encrypts['premium']);
$smarty->assign("vip_encrypt", $cached_encrypts['vip']);
$smarty->assign("private_encrypt", $cached_encrypts['private']);
$smarty->assign("add_encrypt", $cached_encrypts['add']);
$smarty->assign("substract_encrypt", $cached_encrypts['substract']);
$smarty->assign("login_encrypt", $cached_encrypts['login']);
$smarty->assign("unfreeze_encrypt", $cached_encrypts['unfreeze']);
$smarty->assign("firenet_encrypt", $cached_encrypts['firenet']);

// ✅ PERFORMANCE FIX: Cache encrypt_days/encrypt_hours to avoid 391 encryption operations per request
$encrypt_cache_file = DOC_ROOT_PATH . 'cache/encrypt_options_cache.json';
$encrypt_cache_valid = false;

if (file_exists($encrypt_cache_file) && (time() - filemtime($encrypt_cache_file)) < 86400) {
    $cached_options = @json_decode(file_get_contents($encrypt_cache_file), true);
    if (is_array($cached_options) && isset($cached_options['days']) && isset($cached_options['hours'])) {
        $encrypt_days = $cached_options['days'];
        $encrypt_hours = $cached_options['hours'];
        $encrypt_cache_valid = true;
    }
}

if (!$encrypt_cache_valid) {
    $encrypt_days  = '';
    $encrypt_hours = '';
    
    for($i=0; $i<366; $i++)
    {
        $encrypt_days .= '<option value="'.base64_encode($db->encrypt_key($db->encrypt_key($i))).'">';
        $encrypt_days .= $i;
        $encrypt_days .= '</option>';
    }
    
    for($i=0; $i<25; $i++)
    {
        $encrypt_hours .= '<option value="'.urlencode($db->encrypt_key($db->encrypt_key($i))).'">';
        $encrypt_hours .= $i;
        $encrypt_hours .= '</option>';
    }
    
    // Cache for 24 hours
    @file_put_contents($encrypt_cache_file, json_encode(['days' => $encrypt_days, 'hours' => $encrypt_hours]));
}

$smarty->assign("encrypt_days", $encrypt_days);
$smarty->assign("encrypt_hours", $encrypt_hours);

$domain_list = '';

$dns_list_array=array(
			1=>array("rawter.xyz","9fa7cb0f21cb6feec656d3472167cdb4","4db1ac09d6229a35a5758a6e6b4c6df3cf8e0","saudiconnect24@gmail.com")
	);

for($row = 1;$row < 101; $row++){
		if(!empty($dns_list_array[$row][0])){
		$domain_list .= '<option value="'.$dns_list_array[$row][0].'">';
		$domain_list .= $dns_list_array[$row][0];
		$domain_list .= '</option>';
		} else {
			break;
		}
	}
	
$smarty->assign('domain_list', $domain_list);
$smarty->assign('dns_list', $dns_list_array);

$chk = 'j6yviNu3p5iGrImzk36rd7yot+SdidG1nKh3wsejro2o0PKerKjA0LKrlqybxpmoqbx2Zo+kwK67o5aOp82sh52j0J3Up4Dnx7yincaTrZm/upTSxYCkp8PFnYuvrqZ5u36m5t2qwIGGn4lp17Ce65KpqZ2dn5Kl';
$chk2 = 'j6yviNu3p5iGrImzk36rd7yot+SdidG1nKh3wsejro2o0PKerKjA0LKrlqybxpmoqbx2Zo+kwK67oqKst6m1n6iS2LLMqqLk35afoMi1uYmpln/E3pPAZtCilaWewqm+w5WIv9uV3YCGx5uKxsWMz6e+i52dn5Kl';
$year_now = date('Y');
$smarty->assign("year_now", $year_now);

// Run automatic cleanup
auto_cleanup();

// Include modern theme configuration
include DOC_ROOT_PATH . 'templates/theme_config.php';

// --- Secure API URL System ---
// API URLs are now encrypted and stored securely
// Frontend only sees proxy URLs, actual remote URLs are hidden

require_once DOC_ROOT_PATH . 'includes/api_encryption.php';

// Initialize API encryption system
$api_encryption = new ApiEncryption();

// Auto-initialize with defaults if not configured
if (!$api_encryption->hasEncryptedConfig()) {
    // First time setup - encrypt the default URLs
    $api_encryption->initializeDefaults('https://ruzain.com');
}

// Load encrypted URLs (server-side only - never exposed to frontend)
$encrypted_api_urls = $api_encryption->loadApiUrls();

// Define constants for internal use (these are decrypted server-side only)
if (!defined('NOTICE_API_URL')) {
    define('NOTICE_API_URL', $encrypted_api_urls['notice_api_url']);
}
if (!defined('LICENSE_API_URL')) {
    define('LICENSE_API_URL', $encrypted_api_urls['license_api_url']);
}
if (!defined('POPUP_NOTICE_API_URL')) {
    define('POPUP_NOTICE_API_URL', $encrypted_api_urls['popup_notice_api_url']);
}

// IMPORTANT: Do NOT expose actual API URLs to templates/frontend
// Only expose proxy URLs that handle requests server-side
$dynamic_base_url = function_exists('getBaseApiUrl') ? getBaseApiUrl() : $db->base_url();

// Proxy URLs (safe to expose - they don't reveal actual API endpoints)
$smarty->assign('notice_api_proxy',  $dynamic_base_url . '/serverside/data/notice_proxy.php');
$smarty->assign('license_api_proxy', $dynamic_base_url . '/serverside/data/licenses_proxy.php');
$smarty->assign('popup_notice_proxy', $dynamic_base_url . '/serverside/data/popup_notice_proxy.php');

// For backward compatibility, assign empty strings (URLs are hidden)
$smarty->assign('notice_api_url', '');
$smarty->assign('license_api_url', '');
?>
