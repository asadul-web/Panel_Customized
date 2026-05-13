<?php
/**
 * Simple File-based Caching System
 * Improves performance by caching database queries and API responses
 */

if (!class_exists('CacheManager')) {
class CacheManager {
    private $cache_dir;
    private $default_ttl = 3600; // 1 hour
    
    public function __construct($cache_dir = null) {
        $this->cache_dir = $cache_dir ?: __DIR__ . '/../cache/data/';
        if (!is_dir($this->cache_dir)) {
            @mkdir($this->cache_dir, 0755, true);
        }
    }
    
    /**
     * Generate cache key from data
     */
    private function getCacheKey($key) {
        return md5($key) . '.cache';
    }
    
    /**
     * Get cached data
     */
    public function get($key) {
        $cache_file = $this->cache_dir . $this->getCacheKey($key);
        
        if (!file_exists($cache_file)) {
            return null;
        }
        
        $data = @unserialize(file_get_contents($cache_file));
        if (!$data || !isset($data['expires']) || $data['expires'] < time()) {
            @unlink($cache_file);
            return null;
        }
        
        return $data['content'];
    }
    
    /**
     * Set cached data
     */
    public function set($key, $content, $ttl = null) {
        $ttl = $ttl ?: $this->default_ttl;
        $cache_file = $this->cache_dir . $this->getCacheKey($key);
        
        $data = [
            'content' => $content,
            'expires' => time() + $ttl,
            'created' => time()
        ];
        
        return @file_put_contents($cache_file, serialize($data)) !== false;
    }
    
    /**
     * Delete cached data
     */
    public function delete($key) {
        $cache_file = $this->cache_dir . $this->getCacheKey($key);
        return @unlink($cache_file);
    }
    
    /**
     * Clear all cache
     */
    public function clear() {
        $files = glob($this->cache_dir . '*.cache');
        $cleared = 0;
        foreach ($files as $file) {
            if (@unlink($file)) {
                $cleared++;
            }
        }
        return $cleared;
    }
    
    /**
     * Cache database query results
     */
    public function cacheQuery($sql, $callback, $ttl = 300) {
        $key = 'query_' . md5($sql);
        $result = $this->get($key);
        
        if ($result === null) {
            $result = $callback();
            if ($result !== false) {
                $this->set($key, $result, $ttl);
            }
        }
        
        return $result;
    }
    
    /**
     * Get cache statistics
     */
    public function getStats() {
        $files = glob($this->cache_dir . '*.cache');
        $total_size = 0;
        $expired = 0;
        
        foreach ($files as $file) {
            $total_size += filesize($file);
            $data = @unserialize(file_get_contents($file));
            if ($data && isset($data['expires']) && $data['expires'] < time()) {
                $expired++;
            }
        }
        
        return [
            'total_files' => count($files),
            'total_size' => $total_size,
            'expired_files' => $expired,
            'cache_dir' => $this->cache_dir
        ];
    }
    
    /**
     * Clean expired cache files
     */
    public function cleanup() {
        $files = glob($this->cache_dir . '*.cache');
        $cleaned = 0;
        
        foreach ($files as $file) {
            $data = @unserialize(file_get_contents($file));
            if (!$data || !isset($data['expires']) || $data['expires'] < time()) {
                if (@unlink($file)) {
                    $cleaned++;
                }
            }
        }
        
        return $cleaned;
    }
}
}

// Global cache instance (only if class was defined)
if (class_exists('CacheManager')) {
    $cache = new CacheManager();
}
