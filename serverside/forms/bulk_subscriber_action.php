<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
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

// Get form data
$action = $db->Sanitize(trim($_POST['action']));
$subscriber_ids = isset($_POST['subscriber_ids']) ? $_POST['subscriber_ids'] : array();

// Validate input
if(empty($action) || empty($subscriber_ids) || !is_array($subscriber_ids)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing required parameters';
    echo json_encode($values);
    exit;
}

// Validate action
$valid_actions = array('activate', 'unsubscribe', 'delete', 'export');
if(!in_array($action, $valid_actions)) {
    $values['response'] = 2;
    $values['msg'] = 'Invalid action';
    echo json_encode($values);
    exit;
}

// Sanitize IDs
$subscriber_ids = array_map('intval', $subscriber_ids);
$ids_str = implode(',', $subscriber_ids);

$affected_count = 0;

switch($action) {
    case 'activate':
        $update_query = "UPDATE email_subscribers SET 
                        status = 'active', 
                        unsubscribed_date = NULL 
                        WHERE id IN ($ids_str)";
        
        if($db->sql_query($update_query)) {
            $affected_count = $db->sql_affectedrows();
            $values['response'] = 1;
            $values['msg'] = "Activated $affected_count subscribers successfully";
        } else {
            $values['response'] = 2;
            $values['msg'] = 'Failed to activate subscribers';
        }
        break;
        
    case 'unsubscribe':
        $update_query = "UPDATE email_subscribers SET 
                        status = 'unsubscribed', 
                        unsubscribed_date = '".date('Y-m-d H:i:s')."' 
                        WHERE id IN ($ids_str)";
        
        if($db->sql_query($update_query)) {
            $affected_count = $db->sql_affectedrows();
            $values['response'] = 1;
            $values['msg'] = "Unsubscribed $affected_count subscribers successfully";
        } else {
            $values['response'] = 2;
            $values['msg'] = 'Failed to unsubscribe subscribers';
        }
        break;
        
    case 'delete':
        $delete_query = "DELETE FROM email_subscribers WHERE id IN ($ids_str)";
        
        if($db->sql_query($delete_query)) {
            $affected_count = $db->sql_affectedrows();
            $values['response'] = 1;
            $values['msg'] = "Deleted $affected_count subscribers successfully";
        } else {
            $values['response'] = 2;
            $values['msg'] = 'Failed to delete subscribers';
        }
        break;
        
    case 'export':
        // Redirect to export with selected IDs
        $export_url = '/serverside/forms/export_email_subscribers.php?ids=' . urlencode($ids_str);
        $values['response'] = 1;
        $values['msg'] = 'Export started';
        $values['redirect'] = $export_url;
        break;
        
    default:
        $values['response'] = 2;
        $values['msg'] = 'Unknown action';
        break;
}

// Log activity
if($affected_count > 0 || $action == 'export') {
    $action_text = ucfirst($action);
    $log_action = "$action_text bulk action on $affected_count subscribers";
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($log_action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
}

echo json_encode($values);
?>

