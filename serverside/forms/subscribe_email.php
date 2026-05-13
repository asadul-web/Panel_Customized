<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

$values = array();

// Get form data
$email = isset($_POST['email']) ? $db->Sanitize(trim($_POST['email'])) : '';
$source = isset($_POST['source']) ? $db->Sanitize(trim($_POST['source'])) : 'website';
$page = isset($_POST['page']) ? $db->Sanitize(trim($_POST['page'])) : '';

// Validate email
if(empty($email)) {
    $values['response'] = 2;
    $values['msg'] = 'Email address is required';
    echo json_encode($values);
    exit;
}

if(!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $values['response'] = 2;
    $values['msg'] = 'Please enter a valid email address';
    echo json_encode($values);
    exit;
}

// Check if email already exists
$check_query = "SELECT id, status FROM email_subscribers WHERE email = '".$db->SanitizeForSQL($email)."'";
$check_result = $db->sql_query($check_query);

if($db->sql_numrows($check_result) > 0) {
    $existing = $db->sql_fetchrow($check_result);
    
    if($existing['status'] == 'active') {
        $values['response'] = 2;
        $values['msg'] = 'You are already subscribed to our newsletter!';
        echo json_encode($values);
        exit;
    } elseif($existing['status'] == 'unsubscribed') {
        // Reactivate subscription
        $update_query = "UPDATE email_subscribers SET 
                        status = 'active', 
                        subscribed_date = '".date('Y-m-d H:i:s')."',
                        unsubscribed_date = NULL,
                        ip_address = '".$_SERVER['REMOTE_ADDR']."'
                        WHERE id = ".$existing['id'];
        
        if($db->sql_query($update_query)) {
            $values['response'] = 1;
            $values['msg'] = 'Welcome back! You have been resubscribed to our newsletter.';
        } else {
            $values['response'] = 2;
            $values['msg'] = 'Failed to resubscribe. Please try again.';
        }
        echo json_encode($values);
        exit;
    }
}

// Insert new subscriber
$insert_query = "INSERT INTO email_subscribers (email, source, subscribed_date, ip_address, user_agent) 
                VALUES ('".$db->SanitizeForSQL($email)."', 
                        '".$db->SanitizeForSQL($source)."', 
                        '".date('Y-m-d H:i:s')."',
                        '".$_SERVER['REMOTE_ADDR']."',
                        '".$db->SanitizeForSQL($_SERVER['HTTP_USER_AGENT'])."')";

if($db->sql_query($insert_query)) {
    
    // Send welcome email if enabled
    $settings_query = "SELECT setting_value FROM reseller_settings WHERE setting_name = 'email_notifications'";
    $settings_result = $db->sql_query($settings_query);
    
    if($settings_result && $db->sql_fetchrow($settings_result)['setting_value'] == '1') {
        // Get welcome email template
        $template_query = "SELECT subject, content FROM email_templates WHERE template_type = 'welcome' AND is_active = 1 LIMIT 1";
        $template_result = $db->sql_query($template_query);
        
        if($template_result && $db->sql_numrows($template_result) > 0) {
            $template = $db->sql_fetchrow($template_result);
            
            // Replace placeholders
            $subject = str_replace('{email}', $email, $template['subject']);
            $content = str_replace(
                array('{name}', '{email}', '{website_url}', '{unsubscribe_url}'),
                array($email, $email, $db->base_url(), $db->base_url().'unsubscribe?email='.urlencode($email)),
                $template['content']
            );
            
            // Send welcome email using SMTP helper
            require_once '../../includes/smtp_helper.php';
            sendEmailWithSMTP($email, $email, $subject, $content, true);
        }
    }
    
    $values['response'] = 1;
    $values['msg'] = 'Thank you for subscribing! You will receive our latest updates and exclusive offers.';
    
} else {
    $values['response'] = 2;
    $values['msg'] = 'Failed to subscribe. Please try again.';
}

echo json_encode($values);
?>

