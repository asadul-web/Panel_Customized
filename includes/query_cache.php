<?php
/**
 * Query Cache Helper
 * Caches frequently used database queries for better performance
 */

class QueryCache {
    private static $cache = [];
    private static $cache_duration = 300; // 5 minutes default
    
    /**
     * Get cached query result or execute and cache
     */
    public static function get($key, $callback, $duration = null) {
        $duration = $duration ?? self::$cache_duration;
        
        // Check if cached and not expired
        if (isset(self::$cache[$key])) {
            $cached = self::$cache[$key];
            if (time() - $cached['time'] < $duration) {
                return $cached['data'];
            }
        }
        
        // Execute callback and cache result
        $data = $callback();
        self::$cache[$key] = [
            'data' => $data,
            'time' => time()
        ];
        
        return $data;
    }
    
    /**
     * Clear specific cache key
     */
    public static function clear($key) {
        unset(self::$cache[$key]);
    }
    
    /**
     * Clear all cache
     */
    public static function clearAll() {
        self::$cache = [];
    }
    
    /**
     * Get user count with caching
     */
    public static function getUserCount($db, $level = null) {
        $key = 'user_count_' . ($level ?? 'all');
        return self::get($key, function() use ($db, $level) {
            if ($level) {
                $query = "SELECT COUNT(*) as count FROM users WHERE is_groupname='" . $db->Sanitize($level) . "'";
            } else {
                $query = "SELECT COUNT(*) as count FROM users";
            }
            $result = $db->sql_query($query);
            $row = $db->sql_fetchrow($result);
            return $row['count'] ?? 0;
        }, 300); // 5 minutes
    }
    
    /**
     * Get online users count with caching
     */
    public static function getOnlineCount($db) {
        return self::get('online_count', function() use ($db) {
            $query = "SELECT COUNT(DISTINCT user_name) as count FROM user_online";
            $result = $db->sql_query($query);
            $row = $db->sql_fetchrow($result);
            return $row['count'] ?? 0;
        }, 60); // 1 minute
    }
    
    /**
     * Get server count with caching
     */
    public static function getServerCount($db) {
        return self::get('server_count', function() use ($db) {
            $query = "SELECT COUNT(*) as count FROM server";
            $result = $db->sql_query($query);
            $row = $db->sql_fetchrow($result);
            return $row['count'] ?? 0;
        }, 300); // 5 minutes
    }
}
?>
