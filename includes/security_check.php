<?php
/**
 * Security Check - Prevent Direct Access to Source Files
 * This file must be included at the top of every PHP file to prevent unauthorized access
 */

// Start session if not already started
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Define security constant to mark this file as included
if (!defined('SECURITY_CHECK_INCLUDED')) {
    define('SECURITY_CHECK_INCLUDED', true);
}

// Prevent direct access to PHP files
if (!defined('ALLOW_DIRECT_ACCESS')) {
    // Check if user is logged in via session
    if (!isset($_SESSION['user_id']) || empty($_SESSION['user_id'])) {
        // Not logged in - block access
        http_response_code(403);
        die('Access Denied: Authentication Required');
    }
}

// Additional security headers
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: SAMEORIGIN');
header('X-XSS-Protection: 1; mode=block');

// Prevent caching of sensitive pages
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header('Expires: 0');
