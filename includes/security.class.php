<?php
/**
 * Firenet VPN Panel Security Class
 * Comprehensive security protection system
 */

class Security {
    
    private $db;
    private $max_attempts = 5;
    private $lockout_time = 900; // 15 minutes
    private $ddos_threshold = 100; // requests per minute
    
    public function __construct($database) {
        $this->db = $database;
        $this->initializeSecurity();
    }
    
    /**
     * Initialize security measures
     */
    private function initializeSecurity() {
        // Start secure session
        $this->secureSession();
        
        // Set security headers
        $this->setSecurityHeaders();
        
        // Check for DDoS attacks
        $this->checkDDoS();
        
        // Validate request
        $this->validateRequest();
    }
    
    /**
     * Secure session configuration
     */
    private function secureSession() {
        if (session_status() == PHP_SESSION_NONE) {
            // Secure session settings
            ini_set('session.cookie_httponly', 1);
            ini_set('session.cookie_secure', 1);
            ini_set('session.use_strict_mode', 1);
            ini_set('session.cookie_samesite', 'Strict');
            
            // Regenerate session ID periodically
            if (isset($_SESSION['last_regeneration'])) {
                if (time() - $_SESSION['last_regeneration'] > 300) { // 5 minutes
                    session_regenerate_id(true);
                    $_SESSION['last_regeneration'] = time();
                }
            } else {
                $_SESSION['last_regeneration'] = time();
            }
        }
    }
    
    /**
     * Set comprehensive security headers
     */
    private function setSecurityHeaders() {
        // Prevent XSS attacks
        header('X-XSS-Protection: 1; mode=block');
        
        // Prevent clickjacking
        header('X-Frame-Options: DENY');
        
        // Prevent MIME type sniffing
        header('X-Content-Type-Options: nosniff');
        
        // Referrer policy
        header('Referrer-Policy: strict-origin-when-cross-origin');
        
        // Content Security Policy
        header("Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdnjs.cloudflare.com https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self';");
        
        // Remove server information
        header_remove('X-Powered-By');
        header('Server: Firenet-VPN');
    }
    
    /**
     * DDoS Protection System
     */
    private function checkDDoS() {
        $ip = $this->getRealIP();
        $current_time = time();
        
        // Check if IP is in whitelist (admin IPs)
        if ($this->isWhitelistedIP($ip)) {
            return true;
        }
        
        // Get request count for this IP in last minute
        $requests = $this->getRequestCount($ip, $current_time - 60);
        
        if ($requests > $this->ddos_threshold) {
            // Log DDoS attempt
            $this->logSecurityEvent('DDOS_ATTEMPT', $ip, "Requests: $requests in 1 minute");
            
            // Block IP temporarily
            $this->blockIP($ip, 3600); // 1 hour block
            
            // Send 429 Too Many Requests
            http_response_code(429);
            header('Retry-After: 3600');
            die('Rate limit exceeded. Try again later.');
        }
        
        // Log this request
        $this->logRequest($ip, $current_time);
    }
    
