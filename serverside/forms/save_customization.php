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
    $page_name = isset($_POST['page_name']) ? trim($_POST['page_name']) : 'site-info';
    $customization_type = isset($_POST['customization_type']) ? trim($_POST['customization_type']) : '';
    $customization_data = isset($_POST['customization_data']) ? $_POST['customization_data'] : array();
    
    if(empty($customization_type) || empty($customization_data)) {
        $values['response'] = 2;
        $values['msg'] = 'Missing customization data';
        echo json_encode($values);
        exit;
    }
    
    // Escape data for database
    $page_name_escaped = addslashes($page_name);
    $customization_type_escaped = addslashes($customization_type);
    $customization_data_json = json_encode($customization_data);
    $customization_data_escaped = addslashes($customization_data_json);
    
    // Create table if it doesn't exist
    $create_table_query = "CREATE TABLE IF NOT EXISTS page_customizations (
        id INT AUTO_INCREMENT PRIMARY KEY,
        page_name VARCHAR(100) NOT NULL,
        customization_type VARCHAR(50) NOT NULL,
        customization_data TEXT NOT NULL,
        user_id INT NOT NULL,
        created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_page_name (page_name),
        INDEX idx_customization_type (customization_type),
        UNIQUE KEY unique_page_customization (page_name, customization_type)
    )";
    $db->sql_query($create_table_query);
    
    // Check if customization exists
    $check_query = "SELECT id FROM page_customizations 
                    WHERE page_name = '$page_name_escaped' 
                    AND customization_type = '$customization_type_escaped'";
    $check_result = $db->sql_query($check_query);
    
    if($db->sql_numrows($check_result) > 0) {
        // Update existing customization
        $update_query = "UPDATE page_customizations SET 
                        customization_data = '$customization_data_escaped',
                        user_id = $user_id_2,
                        updated_date = '".date('Y-m-d H:i:s')."'
                        WHERE page_name = '$page_name_escaped' 
                        AND customization_type = '$customization_type_escaped'";
        
        if($db->sql_query($update_query)) {
            $action = "Updated";
        } else {
            throw new Exception("Failed to update customization: " . $db->sql_error());
        }
    } else {
        // Insert new customization
        $insert_query = "INSERT INTO page_customizations 
                        (page_name, customization_type, customization_data, user_id, created_date) 
                        VALUES (
                            '$page_name_escaped',
                            '$customization_type_escaped',
                            '$customization_data_escaped',
                            $user_id_2,
                            '".date('Y-m-d H:i:s')."'
                        )";
        
        if($db->sql_query($insert_query)) {
            $action = "Created";
        } else {
            throw new Exception("Failed to save customization: " . $db->sql_error());
        }
    }
    
    // Log activity
    $log_action = "$action page customization: $customization_type for $page_name";
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($log_action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
    
    $values['response'] = 1;
    $values['msg'] = 'Customization saved successfully!';
    $values['action'] = $action;
    $values['type'] = $customization_type;
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['response'] = 2;
    $values['msg'] = 'Fatal Error: ' . $e->getMessage();
}

echo json_encode($values);
?>

