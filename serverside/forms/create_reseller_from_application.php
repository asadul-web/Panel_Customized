<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
require_once '../../includes/smtp_helper.php';

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

if(!isset($_POST['application_id'])) {
    $values['response'] = 2;
    $values['msg'] = 'Missing required parameters';
    echo json_encode($values);
    exit;
}

$application_id = intval($_POST['application_id']);
$credits = isset($_POST['credits']) ? intval($_POST['credits']) : 0;
$custom_username = isset($_POST['username']) ? $db->Sanitize(trim($_POST['username'])) : '';
$custom_password = isset($_POST['password']) ? $db->Sanitize(trim($_POST['password'])) : '';

// Get application details first
$app_query = "SELECT * FROM reseller_applications WHERE id = $application_id";
$app_result = $db->sql_query($app_query);

if($db->sql_numrows($app_result) == 0) {
    $values['response'] = 2;
    $values['msg'] = 'Application not found';
    echo json_encode($values);
    exit;
}

$app_data = $db->sql_fetchrow($app_result);

// Use stored credentials or custom ones
$username = !empty($custom_username) ? $custom_username : $app_data['username'];
$password = !empty($custom_password) ? $custom_password : 'temp_password_' . rand(1000, 9999); // Generate temp if no stored password

// If we have a stored hashed password, we need to generate a new plain password for the user
if(!empty($app_data['password']) && empty($custom_password)) {
    $password = 'reseller_' . rand(10000, 99999); // Generate new password since stored one is hashed
}

// Validation
$valid = true;
$errormsg = array();

if(empty($username)) {
    $errormsg[] = 'Username is required.<br>';
    $valid = false;
}

if(strlen($username) < 3) {
    $errormsg[] = 'Username is too short.<br>';
    $valid = false;
}

if(preg_match('/[^a-z-A-Z-0-9_]/', $username)) {
    $errormsg[] = 'Only letters, numbers and underscores allowed in username.<br>';
    $valid = false;
}

// Check if username already exists
if($valid) {
    $username_check = $db->sql_query("SELECT user_name FROM users WHERE user_name = '".$db->SanitizeForSQL($username)."'");
    if($db->sql_numrows($username_check) > 0) {
        $errormsg[] = 'Username is already taken.<br>';
        $valid = false;
    }
}

// Check if application is in correct status
if($valid) {
    if($app_data['status'] != 'pending' && $app_data['status'] != 'under_review') {
        $values['response'] = 2;
        $values['msg'] = 'Application is not in a valid status for creating reseller account';
        echo json_encode($values);
        exit;
    }
}

if($valid) {
    
    // Create reseller account
    // Use single encryption to match database
    $user_pass = $db->encryptor('encrypt', $password);
    $auth_vpn = md5($password);
    $code = rand(0, 999999999);
    $userlevel = 'reseller';
    $user_email = $app_data['email'];
    $full_name = $app_data['full_name'];
    $is_groupname = 'reseller';
    $duration = 0;
    $is_active = 1;
    
    // Insert user
    $insert_user = "INSERT INTO users 
                    (user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze, user_level, code, is_ban, is_validated, upline, duration, credits)
                    VALUES
                    ('".$db->SanitizeForSQL($username)."',
                     '".$db->SanitizeForSQL($user_pass)."',
                     '".$db->SanitizeForSQL($auth_vpn)."',
                     '".$db->SanitizeForSQL($user_email)."',
                     '".$db->SanitizeForSQL($full_name)."',
                     '".date('Y-m-d H:i:s')."',
                     '".$db->SanitizeForSQL($is_groupname)."',
                     '".$db->SanitizeForSQL($is_active)."',
                     0,
                     '".$db->SanitizeForSQL($userlevel)."',
                     '".$db->SanitizeForSQL($code)."',
                     0,
                     1,
                     '".$user_id_2."',
                     '".$duration."',
                     '".$credits."')";
    
    $result = $db->sql_query($insert_user);
    $insert_id = $db->sql_nextid();
    
    if($result && $insert_id) {
        
        // Insert user profile
        $insert_profile = "INSERT INTO users_profile (profile_id, first_name, last_name, profile_number) 
                          VALUES ($insert_id, '".$db->SanitizeForSQL($app_data['full_name'])."', 'Reseller', '".$db->SanitizeForSQL($app_data['phone'])."')";
        $db->sql_query($insert_profile);
        
        // Update application status to approved
        $update_app = "UPDATE reseller_applications SET 
                       status = 'approved',
                       reviewed_date = '".date('Y-m-d H:i:s')."',
                       reviewed_by = $user_id_2,
                       admin_notes = 'Approved and reseller account created (Username: $username)'
                       WHERE id = $application_id";
        $db->sql_query($update_app);
        
        // Log activity
        $action = "Created reseller account '$username' from application #$application_id with $credits credits";
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                      VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
                      '".$_SERVER['REMOTE_ADDR']."', '', '')";
        $db->sql_query($log_query);
        
        // Log credit transaction if credits > 0
        if($credits > 0) {
            $credit_log = "INSERT INTO credits_logs (credits_id, credits_id2, credits_type, credits_qty, credits_date) 
                          VALUES ($user_id_2, '$username', 'add', $credits, '".date('Y-m-d H:i:s')."')";
            $db->sql_query($credit_log);
        }
        
        // Send welcome email
        $email_settings = $db->sql_query("SELECT setting_name, setting_value FROM reseller_settings WHERE setting_name LIKE '%email%'");
        $settings = array();
        while($setting = $db->sql_fetchrow($email_settings)) {
            $settings[$setting['setting_name']] = $setting['setting_value'];
        }
        
        if(isset($settings['email_notifications']) && $settings['email_notifications'] == '1') {
            $subject = isset($settings['welcome_email_subject']) ? $settings['welcome_email_subject'] : 'Welcome to Our Reseller Program';
            $email_body = isset($settings['welcome_email_body']) ? $settings['welcome_email_body'] : 'Welcome to our reseller program!';
            
            // Replace placeholders
            $email_body = str_replace('{name}', $full_name, $email_body);
            $email_body = str_replace('{username}', $username, $email_body);
            $email_body = str_replace('{password}', $password, $email_body);
            $email_body = str_replace('{reseller_url}', $base_url, $email_body);
            
            sendEmailWithSMTP($user_email, $full_name, $subject, $email_body, false);
        }
        
        $success_message = 'Reseller account created successfully!<br><br>';
        $success_message .= '<strong>Account Details:</strong><br>';
        $success_message .= 'Username: <code>' . $username . '</code><br>';
        $success_message .= 'Password: <code>' . $password . '</code><br>';
        $success_message .= 'Email: <code>' . $user_email . '</code><br>';
        $success_message .= 'Credits: <code>' . $credits . '</code><br><br>';
        $success_message .= '<button class="btn btn-copy btn-primary" data-clipboard-text="Reseller Account Details
        
Username: ' . $username . '
Password: ' . $password . '
Email: ' . $user_email . '
Credits: ' . $credits . '
Reseller URL: ' . $base_url . '">Copy Details</button>';
        
        $values['response'] = 1;
        $values['msg'] = $success_message;
        
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to create reseller account';
    }
    
} else {
    $values['response'] = 3;
    $errors = implode('', $errormsg);
    $values['errormsg'] = $errors;
}

echo json_encode($values);
?>