    /**
     * Get real client IP address
     */
    private function getRealIP() {
        $ip_keys = ['HTTP_CF_CONNECTING_IP', 'HTTP_X_FORWARDED_FOR', 'HTTP_X_FORWARDED', 
                   'HTTP_X_CLUSTER_CLIENT_IP', 'HTTP_FORWARDED_FOR', 'HTTP_FORWARDED', 'REMOTE_ADDR'];
        
        foreach ($ip_keys as $key) {
            if (array_key_exists($key, $_SERVER) === true) {
                $ip = trim($_SERVER[$key]);
                if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE)) {
                    return $ip;
                }
            }
        }
        
        return $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
    }
    
    /**
     * Check if IP is whitelisted
     */
    private function isWhitelistedIP($ip) {
        $whitelist = ['127.0.0.1', '::1']; // Add admin IPs here
        return in_array($ip, $whitelist);
    }
    
    /**
     * Get request count for IP in timeframe
     */
    private function getRequestCount($ip, $since_time) {
        $sql = "SELECT COUNT(*) as count FROM security_logs 
                WHERE ip_address = ? AND timestamp >= ? AND event_type = 'REQUEST'";
        
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param('si', $ip, $since_time);
            $stmt->execute();
            $result = $stmt->get_result();
            $row = $result->fetch_assoc();
            return $row['count'] ?? 0;
        } catch (Exception $e) {
            return 0;
        }
    }
    
    /**
     * Log security request
     */
    private function logRequest($ip, $timestamp) {
        $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        $uri = $_SERVER['REQUEST_URI'] ?? '';
        
        $sql = "INSERT INTO security_logs (ip_address, timestamp, event_type, user_agent, request_uri) 
                VALUES (?, ?, 'REQUEST', ?, ?)";
        
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param('siss', $ip, $timestamp, $user_agent, $uri);
            $stmt->execute();
        } catch (Exception $e) {
            // Silent fail for logging
        }
    }
    
    /**
     * Block IP address
     */
    private function blockIP($ip, $duration) {
        $expires = time() + $duration;
        
        $sql = "INSERT INTO blocked_ips (ip_address, blocked_until, reason) 
                VALUES (?, ?, 'DDoS Protection') 
                ON DUPLICATE KEY UPDATE blocked_until = ?, reason = 'DDoS Protection'";
        
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param('sii', $ip, $expires, $expires);
            $stmt->execute();
        } catch (Exception $e) {
            // Silent fail
        }
    }
    
    /**
     * Check if IP is blocked
     */
    public function isBlocked($ip = null) {
        if (!$ip) $ip = $this->getRealIP();
        
        $sql = "SELECT blocked_until FROM blocked_ips WHERE ip_address = ? AND blocked_until > ?";
        
        try {
            $stmt = $this->db->prepare($sql);
            $current_time = time();
            $stmt->bind_param('si', $ip, $current_time);
            $stmt->execute();
            $result = $stmt->get_result();
            
            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $remaining = $row['blocked_until'] - time();
                
                http_response_code(403);
                die("Access denied. IP blocked for " . ceil($remaining/60) . " more minutes.");
            }
        } catch (Exception $e) {
            // Silent fail
        }
        
        return false;
    }
    
    /**
     * Validate request for common attacks
     */
    private function validateRequest() {
        // Check for SQL injection patterns
        $this->checkSQLInjection();
        
        // Check for XSS patterns
        $this->checkXSS();
        
        // Check for file inclusion attacks
        $this->checkFileInclusion();
        
        // Validate file uploads
        $this->validateUploads();
    }
    
    /**
     * Check for SQL injection attempts
     */
    private function checkSQLInjection() {
        $sql_patterns = [
            '/(\bUNION\b.*\bSELECT\b)/i',
            '/(\bSELECT\b.*\bFROM\b.*\bWHERE\b)/i',
            '/(\bINSERT\b.*\bINTO\b)/i',
            '/(\bDELETE\b.*\bFROM\b)/i',
            '/(\bUPDATE\b.*\bSET\b)/i',
            '/(\bDROP\b.*\bTABLE\b)/i',
            '/(\'\s*OR\s*\'.*\'=\')/i',
            '/(\'\s*OR\s*1=1)/i',
            '/(--|\#|\/\*|\*\/)/i'
        ];
        
        $input = array_merge($_GET, $_POST, $_COOKIE);
        
        foreach ($input as $key => $value) {
            if (is_string($value)) {
                foreach ($sql_patterns as $pattern) {
                    if (preg_match($pattern, $value)) {
                        $this->logSecurityEvent('SQL_INJECTION', $this->getRealIP(), "Field: $key, Value: " . substr($value, 0, 100));
                        $this->blockRequest('SQL injection attempt detected');
                    }
                }
            }
        }
    }
    
    /**
     * Check for XSS attempts
     */
    private function checkXSS() {
        $xss_patterns = [
            '/<script[^>]*>.*?<\/script>/is',
            '/<iframe[^>]*>.*?<\/iframe>/is',
            '/javascript:/i',
            '/on\w+\s*=/i',
            '/<img[^>]+src[^>]*>/i',
            '/eval\s*\(/i',
            '/expression\s*\(/i'
        ];
        
        $input = array_merge($_GET, $_POST);
        
        foreach ($input as $key => $value) {
            if (is_string($value)) {
                foreach ($xss_patterns as $pattern) {
                    if (preg_match($pattern, $value)) {
                        $this->logSecurityEvent('XSS_ATTEMPT', $this->getRealIP(), "Field: $key, Value: " . substr($value, 0, 100));
                        $this->blockRequest('XSS attempt detected');
                    }
                }
            }
        }
    }
    
    /**
     * Check for file inclusion attacks
     */
    private function checkFileInclusion() {
        $lfi_patterns = [
            '/\.\.[\/\\\\]/i',
            '/etc\/passwd/i',
            '/proc\/self\/environ/i',
            '/windows\/system32/i',
            '/php:\/\//i',
            '/data:\/\//i'
        ];
        
        $input = array_merge($_GET, $_POST);
        
        foreach ($input as $key => $value) {
            if (is_string($value)) {
                foreach ($lfi_patterns as $pattern) {
                    if (preg_match($pattern, $value)) {
                        $this->logSecurityEvent('LFI_ATTEMPT', $this->getRealIP(), "Field: $key, Value: " . substr($value, 0, 100));
                        $this->blockRequest('File inclusion attempt detected');
                    }
                }
            }
        }
    }
    
    /**
     * Validate file uploads
     */
    private function validateUploads() {
        if (!empty($_FILES)) {
            foreach ($_FILES as $file) {
                if ($file['error'] === UPLOAD_ERR_OK) {
                    // Check file size (max 10MB)
                    if ($file['size'] > 10 * 1024 * 1024) {
                        $this->blockRequest('File too large');
                    }
                    
                    // Check file type
                    $allowed_types = ['image/jpeg', 'image/png', 'image/gif', 'application/pdf'];
                    $finfo = finfo_open(FILEINFO_MIME_TYPE);
                    $mime_type = finfo_file($finfo, $file['tmp_name']);
                    finfo_close($finfo);
                    
                    if (!in_array($mime_type, $allowed_types)) {
                        $this->logSecurityEvent('INVALID_UPLOAD', $this->getRealIP(), "MIME: $mime_type, File: " . $file['name']);
                        $this->blockRequest('Invalid file type');
                    }
                }
            }
        }
    }
    
    /**
     * Generate CSRF token
     */
    public function generateCSRFToken() {
        if (!isset($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }
    
    /**
     * Validate CSRF token
     */
    public function validateCSRFToken($token) {
        if (!isset($_SESSION['csrf_token'])) {
            return false;
        }
        
        if (!hash_equals($_SESSION['csrf_token'], $token)) {
            $this->logSecurityEvent('CSRF_VIOLATION', $this->getRealIP(), 'Invalid CSRF token');
            return false;
        }
        
        return true;
    }
    
    /**
     * Sanitize input data
     */
    public function sanitizeInput($input, $type = 'string') {
        switch ($type) {
            case 'email':
                return filter_var($input, FILTER_SANITIZE_EMAIL);
            case 'url':
                return filter_var($input, FILTER_SANITIZE_URL);
            case 'int':
                return filter_var($input, FILTER_SANITIZE_NUMBER_INT);
            case 'float':
                return filter_var($input, FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
            case 'string':
            default:
                return htmlspecialchars(strip_tags(trim($input)), ENT_QUOTES, 'UTF-8');
        }
    }
    
    /**
     * Log security events
     */
    private function logSecurityEvent($event_type, $ip, $details) {
        $timestamp = time();
        $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        $uri = $_SERVER['REQUEST_URI'] ?? '';
        
        $sql = "INSERT INTO security_logs (ip_address, timestamp, event_type, details, user_agent, request_uri) 
                VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param('sissss', $ip, $timestamp, $event_type, $details, $user_agent, $uri);
            $stmt->execute();
        } catch (Exception $e) {
            // Log to file if database fails
            error_log("Security Event: $event_type - IP: $ip - Details: $details");
        }
    }
    
    /**
     * Block malicious request
     */
    private function blockRequest($reason) {
        $ip = $this->getRealIP();
        
        // Block IP for 1 hour
        $this->blockIP($ip, 3600);
        
        // Log the block
        $this->logSecurityEvent('REQUEST_BLOCKED', $ip, $reason);
        
        // Send 403 Forbidden
        http_response_code(403);
        die('Access denied: ' . $reason);
    }
    
    /**
     * Rate limiting for login attempts
     */
    public function checkLoginAttempts($username, $ip) {
        $current_time = time();
        $lockout_until = $current_time - $this->lockout_time;
        
        // Clean old attempts
        $this->db->sql_query("DELETE FROM login_attempts WHERE timestamp < $lockout_until");
        
        // Count recent attempts
        $sql = "SELECT COUNT(*) as attempts FROM login_attempts 
                WHERE (username = '$username' OR ip_address = '$ip') 
                AND timestamp > $lockout_until";
        
        $result = $this->db->sql_query($sql);
        $row = $this->db->sql_fetchrow($result);
        $attempts = $row['attempts'];
        
        if ($attempts >= $this->max_attempts) {
            $this->logSecurityEvent('LOGIN_LOCKOUT', $ip, "Username: $username, Attempts: $attempts");
            http_response_code(429);
            die('Too many login attempts. Try again in 15 minutes.');
        }
        
        return true;
    }
    
    /**
     * Log failed login attempt
     */
    public function logFailedLogin($username, $ip) {
        $timestamp = time();
        $sql = "INSERT INTO login_attempts (username, ip_address, timestamp) VALUES ('$username', '$ip', $timestamp)";
        $this->db->sql_query($sql);
        
        $this->logSecurityEvent('FAILED_LOGIN', $ip, "Username: $username");
    }
    
    /**
     * Clear login attempts on successful login
     */
    public function clearLoginAttempts($username, $ip) {
        $sql = "DELETE FROM login_attempts WHERE username = '$username' OR ip_address = '$ip'";
        $this->db->sql_query($sql);
    }
}
