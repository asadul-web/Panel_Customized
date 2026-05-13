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

if(!isset($_POST['application_id']) || !isset($_POST['status'])) {
    $values['response'] = 2;
    $values['msg'] = 'Missing required parameters';
    echo json_encode($values);
    exit;
}

$application_id = intval($_POST['application_id']);
$status = $db->Sanitize($_POST['status']);
$reason = isset($_POST['reason']) ? $db->Sanitize($_POST['reason']) : '';

// Validate status
$valid_statuses = array('pending', 'under_review', 'approved', 'rejected');
if(!in_array($status, $valid_statuses)) {
    $values['response'] = 2;
    $values['msg'] = 'Invalid status';
    echo json_encode($values);
    exit;
}

// Get application details
$app_query = "SELECT * FROM reseller_applications WHERE id = $application_id";
$app_result = $db->sql_query($app_query);

if($db->sql_numrows($app_result) == 0) {
    $values['response'] = 2;
    $values['msg'] = 'Application not found';
    echo json_encode($values);
    exit;
}

$app_data = $db->sql_fetchrow($app_result);

// Check if already approved to prevent duplicate accounts
if($app_data['status'] == 'approved' && $status == 'approved') {
    $values['response'] = 2;
    $values['msg'] = 'Application is already approved';
    echo json_encode($values);
    exit;
}

$created_username = '';
$generated_password = '';

// If approving the application, create reseller account
if($status == 'approved' && $app_data['status'] != 'approved') {

    // Use the applicant's requested username and password
    $created_username = $app_data['username'];

    // Check if username is available
    $check_query = "SELECT user_id FROM users WHERE user_name = '".$db->SanitizeForSQL($created_username)."'";
    $check_result = $db->sql_query($check_query);

    if($db->sql_numrows($check_result) > 0) {
        $values['response'] = 2;
        $values['msg'] = 'Username "' . $created_username . '" is already taken. Please ask applicant to choose a different username and resubmit.';
        echo json_encode($values);
        exit;
    }

    // Get the encrypted password from application (already encrypted with single encryption)
    $encrypted_password = $app_data['password'];
    
    // Decrypt for email notification
    $plain_password_for_email = $db->encryptor('decrypt', $encrypted_password);
    $generated_password = $plain_password_for_email;

    // Create user account
    $current_time = date('Y-m-d H:i:s');
    $random_code = mt_rand(100000000, 999999999);
    $vpn_password = 'vpn' . mt_rand(1000, 9999);

    $create_user_query = "INSERT INTO users (
        password,
        code,
        ss_id,
        ssl_id,
        username_prefix,
        user_name,
        user_pass,
        user_2fa,
        user_2fa_otp,
        user_2fa_id,
        user_2fa_duration,
        attribute,
        op,
        auth_vpn,
        user_email,
        user_email_verified,
        full_name,
        regdate,
        ipaddress,
        lastlogin,
        timestamp,
        reset_code,
        is_groupname,
        is_active,
        is_freeze,
        is_passchange,
        passchange_duration,
        last_freeze_date,
        is_validated,
        is_connected,
        is_offense,
        is_ban,
        is_socksip,
        user_group,
        suspended_date,
        duration,
        vip_duration,
        is_vip,
        private_duration,
        is_private,
        private_slot,
        private_control,
        credits,
        upline,
        login_status,
        last_active_time,
        user_level,
        status,
        bytes_received,
        bytes_sent,
        bandwidth,
        bandwidth_premium,
        bandwidth_vip,
        bandwidth_ph,
        bandwidth_private,
        bandwidth_free,
        device_connected,
        device_id,
        device_model,
        session,
        active_address,
        active_date
    ) VALUES (
        'hjhj',
        '".$random_code."',
        '".(mt_rand(10000, 99999))."',
        'ssl',
        '',
        '".$db->SanitizeForSQL($created_username)."',
        '".$db->SanitizeForSQL($encrypted_password)."',
        0,
        '',
        '',
        0,
        'MD5-Password',
        ':=',
        '".md5($vpn_password)."',
        '".$db->SanitizeForSQL($app_data['email'])."',
        1,
        '".$db->SanitizeForSQL($app_data['full_name'])."',
        '".$current_time."',
        '".$_SERVER['REMOTE_ADDR']."',
        '0000-00-00 00:00:00',
        0,
        '0',
        'reseller',
        1,
        0,
        0,
        0,
        '0000-00-00 00:00:00',
        1,
        0,
        0,
        0,
        0,
        0,
        '0000-00-00 00:00:00',
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        1,
        'offline',
        '".$current_time."',
        'reseller',
        'live',
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        '',
        '',
        0,
        '',
        '0000-00-00 00:00:00'
    )";

    $user_create_result = $db->sql_query($create_user_query);

    if(!$user_create_result) {
        $values['response'] = 2;
        $values['msg'] = 'Failed to create reseller account';
        echo json_encode($values);
        exit;
    }
}

// Update application status
$admin_notes = '';
if($status == 'approved') {
    if(!empty($created_username)) {
        $admin_notes = "Approved and reseller account created (Username: " . $created_username . ")";
    } else {
        $admin_notes = "Approved by " . $user_name_2;
    }
} elseif($status == 'rejected' && !empty($reason)) {
    $admin_notes = "Rejected: " . $reason;
} elseif($status == 'under_review') {
    $admin_notes = "Marked under review by " . $user_name_2;
}

