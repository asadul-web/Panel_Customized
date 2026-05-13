<?php
/**
 * Security Configuration File
 * Store sensitive configuration values here
 * DO NOT commit this file to version control
 */

// Login validation key - change this to a unique random string
if (!defined('LOGIN_VALIDATION_KEY')) {
    define('LOGIN_VALIDATION_KEY', 'firenetdev'); // TODO: Change this to a unique value
}

// Rate limiting settings
if (!defined('MAX_LOGIN_ATTEMPTS')) {
    define('MAX_LOGIN_ATTEMPTS', 5);
}

if (!defined('LOGIN_LOCKOUT_TIME')) {
    define('LOGIN_LOCKOUT_TIME', 900); // 15 minutes in seconds
}

// Session security settings
if (!defined('SESSION_TIMEOUT')) {
    define('SESSION_TIMEOUT', 3600); // 1 hour
}

// CSRF token settings
if (!defined('CSRF_TOKEN_EXPIRY')) {
    define('CSRF_TOKEN_EXPIRY', 3600); // 1 hour
}

// Password hashing settings (for future bcrypt migration)
if (!defined('PASSWORD_HASH_ALGO')) {
    define('PASSWORD_HASH_ALGO', PASSWORD_BCRYPT);
}

if (!defined('PASSWORD_HASH_COST')) {
    define('PASSWORD_HASH_COST', 12);
}

// Database credential encryption key (for .db-base files)
// Generate a strong random key: openssl rand -base64 32
if (!defined('DB_CREDENTIAL_KEY')) {
    define('DB_CREDENTIAL_KEY', 'CHANGE_THIS_TO_RANDOM_32_BYTE_KEY');
}

// API security
if (!defined('API_RATE_LIMIT')) {
    define('API_RATE_LIMIT', 100); // requests per minute
}

// Enable/disable security features
if (!defined('ENABLE_2FA')) {
    define('ENABLE_2FA', true);
}

if (!defined('ENABLE_IP_WHITELIST')) {
    define('ENABLE_IP_WHITELIST', false);
}

// Allowed IP addresses (if IP whitelist is enabled)
$ALLOWED_IPS = [
    // '127.0.0.1',
    // '192.168.1.0/24',
];
