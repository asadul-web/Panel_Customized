<?php
/**
 * API URL Encryption System
 * 
 * This file handles secure encryption/decryption of API URLs
 * so they cannot be viewed or modified by unauthorized users.
 * 
 * Features:
 * - AES-256-CBC encryption for API URLs
 * - Secure storage in encrypted config file
 * - Server-side only decryption (never exposed to frontend)
 * - Integrity verification with HMAC
 */

if (preg_match("/api_encryption.php/i", $_SERVER['SCRIPT_NAME'])) {
    Header("Location: ../index.php");
    die();
}

class ApiEncryption {
    
    private $secret_key;
    private $secret_iv;
    private $encrypt_method = "AES-256-CBC";
    private $config_file;
    private $cache_file;
    
    // Static cache to avoid repeated decryption within same request
    private static $cached_urls = null;
    private static $cache_ttl = 300; // Cache for 5 minutes
    
    public function __construct() {
        // Use unique keys for API URL encryption (different from password encryption)
        $this->secret_key = hash('sha256', 'vollam_api_secure_key_2024_' . $this->getMachineId());
        $this->secret_iv = substr(hash('sha256', 'vollam_api_iv_secure_' . $this->getMachineId()), 0, 16);
        $this->config_file = dirname(__FILE__) . '/backup/api_urls_encrypted.dat';
        $this->cache_file = dirname(__FILE__) . '/backup/api_urls_cache.php';
    }
    
    /**
     * Get a unique machine identifier for additional security
     */
    private function getMachineId() {
        // Use server-specific values to make encryption unique per installation
        $machine_data = php_uname() . __DIR__ . (isset($_SERVER['SERVER_NAME']) ? $_SERVER['SERVER_NAME'] : 'localhost');
        return md5($machine_data);
    }
    
    /**
     * Encrypt a string
     */
    public function encrypt($string) {
        if (empty($string)) return '';
        
        $output = openssl_encrypt($string, $this->encrypt_method, $this->secret_key, 0, $this->secret_iv);
        $output = base64_encode($output);
        
        // Add HMAC for integrity verification
        $hmac = hash_hmac('sha256', $output, $this->secret_key);
        
        return $hmac . ':' . $output;
    }
    
    /**
     * Decrypt a string
     */
    public function decrypt($encrypted_string) {
        if (empty($encrypted_string)) return '';
        
        // Verify HMAC
        $parts = explode(':', $encrypted_string, 2);
        if (count($parts) !== 2) return false;
        
        $hmac = $parts[0];
        $data = $parts[1];
        
        // Verify integrity
        $calculated_hmac = hash_hmac('sha256', $data, $this->secret_key);
        if (!hash_equals($hmac, $calculated_hmac)) {
            return false; // Tampered data
        }
        
        $output = openssl_decrypt(base64_decode($data), $this->encrypt_method, $this->secret_key, 0, $this->secret_iv);
        return $output;
    }
    
    /**
     * Save encrypted API URLs to config file
     */
    public function saveApiUrls($urls) {
        $data = [
            'license_api_url' => $this->encrypt($urls['license_api_url'] ?? ''),
            'notice_api_url' => $this->encrypt($urls['notice_api_url'] ?? ''),
            'popup_notice_api_url' => $this->encrypt($urls['popup_notice_api_url'] ?? ''),
            'updated_at' => time(),
            'version' => '1.0'
        ];
        
        // Encrypt the entire config as additional layer
        $json = json_encode($data);
        $encrypted_config = $this->encrypt($json);
        
        // Save to file with restricted permissions
        $result = file_put_contents($this->config_file, $encrypted_config);
        
        if ($result !== false) {
            // Set file permissions to owner-only read/write
            @chmod($this->config_file, 0600);
            // Clear cache so new URLs are loaded
            $this->clearCache();
        }
        
        return $result !== false;
    }
    
