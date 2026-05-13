<?php
/**
 * Asset Optimization for CSS and JavaScript
 * Minifies and combines assets for better performance
 */

class AssetOptimizer {
    private $cache_dir;
    private $cache_time = 3600; // 1 hour
    
    public function __construct($cache_dir = null) {
        $this->cache_dir = $cache_dir ?: __DIR__ . '/../cache/assets/';
        if (!is_dir($this->cache_dir)) {
            @mkdir($this->cache_dir, 0755, true);
        }
    }
    
    /**
     * Minify CSS content
     */
    public function minifyCSS($css) {
        // Remove comments
        $css = preg_replace('!/\*[^*]*\*+([^/][^*]*\*+)*/!', '', $css);
        // Remove whitespace
        $css = str_replace(["\r\n", "\r", "\n", "\t", '  ', '    ', '    '], '', $css);
        // Remove unnecessary spaces
        $css = preg_replace('/\s+/', ' ', $css);
        $css = str_replace(['; ', ' {', '{ ', ' }', '} ', ': ', ', '], [';', '{', '{', '}', '}', ':', ','], $css);
        return trim($css);
    }
    
    /**
     * Minify JavaScript content
     */
    public function minifyJS($js) {
        // Remove single line comments (but preserve URLs)
        $js = preg_replace('/(?<!:)\/\/.*$/m', '', $js);
        // Remove multi-line comments
        $js = preg_replace('/\/\*[\s\S]*?\*\//', '', $js);
        // Remove extra whitespace
        $js = preg_replace('/\s+/', ' ', $js);
        // Remove spaces around operators
        $js = preg_replace('/\s*([{}();,=+\-*\/])\s*/', '$1', $js);
        return trim($js);
    }
    
    /**
     * Combine and minify CSS files
     */
    public function combineCSS($files, $cache_name = 'combined') {
        $cache_file = $this->cache_dir . $cache_name . '.min.css';
        $cache_time = file_exists($cache_file) ? filemtime($cache_file) : 0;
        
        // Check if any source file is newer than cache
        $needs_update = false;
        foreach ($files as $file) {
            if (!file_exists($file) || filemtime($file) > $cache_time) {
                $needs_update = true;
                break;
            }
        }
        
        if ($needs_update || !file_exists($cache_file)) {
            $combined = '';
            foreach ($files as $file) {
                if (file_exists($file)) {
                    $css = file_get_contents($file);
                    $combined .= $this->minifyCSS($css) . "\n";
                }
            }
            file_put_contents($cache_file, $combined);
        }
        
        return str_replace(__DIR__ . '/../', '/', $cache_file);
    }
    
    /**
     * Combine and minify JavaScript files
     */
    public function combineJS($files, $cache_name = 'combined') {
        $cache_file = $this->cache_dir . $cache_name . '.min.js';
        $cache_time = file_exists($cache_file) ? filemtime($cache_file) : 0;
        
        // Check if any source file is newer than cache
        $needs_update = false;
        foreach ($files as $file) {
            if (!file_exists($file) || filemtime($file) > $cache_time) {
                $needs_update = true;
                break;
            }
        }
        
        if ($needs_update || !file_exists($cache_file)) {
            $combined = '';
            foreach ($files as $file) {
                if (file_exists($file)) {
                    $js = file_get_contents($file);
                    $combined .= $this->minifyJS($js) . ";\n";
                }
            }
            file_put_contents($cache_file, $combined);
        }
        
        return str_replace(__DIR__ . '/../', '/', $cache_file);
    }
    
    /**
     * Generate optimized asset URLs with versioning
     */
    public function getAssetUrl($file, $version = null) {
        if (!$version && file_exists($file)) {
            $version = filemtime($file);
        }
        return $file . ($version ? '?v=' . $version : '');
    }
}
?>
