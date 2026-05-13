<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json');

try {
    require_once '../../includes/functions.php';
    
    $values = array();
    
    // Debug: Check if database connection exists
    if (!isset($db)) {
        $values['response'] = 2;
        $values['msg'] = 'Database connection not available';
        echo json_encode($values);
        exit;
    }
    
    // Debug: Check user variables
    $debug_info = array(
        'user_isset' => isset($user),
        'user_id_2_isset' => isset($user_id_2),
        'user_level_2_isset' => isset($user_level_2),
        'user_level_2_value' => isset($user_level_2) ? $user_level_2 : 'not_set'
    );
    
    // Check if user is logged in and has proper permissions
    if(!isset($user) || !is_logged_in($user)) {
        $values['response'] = 2;
        $values['msg'] = 'Unauthorized - Please login as admin';
        $values['debug'] = $debug_info;
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
    $name = isset($_POST['name']) ? trim($_POST['name']) : '';
    $subject = isset($_POST['subject']) ? trim($_POST['subject']) : '';
    $content = isset($_POST['content']) ? trim($_POST['content']) : '';
    $content_type = isset($_POST['content_type']) ? trim($_POST['content_type']) : 'html';
    $template_type = isset($_POST['template_type']) ? trim($_POST['template_type']) : 'custom';
    $is_active = isset($_POST['is_active']) ? intval($_POST['is_active']) : 1;
    
    // Validate required fields
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
    
    // Check if template name already exists
    $check_query = "SELECT id FROM email_templates WHERE name = '".addslashes($name)."'";
    $check_result = $db->sql_query($check_query);
    
    if($check_result && $db->sql_numrows($check_result) > 0) {
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
    
    // Insert template
    $insert_query = "INSERT INTO email_templates 
                    (name, subject, content, content_type, template_type, created_by, created_date, is_active) 
                    VALUES (
                        '$name_escaped',
                        '$subject_escaped',
                        '$content_escaped',
                        '$content_type_escaped',
                        '$template_type_escaped',
                        $user_id_2,
                        '".date('Y-m-d H:i:s')."',
                        $is_active
                    )";
    
    if($db->sql_query($insert_query)) {
        $template_id = $db->sql_nextid();
        
        // Log activity
        $action = "Created email template: $name";
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                      VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                      '".$_SERVER['REMOTE_ADDR']."', '', '')";
        $db->sql_query($log_query);
        
        $values['response'] = 1;
        $values['msg'] = "Template '$name' created successfully!";
        $values['template_id'] = $template_id;
        
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to create template. Database error.';
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['response'] = 2;
    $values['msg'] = 'Fatal Error: ' . $e->getMessage();
}

echo json_encode($values);
?>

