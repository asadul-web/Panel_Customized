<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json; charset=utf-8');

require_once '../../includes/functions.php';

$values = array();

// Check if user is logged in and has proper permissions
if(!is_logged_in($user)) {
    $values['response'] = 2;
    $values['msg'] = 'Unauthorized';
    echo json_encode($values);
    exit;
}

if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    $values['response'] = 2;
    $values['msg'] = 'Insufficient permissions';
    echo json_encode($values);
    exit;
}

$tags = isset($_POST['tags']) ? trim($_POST['tags']) : '';

if(empty($tags)) {
    $values['response'] = 1;
    $values['count'] = 0;
    echo json_encode($values);
    exit;
}

try {
    // Split tags and prepare for query
    $tag_array = array_map('trim', explode(',', $tags));
    $tag_conditions = array();
    
    foreach($tag_array as $tag) {
        if(!empty($tag)) {
            $tag_escaped = addslashes($tag);
            $tag_conditions[] = "tags LIKE '%$tag_escaped%'";
        }
    }
    
    if(empty($tag_conditions)) {
        $values['response'] = 1;
        $values['count'] = 0;
        echo json_encode($values);
        exit;
    }
    
    // Count subscribers with matching tags
    $count_query = "SELECT COUNT(*) as count FROM email_subscribers 
                    WHERE status = 'active' AND (" . implode(' OR ', $tag_conditions) . ")";
    $result = $db->sql_query($count_query);
    
    if($result) {
        $row = $db->sql_fetchrow($result);
        $values['response'] = 1;
        $values['count'] = intval($row['count']);
    } else {
        $values['response'] = 1;
        $values['count'] = 0;
    }
    
} catch(Exception $e) {
    $values['response'] = 1;
    $values['count'] = 0;
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

