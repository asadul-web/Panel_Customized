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
    
    // Get template ID to duplicate
    $template_id = isset($_POST['template_id']) ? intval($_POST['template_id']) : 0;
    
    if(empty($template_id)) {
        $values['response'] = 2;
        $values['msg'] = 'Missing template ID';
        echo json_encode($values);
        exit;
    }
    
    // Get original template details
    $query = "SELECT name, subject, content, content_type, template_type, is_active 
              FROM email_templates 
              WHERE id = $template_id";
    
    $result = $db->sql_query($query);
    
    if(!$result || $db->sql_numrows($result) == 0) {
        $values['response'] = 2;
        $values['msg'] = 'Original template not found';
        echo json_encode($values);
        exit;
    }
    
    $original_template = $db->sql_fetchrow($result);
    
    // Generate unique name for duplicate
    $base_name = $original_template['name'];
    $duplicate_name = $base_name . ' (Copy)';
    $counter = 1;
    
    // Check if name already exists and increment counter if needed
    while(true) {
        $check_query = "SELECT id FROM email_templates WHERE name = '".addslashes($duplicate_name)."'";
        $check_result = $db->sql_query($check_query);
        
        if(!$check_result || $db->sql_numrows($check_result) == 0) {
            break; // Name is unique
        }
        
        $counter++;
        $duplicate_name = $base_name . ' (Copy ' . $counter . ')';
        
        // Prevent infinite loop
        if($counter > 100) {
            $duplicate_name = $base_name . ' (Copy ' . time() . ')';
            break;
        }
    }
    
    // Escape data for database
    $name_escaped = addslashes($duplicate_name);
    $subject_escaped = addslashes($original_template['subject']);
    $content_escaped = addslashes($original_template['content']);
    $content_type_escaped = addslashes($original_template['content_type']);
    $template_type_escaped = addslashes($original_template['template_type']);
    $is_active = intval($original_template['is_active']);
    
    // Insert duplicate template
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
        
        // Log activity (optional, don't fail if this fails)
        try {
            $action = "Duplicated email template: $base_name -> $duplicate_name";
            $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                          VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                          '".$_SERVER['REMOTE_ADDR']."', '', '')";
            $db->sql_query($log_query);
        } catch(Exception $log_error) {
            // Ignore logging errors
        }
        
        $values['response'] = 1;
        $values['msg'] = "Template duplicated successfully as '$duplicate_name'!";
        $values['new_template_name'] = $duplicate_name;
        
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to duplicate template. Please try again.';
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['response'] = 2;
    $values['msg'] = 'System error: ' . $e->getMessage();
}

echo json_encode($values);
?>

