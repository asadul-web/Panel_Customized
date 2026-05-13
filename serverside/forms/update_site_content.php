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
    $content_id = isset($_POST['content_id']) ? intval($_POST['content_id']) : 0;
    $page_name = isset($_POST['page_name']) ? trim($_POST['page_name']) : 'site-info';
    $section_name = isset($_POST['section_name']) ? trim($_POST['section_name']) : '';
    $section_content = isset($_POST['section_content']) ? trim($_POST['section_content']) : '';
    $section_type = isset($_POST['section_type']) ? trim($_POST['section_type']) : 'text';
    $is_active = isset($_POST['is_active']) ? intval($_POST['is_active']) : 1;
    $section_order = isset($_POST['section_order']) ? intval($_POST['section_order']) : 1;
    
    // Validate required fields
    if(empty($section_name)) {
        $values['response'] = 2;
        $values['msg'] = 'Section name is required';
        echo json_encode($values);
        exit;
    }
    
    if(empty($section_content)) {
        $values['response'] = 2;
        $values['msg'] = 'Section content is required';
        echo json_encode($values);
        exit;
    }
    
    // Escape data for database
    $page_name_escaped = addslashes($page_name);
    $section_name_escaped = addslashes($section_name);
    $section_content_escaped = addslashes($section_content);
    $section_type_escaped = addslashes($section_type);
    
    // Create table if it doesn't exist
    $create_table_query = "CREATE TABLE IF NOT EXISTS page_content (
        id INT AUTO_INCREMENT PRIMARY KEY,
        page_name VARCHAR(100) NOT NULL,
        section_name VARCHAR(100) NOT NULL,
        section_content TEXT NOT NULL,
        section_type ENUM('text', 'textarea', 'html') DEFAULT 'text',
        is_active TINYINT(1) DEFAULT 1,
        section_order INT DEFAULT 1,
        created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_page_name (page_name),
        INDEX idx_section_order (section_order)
    )";
    $db->sql_query($create_table_query);
    
    if($content_id > 0) {
        // Update existing content
        $update_query = "UPDATE page_content SET 
                        section_name = '$section_name_escaped',
                        section_content = '$section_content_escaped',
                        section_type = '$section_type_escaped',
                        is_active = $is_active,
                        section_order = $section_order,
                        updated_date = '".date('Y-m-d H:i:s')."'
                        WHERE id = $content_id";
        
        if($db->sql_query($update_query)) {
            // Log activity
            $action = "Updated site content: $section_name";
            $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                          VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                          '".$_SERVER['REMOTE_ADDR']."', '', '')";
            $db->sql_query($log_query);
            
            $values['response'] = 1;
            $values['msg'] = "Content '$section_name' updated successfully!";
        } else {
            $values['response'] = 2;
            $values['msg'] = 'Failed to update content. Database error: ' . $db->sql_error();
        }
    } else {
        // Insert new content
        $insert_query = "INSERT INTO page_content 
                        (page_name, section_name, section_content, section_type, is_active, section_order, created_date) 
                        VALUES (
                            '$page_name_escaped',
                            '$section_name_escaped',
                            '$section_content_escaped',
                            '$section_type_escaped',
                            $is_active,
                            $section_order,
                            '".date('Y-m-d H:i:s')."'
                        )";
        
        if($db->sql_query($insert_query)) {
            $content_id = $db->sql_nextid();
            
            // Log activity
            $action = "Created site content: $section_name";
            $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                          VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                          '".$_SERVER['REMOTE_ADDR']."', '', '')";
            $db->sql_query($log_query);
            
            $values['response'] = 1;
            $values['msg'] = "Content '$section_name' created successfully!";
            $values['content_id'] = $content_id;
        } else {
            $values['response'] = 2;
            $values['msg'] = 'Failed to create content. Database error: ' . $db->sql_error();
        }
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

