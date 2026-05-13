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

try {
    // Count active subscribers
    $count_query = "SELECT COUNT(*) as count FROM email_subscribers WHERE status = 'active'";
    $result = $db->sql_query($count_query);
    
    if($result) {
        $row = $db->sql_fetchrow($result);
        $values['response'] = 1;
        $values['count'] = intval($row['count']);
    } else {
        // If email_subscribers table doesn't exist, return 0
        $values['response'] = 1;
        $values['count'] = 0;
    }
    
} catch(Exception $e) {
    $values['response'] = 1;
    $values['count'] = 0;
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

