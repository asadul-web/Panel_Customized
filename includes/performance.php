<?php
/**
 * Performance Optimization Configuration
 * Include this file at the top of main entry points for better performance
 */

// Enable output buffering with GZIP compression
if (!ob_get_level() && extension_loaded('zlib')) {
    ob_start('ob_gzhandler');
} elseif (!ob_get_level()) {
    ob_start();
}

// Set memory limit for better performance
@ini_set('memory_limit', '256M');

// Optimize session handling
@ini_set('session.gc_maxlifetime', 3600);
@ini_set('session.cookie_lifetime', 0);
@ini_set('session.use_strict_mode', 1);

// Disable unnecessary PHP features for performance
@ini_set('expose_php', 'Off');
@ini_set('display_errors', 'Off');
@ini_set('log_errors', 'On');

// Optimize realpath cache
@ini_set('realpath_cache_size', '4096K');
@ini_set('realpath_cache_ttl', '600');

// Optimize OPcache if available
if (extension_loaded('opcache')) {
    @ini_set('opcache.enable', '1');
    @ini_set('opcache.memory_consumption', '128');
    @ini_set('opcache.max_accelerated_files', '4000');
    @ini_set('opcache.revalidate_freq', '60');
    @ini_set('opcache.fast_shutdown', '1');
}

// Set timezone to prevent warnings
if (!ini_get('date.timezone')) {
    date_default_timezone_set('UTC');
}

// Optimize file operations
@ini_set('auto_detect_line_endings', 'Off');
@ini_set('default_socket_timeout', '10');

// Security headers for performance and security
if (!headers_sent()) {
    header('X-Content-Type-Options: nosniff');
    header('X-Frame-Options: SAMEORIGIN');
    header('X-XSS-Protection: 1; mode=block');
    header('Referrer-Policy: strict-origin-when-cross-origin');
}
