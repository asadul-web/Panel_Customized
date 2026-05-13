<?php
/**
 * Android App Notice API
 * Returns active notices for the Android app
 * 
 * Usage: GET /api/app_notice.php
 * Optional: ?version=1.0.0 (to filter by app version)
 * 
 * Response: JSON array of notices
 */
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../includes/functions.php';

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

// Set UTF8MB4 for emoji support
@$db->sql_query("SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci");

// Get optional version parameter
$app_version = isset($_GET['version']) ? strip_tags(trim($_GET['version'])) : null;

// Check if table exists
$check_table = $db->sql_query("SHOW TABLES LIKE 'app_notices'");
if($db->sql_numrows($check_table) == 0){
    echo json_encode([
        'status' => 'success',
        'notices' => [],
        'count' => 0,
        'message' => 'No notices configured'
    ]);
    exit;
}

// Get active notices ordered by priority
$sql = "SELECT id, title, message, notice_type, show_button, button_text, button_url, min_version, max_version, priority, created_at 
        FROM app_notices 
        WHERE is_active = 1 
        ORDER BY priority DESC, created_at DESC";

$query = $db->sql_query($sql);
$notices = array();

while($row = $db->sql_fetchrow($query)){
    // Check version filter if app version is provided
    if($app_version !== null){
        $min_ver = $row['min_version'];
        $max_ver = $row['max_version'];
        
        // Skip if version doesn't match criteria
        if(!empty($min_ver) && version_compare($app_version, $min_ver, '<')){
            continue;
        }
        if(!empty($max_ver) && version_compare($app_version, $max_ver, '>')){
            continue;
        }
    }
    
    $notice = array(
        'id' => intval($row['id']),
        'title' => $row['title'],
        'message' => $row['message'],
        'type' => $row['notice_type'],
        'priority' => intval($row['priority']),
        'created_at' => $row['created_at']
    );
    
    // Add button info if enabled
    if($row['show_button'] == 1){
        $notice['button'] = array(
            'show' => true,
            'text' => $row['button_text'],
            'url' => $row['button_url']
        );
    }else{
        $notice['button'] = array(
            'show' => false
        );
    }
    
    $notices[] = $notice;
}

// Response
$response = array(
    'status' => 'success',
    'notices' => $notices,
    'count' => count($notices),
    'timestamp' => time(),
    'date' => date('Y-m-d H:i:s')
);

echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>
