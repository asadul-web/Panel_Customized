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
        $values['success'] = false;
        $values['response'] = 2;
        $values['msg'] = 'Unauthorized - Please login as admin';
        echo json_encode($values);
        exit;
    }
    
    if(!isset($user_level_2) || ($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator')) {
        $values['success'] = false;
        $values['response'] = 2;
        $values['msg'] = 'Insufficient permissions - Admin access required';
        echo json_encode($values);
        exit;
    }
    
    // Get form data
    $page_name = isset($_POST['page_name']) ? trim($_POST['page_name']) : 'site-info';
    $changes = array();
    
    // Handle both 'changes' and 'content_updates' parameters
    if(isset($_POST['changes'])) {
        $changes = $_POST['changes'];
    } elseif(isset($_POST['content_updates'])) {
        $changes = json_decode($_POST['content_updates'], true);
        if(json_last_error() !== JSON_ERROR_NONE) {
            $changes = $_POST['content_updates'];
        }
    }
    
    if(empty($changes)) {
        $values['success'] = false;
        $values['response'] = 2;
        $values['msg'] = 'No changes to save';
        echo json_encode($values);
        exit;
    }
    
    // Escape page name for database
    $page_name_escaped = addslashes($page_name);
    
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
    
    $updated_sections = array();
    $errors = array();
    
    // Process each change
    foreach($changes as $section_name => $new_content) {
        $section_name_escaped = addslashes($section_name);
        $new_content_escaped = addslashes($new_content);
        
        // Check if section exists
        $check_query = "SELECT id FROM page_content WHERE page_name = '$page_name_escaped' AND section_name = '$section_name_escaped'";
        $check_result = $db->sql_query($check_query);
        
        if($db->sql_numrows($check_result) > 0) {
            // Update existing section
            $update_query = "UPDATE page_content SET 
                            section_content = '$new_content_escaped',
                            updated_date = '".date('Y-m-d H:i:s')."'
                            WHERE page_name = '$page_name_escaped' AND section_name = '$section_name_escaped'";
            
            if($db->sql_query($update_query)) {
                $updated_sections[] = $section_name;
            } else {
                $errors[] = "Failed to update $section_name: " . $db->sql_error();
            }
        } else {
            // Insert new section
            $insert_query = "INSERT INTO page_content 
                            (page_name, section_name, section_content, section_type, is_active, section_order, created_date) 
                            VALUES (
                                '$page_name_escaped',
                                '$section_name_escaped',
                                '$new_content_escaped',
                                'text',
                                1,
                                1,
                                '".date('Y-m-d H:i:s')."'
                            )";
            
            if($db->sql_query($insert_query)) {
                $updated_sections[] = $section_name;
            } else {
                $errors[] = "Failed to create $section_name: " . $db->sql_error();
            }
        }
    }
    
    // Log activity
    if(!empty($updated_sections)) {
        $action = "Bulk updated site content: " . implode(', ', $updated_sections);
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                      VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                      '".$_SERVER['REMOTE_ADDR']."', '', '')";
        $db->sql_query($log_query);
    }
    
    // Prepare response
    if(!empty($errors)) {
        $values['success'] = false;
        $values['response'] = 2;
        $values['msg'] = 'Some updates failed: ' . implode('; ', $errors);
        $values['updated'] = $updated_sections;
        $values['errors'] = $errors;
    } else {
        $values['success'] = true;
        $values['response'] = 1;
        $values['msg'] = 'Successfully updated ' . count($updated_sections) . ' content sections!';
        $values['updated'] = $updated_sections;
    }
    
} catch(Exception $e) {
    $values['success'] = false;
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['success'] = false;
    $values['response'] = 2;
    $values['msg'] = 'Fatal Error: ' . $e->getMessage();
}

echo json_encode($values);
?>

