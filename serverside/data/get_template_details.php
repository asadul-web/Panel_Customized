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
    
    // Get template ID
    $template_id = isset($_POST['template_id']) ? intval($_POST['template_id']) : 0;
    
    if(empty($template_id)) {
        $values['response'] = 2;
        $values['msg'] = 'Missing template ID';
        echo json_encode($values);
        exit;
    }
    
    // Get template details
    $query = "SELECT id, name, subject, content, content_type, template_type, is_active 
              FROM email_templates 
              WHERE id = $template_id";
    
    $result = $db->sql_query($query);
    
    if($result && $db->sql_numrows($result) > 0) {
        $template = $db->sql_fetchrow($result);
        
        $values['response'] = 1;
        $values['template'] = array(
            'id' => $template['id'],
            'name' => $template['name'],
            'subject' => $template['subject'],
            'content' => $template['content'],
            'content_type' => $template['content_type'],
            'template_type' => $template['template_type'],
            'is_active' => $template['is_active']
        );
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Template not found';
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
}

echo json_encode($values);
?>

