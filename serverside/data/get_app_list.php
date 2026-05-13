<?php
// Suppress warnings for clean JSON output
error_reporting(0);
ini_set('display_errors', '0');

// Start output buffering to catch any unwanted output
ob_start();

try {
    require_once '../../includes/config.php';
    
    // Simple authentication check - just check if we can access the database
    if(!isset($db) || !is_object($db)) {
        throw new Exception("Database not available");
    }
    
    $query = $db->sql_query("SELECT app_name, package_name FROM ads_apps ORDER BY app_name ASC");
    
    $apps = array();
    
    while($row = $db->sql_fetchrow($query)) {
        $apps[] = array(
            'app_name' => $row['app_name'],
            'package_name' => $row['package_name']
        );
    }
    
    $values = array(
        'response' => 1,
        'apps' => $apps
    );
    
} catch (Exception $e) {
    $values = array(
        'response' => 0,
        'apps' => array(),
        'error' => $e->getMessage()
    );
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
