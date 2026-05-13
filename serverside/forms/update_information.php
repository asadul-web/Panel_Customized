<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

$values = array();

// Check if form was submitted
if(!isset($_POST['submitted']) || $_POST['submitted'] != 'update_information') {
    $values['response'] = 2;
    $values['msg'] = 'Invalid request';
    echo json_encode($values);
    exit;
}

// Verify security key
$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);

if($get_key != 'firenetdev') {
    $values['response'] = 2;
    $values['msg'] = 'Invalid security key';
    echo json_encode($values);
    exit;
}

// Sanitize input data
$full_name = $db->Sanitize(trim($_POST['full_name']));
$email = $db->Sanitize(trim($_POST['email']));
$phone = $db->Sanitize(trim($_POST['phone']));
$country = $db->Sanitize(trim($_POST['country']));
$current_password = $db->Sanitize(trim($_POST['current_password']));
$new_password = $db->Sanitize(trim($_POST['new_password']));
$confirm_password = $db->Sanitize(trim($_POST['confirm_password']));
$two_factor = isset($_POST['two_factor']) ? '1' : '0';
$email_notifications = isset($_POST['email_notifications']) ? '1' : '0';
$sms_notifications = isset($_POST['sms_notifications']) ? '1' : '0';
$marketing_emails = isset($_POST['marketing_emails']) ? '1' : '0';
$security_alerts = isset($_POST['security_alerts']) ? '1' : '0';
$language = $db->Sanitize(trim($_POST['language']));
$timezone = $db->Sanitize(trim($_POST['timezone']));
$bio = $db->Sanitize(trim($_POST['bio']));

// Validation
$errors = array();

// Validate email if provided
if(!empty($email) && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $errors[] = 'Please enter a valid email address';
}

// Validate phone if provided
if(!empty($phone) && !preg_match('/^[\+]?[0-9\s\-\(\)]{10,}$/', $phone)) {
    $errors[] = 'Please enter a valid phone number';
}

// Validate password if changing
if(!empty($new_password)) {
    if(empty($current_password)) {
        $errors[] = 'Current password is required to change password';
    }
    
    if($new_password !== $confirm_password) {
        $errors[] = 'New password and confirm password do not match';
    }
    
    if(strlen($new_password) < 6) {
        $errors[] = 'New password must be at least 6 characters long';
    }
}

// Check for validation errors
if(!empty($errors)) {
    $values['response'] = 2;
    $values['msg'] = implode('. ', $errors);
    echo json_encode($values);
    exit;
}

// For demo purposes, we'll just return success
// In a real application, you would update the database here

try {
    // Example database operations (commented out for demo):
    /*
    // Update user profile
    $update_query = "UPDATE users SET 
                     full_name = '".$db->SanitizeForSQL($full_name)."',
                     email = '".$db->SanitizeForSQL($email)."',
                     phone = '".$db->SanitizeForSQL($phone)."',
                     country = '".$db->SanitizeForSQL($country)."',
                     language = '".$db->SanitizeForSQL($language)."',
                     timezone = '".$db->SanitizeForSQL($timezone)."',
                     bio = '".$db->SanitizeForSQL($bio)."',
                     two_factor = '".$db->SanitizeForSQL($two_factor)."',
                     email_notifications = '".$db->SanitizeForSQL($email_notifications)."',
                     sms_notifications = '".$db->SanitizeForSQL($sms_notifications)."',
                     marketing_emails = '".$db->SanitizeForSQL($marketing_emails)."',
                     security_alerts = '".$db->SanitizeForSQL($security_alerts)."',
                     updated_date = '".date('Y-m-d H:i:s')."'
                     WHERE id = '".$user_id."'";
    
    $result = $db->sql_query($update_query);
    
    if(!$result) {
        throw new Exception('Failed to update user information');
    }
    
    // Update password if provided
    if(!empty($new_password)) {
        // Verify current password first
        $check_password_query = "SELECT password FROM users WHERE id = '".$user_id."'";
        $check_result = $db->sql_query($check_password_query);
        $user_data = $db->sql_fetchrow($check_result);
        
        if(!password_verify($current_password, $user_data['password'])) {
            throw new Exception('Current password is incorrect');
        }
        
        // Hash new password
        $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);
        
        // Update password
        $password_update_query = "UPDATE users SET 
                                 password = '".$db->SanitizeForSQL($hashed_password)."',
                                 updated_date = '".date('Y-m-d H:i:s')."'
                                 WHERE id = '".$user_id."'";
        
        $password_result = $db->sql_query($password_update_query);
        
        if(!$password_result) {
            throw new Exception('Failed to update password');
        }
    }
    
    // Log activity
    $action = "Updated account information";
    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                  VALUES ('".$user_id."', '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);
    */
    
    // For demo purposes, simulate successful update
    $values['response'] = 1;
    $values['msg'] = 'Information updated successfully!';
    
    // Add some demo feedback
    $updated_fields = array();
    if(!empty($full_name)) $updated_fields[] = 'Full Name';
    if(!empty($email)) $updated_fields[] = 'Email';
    if(!empty($phone)) $updated_fields[] = 'Phone';
    if(!empty($new_password)) $updated_fields[] = 'Password';
    
    if(!empty($updated_fields)) {
        $values['msg'] = 'Successfully updated: ' . implode(', ', $updated_fields);
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = $e->getMessage();
}

echo json_encode($values);
?>

