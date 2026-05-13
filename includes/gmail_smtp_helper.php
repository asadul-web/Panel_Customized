<?php
/**
 * Gmail SMTP Helper for VPN Panel
 * Bypasses ISP SMTP blocking and PHPMailer issues
 * 
 * Usage:
 * require_once 'includes/gmail_smtp_helper.php';
 * $result = sendVPNPanelEmail('recipient@domain.com', 'Subject', 'Message content');
 */

// Load SMTP configuration
require_once __DIR__ . '/smtp_config.php';

// Gmail SMTP Configuration
define('GMAIL_SMTP_HOST', 'smtp.gmail.com');
define('GMAIL_SMTP_PORT', 587);

/**
 * Send email using SMTP (Gmail or other providers)
 * 
 * @param string $from Email address
 * @param string $password Email password or App Password
 * @param string $to Recipient email
 * @param string $subject Email subject
 * @param string $message Email message (HTML supported)
 * @param string $smtp_host SMTP server (default: Gmail)
 * @param int $smtp_port SMTP port (default: 587)
 * @param string $security Security type (tls, ssl, or none)
 * @return string "SUCCESS" or error message
 */
function sendGmailSMTP($from, $password, $to, $subject, $message, $smtp_host = null, $smtp_port = null, $security = 'tls') {
    $smtp_server = $smtp_host ?? GMAIL_SMTP_HOST;
    $smtp_port = $smtp_port ?? GMAIL_SMTP_PORT;
    
    // Connect to Gmail SMTP
    $socket = stream_socket_client("$smtp_server:$smtp_port", $errno, $errstr, 30);
    if (!$socket) {
        return "Connection failed: $errstr ($errno)";
    }
    
    // Read server greeting
    $response = fgets($socket, 515);
    if (substr($response, 0, 3) != '220') {
        fclose($socket);
        return "Server greeting failed: $response";
    }
    
    // Send EHLO
    fwrite($socket, "EHLO localhost\r\n");
    $response = '';
    do {
        $line = fgets($socket, 515);
        $response .= $line;
    } while ($line && substr($line, 3, 1) == '-');
    
    // Handle encryption based on security type
    if($security === 'tls') {
        // Start TLS
        fwrite($socket, "STARTTLS\r\n");
        $response = fgets($socket, 515);
        if (substr($response, 0, 3) != '220') {
            fclose($socket);
            return "STARTTLS failed: $response";
        }
        
        // Enable TLS encryption
        if (!stream_socket_enable_crypto($socket, true, STREAM_CRYPTO_METHOD_TLS_CLIENT)) {
            fclose($socket);
            return "TLS encryption failed";
        }
    } elseif($security === 'ssl') {
        // SSL is handled at connection level, already done if needed
        // For SSL connections, we would connect to ssl://host:port initially
    }
    // For 'none' security, we skip encryption
    
    // Send EHLO again after TLS
    fwrite($socket, "EHLO localhost\r\n");
    $response = '';
    do {
        $line = fgets($socket, 515);
        $response .= $line;
    } while ($line && substr($line, 3, 1) == '-');
    
    // Authenticate
    fwrite($socket, "AUTH LOGIN\r\n");
    $response = fgets($socket, 515);
    if (substr($response, 0, 3) != '334') {
        fclose($socket);
        return "AUTH LOGIN failed: $response";
    }
    
    // Send username
    fwrite($socket, base64_encode($from) . "\r\n");
    $response = fgets($socket, 515);
    if (substr($response, 0, 3) != '334') {
        fclose($socket);
        return "Username failed: $response";
    }
    
    // Send password
    fwrite($socket, base64_encode($password) . "\r\n");
    $response = fgets($socket, 515);
    if (substr($response, 0, 3) != '235') {
        fclose($socket);
        return "Authentication failed: $response";
    }
    
    // Send MAIL FROM
    fwrite($socket, "MAIL FROM:<$from>\r\n");
    $response = fgets($socket, 515);
    if (substr($response, 0, 3) != '250') {
        fclose($socket);
        return "MAIL FROM failed: $response";
    }
    
    // Send RCPT TO
    fwrite($socket, "RCPT TO:<$to>\r\n");
    $response = fgets($socket, 515);
    if (substr($response, 0, 3) != '250') {
        fclose($socket);
        return "RCPT TO failed: $response";
    }
    
    // Send DATA
    fwrite($socket, "DATA\r\n");
    $response = fgets($socket, 515);
    if (substr($response, 0, 3) != '354') {
        fclose($socket);
        return "DATA command failed: $response";
    }
    
    // Send email headers and body
    $email_data = "From: $from\r\n";
    $email_data .= "To: $to\r\n";
    $email_data .= "Subject: $subject\r\n";
    $email_data .= "Date: " . date('r') . "\r\n";
    $email_data .= "MIME-Version: 1.0\r\n";
    $email_data .= "Content-Type: text/html; charset=UTF-8\r\n";
    $email_data .= "Content-Transfer-Encoding: 8bit\r\n";
    $email_data .= "\r\n";
    $email_data .= $message;
    $email_data .= "\r\n.\r\n";
    
    fwrite($socket, $email_data);
    $response = fgets($socket, 515);
    if (substr($response, 0, 3) != '250') {
        fclose($socket);
        return "Email sending failed: $response";
    }
    
    // Send QUIT
    fwrite($socket, "QUIT\r\n");
    fclose($socket);
    
    return "SUCCESS";
}

