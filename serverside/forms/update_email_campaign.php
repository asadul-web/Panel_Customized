<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json; charset=utf-8');

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

try {
    // Get form data
    $campaign_id = isset($_POST['campaign_id']) ? intval($_POST['campaign_id']) : 0;
    $name = isset($_POST['name']) ? trim($_POST['name']) : '';
    $subject = isset($_POST['subject']) ? trim($_POST['subject']) : '';
    $content = isset($_POST['content']) ? trim($_POST['content']) : '';
    $content_type = isset($_POST['content_type']) ? trim($_POST['content_type']) : 'html';
    $recipient_type = isset($_POST['recipient_type']) ? trim($_POST['recipient_type']) : 'all';
    $status = isset($_POST['status']) ? trim($_POST['status']) : 'draft';
    
    // Validate required fields
    if(empty($campaign_id)) {
        $values['response'] = 2;
        $values['msg'] = 'Campaign ID is required';
        echo json_encode($values);
        exit;
    }
    
    if(empty($name)) {
        $values['response'] = 2;
        $values['msg'] = 'Campaign name is required';
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
    
    // Check if campaign exists and user has permission to edit it
    $check_query = "SELECT id, name, status FROM email_campaigns WHERE id = $campaign_id";
    $check_result = $db->sql_query($check_query);
    
    if(!$check_result || $db->sql_numrows($check_result) == 0) {
        $values['response'] = 2;
        $values['msg'] = 'Campaign not found';
        echo json_encode($values);
        exit;
    }
    
    $existing_campaign = $db->sql_fetchrow($check_result);
    
    // Prevent editing of campaigns that are currently being sent
    if($existing_campaign['status'] === 'sending') {
        $values['response'] = 2;
        $values['msg'] = 'Cannot edit campaign that is currently being sent';
        echo json_encode($values);
        exit;
    }
    
    // Calculate recipient count (simplified for now)
    $recipient_count = 0;
    switch($recipient_type) {
        case 'all':
            $count_query = "SELECT COUNT(*) as count FROM subscribers WHERE status = 'active'";
            $count_result = $db->sql_query($count_query);
            if($count_result) {
                $recipient_count = $db->sql_fetchrow($count_result)['count'];
            }
            break;
        default:
            $recipient_count = 1; // Default fallback
    }
    
    // Escape data for SQL
    $name_escaped = addslashes($name);
    $subject_escaped = addslashes($subject);
    $content_escaped = addslashes($content);
    $content_type_escaped = addslashes($content_type);
    $status_escaped = addslashes($status);
    $recipient_type_escaped = addslashes($recipient_type);
    
    // Update campaign (handle missing columns gracefully)
    $update_query = "UPDATE email_campaigns SET 
                    name = '$name_escaped',
                    subject = '$subject_escaped',
                    content = '$content_escaped',
                    content_type = '$content_type_escaped',
                    status = '$status_escaped',
                    total_recipients = $recipient_count
                    WHERE id = $campaign_id";
    
    if($db->sql_query($update_query)) {
        
        // Log activity
        $action = "Updated email campaign: $name";
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                      VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."', 
                      '".$_SERVER['REMOTE_ADDR']."', '', '')";
        $db->sql_query($log_query);
        
        $values['response'] = 1;
        $values['msg'] = "Campaign '$name' updated successfully! Recipients: $recipient_count";
        
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to update campaign. Database error: ' . $db->sql_error();
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['response'] = 2;
    $values['msg'] = 'Fatal Error: ' . $e->getMessage();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

