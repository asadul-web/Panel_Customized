<?php
/**
 * Cache Cleanup Script
 * Automatically cleans expired cache files
 */

if (preg_match("/cache_cleanup.php/i", $_SERVER['SCRIPT_NAME'])) {
    Header("Location: /"); die();
}

require_once 'cache.class.php';

// Function to clean expired cache files
function cleanup_expired_cache() {
    global $cache;
    
    $cleaned = $cache->cleanup();
    
    // Log cleanup activity
    if ($cleaned > 0) {
        error_log("Cache cleanup: Removed $cleaned expired cache files");
    }
    
    return $cleaned;
}

// Function to clean Smarty compiled templates older than 24 hours
function cleanup_smarty_cache() {
    $templates_dir = dirname(__FILE__) . '/../templates_c/';
    $cleaned = 0;
    
    if (is_dir($templates_dir)) {
        $files = glob($templates_dir . '*.php');
        $cutoff_time = time() - (24 * 3600); // 24 hours ago
        
        foreach ($files as $file) {
            if (filemtime($file) < $cutoff_time) {
                if (unlink($file)) {
                    $cleaned++;
                }
            }
        }
    }
    
    if ($cleaned > 0) {
        error_log("Smarty cleanup: Removed $cleaned old compiled templates");
    }
    
    return $cleaned;
}

// Function to clean old log files
function cleanup_old_logs() {
    $logs_dir = dirname(__FILE__) . '/../logs/';
    $cleaned = 0;
    
    if (is_dir($logs_dir)) {
        $files = glob($logs_dir . '*.log');
        $cutoff_time = time() - (7 * 24 * 3600); // 7 days ago
        
        foreach ($files as $file) {
            if (filemtime($file) < $cutoff_time) {
                // Instead of deleting, truncate large log files
                if (filesize($file) > 10 * 1024 * 1024) { // 10MB
                    file_put_contents($file, '');
                    $cleaned++;
                }
            }
        }
    }
    
    if ($cleaned > 0) {
        error_log("Log cleanup: Truncated $cleaned large log files");
    }
    
    return $cleaned;
}

// Run cleanup if called directly or via cron
// ✅ FIX: Only output if called directly, not when included
// Check if this file is being executed directly (not included via require/include)
$script_name = $_SERVER['PHP_SELF'] ?? '';
$is_direct_call = (basename($script_name) == 'cache_cleanup.php' && strpos($script_name, 'cache_cleanup.php') !== false);
$is_cli = (php_sapi_name() === 'cli');

// Only run cleanup and output if this is a direct call (not included)
if ($is_direct_call || ($is_cli && isset($argv) && basename($argv[0] ?? '') == 'cache_cleanup.php')) {
    $cache_cleaned = cleanup_expired_cache();
    $smarty_cleaned = cleanup_smarty_cache();
    $logs_cleaned = cleanup_old_logs();
    
    $total_cleaned = $cache_cleaned + $smarty_cleaned + $logs_cleaned;
    
    if ($is_cli && $is_direct_call) {
        echo "Cleanup completed:\n";
        echo "- Cache files: $cache_cleaned\n";
        echo "- Smarty templates: $smarty_cleaned\n";
        echo "- Log files: $logs_cleaned\n";
        echo "Total: $total_cleaned files processed\n";
    } elseif ($is_direct_call && !$is_cli && isset($_GET['cleanup'])) {
        header('Content-Type: application/json');
        echo json_encode([
            'success' => true,
            'cache_cleaned' => $cache_cleaned,
            'smarty_cleaned' => $smarty_cleaned,
            'logs_cleaned' => $logs_cleaned,
            'total' => $total_cleaned
        ]);
    }
}

// Auto-cleanup function (call this periodically)
function auto_cleanup() {
    // Run cleanup with 1% probability on each request
    // ✅ FIX: Only log, don't output when called automatically
    if (rand(1, 100) === 1) {
        $cache_cleaned = cleanup_expired_cache();
        $smarty_cleaned = cleanup_smarty_cache();
        $logs_cleaned = cleanup_old_logs();
        
        // Only log if something was cleaned
        if ($cache_cleaned > 0 || $smarty_cleaned > 0 || $logs_cleaned > 0) {
            error_log("Auto-cleanup: Cache=$cache_cleaned, Smarty=$smarty_cleaned, Logs=$logs_cleaned");
        }
    }
}

?>