/**
 * Simplified function for VPN Panel emails
 * Uses predefined Gmail credentials
 * 
 * @param string $to Recipient email
 * @param string $subject Email subject
 * @param string $message Email message (HTML supported)
 * @param string $from_name Optional sender name (default: VPN Panel)
 * @return bool True if successful, false otherwise
 */
function sendVPNPanelEmail($to, $subject, $message, $from_name = 'VPN Panel') {
    global $gmail_config, $smtp_configured;
    
    // Check if Gmail credentials are configured
    if (!$smtp_configured) {
        error_log('Gmail App Password not configured in smtp_config.php');
        return false;
    }
    
    // Add VPN Panel branding to email
    $branded_message = '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">';
    $branded_message .= '<div style="background: #007cba; color: white; padding: 20px; text-align: center;">';
    $branded_message .= '<h2 style="margin: 0;">🔐 VPN Panel</h2>';
    $branded_message .= '</div>';
    $branded_message .= '<div style="padding: 20px; background: #f9f9f9;">';
    $branded_message .= $message;
    $branded_message .= '</div>';
    $branded_message .= '<div style="background: #333; color: #ccc; padding: 15px; text-align: center; font-size: 12px;">';
    $branded_message .= '<p>This email was sent from your VPN Panel system.</p>';
    $branded_message .= '<p>Time: ' . date('Y-m-d H:i:s') . '</p>';
    $branded_message .= '</div>';
    $branded_message .= '</div>';
    
    $result = sendGmailSMTP($gmail_config['username'], $gmail_config['app_password'], $to, $subject, $branded_message);
    
    if ($result === "SUCCESS") {
        return true;
    } else {
        error_log("VPN Panel Email Failed: $result");
        return false;
    }
}

/**
 * Send welcome email to new VPN users
 * 
 * @param string $user_email User's email address
 * @param string $username VPN username
 * @param string $password VPN password
 * @param int $duration Account duration in days
 * @return bool True if successful
 */