    /**
     * Load and decrypt API URLs from config file (with file-based caching)
     */
    public function loadApiUrls() {
        $defaults = [
            'license_api_url' => '',
            'notice_api_url' => '',
            'popup_notice_api_url' => ''
        ];
        
        // Return memory cached URLs if available (same request)
        if (self::$cached_urls !== null) {
            return self::$cached_urls;
        }
        
        // Try file-based cache first (fast - no decryption needed)
        if (file_exists($this->cache_file)) {
            $cache_age = time() - filemtime($this->cache_file);
            if ($cache_age < self::$cache_ttl) {
                $cached = @include($this->cache_file);
                if (is_array($cached) && !empty($cached['license_api_url'])) {
                    self::$cached_urls = $cached;
                    return $cached;
                }
            }
        }
        
        // Cache miss - decrypt from encrypted file
        if (!file_exists($this->config_file)) {
            return $defaults;
        }
        
        $encrypted_config = @file_get_contents($this->config_file);
        if (empty($encrypted_config)) {
            return $defaults;
        }
        
        // Decrypt outer layer
        $json = $this->decrypt($encrypted_config);
        if ($json === false) {
            return $defaults; // Tampered or corrupted
        }
        
        $data = json_decode($json, true);
        if (!is_array($data)) {
            return $defaults;
        }
        
        // Decrypt individual URLs
        $urls = [
            'license_api_url' => $this->decrypt($data['license_api_url'] ?? ''),
            'notice_api_url' => $this->decrypt($data['notice_api_url'] ?? ''),
            'popup_notice_api_url' => $this->decrypt($data['popup_notice_api_url'] ?? '')
        ];
        
        // Save to file cache for future requests (much faster than decryption)
        $this->saveCache($urls);
        
        // Memory cache
        self::$cached_urls = $urls;
        
        return $urls;
    }
    
    /**
     * Save decrypted URLs to cache file
     */
    private function saveCache($urls) {
        $cache_content = "<?php\n// Auto-generated cache - do not edit\n// Generated: " . date('Y-m-d H:i:s') . "\nreturn " . var_export($urls, true) . ";\n";
        @file_put_contents($this->cache_file, $cache_content);
        @chmod($this->cache_file, 0600);
    }
    
    /**
     * Clear the cache file
     */
    public function clearCache() {
        if (file_exists($this->cache_file)) {
            @unlink($this->cache_file);
        }
        self::$cached_urls = null;
    }
    
    /**
     * Get a specific API URL (decrypted)
     */
    public function getApiUrl($key) {
        $urls = $this->loadApiUrls();
        return $urls[$key] ?? '';
    }
    
    /**
     * Check if encrypted config exists
     */
    public function hasEncryptedConfig() {
        return file_exists($this->config_file) && filesize($this->config_file) > 0;
    }
    
    /**
     * Initialize with default URLs (first-time setup)
     */
    public function initializeDefaults($base_url = 'https://ruzain.com') {
        $base_url = rtrim($base_url, '/');
        
        $urls = [
            'license_api_url' => $base_url . '/serverside/data/licenses_api.php',
            'notice_api_url' => $base_url . '/serverside/data/notice_api.php',
            'popup_notice_api_url' => $base_url . '/serverside/data/popup_notice_api.php'
        ];
        
        return $this->saveApiUrls($urls);
    }
    
    /**
     * Verify the encrypted config integrity
     */
    public function verifyConfig() {
        if (!$this->hasEncryptedConfig()) {
            return ['valid' => false, 'error' => 'Config file not found'];
        }
        
        $urls = $this->loadApiUrls();
        
        // Check if all URLs are valid
        $valid = true;
        $errors = [];
        
        foreach ($urls as $key => $url) {
            if (empty($url)) {
                $valid = false;
                $errors[] = "Missing: $key";
            } elseif (!filter_var($url, FILTER_VALIDATE_URL)) {
                $valid = false;
                $errors[] = "Invalid URL: $key";
            }
        }
        
        return [
            'valid' => $valid,
            'errors' => $errors,
            'urls_count' => count(array_filter($urls))
        ];
    }
}

/**
 * Helper function to get encrypted API URL
 * Use this in proxy files instead of hardcoded URLs
 */
function getEncryptedApiUrl($key) {
    static $api_encryption = null;
    
    if ($api_encryption === null) {
        $api_encryption = new ApiEncryption();
    }
    
    return $api_encryption->getApiUrl($key);
}

/**
 * Helper function to check if API encryption is configured
 */
function isApiEncryptionConfigured() {
    static $api_encryption = null;
    
    if ($api_encryption === null) {
        $api_encryption = new ApiEncryption();
    }
    
    return $api_encryption->hasEncryptedConfig();
}
