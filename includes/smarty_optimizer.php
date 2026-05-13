<?php
/**
 * Smarty Template Optimization
 * Configures Smarty for better performance
 */

// Optimize Smarty configuration
if (isset($smarty)) {
    // Enable caching
    $smarty->setCaching(Smarty::CACHING_LIFETIME_CURRENT);
    $smarty->setCacheLifetime(3600); // 1 hour
    
    // Optimize compilation
    $smarty->setCompileCheck(false); // Disable in production
    $smarty->setForceCompile(false);
    
    // Set cache and compile directories
    $smarty->setCacheDir(__DIR__ . '/../cache/smarty/');
    $smarty->setCompileDir(__DIR__ . '/../templates_c/');
    
    // Create directories if they don't exist
    if (!is_dir(__DIR__ . '/../cache/smarty/')) {
        @mkdir(__DIR__ . '/../cache/smarty/', 0755, true);
    }
    
    // Security settings
    $smarty->enableSecurity();
    $smarty->setSecurityPolicy(new Smarty_Security($smarty));
    
    // Performance settings
    $smarty->setMergeCompiledIncludes(true);
    $smarty->setUseSubDirs(true);
    
    // Error handling
    $smarty->setErrorReporting(E_ALL & ~E_NOTICE);
    
    // Register common functions
    $smarty->registerPlugin('function', 'asset_url', function($params, $smarty) {
        $file = $params['file'] ?? '';
        if (file_exists(__DIR__ . '/../' . $file)) {
            return $file . '?v=' . filemtime(__DIR__ . '/../' . $file);
        }
        return $file;
    });
    
    $smarty->registerPlugin('modifier', 'format_bytes', function($bytes, $precision = 2) {
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }
        return round($bytes, $precision) . ' ' . $units[$i];
    });
    
    $smarty->registerPlugin('modifier', 'time_ago', function($timestamp) {
        $time = time() - strtotime($timestamp);
        if ($time < 60) return 'just now';
        if ($time < 3600) return floor($time/60) . ' minutes ago';
        if ($time < 86400) return floor($time/3600) . ' hours ago';
        if ($time < 2592000) return floor($time/86400) . ' days ago';
        return date('M j, Y', strtotime($timestamp));
    });
}

/**
 * Clear Smarty cache
 */
function clearSmartyCache() {
    global $smarty;
    if (isset($smarty)) {
        $smarty->clearAllCache();
        $smarty->clearCompiledTemplate();
        return true;
    }
    return false;
}

/**
 * Get Smarty cache statistics
 */
function getSmartyStats() {
    $cache_dir = __DIR__ . '/../cache/smarty/';
    $compile_dir = __DIR__ . '/../templates_c/';
    
    $cache_files = glob($cache_dir . '*');
    $compile_files = glob($compile_dir . '*');
    
    $cache_size = 0;
    foreach ($cache_files as $file) {
        if (is_file($file)) {
            $cache_size += filesize($file);
        }
    }
    
    $compile_size = 0;
    foreach ($compile_files as $file) {
        if (is_file($file)) {
            $compile_size += filesize($file);
        }
    }
    
    return [
        'cache_files' => count($cache_files),
        'cache_size' => $cache_size,
        'compile_files' => count($compile_files),
        'compile_size' => $compile_size
    ];
}
?>
