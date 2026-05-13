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
    $slider_id = isset($_POST['slider_id']) ? intval($_POST['slider_id']) : 0;
    $page_name = isset($_POST['page_name']) ? trim($_POST['page_name']) : 'site-info';
    $text_content = isset($_POST['text_content']) ? trim($_POST['text_content']) : '';
    $is_active = isset($_POST['is_active']) ? intval($_POST['is_active']) : 1;
    $display_order = isset($_POST['display_order']) ? intval($_POST['display_order']) : 1;
    
    // Validate required fields
    if(empty($text_content)) {
        $values['response'] = 2;
        $values['msg'] = 'Slider text content is required';
        echo json_encode($values);
        exit;
    }
    
    // Escape data for database
    $page_name_escaped = addslashes($page_name);
    $text_content_escaped = addslashes($text_content);
    
    // Create table if it doesn't exist
    $create_table_query = "CREATE TABLE IF NOT EXISTS slider_content (
        id INT AUTO_INCREMENT PRIMARY KEY,
        page_name VARCHAR(100) NOT NULL,
        text_content TEXT NOT NULL,
        is_active TINYINT(1) DEFAULT 1,
        display_order INT DEFAULT 1,
        created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_page_name (page_name),
        INDEX idx_display_order (display_order)
    )";
    $db->sql_query($create_table_query);
    
    if($slider_id > 0) {
        // Update existing slider content
        $update_query = "UPDATE slider_content SET 
                        text_content = '$text_content_escaped',
                        is_active = $is_active,
                        display_order = $display_order,
                        updated_date = '".date('Y-m-d H:i:s')."'
                        WHERE id = $slider_id";
        
        if($db->sql_query($update_query)) {
            // Log activity
            $action = "Updated site slider content: " . substr($text_content, 0, 50) . "...";
            $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                          VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                          '".$_SERVER['REMOTE_ADDR']."', '', '')";
            $db->sql_query($log_query);
            
            $values['response'] = 1;
            $values['msg'] = "Slider content updated successfully!";
        } else {
            $values['response'] = 2;
            $values['msg'] = 'Failed to update slider content. Database error: ' . $db->sql_error();
        }
    } else {
        // Insert new slider content
        $insert_query = "INSERT INTO slider_content 
                        (page_name, text_content, is_active, display_order, created_date) 
                        VALUES (
                            '$page_name_escaped',
                            '$text_content_escaped',
                            $is_active,
                            $display_order,
                            '".date('Y-m-d H:i:s')."'
                        )";
        
        if($db->sql_query($insert_query)) {
            $slider_id = $db->sql_nextid();
            
            // Log activity
            $action = "Created site slider content: " . substr($text_content, 0, 50) . "...";
            $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                          VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                          '".$_SERVER['REMOTE_ADDR']."', '', '')";
            $db->sql_query($log_query);
            
            $values['response'] = 1;
            $values['msg'] = "Slider content created successfully!";
            $values['slider_id'] = $slider_id;
        } else {
            $values['response'] = 2;
            $values['msg'] = 'Failed to create slider content. Database error: ' . $db->sql_error();
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

