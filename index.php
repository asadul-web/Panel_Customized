<?php
/**
 * VPN Panel - Main Entry Point
 * Auto-redirects to installer if not configured
 */

// Suppress ALL errors during installer check (CRITICAL)
error_reporting(0);
@ini_set('display_errors', '0');

// Set UTF-8 encoding for all pages
@header('Content-Type: text/html; charset=utf-8');
if (function_exists('mb_internal_encoding')) {
    @mb_internal_encoding('UTF-8');
}

// Check if config file exists
$dbConfigFile = __DIR__ . '/includes/db_config.php';
$lockFile = __DIR__ . '/.installed';

// If config exists, we need to validate it WITHOUT triggering die()
// Read the file content and check if it looks valid
if (file_exists($dbConfigFile)) {
    $configContent = @file_get_contents($dbConfigFile);
    
    // Check if config has die() or empty credentials
    $hasValidCredentials = (
        strpos($configContent, '$DB_host') !== false &&
        strpos($configContent, '$DB_user') !== false &&
        strpos($configContent, '$DB_name') !== false &&
        strpos($configContent, '$DB_host = "";') === false &&
        strpos($configContent, '$DB_user = "";') === false &&
        strpos($configContent, '$DB_name = "";') === false &&
        strpos($configContent, 'INSTALL_REQUIRED') === false
    );
    
    if (!$hasValidCredentials && $installerExists) {
        // Config exists but looks invalid - redirect to installer
        if (file_exists(__DIR__ . '/install/index.php')) {
            header('Location: install/');
        } else {
            header('Location: install.php');
        }
        exit;
    }
    
    // Now safely test the database connection
    // Extract credentials using regex to avoid including the file (which might die())
    preg_match('/\$DB_host\s*=\s*["\']([^"\']*)["\']/', $configContent, $hostMatch);
    preg_match('/\$DB_user\s*=\s*["\']([^"\']*)["\']/', $configContent, $userMatch);
    preg_match('/\$DB_pass\s*=\s*["\']([^"\']*)["\']/', $configContent, $passMatch);
    preg_match('/\$DB_name\s*=\s*["\']([^"\']*)["\']/', $configContent, $nameMatch);
    
    $testHost = $hostMatch[1] ?? '';
    $testUser = $userMatch[1] ?? '';
    $testPass = $passMatch[1] ?? '';
    $testName = $nameMatch[1] ?? '';
    
    if (!empty($testHost) && !empty($testUser) && !empty($testName)) {
        // Test actual database connection
        $testConn = @new mysqli($testHost, $testUser, $testPass, $testName);
        if ($testConn && !$testConn->connect_error) {
            // Check if tables exist
            $check = @$testConn->query("SHOW TABLES LIKE 'users'");
            if (!$check || $check->num_rows == 0) {
                // Database exists but no tables - show error
                @$testConn->close();
                die('Database configuration error: Tables not found. Please check your database setup.');
            }
            @$testConn->close();
        } else {
            // Connection failed - show error
            die('Database connection failed. Please check your database configuration in /includes/db_config.php');
        }
    } else {
        // Empty credentials - show error
        die('Database configuration error: Missing credentials in /includes/db_config.php');
    }
}

// Now safe to load performance optimizations
require_once __DIR__ . '/includes/performance.php';

// Production error handling - secure configuration
error_reporting(E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE);
ini_set('display_errors', '0'); // OFF for production security
ini_set('log_errors', '1');
ini_set('error_log', __DIR__ . '/logs/php_errors.log');
include './includes/functions.php';
$p = $_GET['p'] ?? ''; // ?page=
$ex = "php"; // File extension
$folder_content = "content"; //
$main = "login"; // Main page
$error = "404"; // 404 error page

if(empty($p)) {
	include("$folder_content/$main.$ex");
} else if(file_exists("$folder_content/$p.$ex")) {
	include("$folder_content/$p.$ex");
} else if(file_exists("$folder_content/serverside/$p.$ex")) {
	include("$folder_content/serverside/$p.$ex");
} else if(file_exists("$folder_content/serverside/credits/$p.$ex")) {
	include("$folder_content/serverside/credits/$p.$ex");
} else {
	include("$folder_content/$error.$ex");
}
?>