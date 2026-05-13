<?php
/**
 * Email Unsubscribe Page
 * Allows users to opt-out from email campaigns
 */
error_reporting(E_ERROR | E_PARSE);
require_once 'includes/functions.php';

$email = isset($_GET['email']) ? trim($_GET['email']) : '';
$success = false;
$error = '';
$already_unsubscribed = false;

// Process unsubscribe request
if(!empty($email)) {
    // Validate email
    if(!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'Invalid email address';
    } else {
        // Check if email exists in database
        $check_query = "SELECT id, status FROM email_subscribers WHERE email = '".$db->SanitizeForSQL($email)."'";
        $result = $db->sql_query($check_query);
        
        if($result && $db->sql_numrows($result) > 0) {
            $subscriber = $db->sql_fetchrow($result);
            
            if($subscriber['status'] == 'unsubscribed') {
                $already_unsubscribed = true;
            } else {
                // Update subscriber status to unsubscribed
                $update_query = "UPDATE email_subscribers SET 
                                status = 'unsubscribed',
                                unsubscribed_date = '".date('Y-m-d H:i:s')."'
                                WHERE email = '".$db->SanitizeForSQL($email)."'";
                
                if($db->sql_query($update_query)) {
                    $success = true;
                    
                    // Log activity
                    $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                                  VALUES (0, '".date('Y-m-d H:i:s')."', 'Email unsubscribed: $email', 
                                  '".$_SERVER['REMOTE_ADDR']."', '', '')";
                    $db->sql_query($log_query);
                } else {
                    $error = 'Failed to process unsubscribe request. Please try again.';
                }
            }
        } else {
            $error = 'Email address not found in our mailing list';
        }
    }
} else {
    $error = 'No email address provided';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unsubscribe - VPN Panel</title>
    <link rel="stylesheet" href="dist/bootstrap-4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="dist/@fortawesome/fontawesome-free/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        .header p {
            opacity: 0.9;
            font-size: 16px;
        }
        .content {
            padding: 40px;
            text-align: center;
        }
        .icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        .icon.success {
            color: #28a745;
        }
        .icon.error {
            color: #dc3545;
        }
        .icon.warning {
            color: #ffc107;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        .email-display {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            font-family: monospace;
            color: #333;
            word-break: break-all;
        }
        .btn {
            padding: 14px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-block;
            text-decoration: none;
            margin-top: 20px;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102,126,234,0.4);
            color: white;
            text-decoration: none;
        }
        .btn-secondary {
            background: #6c757d;
        }
        .footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            font-size: 14px;
        }
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .alert-info {
            background: #e3f2fd;
            border: 1px solid #b3d4fc;
            color: #0c5460;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📧 Email Preferences</h1>
            <p>Manage your email subscription</p>
        </div>
        
        <div class="content">
            <?php if($success): ?>
                <div class="icon success">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h2>Successfully Unsubscribed</h2>
                <p>You have been removed from our mailing list.</p>
                <div class="email-display">
                    <?php echo htmlspecialchars($email); ?>
                </div>
                <p>We're sorry to see you go! You will no longer receive promotional emails from us.</p>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> You may still receive important account-related emails if you have an active account with us.
                </div>
                <p><small>Changed your mind? You can re-subscribe anytime from our website.</small></p>
                
            <?php elseif($already_unsubscribed): ?>
                <div class="icon warning">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                <h2>Already Unsubscribed</h2>
                <p>This email address is already unsubscribed from our mailing list.</p>
                <div class="email-display">
                    <?php echo htmlspecialchars($email); ?>
                </div>
                <p>You won't receive any promotional emails from us.</p>
                
            <?php elseif(!empty($error)): ?>
                <div class="icon error">
                    <i class="fas fa-times-circle"></i>
                </div>
                <h2>Unsubscribe Failed</h2>
                <p><?php echo htmlspecialchars($error); ?></p>
                <?php if(!empty($email)): ?>
                <div class="email-display">
                    <?php echo htmlspecialchars($email); ?>
                </div>
                <?php endif; ?>
                <p>Please contact our support team if you continue to experience issues.</p>
                
            <?php else: ?>
                <div class="icon error">
                    <i class="fas fa-envelope-open-text"></i>
                </div>
                <h2>Invalid Request</h2>
                <p>No email address was provided. Please use the unsubscribe link from your email.</p>
            <?php endif; ?>
            
            <a href="<?php echo $db->base_url(); ?>" class="btn">
                <i class="fas fa-home"></i> Return to Homepage
            </a>
        </div>
        
        <div class="footer">
            <p>&copy; <?php echo date('Y'); ?> VPN Panel. All rights reserved.</p>
            <p style="margin-top: 10px;">
                <small>If you believe this was a mistake, please contact our support team.</small>
            </p>
        </div>
    </div>
</body>
</html>
