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
    
    // Get template ID to delete
    $template_id = isset($_POST['template_id']) ? intval($_POST['template_id']) : 0;
    
    if(empty($template_id)) {
        $values['response'] = 2;
        $values['msg'] = 'Missing template ID';
        echo json_encode($values);
        exit;
    }
    
    // Get template details before deletion for logging
    $query = "SELECT id, name FROM email_templates WHERE id = $template_id";
    $result = $db->sql_query($query);
    
    if(!$result || $db->sql_numrows($result) == 0) {
        $values['response'] = 2;
        $values['msg'] = 'Template not found';
        echo json_encode($values);
        exit;
    }
    
    $template = $db->sql_fetchrow($result);
    $template_name = $template['name'];
    
    // Check if template is being used in any active campaigns or automations
    // This is a safety check to prevent deletion of templates that might be in use
    $usage_check_queries = array(
        "SELECT COUNT(*) as count FROM email_campaigns WHERE template_id = $template_id",
        "SELECT COUNT(*) as count FROM email_automations WHERE template_id = $template_id"
    );
    
    $is_in_use = false;
    $usage_details = array();
    
    foreach($usage_check_queries as $check_query) {
        $check_result = $db->sql_query($check_query);
        if($check_result) {
            $check_row = $db->sql_fetchrow($check_result);
            if($check_row['count'] > 0) {
                $is_in_use = true;
                $usage_details[] = $check_row['count'] . ' active usage(s) found';
            }
        }
    }
    
    // If template is in use, ask for confirmation or prevent deletion
    if($is_in_use && !isset($_POST['force_delete'])) {
        $values['response'] = 3; // Special response code for "in use" warning
        $values['msg'] = 'This template is currently being used in active campaigns or automations. Are you sure you want to delete it?';
        $values['usage_details'] = $usage_details;
        echo json_encode($values);
        exit;
    }
    
    // Perform the deletion
    $delete_query = "DELETE FROM email_templates WHERE id = $template_id";
    
    if($db->sql_query($delete_query)) {
        
        // Log activity
        $action = "Deleted email template: $template_name (ID: $template_id)";
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                      VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                      '".$_SERVER['REMOTE_ADDR']."', '', '')";
        $db->sql_query($log_query);
        
        $values['response'] = 1;
        $values['msg'] = "Template '$template_name' deleted successfully!";
        
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to delete template. Database error.';
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

