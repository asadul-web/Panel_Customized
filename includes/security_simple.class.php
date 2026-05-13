<?php
/**
 * Simplified Security Class - Compatible with custom DB class
 * Basic security protection without prepared statements
 */

class SecuritySimple {
    
    private $db;
    private $max_attempts = 5;
    private $lockout_time = 900; // 15 minutes
    
    public function __construct($database) {
        $this->db = $database;
    }
    
    /**
     * Get real client IP address
     */
    public function getRealIP() {
        $ip_keys = ['HTTP_CF_CONNECTING_IP', 'HTTP_X_FORWARDED_FOR', 'REMOTE_ADDR'];
        
        foreach ($ip_keys as $key) {
            if (isset($_SERVER[$key])) {
                $ip = trim(explode(',', $_SERVER[$key])[0]);
                if (filter_var($ip, FILTER_VALIDATE_IP)) {
                    return $ip;
                }
            }
        }
        
        return $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
    }
    
    /**
     * Log security event
     */
    public function logEvent($event_type, $details = '') {
        $ip = $this->getRealIP();
        $timestamp = time();
        $user_agent = isset($_SERVER['HTTP_USER_AGENT']) ? $this->db->SanitizeForSQL($_SERVER['HTTP_USER_AGENT']) : '';
        $uri = isset($_SERVER['REQUEST_URI']) ? $this->db->SanitizeForSQL($_SERVER['REQUEST_URI']) : '';
        $details = $this->db->SanitizeForSQL($details);
        
        $sql = "INSERT INTO security_logs (ip_address, timestamp, event_type, details, user_agent, request_uri) 
                VALUES ('$ip', $timestamp, '$event_type', '$details', '$user_agent', '$uri')";
        
        @$this->db->sql_query($sql);
    }
    
    /**
     * Check login attempts - call before processing login
     * Returns true if allowed, false if blocked
     */
    public function checkLoginAttempts($username) {
        $ip = $this->getRealIP();
        $username = $this->db->SanitizeForSQL($username);
        $current_time = time();
        $lockout_until = $current_time - $this->lockout_time;
        
        // Clean old attempts (using existing table structure)
        @$this->db->sql_query("DELETE FROM login_attempts WHERE timestamp < $lockout_until");
        
        // Check attempts for this IP (using existing table structure)
        $sql = "SELECT attempts FROM login_attempts WHERE ip = '$ip' AND timestamp > $lockout_until";
        
        $result = @$this->db->sql_query($sql);
        if (!$result) {
            return true; // If query fails, allow login
        }
        
        $attempts = 0;
        if ($this->db->sql_numrows($result) > 0) {
            $row = $this->db->sql_fetchrow($result);
            $attempts = isset($row['attempts']) ? $row['attempts'] : 0;
        }
        
        if ($attempts >= $this->max_attempts) {
            $this->logEvent('LOGIN_LOCKOUT', "Username: $username, IP: $ip, Attempts: $attempts");
            return false; // Blocked
        }
        
        return true; // Allowed
    }
    
    /**
     * Log failed login attempt
     */
    public function logFailedLogin($username) {
        $ip = $this->getRealIP();
        $username = $this->db->SanitizeForSQL($username);
        $timestamp = time();
        
        // Use existing table structure: increment attempts for this IP
        $check_sql = "SELECT attempts FROM login_attempts WHERE ip = '$ip'";
        $check_result = @$this->db->sql_query($check_sql);
        
        if ($check_result && $this->db->sql_numrows($check_result) > 0) {
            // IP exists, increment attempts
            $sql = "UPDATE login_attempts SET attempts = attempts + 1, timestamp = $timestamp WHERE ip = '$ip'";
        } else {
            // New IP, insert first attempt
            $sql = "INSERT INTO login_attempts (ip, attempts, timestamp) VALUES ('$ip', 1, $timestamp)";
        }
        
        $result = $this->db->sql_query($sql);
        
        // Silent fail for production
        
        $this->logEvent('FAILED_LOGIN', "Username: $username");
    }
    
