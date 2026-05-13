<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json; charset=utf-8');

require_once '../../includes/functions.php';

$values = array();

// Check if user is logged in and has proper permissions
if(!is_logged_in($user)) {
    $values['response'] = 2;
    $values['msg'] = 'Unauthorized';
    echo json_encode($values);
    exit;
}

if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    $values['response'] = 2;
    $values['msg'] = 'Insufficient permissions';
    echo json_encode($values);
    exit;
}

try {
    $updates_applied = array();
    
    // Check if email_campaigns table exists
    $table_check = "SHOW TABLES LIKE 'email_campaigns'";
    $table_result = $db->sql_query($table_check);
    
    if(!$table_result || $db->sql_numrows($table_result) == 0) {
        $values['response'] = 2;
        $values['msg'] = 'Email campaigns table does not exist';
        echo json_encode($values);
        exit;
    }
    
    // Get current table structure
    $structure_query = "DESCRIBE email_campaigns";
    $structure_result = $db->sql_query($structure_query);
    $existing_columns = array();
    
    if($structure_result) {
        while($row = $db->sql_fetchrow($structure_result)) {
            $existing_columns[] = $row['Field'];
        }
    }
    
    // Add missing columns
    $required_columns = array(
        'recipient_type' => "ALTER TABLE email_campaigns ADD COLUMN recipient_type VARCHAR(50) DEFAULT 'all' AFTER total_recipients",
        'emails_sent' => "ALTER TABLE email_campaigns ADD COLUMN emails_sent INT(11) DEFAULT 0 AFTER recipient_type",
        'opens' => "ALTER TABLE email_campaigns ADD COLUMN opens INT(11) DEFAULT 0 AFTER emails_sent",
        'clicks' => "ALTER TABLE email_campaigns ADD COLUMN clicks INT(11) DEFAULT 0 AFTER opens",
        'created_by' => "ALTER TABLE email_campaigns ADD COLUMN created_by INT(11) DEFAULT NULL AFTER clicks",
        'updated_date' => "ALTER TABLE email_campaigns ADD COLUMN updated_date DATETIME DEFAULT NULL AFTER created_date",
        'scheduled_date' => "ALTER TABLE email_campaigns ADD COLUMN scheduled_date DATETIME DEFAULT NULL AFTER updated_date",
        'sent_date' => "ALTER TABLE email_campaigns ADD COLUMN sent_date DATETIME DEFAULT NULL AFTER scheduled_date"
    );
    
    foreach($required_columns as $column_name => $alter_query) {
        if(!in_array($column_name, $existing_columns)) {
            if($db->sql_query($alter_query)) {
                $updates_applied[] = "Added column: $column_name";
            } else {
                $updates_applied[] = "Failed to add column: $column_name - " . $db->sql_error();
            }
        } else {
            $updates_applied[] = "Column already exists: $column_name";
        }
    }
    
    // Update status column to use ENUM if it's not already
    $status_update = "ALTER TABLE email_campaigns MODIFY COLUMN status ENUM('draft','scheduled','sending','sent','paused') DEFAULT 'draft'";
    if($db->sql_query($status_update)) {
        $updates_applied[] = "Updated status column to use ENUM";
    }
    
    // Update content_type column to use ENUM if it's not already
    $content_type_update = "ALTER TABLE email_campaigns MODIFY COLUMN content_type ENUM('html','text') DEFAULT 'html'";
    if($db->sql_query($content_type_update)) {
        $updates_applied[] = "Updated content_type column to use ENUM";
    }
    
    // Add indexes for better performance
    $indexes = array(
        'idx_status' => "ALTER TABLE email_campaigns ADD INDEX idx_status (status)",
        'idx_created_by' => "ALTER TABLE email_campaigns ADD INDEX idx_created_by (created_by)",
        'idx_created_date' => "ALTER TABLE email_campaigns ADD INDEX idx_created_date (created_date)"
    );
    
    foreach($indexes as $index_name => $index_query) {
        // Check if index already exists
        $index_check = "SHOW INDEX FROM email_campaigns WHERE Key_name = '$index_name'";
        $index_result = $db->sql_query($index_check);
        
        if(!$index_result || $db->sql_numrows($index_result) == 0) {
            if($db->sql_query($index_query)) {
                $updates_applied[] = "Added index: $index_name";
            }
        } else {
            $updates_applied[] = "Index already exists: $index_name";
        }
    }
    
    $values['response'] = 1;
    $values['msg'] = 'Email campaigns table updated successfully';
    $values['updates_applied'] = $updates_applied;
    $values['total_updates'] = count($updates_applied);
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error updating table: ' . $e->getMessage();
    $values['exception'] = $e->getMessage();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

