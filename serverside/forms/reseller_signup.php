<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
require_once '../../includes/smtp_helper.php';

$values = array();

if(isset($_POST['submitted']) && $_POST['submitted'] == 'reseller_signup') {

    $key = $db->encryptor('decrypt', $_POST['_key']);
    $get_key = $db->Sanitize($key);

    // Sanitize input data
    $business_name = $db->Sanitize(trim($_POST['business_name']));
    $full_name = $db->Sanitize(trim($_POST['full_name']));
    $email = $db->Sanitize(trim($_POST['email']));
    $username = $db->Sanitize(trim($_POST['username']));
    $password = $db->Sanitize(trim($_POST['password']));
    $confirm_password = $db->Sanitize(trim($_POST['confirm_password']));
    $phone = $db->Sanitize(trim($_POST['phone']));
    $country = $db->Sanitize(trim($_POST['country']));
    $website = $db->Sanitize(trim($_POST['website']));
    $experience = $db->Sanitize(trim($_POST['experience']));
    $expected_sales = $db->Sanitize(trim($_POST['expected_sales']));
    $message = $db->Sanitize(trim($_POST['message']));
    $agree = isset($_POST['agree']) ? 1 : 0;

    $valid = true;
    $errormsg = array();

    // Validation
    if(empty($business_name)) {
        $errormsg[] = 'Business/Company name is required.<br>';
        $valid = false;
    }

    if(empty($full_name)) {
        $errormsg[] = 'Full name is required.<br>';
        $valid = false;
    }

    if(empty($email)) {
        $errormsg[] = 'Email address is required.<br>';
        $valid = false;
    } elseif(!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errormsg[] = 'Please enter a valid email address.<br>';
        $valid = false;
    }

    if(empty($username)) {
        $errormsg[] = 'Username is required.<br>';
        $valid = false;
    } elseif(strlen($username) < 4 || strlen($username) > 20) {
        $errormsg[] = 'Username must be between 4 and 20 characters.<br>';
        $valid = false;
    } elseif(!preg_match('/^[a-zA-Z0-9_]+$/', $username)) {
        $errormsg[] = 'Username can only contain letters, numbers, and underscores.<br>';
        $valid = false;
    }

    if(empty($password)) {
        $errormsg[] = 'Password is required.<br>';
        $valid = false;
    } elseif(strlen($password) < 6) {
        $errormsg[] = 'Password must be at least 6 characters long.<br>';
        $valid = false;
    }

    if($password !== $confirm_password) {
        $errormsg[] = 'Password and confirm password do not match.<br>';
        $valid = false;
    }

    if(empty($phone)) {
        $errormsg[] = 'Phone number is required.<br>';
        $valid = false;
    }

    if(empty($country)) {
        $errormsg[] = 'Country is required.<br>';
        $valid = false;
    }

    if(empty($experience)) {
        $errormsg[] = 'Experience level is required.<br>';
        $valid = false;
    }

    if(empty($expected_sales)) {
        $errormsg[] = 'Expected sales is required.<br>';
        $valid = false;
    }

    if(empty($message)) {
        $errormsg[] = 'Please tell us why you want to become a reseller.<br>';
        $valid = false;
    }

    if(!$agree) {
        $errormsg[] = 'You must agree to the terms and conditions.<br>';
        $valid = false;
    }

    // Check if email already exists
    if($valid) {
        $email_check = $db->sql_query("SELECT id FROM reseller_applications WHERE email = '".$db->SanitizeForSQL($email)."'");
        if($db->sql_numrows($email_check) > 0) {
            $errormsg[] = 'An application with this email address already exists.<br>';
            $valid = false;
        }

        // Also check if email exists in users table
        $user_check = $db->sql_query("SELECT user_id FROM users WHERE user_email = '".$db->SanitizeForSQL($email)."'");
        if($db->sql_numrows($user_check) > 0) {
            $errormsg[] = 'An account with this email address already exists.<br>';
            $valid = false;
        }

        // Check if username already exists in applications
        $username_check = $db->sql_query("SELECT id FROM reseller_applications WHERE username = '".$db->SanitizeForSQL($username)."'");
        if($db->sql_numrows($username_check) > 0) {
            $errormsg[] = 'This username is already taken. Please choose a different username.<br>';
            $valid = false;
        }

        // Also check if username exists in users table
        $user_username_check = $db->sql_query("SELECT user_id FROM users WHERE user_name = '".$db->SanitizeForSQL($username)."'");
        if($db->sql_numrows($user_username_check) > 0) {
            $errormsg[] = 'This username is already taken. Please choose a different username.<br>';
            $valid = false;
        }
    }

    if($valid) {
        if($get_key == 'firenetdev') {

            $ip_address = $_SERVER['REMOTE_ADDR'];
            $user_agent = $_SERVER['HTTP_USER_AGENT'];

            // Encrypt password using single encryption method (matches login authentication)
            $encrypted_password = $db->encryptor('encrypt', $password);

            // Check if admin_password column exists
            $check_column_query = "SHOW COLUMNS FROM `reseller_applications` LIKE 'admin_password'";
            $check_column_result = $db->sql_query($check_column_query);
            $has_admin_password_column = ($db->sql_numrows($check_column_result) > 0);

            if($has_admin_password_column) {
                // Store encrypted password in both fields for consistency
                $insert_query = "INSERT INTO reseller_applications
                                (business_name, full_name, email, username, password, admin_password, phone, country, website, experience, expected_sales, message, ip_address, user_agent, applied_date)
                                VALUES
                                ('".$db->SanitizeForSQL($business_name)."',
                                 '".$db->SanitizeForSQL($full_name)."',
                                 '".$db->SanitizeForSQL($email)."',
                                 '".$db->SanitizeForSQL($username)."',
                                 '".$db->SanitizeForSQL($encrypted_password)."',
                                 '".$db->SanitizeForSQL($encrypted_password)."',
                                 '".$db->SanitizeForSQL($phone)."',
                                 '".$db->SanitizeForSQL($country)."',
                                 '".$db->SanitizeForSQL($website)."',
                                 '".$db->SanitizeForSQL($experience)."',
                                 '".$db->SanitizeForSQL($expected_sales)."',
                                 '".$db->SanitizeForSQL($message)."',
                                 '".$db->SanitizeForSQL($ip_address)."',
                                 '".$db->SanitizeForSQL($user_agent)."',
                                 '".date('Y-m-d H:i:s')."')";
            } else {
                // Insert application without admin_password column (fallback for old database structure)
                $insert_query = "INSERT INTO reseller_applications
                                (business_name, full_name, email, username, password, phone, country, website, experience, expected_sales, message, ip_address, user_agent, applied_date)
                                VALUES
                                ('".$db->SanitizeForSQL($business_name)."',
                                 '".$db->SanitizeForSQL($full_name)."',
                                 '".$db->SanitizeForSQL($email)."',
                                 '".$db->SanitizeForSQL($username)."',
                                 '".$db->SanitizeForSQL($encrypted_password)."',
                                 '".$db->SanitizeForSQL($phone)."',
                                 '".$db->SanitizeForSQL($country)."',
                                 '".$db->SanitizeForSQL($website)."',
                                 '".$db->SanitizeForSQL($experience)."',
                                 '".$db->SanitizeForSQL($expected_sales)."',
                                 '".$db->SanitizeForSQL($message)."',
                                 '".$db->SanitizeForSQL($ip_address)."',
                                 '".$db->SanitizeForSQL($user_agent)."',
                                 '".date('Y-m-d H:i:s')."')";
            }

            $result = $db->sql_query($insert_query);

            if($result) {

                // Automatically add email to subscribers list
                try {
                    require_once '../../includes/reseller_email_sync.php';
                    add_reseller_to_subscribers($email, $full_name, $ip_address, $user_agent);
                } catch(Exception $e) {
                    // Log error but don't fail the application
                    error_log("Failed to add reseller email to subscribers: " . $e->getMessage());
                }

                // Send notification email to admin (if enabled)
                $email_settings = $db->sql_query("SELECT setting_name, setting_value FROM reseller_settings WHERE setting_name IN ('email_notifications', 'admin_email')");
                $settings = array();
                while($setting = $db->sql_fetchrow($email_settings)) {
                    $settings[$setting['setting_name']] = $setting['setting_value'];
                }

                if(isset($settings['email_notifications']) && $settings['email_notifications'] == '1' && isset($settings['admin_email'])) {

                    $admin_email = $settings['admin_email'];
                    $subject = "New Reseller Application - " . $business_name;

                    $email_body = "A new reseller application has been submitted.\n\n";
                    $email_body .= "Business Name: " . $business_name . "\n";
                    $email_body .= "Full Name: " . $full_name . "\n";
                    $email_body .= "Email: " . $email . "\n";
                    $email_body .= "Username: " . $username . "\n";
                    $email_body .= "Phone: " . $phone . "\n";
                    $email_body .= "Country: " . $country . "\n";
                    $email_body .= "Website: " . ($website ? $website : 'Not provided') . "\n";
                    $email_body .= "Experience: " . $experience . "\n";
                    $email_body .= "Expected Sales: " . $expected_sales . "\n";
                    $email_body .= "Message: " . $message . "\n";
                    $email_body .= "Applied Date: " . date('Y-m-d H:i:s') . "\n";
                    $email_body .= "IP Address: " . $ip_address . "\n\n";
                    $email_body .= "Please review this application in the admin panel.";

                    $body_html = nl2br(htmlspecialchars($email_body));
                    sendEmailWithSMTP($admin_email, $admin_email, $subject, $body_html, true);
                }

                // Send confirmation email to applicant
                $applicant_subject = "Reseller Application Received";
                $applicant_body = "Dear " . $full_name . ",\n\n";
                $applicant_body .= "Thank you for your interest in becoming a reseller with " . $site_name . ".\n\n";
                $applicant_body .= "We have received your application and it is currently under review. Our team will carefully evaluate your application and get back to you within 2-3 business days.\n\n";
                $applicant_body .= "Application Details:\n";
                $applicant_body .= "Business Name: " . $business_name . "\n";
                $applicant_body .= "Email: " . $email . "\n";
                $applicant_body .= "Applied Date: " . date('Y-m-d H:i:s') . "\n\n";
                $applicant_body .= "If you have any questions, please don't hesitate to contact us.\n\n";
                $applicant_body .= "Best regards,\n";
                $applicant_body .= "The " . $site_name . " Team";

                $applicant_body_html = nl2br(htmlspecialchars($applicant_body));
                sendEmailWithSMTP($email, $full_name, $applicant_subject, $applicant_body_html, true);

                $success_message = 'Your reseller application has been submitted successfully!<br><br>';
                $success_message .= 'We have sent a confirmation email to <strong>' . $email . '</strong><br>';
                $success_message .= 'Our team will review your application and get back to you within 2-3 business days.<br><br>';
                $success_message .= 'Thank you for your interest in becoming a reseller!';

                $values['response'] = 1;
                $values['msg'] = $success_message;

            } else {
                $error_message = 'Failed to submit application. Please try again.';
                $values['response'] = 2;
                $values['msg'] = $error_message;
            }

        } else {
            $error_message = 'Invalid security key!';
            $values['response'] = 2;
            $values['msg'] = $error_message;
        }

    } else {
        $values['response'] = 3;
        $errors = implode('', $errormsg);
        $values['errormsg'] = $errors;
    }

} else {
    $values['response'] = 2;
    $values['msg'] = 'Invalid request!';
}

echo json_encode($values);
?>

