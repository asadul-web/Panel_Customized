<?php
/**
 * API Keys Configuration
 * Multiple Authentication Methods for Enhanced Security
 * 
 * SECURITY BEST PRACTICES:
 * 1. Each key has specific permissions
 * 2. Use different keys for different operations
 * 3. Rotate keys regularly
 * 4. Monitor key usage in logs
 * 5. Revoke compromised keys immediately
 */

// DO NOT commit this file to version control
// Add to .gitignore: includes/api_keys_config.php

/**
 * API Key Definitions
 * Each key has specific access levels and purposes
 */
define('API_KEYS', [
    // Primary Admin Key - Full Access
    'azimaxus' => [
        'name' => 'Primary Admin Key',
        'permissions' => ['read', 'write', 'sync', 'delete', 'admin'],
        'description' => 'Full administrative access to all operations',
        'created' => '2024-11-24',
        'expires' => null, // Never expires
    ],
    
    // Sync Key - User Synchronization
    'azimaxus_sync' => [
        'name' => 'User Sync Key',
        'permissions' => ['read', 'sync'],
        'description' => 'User synchronization between panel and VPN servers',
        'created' => '2024-11-24',
        'expires' => null,
    ],
    
    // Read-Only Key - Query Operations
    'azimaxus_read' => [
        'name' => 'Read-Only Key',
        'permissions' => ['read'],
        'description' => 'Read-only access for monitoring and statistics',
        'created' => '2024-11-24',
        'expires' => null,
    ],
    
    // Write Key - User Management
    'azimaxus_write' => [
        'name' => 'Write Operations Key',
        'permissions' => ['read', 'write'],
        'description' => 'Activate, deactivate, and delete users',
        'created' => '2024-11-24',
        'expires' => null,
    ],
    
    // Server-Specific Keys (Optional - for individual server isolation)
    'azimaxus_server1' => [
        'name' => 'Server 1 Key',
        'permissions' => ['read', 'sync'],
        'description' => 'Dedicated key for Server 1',
        'created' => '2024-11-24',
        'expires' => null,
        'server_id' => 1,
    ],
    
    'azimaxus_server2' => [
        'name' => 'Server 2 Key',
        'permissions' => ['read', 'sync'],
        'description' => 'Dedicated key for Server 2',
        'created' => '2024-11-24',
        'expires' => null,
        'server_id' => 2,
    ],
]);

/**
 * Validate API Key
 * @param string $key The API key to validate
 * @param string $required_permission The permission required (read, write, sync, delete, admin)
 * @return bool True if valid and has permission
 */
function validate_api_key($key, $required_permission = 'read') {
    $keys = API_KEYS;
    
    // Check if key exists
    if (!isset($keys[$key])) {
        return false;
    }
    
    $key_config = $keys[$key];
    
    // Check if key has expired
    if ($key_config['expires'] !== null) {
        $expiry = strtotime($key_config['expires']);
        if (time() > $expiry) {
            return false;
        }
    }
    
    // Check if key has required permission
    if (!in_array($required_permission, $key_config['permissions'])) {
        return false;
    }
    
    return true;
}

/**
 * Get API Key Info
 * @param string $key The API key
 * @return array|null Key configuration or null if not found
 */
function get_api_key_info($key) {
    $keys = API_KEYS;
    return $keys[$key] ?? null;
}

/**
 * Log API Key Usage
 * @param string $key The API key used
 * @param string $endpoint The endpoint accessed
 * @param string $ip Client IP address
 */
function log_api_key_usage($key, $endpoint, $ip) {
    $log_file = __DIR__ . '/../logs/api_key_usage.log';
    $log_dir = dirname($log_file);
    
    if (!is_dir($log_dir)) {
        mkdir($log_dir, 0755, true);
    }
    
    $key_info = get_api_key_info($key);
    $key_name = $key_info ? $key_info['name'] : 'Unknown';
    
    $log_entry = sprintf(
        "[%s] Key: %s (%s) | Endpoint: %s | IP: %s\n",
        date('Y-m-d H:i:s'),
        substr($key, 0, 10) . '...',
        $key_name,
        $endpoint,
        $ip
    );
    
    file_put_contents($log_file, $log_entry, FILE_APPEND);
}

/**
 * Generate New API Key
 * @param string $prefix Key prefix (default: azimaxus_)
 * @return string New random API key
 */
function generate_api_key($prefix = 'azimaxus_') {
    return $prefix . bin2hex(random_bytes(16));
}

/**
 * Revoke API Key
 * This is a placeholder - implement database storage for dynamic key management
 */
function revoke_api_key($key) {
    // TODO: Implement database-based key revocation
    // For now, remove from API_KEYS constant manually
    return false;
}
