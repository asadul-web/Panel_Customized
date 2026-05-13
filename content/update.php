<?php
// Update page - displays Info Edit content only

// Handle cache clear request
if(isset($_GET['clear_cache']) && $_GET['clear_cache'] == '1') {
    // Clear Smarty cache
    $smarty->clearAllCache();
    $smarty->clearCompiledTemplate();
    
    // Clear PHP opcache if available
    if (function_exists('opcache_reset')) {
        opcache_reset();
    }
    
    // Clear any custom cache files
    $cache_dir = 'cache/';
    if (is_dir($cache_dir)) {
        $files = glob($cache_dir . '*');
        foreach($files as $file) {
            if(is_file($file)) {
                unlink($file);
            }
        }
    }
    
    // Clear templates_c directory
    $templates_c_dir = 'templates_c/';
    if (is_dir($templates_c_dir)) {
        $files = glob($templates_c_dir . '*');
        foreach($files as $file) {
            if(is_file($file)) {
                unlink($file);
            }
        }
    }
    
    // Redirect back to update page with success message
    header("Location: " . $_SERVER['PHP_SELF'] . "?cache_cleared=1");
    exit;
}

if(!is_logged_in($user)){
    $btn_val = 'Login Page';
    $btn_link = 'login';
}else{
    $btn_val = 'Dashboard';
    $btn_link = 'dashboard';
}

// Update hit counter
$totalhits = $db->sql_query("UPDATE site_options SET hits=hits + 1");
$smarty->assign("totalhits", $totalhits);

// Check if cache was cleared
$cache_cleared = isset($_GET['cache_cleared']) ? true : false;
$smarty->assign('cache_cleared', $cache_cleared);

// Assign navigation variables
$smarty->assign('btn_value', $btn_val);
$smarty->assign('btn_link', $btn_link);

// Display the template
$smarty->display("update-information.tpl");
?>
