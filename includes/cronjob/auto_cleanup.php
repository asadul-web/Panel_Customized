<?php
/**
 * Auto Cleanup Script
 * - Removes error logs immediately
 * - Removes all logs older than 1 month
 * - Cleans up cache files
 * 
 * Run via cron: 0 0 * * * php /path/to/auto_cleanup.php
 */

// Prevent direct access via browser
if (php_sapi_name() !== 'cli' && !defined('CRON_RUNNING')) {
    // Allow running from panel
    if (!isset($_GET['key']) || $_GET['key'] !== 'firenet_cleanup_2024') {
        die('Access denied');
    }
}

// Configuration
$base_path = dirname(dirname(__DIR__));
$log_retention_days = 30; // Keep logs for 1 month
$cache_retention_days = 7; // Keep cache for 1 week

// Results tracking
$results = [
    'deleted_files' => 0,
    'deleted_size' => 0,
    'errors' => []
];

/**
 * Delete files matching pattern older than X days
 */
function cleanupFiles($directory, $pattern, $days, &$results) {
    if (!is_dir($directory)) {
        return;
    }
    
    $cutoff_time = time() - ($days * 24 * 60 * 60);
    $files = glob($directory . '/' . $pattern);
    
    foreach ($files as $file) {
        if (is_file($file)) {
            $file_time = filemtime($file);
            if ($file_time < $cutoff_time) {
                $size = filesize($file);
                if (@unlink($file)) {
                    $results['deleted_files']++;
                    $results['deleted_size'] += $size;
                } else {
                    $results['errors'][] = "Failed to delete: $file";
                }
            }
        }
    }
}

/**
 * Delete error log files immediately (any age)
 */
function cleanupErrorLogs($directory, &$results) {
    if (!is_dir($directory)) {
        return;
    }
    
    // Error log patterns to delete immediately
    $error_patterns = [
        '*error*.log',
        '*debug*.log',
        'php_errors.log',
        'error.log',
        'debug.log'
    ];
    
    foreach ($error_patterns as $pattern) {
        $files = glob($directory . '/' . $pattern);
        foreach ($files as $file) {
            if (is_file($file)) {
                $size = filesize($file);
                if (@unlink($file)) {
                    $results['deleted_files']++;
                    $results['deleted_size'] += $size;
                } else {
                    $results['errors'][] = "Failed to delete: $file";
                }
            }
        }
    }
}

/**
 * Clean activity logs from database older than X days
 */
function cleanupDatabaseLogs($days) {
    global $db;
    
    // Include database if not already loaded
    if (!isset($db)) {
        $config_file = dirname(__DIR__) . '/config.php';
        if (file_exists($config_file)) {
            require_once $config_file;
        } else {
            return ['deleted' => 0, 'error' => 'Config not found'];
        }
    }
    
    $cutoff_date = date('Y-m-d H:i:s', strtotime("-$days days"));
    
    // Count before delete
    $count_sql = "SELECT COUNT(*) as total FROM activity_logs WHERE date < '$cutoff_date'";
    $count_query = $db->sql_query($count_sql);
    $count_row = $db->sql_fetchrow($count_query);
    $to_delete = $count_row['total'];
    
    // Delete old logs
    $delete_sql = "DELETE FROM activity_logs WHERE date < '$cutoff_date'";
    $db->sql_query($delete_sql);
    
    return ['deleted' => $to_delete, 'error' => null];
}

// ============================================
// CLEANUP EXECUTION
// ============================================

echo "=== Firenet Auto Cleanup Script ===\n";
echo "Started: " . date('Y-m-d H:i:s') . "\n\n";

// 1. Delete error logs immediately
echo "1. Cleaning error logs...\n";
cleanupErrorLogs($base_path . '/logs', $results);
cleanupErrorLogs($base_path . '/api/authentication', $results);

// 2. Clean all log files older than 1 month
echo "2. Cleaning old log files (>$log_retention_days days)...\n";
cleanupFiles($base_path . '/logs', '*.log', $log_retention_days, $results);
cleanupFiles($base_path . '/api/authentication', '*.log', $log_retention_days, $results);

// 3. Clean cache files older than 1 week
echo "3. Cleaning old cache files (>$cache_retention_days days)...\n";
cleanupFiles($base_path . '/includes/backup', '*.json', $cache_retention_days, $results);

// 4. Clean Smarty compiled templates older than 1 week
echo "4. Cleaning Smarty cache...\n";
cleanupFiles($base_path . '/templates_c', '*.php', $cache_retention_days, $results);

// 5. Clean database activity logs older than 1 month
echo "5. Cleaning database activity logs...\n";
$db_result = cleanupDatabaseLogs($log_retention_days);
if ($db_result['error']) {
    $results['errors'][] = $db_result['error'];
} else {
    echo "   Deleted {$db_result['deleted']} database log entries\n";
}

// ============================================
// RESULTS
// ============================================

echo "\n=== Cleanup Results ===\n";
echo "Files deleted: {$results['deleted_files']}\n";
echo "Space freed: " . formatBytes($results['deleted_size']) . "\n";

if (!empty($results['errors'])) {
    echo "\nErrors:\n";
    foreach ($results['errors'] as $error) {
        echo "  - $error\n";
    }
}

echo "\nCompleted: " . date('Y-m-d H:i:s') . "\n";

/**
 * Format bytes to human readable
 */
function formatBytes($bytes) {
    if ($bytes >= 1073741824) {
        return number_format($bytes / 1073741824, 2) . ' GB';
    } elseif ($bytes >= 1048576) {
        return number_format($bytes / 1048576, 2) . ' MB';
    } elseif ($bytes >= 1024) {
        return number_format($bytes / 1024, 2) . ' KB';
    } else {
        return $bytes . ' bytes';
    }
}

// Return JSON if called via HTTP
if (php_sapi_name() !== 'cli') {
    header('Content-Type: application/json');
    echo json_encode([
        'success' => true,
        'deleted_files' => $results['deleted_files'],
        'deleted_size' => formatBytes($results['deleted_size']),
        'db_logs_deleted' => $db_result['deleted'] ?? 0,
        'errors' => $results['errors']
    ]);
}
?>
