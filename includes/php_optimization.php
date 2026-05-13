<?php
/**
 * PHP Performance Optimizations
 * Include this file early in your application
 */

if (preg_match("/php_optimization.php/i", $_SERVER['SCRIPT_NAME'])) {
    Header("Location: /"); die();
}

// Enable output buffering for better performance
// ✅ FIX: Check if output buffering is already started
if (!ob_get_level() && !headers_sent()) {
    ob_start('ob_gzhandler');
}

// Set optimal PHP settings for performance
ini_set('memory_limit', '256M');
ini_set('max_execution_time', '30');
ini_set('max_input_time', '30');
ini_set('post_max_size', '32M');
ini_set('upload_max_filesize', '32M');

// Enable OPcache if available
if (function_exists('opcache_get_status')) {
    $opcache_status = opcache_get_status();
    if (!$opcache_status['opcache_enabled']) {
        // OPcache is not enabled, log a warning
        error_log('Warning: OPcache is not enabled. Enable it for better performance.');
    }
}

// Optimize session handling
ini_set('session.gc_maxlifetime', 3600); // 1 hour
ini_set('session.gc_probability', 1);
ini_set('session.gc_divisor', 100);
ini_set('session.cookie_lifetime', 0);
ini_set('session.use_strict_mode', 1);
ini_set('session.cookie_httponly', 1);
ini_set('session.cookie_secure', isset($_SERVER['HTTPS']));

// Disable unnecessary PHP features for security and performance
ini_set('expose_php', 'Off');
ini_set('display_errors', 'Off'); // Should be Off in production
ini_set('log_errors', 'On');
ini_set('error_log', dirname(__FILE__) . '/../logs/php_errors.log');

// Set timezone to avoid warnings
if (!ini_get('date.timezone')) {
    date_default_timezone_set('UTC');
}

// Function to minify HTML output
function minify_html($buffer) {
    // Remove HTML comments (except IE conditional comments)
    $buffer = preg_replace('/<!--(?!\s*(?:\[if [^\]]+]|<!|>))(?:(?!-->).)*-->/s', '', $buffer);
    
    // Remove whitespace between HTML tags
    $buffer = preg_replace('/>\s+</', '><', $buffer);
    
    // Remove extra whitespace
    $buffer = preg_replace('/\s+/', ' ', $buffer);
    
    return trim($buffer);
}

// Enable HTML minification for production (temporarily disabled for debugging)
// if (!defined('DEBUG_MODE') || !DEBUG_MODE) {
//     ob_start('minify_html');
// }

// Performance monitoring function
function log_performance($start_time, $start_memory) {
    $end_time = microtime(true);
    $end_memory = memory_get_usage();
    
    $execution_time = ($end_time - $start_time) * 1000; // Convert to milliseconds
    $memory_used = $end_memory - $start_memory;
    
    // Log slow requests (over 1 second)
    if ($execution_time > 1000) {
        error_log(sprintf(
            'Slow request: %s - Time: %.2fms, Memory: %s',
            $_SERVER['REQUEST_URI'] ?? 'CLI',
            $execution_time,
            formatBytes($memory_used)
        ));
    }
}

// Helper function to format bytes (check if already exists)
if (!function_exists('formatBytes')) {
    function formatBytes($size, $precision = 2) {
        $units = array('B', 'KB', 'MB', 'GB', 'TB');
        
        for ($i = 0; $size > 1024 && $i < count($units) - 1; $i++) {
            $size /= 1024;
        }
        
        return round($size, $precision) . ' ' . $units[$i];
    }
}

// Register shutdown function for performance logging
register_shutdown_function(function() {
    if (defined('APP_START_TIME') && defined('APP_START_MEMORY')) {
        log_performance(APP_START_TIME, APP_START_MEMORY);
    }
});

// Define performance tracking constants
if (!defined('APP_START_TIME')) {
    define('APP_START_TIME', microtime(true));
}
if (!defined('APP_START_MEMORY')) {
    define('APP_START_MEMORY', memory_get_usage());
}

?>