    /**
     * Clear login attempts on successful login
     */
    public function clearLoginAttempts($username) {
        $ip = $this->getRealIP();
        $username = $this->db->SanitizeForSQL($username);
        
        // Clear attempts for this IP (using existing table structure)
        $sql = "DELETE FROM login_attempts WHERE ip = '$ip'";
        $this->db->sql_query($sql);
    }
    
    /**
     * Check if IP is blocked
     */
    public function isBlocked() {
        $ip = $this->getRealIP();
        $current_time = time();
        
        $sql = "SELECT blocked_until FROM blocked_ips 
                WHERE ip_address = '$ip' AND blocked_until > $current_time";
        
        $result = @$this->db->sql_query($sql);
        
        if ($result && $this->db->sql_numrows($result) > 0) {
            $row = $this->db->sql_fetchrow($result);
            $remaining = ceil(($row['blocked_until'] - time()) / 60);
            
            http_response_code(403);
            die("Access denied. IP blocked for $remaining more minutes.");
        }
        
        return false;
    }
    
    /**
     * Block IP address
     */
    public function blockIP($duration = 3600, $reason = 'Security violation') {
        $ip = $this->getRealIP();
        $expires = time() + $duration;
        $reason = $this->db->SanitizeForSQL($reason);
        
        // Delete old block if exists
        $this->db->sql_query("DELETE FROM blocked_ips WHERE ip_address = '$ip'");
        
        // Insert new block
        $sql = "INSERT INTO blocked_ips (ip_address, blocked_until, reason) 
                VALUES ('$ip', $expires, '$reason')";
        
        $this->db->sql_query($sql);
        $this->logEvent('IP_BLOCKED', "Reason: $reason, Duration: $duration seconds");
    }
    
    /**
     * Set security headers
     */
    public function setSecurityHeaders() {
        if (!headers_sent()) {
            header('X-XSS-Protection: 1; mode=block');
            header('X-Frame-Options: DENY');
            header('X-Content-Type-Options: nosniff');
            header('Referrer-Policy: strict-origin-when-cross-origin');
            header_remove('X-Powered-By');
        }
    }
    
    /**
     * Basic XSS protection check
     */
    public function checkXSS() {
        $xss_patterns = [
            '/<script[^>]*>.*?<\/script>/is',
            '/javascript:/i',
            '/on\w+\s*=/i'
        ];
        
        $input = array_merge($_GET, $_POST);
        
        foreach ($input as $key => $value) {
            if (is_string($value)) {
                foreach ($xss_patterns as $pattern) {
                    if (preg_match($pattern, $value)) {
                        $this->logEvent('XSS_ATTEMPT', "Field: $key, Value: " . substr($value, 0, 100));
                        $this->blockIP(3600, 'XSS attempt detected');
                        die('Security violation detected');
                    }
                }
            }
        }
    }
    
    /**
     * Basic SQL injection check
     */
    public function checkSQLInjection() {
        $sql_patterns = [
            '/(\bUNION\b.*\bSELECT\b)/i',
            '/(\'\s*OR\s*\'.*\'=\')/i',
            '/(\'\s*OR\s*1=1)/i',
            '/(--|\#)/i'
        ];
        
        $input = array_merge($_GET, $_POST);
        
        foreach ($input as $key => $value) {
            if (is_string($value)) {
                foreach ($sql_patterns as $pattern) {
                    if (preg_match($pattern, $value)) {
                        $this->logEvent('SQL_INJECTION', "Field: $key, Value: " . substr($value, 0, 100));
                        $this->blockIP(3600, 'SQL injection attempt');
                        die('Security violation detected');
                    }
                }
            }
        }
    }
    
    /**
     * Sanitize input
     */
    public function sanitizeInput($input) {
        return htmlspecialchars(strip_tags(trim($input)), ENT_QUOTES, 'UTF-8');
    }
}
