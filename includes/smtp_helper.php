<?php
// SMTP Helper functions for the reseller system - Updated to use Gmail SMTP

// Load Gmail SMTP helper
require_once dirname(__FILE__) . '/gmail_smtp_helper.php';

function sendEmailWithSMTP($to_email, $to_name, $subject, $body, $is_html = true) {
    global $db, $gmail_config, $smtp_configured;
    
    // Get SMTP settings from database
    $smtp_settings = array();
    $settings_query = "SELECT setting_name, setting_value FROM reseller_settings WHERE setting_name LIKE 'smtp_%'";
    $settings_result = $db->sql_query($settings_query);
    
    if($settings_result) {
        while($setting = $db->sql_fetchrow($settings_result)) {
            $smtp_settings[$setting['setting_name']] = $setting['setting_value'];
        }
    }
    
    // Check if SMTP is enabled
    if(!isset($smtp_settings['smtp_enabled']) || $smtp_settings['smtp_enabled'] != '1') {
        // Use PHP's default mail() function as fallback
        $headers = "From: " . ($smtp_settings['smtp_from_name'] ?? 'VPN Panel') . " <" . ($smtp_settings['smtp_from_email'] ?? 'noreply@' . $_SERVER['HTTP_HOST']) . ">\r\n";
        if($is_html) {
            $headers .= "Content-Type: text/html; charset=UTF-8\r\n";
        } else {
            $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";
        }
        
        return mail($to_email, $subject, $body, $headers);
    }
    
    // Determine SMTP type (Gmail or Webmail)
    $smtp_type = $smtp_settings['smtp_type'] ?? 'gmail';
    
    if($smtp_type === 'gmail' && $smtp_configured) {
        // Use Gmail SMTP (bypasses ISP blocking and PHPMailer issues)
        $result = sendGmailSMTP($gmail_config['username'], $gmail_config['app_password'], $to_email, $subject, $body);
        
        if($result === "SUCCESS") {
            return true;
        } else {
            // Log error and fallback to regular mail
            error_log("Gmail SMTP failed: $result");
        }
    } elseif($smtp_type === 'webmail') {
        // Use Webmail SMTP (traditional method)
        $webmail_host = $smtp_settings['webmail_host'] ?? 'mail.ruzain.com';
        $webmail_port = intval($smtp_settings['webmail_port'] ?? 587);
        $webmail_security = $smtp_settings['webmail_security'] ?? 'tls';
        $webmail_username = $smtp_settings['webmail_username'] ?? 'info@ruzain.com';
        $webmail_password = $smtp_settings['webmail_password'] ?? '';
        
        if(!empty($webmail_host) && !empty($webmail_username) && !empty($webmail_password)) {
            $result = sendGmailSMTP($webmail_username, $webmail_password, $to_email, $subject, $body, $webmail_host, $webmail_port, $webmail_security);
            
            if($result === "SUCCESS") {
                return true;
            } else {
                error_log("Webmail SMTP failed: $result");
            }
        }
    }
    
    // Fallback to PHP mail() if SMTP fails
    $headers = "From: " . ($smtp_settings['smtp_from_name'] ?? 'VPN Panel') . " <" . ($smtp_settings['smtp_from_email'] ?? 'noreply@' . $_SERVER['HTTP_HOST']) . ">\r\n";
    if($is_html) {
        $headers .= "Content-Type: text/html; charset=UTF-8\r\n";
    } else {
        $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";
    }
    
    return mail($to_email, $subject, $body, $headers);
}

function getEmailSettings() {
    global $db;
    
    $settings = array();
    $settings_query = "SELECT setting_name, setting_value FROM reseller_settings";
    $settings_result = $db->sql_query($settings_query);
    
    if($settings_result) {
        while($setting = $db->sql_fetchrow($settings_result)) {
            $settings[$setting['setting_name']] = $setting['setting_value'];
        }
    }
    
    return $settings;
}
?>
