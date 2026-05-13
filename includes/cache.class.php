<?php
/**
 * Simple File-based Caching System
 * Optimizes performance by caching frequently accessed data
 */

if (preg_match("/cache.class.php/i", $_SERVER['SCRIPT_NAME'])) {
    Header("Location: /"); die();
}

class SimpleCache {
    private $cache_dir;
    private $default_ttl = 3600; // 1 hour default
    
    public function __construct($cache_dir = null) {
        $this->cache_dir = $cache_dir ?: dirname(__FILE__) . '/../cache/';
        
        // Create cache directory if it doesn't exist
        if (!is_dir($this->cache_dir)) {
            mkdir($this->cache_dir, 0755, true);
        }
    }
    
    /**
     * Get cached data
     */
    public function get($key) {
        $file = $this->cache_dir . md5($key) . '.cache';
        
        if (!file_exists($file)) {
            return false;
        }
        
        $data = file_get_contents($file);
        $cache_data = unserialize($data);
        
        // Check if cache has expired
        if ($cache_data['expires'] < time()) {
            unlink($file);
            return false;
        }
        
        return $cache_data['data'];
    }
    
    /**
     * Set cache data
     */
    public function set($key, $data, $ttl = null) {
        $ttl = $ttl ?: $this->default_ttl;
        $file = $this->cache_dir . md5($key) . '.cache';
        
        $cache_data = array(
            'data' => $data,
            'expires' => time() + $ttl
        );
        
        return file_put_contents($file, serialize($cache_data), LOCK_EX) !== false;
    }
    
    /**
     * Delete cached data
     */
    public function delete($key) {
        $file = $this->cache_dir . md5($key) . '.cache';
        
        if (file_exists($file)) {
            return unlink($file);
        }
        
        return true;
    }
    
    /**
     * Clear all cache
     */
    public function clear() {
        $files = glob($this->cache_dir . '*.cache');
        foreach ($files as $file) {
            unlink($file);
        }
        return true;
    }
    
    /**
     * Get or set cache with callback
     */
    public function remember($key, $callback, $ttl = null) {
        $data = $this->get($key);
        
        if ($data === false) {
            $data = call_user_func($callback);
            $this->set($key, $data, $ttl);
        }
        
        return $data;
    }
    
    /**
     * Clean expired cache files
     */
    public function cleanup() {
        $files = glob($this->cache_dir . '*.cache');
        $cleaned = 0;
        
        foreach ($files as $file) {
            $data = file_get_contents($file);
            $cache_data = unserialize($data);
            
            if ($cache_data['expires'] < time()) {
                unlink($file);
                $cleaned++;
            }
        }
        
        return $cleaned;
    }
}

// Global cache instance
$cache = new SimpleCache();
?>
