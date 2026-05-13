<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json');

try {
    require_once '../../includes/functions.php';
    
    $values = array();
    
    // Check if user is logged in and has proper permissions
    if(!isset($user) || !is_logged_in($user)) {
        $values['response'] = 2;
        $values['msg'] = 'Unauthorized';
        echo json_encode($values);
        exit;
    }
    
    if(!isset($user_level_2) || ($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator')) {
        $values['response'] = 2;
        $values['msg'] = 'Insufficient permissions';
        echo json_encode($values);
        exit;
    }
    
    // Get all templates
    $query = "SELECT id, name, subject, content, content_type, template_type, created_date, updated_date, is_active 
              FROM email_templates 
              ORDER BY created_date DESC";
    
    $result = $db->sql_query($query);
    
    $templates = array();
    if($result) {
        while($row = $db->sql_fetchrow($result)) {
            $templates[] = array(
                'id' => $row['id'],
                'name' => htmlspecialchars($row['name']),
                'subject' => htmlspecialchars($row['subject']),
                'content' => $row['content'], // Don't escape content as it may contain HTML
                'content_type' => $row['content_type'],
                'template_type' => $row['template_type'],
                'created_date' => $row['created_date'],
                'updated_date' => $row['updated_date'],
                'is_active' => $row['is_active'],
                'content_preview' => substr(strip_tags($row['content']), 0, 100) . '...'
            );
        }
    }
    
    $values['response'] = 1;
    $values['templates'] = $templates;
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
}

echo json_encode($values);
?>

