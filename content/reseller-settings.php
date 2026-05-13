<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Check if user is logged in and has proper permissions
if(!isset($user) || empty($user) || !is_logged_in($user)) {
    $db->RedirectToURL($db->base_url().'login');
    exit;
}

// Check if user has admin permissions
if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    $db->RedirectToURL($db->base_url().'dashboard');
    exit;
}

// Get current reseller settings
$settings = array();

try {
    $settings_query = "SELECT setting_name, setting_value FROM reseller_settings";
    $settings_result = $db->sql_query($settings_query);
    
    if($settings_result) {
        while($setting = $db->sql_fetchrow($settings_result)) {
            $settings[$setting['setting_name']] = $setting['setting_value'];
        }
    }
} catch(Exception $e) {
    // If table doesn't exist, we'll use defaults
}

// Get system information for auto-detection
$server_domain = $_SERVER['HTTP_HOST'] ?? 'localhost';
$admin_email_auto = 'admin@' . str_replace('www.', '', $server_domain);

// Set default values if settings don't exist
$default_settings = array(
    'email_notifications' => '1',
    'auto_approval' => '0',
    'admin_email' => $admin_email_auto,
    'panel_domain' => $server_domain,
    'company_name' => 'VPN Panel System',
    'company_logo' => '/dist/img/logo.png',
    'company_address' => '',
    'company_phone' => '',
    'company_website' => 'https://' . $server_domain,
    'smtp_enabled' => '0',
    'smtp_type' => 'gmail', // gmail or webmail
    'smtp_host' => '',
    'smtp_port' => '587',
    'smtp_security' => 'tls',
    'smtp_username' => '',
    'smtp_password' => '',
    'smtp_from_email' => $admin_email_auto,
    'smtp_from_name' => 'VPN Panel',
    // Gmail SMTP settings
    'gmail_enabled' => '1',
    'gmail_username' => 'datasoftcaresales@gmail.com',
    'gmail_from_name' => 'VPN Panel System',
    // Webmail SMTP settings  
    'webmail_host' => 'mail.ruzain.com',
    'webmail_port' => '587',
    'webmail_security' => 'tls',
    'webmail_username' => 'info@ruzain.com',
    'webmail_password' => '',
    'webmail_from_name' => 'VPN Panel',
    'welcome_email_subject' => '🎉 Welcome to Our Reseller Program - Account Created!',
    'welcome_email_body' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Our Reseller Program</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .header { text-align: center; padding: 20px 0; border-bottom: 3px solid #007bff; margin-bottom: 20px; }
        .logo { max-height: 60px; margin-bottom: 10px; }
        .welcome-title { color: #007bff; font-size: 24px; margin: 0; }
        .account-details { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #28a745; }
        .detail-row { margin: 10px 0; padding: 8px 0; border-bottom: 1px solid #eee; }
        .detail-label { font-weight: bold; color: #495057; }
        .detail-value { color: #007bff; font-family: monospace; }
        .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; color: #6c757d; font-size: 14px; }
        .contact-info { background: #e9ecef; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .bangla-text { font-family: "Hind Siliguri", Arial, sans-serif; background: #fff3cd; padding: 10px; border-radius: 5px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="{company_logo}" alt="{company_name}" class="logo">
            <h1 class="welcome-title">Welcome to Our Reseller Program!</h1>
        </div>
        
        <p>Dear <strong>{name}</strong>,</p>
        
        <p>Congratulations! 🎉 Your reseller application has been approved and your account has been successfully created. We are excited to have you as part of our reseller network!</p>
        
        <div class="account-details">
            <h3 style="color: #28a745; margin-top: 0;">🔐 Your Reseller Account Details</h3>
            <div class="detail-row">
                <span class="detail-label">Username:</span>
                <span class="detail-value">{username}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Password:</span>
                <span class="detail-value">{password}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Reseller Panel:</span>
                <span class="detail-value">{reseller_url}</span>
            </div>
        </div>
        
        <div class="bangla-text">
            <p style="margin: 0; font-size: 16px;">🇧🇩 আপনাকে স্বাগতম! আপনার রিসেলার আবেদন অনুমোদিত হয়েছে এবং আপনার অ্যাকাউন্ট তৈরি করা হয়েছে।</p>
        </div>
        
        <div class="contact-info">
            <h4 style="margin-top: 0; color: #495057;">📞 Contact Information</h4>
            <p><strong>Company:</strong> {company_name}<br>
            <strong>Website:</strong> <a href="{panel_domain}">{panel_domain}</a><br>
            <strong>Support Email:</strong> <a href="mailto:{admin_email}">{admin_email}</a></p>
        </div>
        
        <div class="footer">
            <p>Thank you for choosing {company_name}!</p>
            <p><small>This email was sent from {panel_domain} | © 2025 {company_name}</small></p>
        </div>
    </div>
</body>
</html>',
    'approval_email_subject' => '✅ Congratulations! Your Reseller Application has been Approved',
    'approval_email_body' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Approved</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .header { text-align: center; padding: 20px 0; border-bottom: 3px solid #28a745; margin-bottom: 20px; }
        .logo { max-height: 60px; margin-bottom: 10px; }
        .approval-title { color: #28a745; font-size: 24px; margin: 0; }
        .approval-badge { background: #28a745; color: white; padding: 10px 20px; border-radius: 25px; display: inline-block; margin: 15px 0; font-weight: bold; }
        .business-info { background: #d4edda; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #28a745; }
        .next-steps { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #007bff; }
        .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; color: #6c757d; font-size: 14px; }
        .contact-info { background: #e9ecef; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .bangla-text { font-family: "Hind Siliguri", Arial, sans-serif; background: #fff3cd; padding: 10px; border-radius: 5px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="{company_logo}" alt="{company_name}" class="logo">
            <h1 class="approval-title">Application Approved!</h1>
            <div class="approval-badge">✅ APPROVED</div>
        </div>
        
        <p>Dear <strong>{name}</strong>,</p>
        
        <p>Congratulations! 🎉 We are pleased to inform you that your reseller application has been <strong>approved</strong>!</p>
        
        <div class="business-info">
            <h3 style="color: #155724; margin-top: 0;">📋 Application Details</h3>
            <p><strong>Business Name:</strong> {business_name}<br>
            <strong>Applicant:</strong> {name}<br>
            <strong>Status:</strong> <span style="color: #28a745; font-weight: bold;">APPROVED</span></p>
        </div>
        
        <div class="bangla-text">
            <p style="margin: 0; font-size: 16px;">🇧🇩 অভিনন্দন! আপনার রিসেলার আবেদন অনুমোদিত হয়েছে। আমরা শীঘ্রই আপনার সাথে যোগাযোগ করব।</p>
        </div>
        
        <div class="next-steps">
            <h3 style="color: #0c5460; margin-top: 0;">📋 Next Steps</h3>
            <p>Our team will contact you within <strong>24-48 hours</strong> with:</p>
            <ul>
                <li>Your reseller account credentials</li>
                <li>Access to the reseller panel</li>
                <li>Training materials and documentation</li>
                <li>Pricing and commission structure</li>
            </ul>
        </div>
        
        <div class="contact-info">
            <h4 style="margin-top: 0; color: #495057;">📞 Contact Information</h4>
            <p><strong>Company:</strong> {company_name}<br>
            <strong>Website:</strong> <a href="{panel_domain}">{panel_domain}</a><br>
            <strong>Support Email:</strong> <a href="mailto:{admin_email}">{admin_email}</a></p>
        </div>
        
        <div class="footer">
            <p>Welcome to the {company_name} reseller family!</p>
            <p><small>This email was sent from {panel_domain} | © 2025 {company_name}</small></p>
        </div>
    </div>
</body>
</html>',
    'auto_reply_email_subject' => '✅ Thank You! Your Reseller Application has been Received',
    'auto_reply_email_body' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Received</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .header { text-align: center; padding: 20px 0; border-bottom: 3px solid #17a2b8; margin-bottom: 20px; }
        .logo { max-height: 60px; margin-bottom: 10px; }
        .received-title { color: #17a2b8; font-size: 24px; margin: 0; }
        .received-badge { background: #17a2b8; color: white; padding: 10px 20px; border-radius: 25px; display: inline-block; margin: 15px 0; font-weight: bold; }
        .application-info { background: #d1ecf1; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #17a2b8; }
        .next-steps { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #28a745; }
        .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; color: #6c757d; font-size: 14px; }
        .contact-info { background: #e9ecef; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .bangla-text { font-family: "Hind Siliguri", Arial, sans-serif; background: #fff3cd; padding: 10px; border-radius: 5px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="{company_logo}" alt="{company_name}" class="logo">
            <h1 class="received-title">Application Received!</h1>
            <div class="received-badge">✅ RECEIVED</div>
        </div>
        
        <p>Dear <strong>{name}</strong>,</p>
        
        <p>Thank you for submitting your reseller application! We have successfully received your application for <strong>{business_name}</strong> and it is now under review.</p>
        
        <div class="application-info">
            <h3 style="color: #0c5460; margin-top: 0;">📋 Application Summary</h3>
            <p><strong>Business Name:</strong> {business_name}<br>
            <strong>Applicant:</strong> {name}<br>
            <strong>Email:</strong> {email}<br>
            <strong>Status:</strong> <span style="color: #17a2b8; font-weight: bold;">UNDER REVIEW</span></p>
        </div>
        
        <div class="bangla-text">
            <p style="margin: 0; font-size: 16px;">🇧🇩 ধন্যবাদ! আপনার রিসেলার আবেদন গ্রহণ করা হয়েছে এবং পর্যালোচনা করা হচ্ছে।</p>
        </div>
        
        <div class="next-steps">
            <h3 style="color: #155724; margin-top: 0;">⏰ What Happens Next?</h3>
            <p>Our team will carefully review your application. Here\'s what you can expect:</p>
            <ul>
                <li><strong>Review Period:</strong> 2-3 business days</li>
                <li><strong>Verification:</strong> We may contact you for additional information</li>
                <li><strong>Decision:</strong> You will receive an email with our decision</li>
                <li><strong>Account Setup:</strong> If approved, we\'ll create your reseller account</li>
            </ul>
        </div>
        
        <div class="contact-info">
            <h4 style="margin-top: 0; color: #495057;">📞 Contact Information</h4>
            <p>If you have any questions about your application, please contact us:</p>
            <p><strong>Company:</strong> {company_name}<br>
            <strong>Website:</strong> <a href="{panel_domain}">{panel_domain}</a><br>
            <strong>Support Email:</strong> <a href="mailto:{admin_email}">{admin_email}</a></p>
        </div>
        
        <div class="footer">
            <p>Thank you for your interest in {company_name}!</p>
            <p><small>This is an automated email from {panel_domain} | © 2025 {company_name}</small></p>
        </div>
    </div>
</body>
</html>',
    'rejection_email_subject' => '📋 Update on Your Reseller Application',
    'rejection_email_body' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Update</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .header { text-align: center; padding: 20px 0; border-bottom: 3px solid #dc3545; margin-bottom: 20px; }
        .logo { max-height: 60px; margin-bottom: 10px; }
        .update-title { color: #dc3545; font-size: 24px; margin: 0; }
        .status-badge { background: #dc3545; color: white; padding: 10px 20px; border-radius: 25px; display: inline-block; margin: 15px 0; font-weight: bold; }
        .reason-box { background: #f8d7da; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #dc3545; }
        .reapply-info { background: #d1ecf1; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #17a2b8; }
        .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; color: #6c757d; font-size: 14px; }
        .contact-info { background: #e9ecef; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .bangla-text { font-family: "Hind Siliguri", Arial, sans-serif; background: #fff3cd; padding: 10px; border-radius: 5px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="{company_logo}" alt="{company_name}" class="logo">
            <h1 class="update-title">Application Update</h1>
            <div class="status-badge">📋 UNDER REVIEW</div>
        </div>
        
        <p>Dear <strong>{name}</strong>,</p>
        
        <p>Thank you for your interest in our reseller program and for taking the time to submit your application for <strong>{business_name}</strong>.</p>
        
        <p>After careful review of your application, we are unable to approve it at this time.</p>
        
        <div class="reason-box">
            <h3 style="color: #721c24; margin-top: 0;">📝 Reason for Decision</h3>
            <p><strong>{reason}</strong></p>
        </div>
        
        <div class="bangla-text">
            <p style="margin: 0; font-size: 16px;">🇧🇩 দুঃখিত, আপনার আবেদন এই মুহূর্তে অনুমোদন করা সম্ভব হয়নি। ভবিষ্যতে আবার আবেদন করতে পারেন।</p>
        </div>
        
        <div class="reapply-info">
            <h3 style="color: #0c5460; margin-top: 0;">🔄 Future Applications</h3>
            <p>We encourage you to address the concerns mentioned above and reapply in the future. Our reseller program is always open to qualified applicants.</p>
            <p><strong>You may reapply after:</strong> 30 days from today</p>
        </div>
        
        <div class="contact-info">
            <h4 style="margin-top: 0; color: #495057;">📞 Contact Information</h4>
            <p>If you have any questions about this decision, please feel free to contact us:</p>
            <p><strong>Company:</strong> {company_name}<br>
            <strong>Website:</strong> <a href="{panel_domain}">{panel_domain}</a><br>
            <strong>Support Email:</strong> <a href="mailto:{admin_email}">{admin_email}</a></p>
        </div>
        
        <div class="footer">
            <p>Thank you for your interest in {company_name}</p>
            <p><small>This email was sent from {panel_domain} | © 2025 {company_name}</small></p>
        </div>
    </div>
</body>
</html>'
);

// Merge with defaults
foreach($default_settings as $key => $default_value) {
    if(!isset($settings[$key])) {
        $settings[$key] = $default_value;
    }
}

// Load Gmail SMTP configuration status
require_once dirname(__FILE__) . '/../includes/smtp_config.php';

// Set navigation active states
$smarty->assign('reseller_management_active', 'active');
$smarty->assign('reseller_settings_active', 'active');
$smarty->assign('settings', $settings);

// Add Gmail configuration status
$smarty->assign('gmail_configured', $smtp_configured);
$smarty->assign('gmail_config', $gmail_config);
$smarty->assign('smtp_error', $smtp_error);

// Add system information
$system_info = array(
    'server_domain' => $server_domain,
    'admin_email_auto' => $admin_email_auto,
    'server_ip' => $_SERVER['SERVER_ADDR'] ?? 'Unknown',
    'php_version' => phpversion(),
    'current_time' => date('Y-m-d H:i:s'),
    'timezone' => date_default_timezone_get()
);

// Add encryption key for form security
$smarty->assign('firenet_encrypt', $db->encryptor('encrypt', 'firenetdev'));
$smarty->assign('system_info', $system_info);

$smarty->display('reseller-settings.tpl');
?>

