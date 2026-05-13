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
    // Get saved email lists
    $lists_query = "SELECT id, name, description, email_count, created_date 
                    FROM email_lists 
                    WHERE created_by = $user_id_2 AND is_active = 1 
                    ORDER BY created_date DESC";
    $result = $db->sql_query($lists_query);
    
    $lists = array();
    if($result) {
        while($row = $db->sql_fetchrow($result)) {
            $lists[] = array(
                'id' => $row['id'],
                'name' => $row['name'],
                'description' => $row['description'],
                'email_count' => intval($row['email_count']),
                'created_date' => $row['created_date']
            );
        }
    }
    
    $values['response'] = 1;
    $values['lists'] = $lists;
    
} catch(Exception $e) {
    $values['response'] = 1;
    $values['lists'] = array();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