$update_query = "UPDATE reseller_applications SET
                 status = '".$db->SanitizeForSQL($status)."',
                 reviewed_date = '".date('Y-m-d H:i:s')."',
                 reviewed_by = $user_id_2";

if(!empty($admin_notes)) {
    $update_query .= ", admin_notes = '".$db->SanitizeForSQL($admin_notes)."'";
}

$update_query .= " WHERE id = $application_id";

$result = $db->sql_query($update_query);

if($result) {

    // Send email notification to applicant
    $email_settings = $db->sql_query("SELECT setting_name, setting_value FROM reseller_settings WHERE setting_name LIKE '%email%' OR setting_name = 'welcome_email_subject' OR setting_name = 'welcome_email_body' OR setting_name = 'rejection_email_subject' OR setting_name = 'rejection_email_body'");
    $settings = array();
    while($setting = $db->sql_fetchrow($email_settings)) {
        $settings[$setting['setting_name']] = $setting['setting_value'];
    }

    if(isset($settings['email_notifications']) && $settings['email_notifications'] == '1') {

        $subject = '';
        $email_body = '';

        if($status == 'approved') {
            $subject = isset($settings['welcome_email_subject']) ? $settings['welcome_email_subject'] : 'Welcome to Our Reseller Program';
            $email_body = isset($settings['welcome_email_body']) ? $settings['welcome_email_body'] :
                '<p>Dear {name},</p>
                <p>Congratulations! Your reseller application has been approved.</p>
                <p><strong>Your reseller account details:</strong><br>
                Username: {username}<br>
                Password: {password}<br>
                Reseller Panel: {reseller_url}</p>
                <p>You can now log in to your reseller panel and start managing your accounts.</p>
                <p>Best regards,<br>The Team</p>';
        } elseif($status == 'rejected') {
            $subject = isset($settings['rejection_email_subject']) ? $settings['rejection_email_subject'] : 'Reseller Application Update';
            $email_body = isset($settings['rejection_email_body']) ? $settings['rejection_email_body'] :
                '<p>Dear {name},</p>
                <p>Thank you for your interest in our reseller program.</p>
                <p>Unfortunately, your application has been declined for the following reason:</p>
                <p><em>{reason}</em></p>
                <p>You may reapply in the future if circumstances change.</p>
                <p>Best regards,<br>The Team</p>';
            $email_body = str_replace('{reason}', $reason, $email_body);
        } elseif($status == 'under_review') {
            $subject = 'Reseller Application - Under Review';
            $email_body = '<p>Dear {name},</p>
                <p>Your reseller application is currently under review.</p>
                <p>We will notify you once a decision has been made.</p>
                <p>Thank you for your patience.</p>
                <p>Best regards,<br>The Team</p>';
        }

        if(!empty($subject) && !empty($email_body)) {
            // Get reseller panel URL (current domain)
            $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https://' : 'http://';
            $reseller_url = $protocol . $_SERVER['HTTP_HOST'];

            // Replace placeholders
            $email_body = str_replace('{name}', $app_data['full_name'], $email_body);
            $email_body = str_replace('{business_name}', $app_data['business_name'], $email_body);
            $email_body = str_replace('{username}', $created_username, $email_body);
            $email_body = str_replace('{password}', $generated_password, $email_body);
            $email_body = str_replace('{reseller_url}', $reseller_url, $email_body);
            $email_body = str_replace('{expected_sales}', $app_data['expected_sales'], $email_body);
            $email_body = str_replace('{phone}', $app_data['phone'], $email_body);
            $email_body = str_replace('{country}', $app_data['country'], $email_body);
            $email_body = str_replace('{website}', $app_data['website'], $email_body);
            $email_body = str_replace('{experience}', $app_data['experience'], $email_body);

            // Also replace in subject
            $subject = str_replace('{name}', $app_data['full_name'], $subject);
            $subject = str_replace('{business_name}', $app_data['business_name'], $subject);
            $subject = str_replace('{expected_sales}', $app_data['expected_sales'], $subject);

            // Send email
            $email_sent = sendEmailWithSMTP($app_data['email'], $app_data['full_name'], $subject, $email_body, true);

            // Log email sending attempt
            $email_status = $email_sent ? 'sent' : 'failed';
            $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client)
                          VALUES ($user_id_2, '".date('Y-m-d H:i:s')."',
                          'Email notification $email_status to ".$app_data['email']." for reseller application #$application_id',
                          '".$_SERVER['REMOTE_ADDR']."', '', '')";
            $db->sql_query($log_query);
        }
    }

    // Log activity
    $action = "Updated reseller application #$application_id status to '$status'";
    if($status == 'approved' && !empty($created_username)) {
        $action .= " and created reseller account: $created_username";
    }
    if($status == 'rejected' && !empty($reason)) {
        $action .= " (Reason: $reason)";
    }

    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client)
                  VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."',
                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
    $db->sql_query($log_query);

    $values['response'] = 1;
    if($status == 'approved' && !empty($created_username)) {
        $values['msg'] = 'Application approved successfully! Reseller account created using applicant\'s requested credentials:<br><strong>Username:</strong> ' . $created_username . '<br><strong>Password:</strong> ' . $generated_password . '<br><br>Login details have been emailed to the applicant.<br><br><strong>Note:</strong> New reseller starts with 0 credits - please add credits manually as needed.';
    } else {
        $values['msg'] = 'Application status updated successfully';
    }

} else {
    $values['response'] = 2;
    $values['msg'] = 'Failed to update application status';
}

echo json_encode($values);
?>

