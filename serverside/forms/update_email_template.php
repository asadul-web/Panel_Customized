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
        $values['msg'] = 'Unauthorized - Please login as admin';
        echo json_encode($values);
        exit;
    }
    
    if(!isset($user_level_2) || ($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator')) {
        $values['response'] = 2;
        $values['msg'] = 'Insufficient permissions - Admin access required';
        echo json_encode($values);
        exit;
    }
    
    // Get form data
    $template_id = isset($_POST['template_id']) ? intval($_POST['template_id']) : 0;
    $name = isset($_POST['name']) ? trim($_POST['name']) : '';
    $subject = isset($_POST['subject']) ? trim($_POST['subject']) : '';
    $content = isset($_POST['content']) ? trim($_POST['content']) : '';
    $content_type = isset($_POST['content_type']) ? trim($_POST['content_type']) : 'html';
    $template_type = isset($_POST['template_type']) ? trim($_POST['template_type']) : 'custom';
    $is_active = isset($_POST['is_active']) ? intval($_POST['is_active']) : 1;
    
    // Validate required fields
    if(empty($template_id)) {
        $values['response'] = 2;
        $values['msg'] = 'Missing template ID';
        echo json_encode($values);
        exit;
    }
    
    if(empty($name)) {
        $values['response'] = 2;
        $values['msg'] = 'Template name is required';
        echo json_encode($values);
        exit;
    }
    
    if(empty($subject)) {
        $values['response'] = 2;
        $values['msg'] = 'Email subject is required';
        echo json_encode($values);
        exit;
    }
    
    if(empty($content)) {
        $values['response'] = 2;
        $values['msg'] = 'Email content is required';
        echo json_encode($values);
        exit;
    }
    
    // Validate content type
    if(!in_array($content_type, array('html', 'text'))) {
        $content_type = 'html';
    }
    
    // Validate template type
    if(!in_array($template_type, array('newsletter', 'promotion', 'announcement', 'welcome', 'custom'))) {
        $template_type = 'custom';
    }
    
    // Check if template exists
    $check_query = "SELECT id, name FROM email_templates WHERE id = $template_id";
    $check_result = $db->sql_query($check_query);
    
    if(!$check_result || $db->sql_numrows($check_result) == 0) {
        $values['response'] = 2;
        $values['msg'] = 'Template not found';
        echo json_encode($values);
        exit;
    }
    
    $existing_template = $db->sql_fetchrow($check_result);
    
    // Check if template name already exists (excluding current template)
    $name_check_query = "SELECT id FROM email_templates WHERE name = '".addslashes($name)."' AND id != $template_id";
    $name_check_result = $db->sql_query($name_check_query);
    
    if($name_check_result && $db->sql_numrows($name_check_result) > 0) {
        $values['response'] = 2;
        $values['msg'] = 'A template with this name already exists';
        echo json_encode($values);
        exit;
    }
    
    // Escape data for database
    $name_escaped = addslashes($name);
    $subject_escaped = addslashes($subject);
    $content_escaped = addslashes($content);
    $content_type_escaped = addslashes($content_type);
    $template_type_escaped = addslashes($template_type);
    
    // Update template
    $update_query = "UPDATE email_templates SET 
                    name = '$name_escaped',
                    subject = '$subject_escaped',
                    content = '$content_escaped',
                    content_type = '$content_type_escaped',
                    template_type = '$template_type_escaped',
                    updated_date = '".date('Y-m-d H:i:s')."',
                    is_active = $is_active
                    WHERE id = $template_id";
    
    if($db->sql_query($update_query)) {
        
        // Log activity
        $action = "Updated email template: $name";
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                      VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                      '".$_SERVER['REMOTE_ADDR']."', '', '')";
        $db->sql_query($log_query);
        
        $values['response'] = 1;
        $values['msg'] = "Template '$name' updated successfully!";
        
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to update template. Database error.';
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
}

echo json_encode($values);
?>

