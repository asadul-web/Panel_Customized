<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
require_once '../../includes/fcm_helper.php';
chkSession();

$values = array();

if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'administrator'){
    // Allowed
}else{
    $values['response'] = 2;
    $values['msg'] = 'Permission denied';
    echo json_encode($values);
    exit;
}

$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);
$action = isset($_POST['action']) ? $db->Sanitize($_POST['action']) : '';

if($get_key != 'firenetdev'){
    $values['response'] = 2;
    $values['msg'] = 'Invalid key';
    echo json_encode($values);
    exit;
}

switch($action) {
    case 'add':
        $title = $db->Sanitize(trim($_POST['title']));
        $message = $db->Sanitize(trim($_POST['message']));
        $notice_type = $db->Sanitize(trim($_POST['notice_type']));
        $priority = intval($_POST['priority']);
        $show_button = isset($_POST['show_button']) ? 1 : 0;
        $button_text = $db->Sanitize(trim($_POST['button_text'] ?? ''));
        $button_url = $db->Sanitize(trim($_POST['button_url'] ?? ''));
        $min_version = $db->Sanitize(trim($_POST['min_version'] ?? ''));
        $max_version = $db->Sanitize(trim($_POST['max_version'] ?? ''));
        
        if(empty($title) || empty($message)){
            $values['response'] = 2;
            $values['msg'] = 'Title and message are required';
            break;
        }
        
        $sql = "INSERT INTO app_notices (title, message, notice_type, priority, show_button, button_text, button_url, min_version, max_version) 
                VALUES ('$title', '$message', '$notice_type', $priority, $show_button, '$button_text', '$button_url', '$min_version', '$max_version')";
        
        if($db->sql_query($sql)){
            // Send FCM Push Notification
            try {
                $fcm = new FCMHelper();
                
                // Get Firebase Server Key from database or config
                $fcm_query = $db->sql_query("SELECT fcm_server_key FROM site_options WHERE id='1'");
                if($fcm_query && $fcm_row = $db->sql_fetchrow($fcm_query)) {
                    if(!empty($fcm_row['fcm_server_key'])) {
                        $fcm->setServerKey($fcm_row['fcm_server_key']);
                    }
                }
                
                // Prepare notification data
                $notificationData = [
                    'notice_type' => $notice_type,
                    'priority' => $priority
                ];
                
                if($show_button) {
                    $notificationData['button_text'] = $button_text;
                    $notificationData['button_url'] = $button_url;
                }
                
                // Add emoji based on notice type
                $emoji = '📢';
                if($notice_type == 'info') $emoji = 'ℹ️';
                elseif($notice_type == 'warning') $emoji = '⚠️';
                elseif($notice_type == 'success') $emoji = '✅';
                elseif($notice_type == 'error') $emoji = '❌';
                
                $notificationTitle = $emoji . ' ' . $title;
                
                // Send to all users
                $fcmResult = $fcm->sendToAll($notificationTitle, strip_tags($message), $notificationData);
                
                $values['response'] = 1;
                $values['msg'] = 'Notice added successfully';
                $values['fcm_sent'] = $fcmResult['success'];
                $values['fcm_details'] = $fcmResult;
            } catch (Exception $e) {
                // Notice added but FCM failed - still return success
                $values['response'] = 1;
                $values['msg'] = 'Notice added successfully (Push notification failed: ' . $e->getMessage() . ')';
                $values['fcm_sent'] = false;
            }
        }else{
            $values['response'] = 2;
            $values['msg'] = 'Failed to add notice';
        }
        break;
        
    case 'toggle':
        $id = intval($_POST['id']);
        $status = intval($_POST['status']);
        
        $sql = "UPDATE app_notices SET is_active = $status WHERE id = $id";
        if($db->sql_query($sql)){
            $values['response'] = 1;
            $values['msg'] = 'Notice status updated';
        }else{
            $values['response'] = 2;
            $values['msg'] = 'Failed to update status';
        }
        break;
        
    case 'delete':
        $id = intval($_POST['id']);
        
        $sql = "DELETE FROM app_notices WHERE id = $id";
        if($db->sql_query($sql)){
            $values['response'] = 1;
            $values['msg'] = 'Notice deleted successfully';
        }else{
            $values['response'] = 2;
            $values['msg'] = 'Failed to delete notice';
        }
        break;
        
    default:
        $values['response'] = 2;
        $values['msg'] = 'Invalid action';
        break;
}

echo json_encode($values);
?>