function sendWelcomeEmail($user_email, $username, $password, $duration) {
    $subject = 'Welcome to VPN Service - Account Created';
    
    $message = '<h3>🎉 Welcome to Our VPN Service!</h3>';
    $message .= '<p>Your VPN account has been successfully created.</p>';
    $message .= '<div style="background: #e8f5e8; padding: 15px; border-radius: 5px; margin: 20px 0;">';
    $message .= '<h4>📋 Account Details:</h4>';
    $message .= '<p><strong>Username:</strong> ' . htmlspecialchars($username) . '</p>';
    $message .= '<p><strong>Password:</strong> ' . htmlspecialchars($password) . '</p>';
    $message .= '<p><strong>Duration:</strong> ' . $duration . ' days</p>';
    $message .= '</div>';
    $message .= '<h4>🔧 Setup Instructions:</h4>';
    $message .= '<ol>';
    $message .= '<li>Download your VPN client</li>';
    $message .= '<li>Use the credentials above to connect</li>';
    $message .= '<li>Enjoy secure browsing!</li>';
    $message .= '</ol>';
    $message .= '<p>If you need help, please contact our support team.</p>';
    
    return sendVPNPanelEmail($user_email, $subject, $message);
}

/**
 * Send account expiration warning
 * 
 * @param string $user_email User's email
 * @param string $username VPN username
 * @param int $days_remaining Days until expiration
 * @return bool True if successful
 */
function sendExpirationWarning($user_email, $username, $days_remaining) {
    $subject = 'VPN Account Expiration Warning - ' . $days_remaining . ' days remaining';
    
    $message = '<h3>⚠️ Account Expiration Notice</h3>';
    $message .= '<p>Your VPN account is set to expire soon.</p>';
    $message .= '<div style="background: #fff3cd; padding: 15px; border-radius: 5px; margin: 20px 0;">';
    $message .= '<h4>📋 Account Information:</h4>';
    $message .= '<p><strong>Username:</strong> ' . htmlspecialchars($username) . '</p>';
    $message .= '<p><strong>Days Remaining:</strong> ' . $days_remaining . ' days</p>';
    $message .= '</div>';
    $message .= '<p>To continue using our VPN service, please renew your account before it expires.</p>';
    $message .= '<p>Contact our support team for renewal options.</p>';
    
    return sendVPNPanelEmail($user_email, $subject, $message);
}

/**
 * Send password reset email
 * 
 * @param string $user_email User's email
 * @param string $username VPN username
 * @param string $new_password New password
 * @return bool True if successful
 */
function sendPasswordReset($user_email, $username, $new_password) {
    $subject = 'VPN Account Password Reset';
    
    $message = '<h3>🔑 Password Reset Confirmation</h3>';
    $message .= '<p>Your VPN account password has been reset as requested.</p>';
    $message .= '<div style="background: #e3f2fd; padding: 15px; border-radius: 5px; margin: 20px 0;">';
    $message .= '<h4>📋 New Login Details:</h4>';
    $message .= '<p><strong>Username:</strong> ' . htmlspecialchars($username) . '</p>';
    $message .= '<p><strong>New Password:</strong> ' . htmlspecialchars($new_password) . '</p>';
    $message .= '</div>';
    $message .= '<p>Please use these new credentials to access your VPN account.</p>';
    $message .= '<p>For security reasons, consider changing your password after logging in.</p>';
    
    return sendVPNPanelEmail($user_email, $subject, $message);
}

/**
 * Test Gmail SMTP configuration
 * 
 * @return array Result with status and message
 */
function testGmailSMTPConfig() {
    global $gmail_config, $smtp_configured;
    
    if (!$smtp_configured) {
        return [
            'success' => false,
            'message' => 'Gmail App Password not configured. Please set app_password in smtp_config.php'
        ];
    }
    
    $test_result = sendGmailSMTP(
        $gmail_config['username'], 
        $gmail_config['app_password'], 
        $gmail_config['username'], 
        'VPN Panel SMTP Test - ' . date('Y-m-d H:i:s'),
        '<h3>✅ VPN Panel SMTP Test Successful!</h3><p>Gmail SMTP is working correctly.</p>'
    );
    
    if ($test_result === "SUCCESS") {
        return [
            'success' => true,
            'message' => 'Gmail SMTP is working correctly!'
        ];
    } else {
        return [
            'success' => false,
            'message' => 'Gmail SMTP test failed: ' . $test_result
        ];
    }
}
?>
