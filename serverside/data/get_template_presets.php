<?php
// Get Template Presets for Quick Creation
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Include required functions and check permissions like other similar files
require_once dirname(__FILE__) . '/../../includes/functions.php';

// Check if user is logged in and has proper permissions
if(!isset($user) || !is_logged_in($user)) {
    $values = array('response' => 2, 'msg' => 'Unauthorized');
    echo json_encode($values);
    exit;
}

if(!isset($user_level_2) || ($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator')) {
    $values = array('response' => 2, 'msg' => 'Insufficient permissions');
    echo json_encode($values);
    exit;
}

// Set content type for JSON response with UTF-8 encoding
header('Content-Type: application/json; charset=utf-8');
mb_internal_encoding('UTF-8');

$values = array();

$template_presets = array(
    array(
        'name' => 'Modern Welcome Email',
        'subject' => 'Welcome to {website_name} - Your VPN Journey Starts Here!',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 0; font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .container { max-width: 600px; margin: 0 auto; background: white; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 20px; text-align: center; }
        .header h1 { color: white; margin: 0; font-size: 28px; }
        .content { padding: 40px 30px; }
        .welcome-box { background: #f8f9ff; border-left: 4px solid #667eea; padding: 20px; margin: 20px 0; }
        .btn { display: inline-block; background: #667eea; color: white; padding: 15px 30px; text-decoration: none; border-radius: 25px; margin: 20px 0; }
        .features { display: flex; flex-wrap: wrap; gap: 20px; margin: 30px 0; }
        .feature { flex: 1; min-width: 150px; text-align: center; padding: 20px; background: #f8f9ff; border-radius: 10px; }
        .footer { background: #333; color: white; padding: 30px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Welcome Aboard!</h1>
        </div>
        <div class="content">
            <div class="welcome-box">
                <h2>Hello {name}!</h2>
                <p>Welcome to our premium VPN service! We are excited to have you join our community of privacy-conscious users.</p>
            </div>
            
            <div class="features">
                <div class="feature">
                    <h3>🔒 Secure</h3>
                    <p>Military-grade encryption</p>
                </div>
                <div class="feature">
                    <h3>⚡ Fast</h3>
                    <p>Lightning-fast servers</p>
                </div>
                <div class="feature">
                    <h3>🌍 Global</h3>
                    <p>Servers worldwide</p>
                </div>
            </div>
            
            <p>Your account is now active and ready to use. Click the button below to get started:</p>
            <a href="{website_url}" class="btn">Get Started Now</a>
            
            <p>If you have any questions, our 24/7 support team is here to help!</p>
        </div>
        <div class="footer">
            <p>© 2024 VPN Service. All rights reserved.</p>
            <p><a href="{unsubscribe_url}" style="color: #ccc;">Unsubscribe</a></p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'welcome'
    ),
    
    array(
        'name' => 'Newsletter - Tech Updates',
        'subject' => '📰 Weekly Tech Updates & VPN News',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 0; font-family: "Segoe UI", Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .header { background: #2c3e50; color: white; padding: 30px; text-align: center; }
        .content { padding: 30px; }
        .article { border-bottom: 1px solid #eee; padding: 20px 0; }
        .article:last-child { border-bottom: none; }
        .article h3 { color: #2c3e50; margin-top: 0; }
        .read-more { color: #3498db; text-decoration: none; font-weight: bold; }
        .stats { background: #ecf0f1; padding: 20px; border-radius: 10px; margin: 20px 0; }
        .footer { background: #34495e; color: white; padding: 20px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📰 Weekly Newsletter</h1>
            <p>Stay updated with the latest in VPN technology</p>
        </div>
        <div class="content">
            <p>Hi {name},</p>
            
            <div class="stats">
                <h3>📊 This Week in Numbers</h3>
                <p>• 50,000+ new users joined<br>
                • 99.9% uptime maintained<br>
                • 15 new server locations added</p>
            </div>
            
            <div class="article">
                <h3>🔒 New Security Features Released</h3>
                <p>We have enhanced our encryption protocols with the latest WireGuard technology, providing even faster and more secure connections.</p>
                <a href="{website_url}" class="read-more">Read More →</a>
            </div>
            
            <div class="article">
                <h3>🌍 Server Expansion Update</h3>
                <p>New servers are now live in Tokyo, Sydney, and São Paulo, bringing our total to over 100 locations worldwide.</p>
                <a href="{website_url}" class="read-more">View All Locations →</a>
            </div>
            
            <div class="article">
                <h3>💡 Privacy Tip of the Week</h3>
                <p>Always use HTTPS websites when browsing. Look for the lock icon in your browser address bar to ensure your connection is encrypted.</p>
            </div>
        </div>
        <div class="footer">
            <p>Thank you for being part of our community!</p>
            <p><a href="{unsubscribe_url}" style="color: #bdc3c7;">Unsubscribe</a> | <a href="{website_url}" style="color: #bdc3c7;">Visit Website</a></p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'newsletter'
    ),
    
    array(
        'name' => 'Promotion - Special Offer',
        'subject' => '🎉 Limited Time: 50% OFF Premium VPN Plans!',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 0; font-family: Arial, sans-serif; background: linear-gradient(45deg, #ff6b6b, #feca57); }
        .container { max-width: 600px; margin: 0 auto; background: white; }
        .header { background: linear-gradient(45deg, #ff6b6b, #feca57); padding: 40px 20px; text-align: center; color: white; }
        .offer-badge { background: #ff4757; color: white; padding: 10px 20px; border-radius: 50px; display: inline-block; font-weight: bold; margin: 10px 0; }
        .content { padding: 40px 30px; text-align: center; }
        .price-box { background: #f1f2f6; padding: 30px; border-radius: 15px; margin: 30px 0; }
        .old-price { text-decoration: line-through; color: #999; font-size: 18px; }
        .new-price { color: #ff4757; font-size: 36px; font-weight: bold; }
        .cta-button { background: linear-gradient(45deg, #ff6b6b, #feca57); color: white; padding: 20px 40px; text-decoration: none; border-radius: 50px; font-size: 18px; font-weight: bold; display: inline-block; margin: 20px 0; }
        .countdown { background: #2f3542; color: white; padding: 20px; border-radius: 10px; margin: 20px 0; }
        .footer { background: #2f3542; color: white; padding: 20px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="offer-badge">LIMITED TIME OFFER</div>
            <h1>🎉 MEGA SALE</h1>
            <h2>50% OFF Everything!</h2>
        </div>
        <div class="content">
            <p>Hi {name},</p>
            <p>This is your chance to get premium VPN protection at an unbeatable price!</p>
            
            <div class="price-box">
                <h3>Premium Annual Plan</h3>
                <div class="old-price">$99.99/year</div>
                <div class="new-price">$49.99/year</div>
                <p><strong>Save $50 instantly!</strong></p>
            </div>
            
            <div class="countdown">
                <h3>⏰ Hurry! Offer expires in:</h3>
                <p style="font-size: 24px; margin: 0;"><strong>48 HOURS</strong></p>
            </div>
            
            <a href="{website_url}" class="cta-button">Claim Your 50% Discount</a>
            
            <p><strong>What you get:</strong></p>
            <p>✅ Unlimited bandwidth<br>
            ✅ 100+ server locations<br>
            ✅ 24/7 customer support<br>
            ✅ 30-day money-back guarantee</p>
            
            <p><em>No coupon code needed - discount applied automatically!</em></p>
        </div>
        <div class="footer">
            <p>This offer is exclusive to our subscribers</p>
            <p><a href="{unsubscribe_url}" style="color: #a4b0be;">Unsubscribe</a></p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'promotion'
    ),
    
    array(
        'name' => 'Security Alert - Dark Theme',
        'subject' => '🔐 Security Alert: Suspicious Activity Detected',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 0; font-family: "Segoe UI", Arial, sans-serif; background: #1a1a1a; color: #e0e0e0; }
        .container { max-width: 600px; margin: 0 auto; background: #2d2d2d; border: 1px solid #404040; border-radius: 8px; overflow: hidden; }
        .header { background: linear-gradient(135deg, #1e1e1e 0%, #3d3d3d 100%); padding: 40px 30px; text-align: center; }
        .alert-badge { background: #ff4444; color: white; padding: 10px 20px; border-radius: 25px; font-size: 14px; font-weight: bold; display: inline-block; margin-bottom: 15px; }
        .content { padding: 40px 30px; background: #2d2d2d; }
        .alert-box { background: #3d1a1a; border: 2px solid #ff4444; border-radius: 12px; padding: 25px; margin: 25px 0; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 30px 0; }
        .info-item { background: #1a1a1a; padding: 20px; border-radius: 8px; border: 1px solid #404040; }
        .btn { display: inline-block; background: linear-gradient(135deg, #ff4444 0%, #cc3333 100%); color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; margin: 20px 0; font-weight: bold; box-shadow: 0 4px 15px rgba(255,68,68,0.3); }
        .btn:hover { background: linear-gradient(135deg, #cc3333 0%, #aa2222 100%); }
        .footer { background: #1a1a1a; padding: 30px; text-align: center; border-top: 1px solid #404040; }
        .highlight { color: #ff6666; font-weight: bold; }
        .success { color: #66ff66; }
        .warning { color: #ffaa00; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="alert-badge">🚨 SECURITY ALERT</div>
            <h1 style="color: #ff6666; margin: 15px 0; font-size: 28px;">🔐 Suspicious Activity Detected</h1>
            <p style="color: #cccccc; margin: 0;">Immediate action may be required</p>
        </div>
        <div class="content">
            <p>Hello <span class="highlight">{name}</span>,</p>
            
            <div class="alert-box">
                <h3 style="color: #ff6666; margin-top: 0; font-size: 20px;">⚠️ Unusual Login Attempt Blocked</h3>
                <p>We detected and blocked a suspicious login attempt from an unrecognized device or location. Your account remains secure.</p>
            </div>
            
            <div class="info-grid">
                <div class="info-item">
                    <strong style="color: #ffaa00;">📅 Time:</strong><br>
                    <span style="color: #cccccc;">2024-11-12 14:30 UTC</span>
                </div>
                <div class="info-item">
                    <strong style="color: #ffaa00;">🌍 Location:</strong><br>
                    <span style="color: #cccccc;">Unknown Location</span>
                </div>
                <div class="info-item">
                    <strong style="color: #ffaa00;">🌐 IP Address:</strong><br>
                    <span style="color: #cccccc;">192.168.1.xxx</span>
                </div>
                <div class="info-item">
                    <strong style="color: #ffaa00;">🛡️ Status:</strong><br>
                    <span style="color: #ff6666; font-weight: bold;">BLOCKED</span>
                </div>
            </div>
            
            <h3 style="color: #66ff66;">✅ What we did:</h3>
            <p style="line-height: 1.6;">
            <span class="success">✅</span> Immediately blocked the suspicious login attempt<br>
            <span class="success">✅</span> Secured your account with additional protection<br>
            <span class="success">✅</span> Sent you this real-time notification<br>
            <span class="success">✅</span> Logged the incident for further analysis
            </p>
            
            <h3 style="color: #ffaa00;">🔧 Recommended actions:</h3>
            <p style="line-height: 1.6;">
            <span class="warning">1.</span> Review your recent account activity<br>
            <span class="warning">2.</span> Update your password if you suspect compromise<br>
            <span class="warning">3.</span> Enable two-factor authentication for extra security<br>
            <span class="warning">4.</span> Check your connected devices and sessions
            </p>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="{website_url}" class="btn">🔒 Secure My Account Now</a>
            </div>
            
            <div style="background: #1a1a1a; padding: 20px; border-radius: 8px; border-left: 4px solid #ffaa00; margin: 20px 0;">
                <p style="margin: 0; font-style: italic; color: #cccccc;">
                <strong style="color: #ffaa00;">Note:</strong> If this was you attempting to login, you can safely ignore this message. However, we recommend reviewing your account security settings.
                </p>
            </div>
        </div>
        <div class="footer">
            <p style="color: #ff6666; font-weight: bold; margin: 0 0 10px 0;">🛡️ VPN Security Team</p>
            <p style="color: #888888; font-size: 12px; margin: 0;">
                <a href="{unsubscribe_url}" style="color: #888888;">Unsubscribe</a> | 
                <a href="{website_url}" style="color: #888888;">Security Center</a>
            </p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'announcement'
    ),
    
    array(
        'name' => 'Minimalist Clean Design',
        'subject' => 'Simple & Clean: {website_name} Updates',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 40px; font-family: "Helvetica Neue", Arial, sans-serif; background: #fafafa; color: #333; line-height: 1.6; }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 60px 40px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { font-size: 24px; font-weight: 300; margin: 0 0 30px 0; color: #2c3e50; }
        .divider { width: 50px; height: 2px; background: #3498db; margin: 30px 0; }
        .btn { display: inline-block; background: #2c3e50; color: white; padding: 12px 30px; text-decoration: none; font-size: 14px; letter-spacing: 1px; text-transform: uppercase; margin: 30px 0; }
        .footer { margin-top: 50px; padding-top: 30px; border-top: 1px solid #eee; font-size: 12px; color: #999; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello {name}</h1>
        
        <p>We believe in keeping things simple and focused. That is why we have designed our VPN service to be straightforward, secure, and reliable.</p>
        
        <div class="divider"></div>
        
        <p>Our mission is to provide you with the best online privacy protection without the complexity. Just pure, simple security.</p>
        
        <p>Key features:</p>
        <p>• One-click connection<br>
        • Zero-log policy<br>
        • 24/7 support</p>
        
        <a href="{website_url}" class="btn">Learn More</a>
        
        <div class="footer">
            <p>Thank you for choosing simplicity.</p>
            <p><a href="{unsubscribe_url}" style="color: #bdc3c7;">Unsubscribe</a></p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'custom'
    ),
    
    array(
        'name' => 'VPN Account Activation',
        'subject' => '🎉 Your VPN Account is Ready - Get Started in 3 Easy Steps',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 0; font-family: Arial, sans-serif; background: #0f0f23; }
        .container { max-width: 600px; margin: 0 auto; background: linear-gradient(180deg, #1a1a3e 0%, #0f0f23 100%); }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px; text-align: center; }
        .header h1 { color: white; margin: 0; font-size: 32px; }
        .badge { background: #ffd700; color: #0f0f23; padding: 8px 16px; border-radius: 20px; font-size: 12px; font-weight: bold; display: inline-block; margin-bottom: 15px; }
        .content { padding: 40px 30px; color: white; }
        .step-box { background: rgba(102, 126, 234, 0.1); border: 2px solid #667eea; border-radius: 15px; padding: 25px; margin: 20px 0; }
        .step-number { background: #667eea; color: white; width: 40px; height: 40px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 20px; font-weight: bold; margin-right: 15px; float: left; }
        .step-content { margin-left: 60px; }
        .btn { display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 18px 40px; text-decoration: none; border-radius: 30px; font-size: 18px; font-weight: bold; margin: 25px 0; box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3); }
        .credentials-box { background: #1a1a3e; border: 2px dashed #667eea; border-radius: 12px; padding: 25px; margin: 25px 0; }
        .cred-item { margin: 15px 0; }
        .cred-label { color: #a0a0c0; font-size: 12px; text-transform: uppercase; }
        .cred-value { color: #667eea; font-size: 18px; font-weight: bold; font-family: monospace; }
        .footer { background: #0a0a1a; padding: 30px; text-align: center; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="badge">✨ ACCOUNT ACTIVATED</div>
            <h1>🚀 Welcome to Premium VPN!</h1>
            <p style="color: rgba(255,255,255,0.9); margin: 10px 0 0 0;">Your journey to online privacy starts now</p>
        </div>
        <div class="content">
            <p style="font-size: 16px;">Hello <strong style="color: #667eea;">{name}</strong>,</p>
            
            <p>Congratulations! Your VPN account is now <strong style="color: #66ff66;">ACTIVE</strong> and ready to use. Get started in just 3 simple steps:</p>
            
            <div class="step-box">
                <div class="step-number">1</div>
                <div class="step-content">
                    <h3 style="margin: 0 0 10px 0; color: white;">Download the App</h3>
                    <p style="margin: 0; color: #d0d0e0;">Get our VPN app for Windows, Mac, iOS, Android, or Linux. Available on all platforms.</p>
                </div>
                <div style="clear: both;"></div>
            </div>
            
            <div class="step-box">
                <div class="step-number">2</div>
                <div class="step-content">
                    <h3 style="margin: 0 0 10px 0; color: white;">Login with Your Credentials</h3>
                    <p style="margin: 0; color: #d0d0e0;">Use the details below to sign in to your account.</p>
                </div>
                <div style="clear: both;"></div>
            </div>
            
            <div class="credentials-box">
                <h3 style="margin: 0 0 20px 0; color: #667eea; text-align: center;">🔐 Your Login Details</h3>
                <div class="cred-item">
                    <div class="cred-label">Username:</div>
                    <div class="cred-value">{email}</div>
                </div>
                <div class="cred-item">
                    <div class="cred-label">Email:</div>
                    <div class="cred-value">{email}</div>
                </div>
                <p style="text-align: center; color: #ffaa00; margin: 20px 0 0 0; font-size: 12px;">⚠️ Keep these credentials safe and never share them</p>
            </div>
            
            <div class="step-box">
                <div class="step-number">3</div>
                <div class="step-content">
                    <h3 style="margin: 0 0 10px 0; color: white;">Connect & Browse Safely</h3>
                    <p style="margin: 0; color: #d0d0e0;">Choose any server location and enjoy unlimited, secure browsing!</p>
                </div>
                <div style="clear: both;"></div>
            </div>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="{website_url}" class="btn">🎯 Download VPN App Now</a>
            </div>
            
            <div style="background: rgba(255, 170, 0, 0.1); border-left: 4px solid #ffaa00; padding: 20px; border-radius: 8px; margin: 30px 0;">
                <h4 style="margin: 0 0 10px 0; color: #ffaa00;">🎁 Your Premium Features Include:</h4>
                <p style="margin: 0; color: #e0e0f0; line-height: 1.8;">
                ✅ Unlimited bandwidth & data<br>
                ✅ 100+ server locations worldwide<br>
                ✅ Military-grade AES-256 encryption<br>
                ✅ No-logs policy guarantee<br>
                ✅ 24/7 customer support<br>
                ✅ Up to 10 simultaneous connections
                </p>
            </div>
            
            <p style="color: #d0d0e0;">Need help? Our support team is available 24/7 to assist you with setup, connection issues, or any questions you might have.</p>
        </div>
        <div class="footer">
            <p style="margin: 0 0 10px 0; color: #888;">© 2024 VPN Panel. Secure. Private. Fast.</p>
            <p style="margin: 0; font-size: 12px;">
                <a href="{website_url}" style="color: #888;">Support</a> | 
                <a href="{unsubscribe_url}" style="color: #888;">Unsubscribe</a>
            </p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'welcome'
    ),
    
    array(
        'name' => 'VPN Connection Tutorial',
        'subject' => '📚 Quick Guide: How to Connect to VPN in 60 Seconds',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 0; font-family: "Segoe UI", Arial, sans-serif; background: #f5f7fa; }
        .container { max-width: 600px; margin: 0 auto; background: white; }
        .header { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); padding: 40px; text-align: center; color: white; }
        .header h1 { margin: 0; font-size: 28px; }
        .content { padding: 40px 30px; }
        .tutorial-step { margin: 30px 0; padding: 25px; background: #f8f9fa; border-left: 5px solid #4facfe; border-radius: 8px; }
        .step-header { color: #4facfe; font-size: 20px; font-weight: bold; margin-bottom: 15px; }
        .screenshot-placeholder { background: #e9ecef; border: 2px dashed #4facfe; border-radius: 10px; padding: 60px 20px; text-align: center; color: #999; margin: 15px 0; }
        .tip-box { background: #fff3cd; border: 2px solid #ffc107; border-radius: 10px; padding: 20px; margin: 20px 0; }
        .tip-icon { color: #ffc107; font-size: 24px; float: left; margin-right: 15px; }
        .btn { display: inline-block; background: #4facfe; color: white; padding: 15px 35px; text-decoration: none; border-radius: 25px; margin: 20px 0; font-weight: bold; }
        .footer { background: #2c3e50; color: white; padding: 25px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📚 VPN Connection Guide</h1>
            <p style="margin: 10px 0 0 0; opacity: 0.9;">Master your VPN in 60 seconds</p>
        </div>
        <div class="content">
            <p>Hi <strong>{name}</strong>,</p>
            
            <p>Welcome to our VPN service! We have created this simple step-by-step guide to help you connect to our VPN servers quickly and easily.</p>
            
            <div class="tutorial-step">
                <div class="step-header">⬇️ Step 1: Download & Install</div>
                <p>Download the VPN app for your device from our website or app store. The installation process is automatic and takes less than 2 minutes.</p>
                <div class="screenshot-placeholder">📱 [App Screenshot]</div>
                <p><strong>Available for:</strong> Windows, Mac, iOS, Android, Linux</p>
            </div>
            
            <div class="tutorial-step">
                <div class="step-header">🔑 Step 2: Login to Your Account</div>
                <p>Open the app and enter your credentials:</p>
                <ul>
                    <li><strong>Username:</strong> {email}</li>
                    <li><strong>Password:</strong> Your chosen password</li>
                </ul>
                <div class="screenshot-placeholder">🔐 [Login Screen]</div>
            </div>
            
            <div class="tutorial-step">
                <div class="step-header">🌍 Step 3: Choose a Server Location</div>
                <p>Select any server from our 100+ locations worldwide. For best speed, choose the server closest to your actual location.</p>
                <div class="screenshot-placeholder">🗺️ [Server List]</div>
                <p><strong>Popular locations:</strong></p>
                <ul>
                    <li>🇺🇸 United States (New York, Los Angeles)</li>
                    <li>🇬🇧 United Kingdom (London)</li>
                    <li>🇩🇪 Germany (Frankfurt)</li>
                    <li>🇯🇵 Japan (Tokyo)</li>
                    <li>🇸🇬 Singapore</li>
                </ul>
            </div>
            
            <div class="tutorial-step">
                <div class="step-header">🚀 Step 4: Connect!</div>
                <p>Click the big <strong>"Connect"</strong> button and wait 3-5 seconds. When the status shows <strong style="color: #28a745;">"Connected"</strong>, you\'re all set!</p>
                <div class="screenshot-placeholder">✅ [Connected Status]</div>
            </div>
            
            <div class="tip-box">
                <div class="tip-icon">💡</div>
                <div style="margin-left: 45px;">
                    <h4 style="margin: 0 0 10px 0; color: #856404;">Pro Tips:</h4>
                    <ul style="margin: 0; color: #856404;">
                        <li>Enable "Auto-Connect" to automatically connect when you start your device</li>
                        <li>Use "Kill Switch" feature to prevent data leaks if VPN disconnects</li>
                        <li>Switch servers anytime - unlimited server switching!</li>
                    </ul>
                </div>
                <div style="clear: both;"></div>
            </div>
            
            <h3 style="color: #2c3e50;">🎯 Quick Start Video</h3>
            <p>Prefer watching? Check out our 60-second video tutorial that shows you exactly how to get connected.</p>
            
            <div style="text-align: center;">
                <a href="{website_url}" class="btn">▶️ Watch Video Tutorial</a>
            </div>
            
            <hr style="border: none; border-top: 1px solid #e9ecef; margin: 40px 0;">
            
            <h3 style="color: #2c3e50;">❓ Need Help?</h3>
            <p>If you encounter any issues or have questions:</p>
            <ul>
                <li>📧 Email: support@vpnpanel.com</li>
                <li>💬 Live Chat: Available 24/7 on our website</li>
                <li>📖 Knowledge Base: Detailed guides and FAQs</li>
            </ul>
        </div>
        <div class="footer">
            <p style="margin: 0 0 10px 0;">Happy browsing! 🎉</p>
            <p style="margin: 0; font-size: 12px; opacity: 0.8;">
                <a href="{website_url}" style="color: white;">Help Center</a> | 
                <a href="{unsubscribe_url}" style="color: white;">Unsubscribe</a>
            </p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'tutorial'
    ),
    
    array(
        'name' => 'VPN Server Maintenance Notice',
        'subject' => '🔧 Scheduled Maintenance: Server Upgrades This Weekend',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 0; font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 600px; margin: 0 auto; background: white; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); padding: 40px; text-align: center; color: white; }
        .icon { font-size: 60px; margin-bottom: 10px; }
        .content { padding: 40px 30px; }
        .notice-box { background: #fff3cd; border-left: 5px solid #ffc107; padding: 20px; margin: 25px 0; border-radius: 5px; }
        .timeline { margin: 30px 0; }
        .timeline-item { padding: 20px; margin: 15px 0; background: #f8f9fa; border-left: 4px solid #007bff; border-radius: 5px; }
        .time { color: #007bff; font-weight: bold; font-size: 16px; }
        .affected-servers { background: #e7f3ff; padding: 20px; border-radius: 10px; margin: 20px 0; }
        .server-list { list-style: none; padding: 0; }
        .server-list li { padding: 10px 0; border-bottom: 1px solid #cce5ff; }
        .server-list li:last-child { border-bottom: none; }
        .btn { display: inline-block; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 15px 30px; text-decoration: none; border-radius: 25px; margin: 20px 0; font-weight: bold; }
        .footer { background: #2c3e50; color: white; padding: 25px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon">🔧</div>
            <h1 style="margin: 0; font-size: 28px;">Scheduled Maintenance</h1>
            <p style="margin: 10px 0 0 0; opacity: 0.9;">Server upgrades & performance improvements</p>
        </div>
        <div class="content">
            <p>Hello <strong>{name}</strong>,</p>
            
            <p>We are constantly working to improve your VPN experience. This weekend, we will be performing scheduled maintenance on select servers to enhance speed and reliability.</p>
            
            <div class="notice-box">
                <h3 style="margin: 0 0 10px 0; color: #856404;">⚠️ Important Information</h3>
                <p style="margin: 0; color: #856404;">Some servers will be temporarily unavailable during the maintenance window. We recommend connecting to alternative server locations during this time.</p>
            </div>
            
            <h3 style="color: #2c3e50;">📅 Maintenance Schedule</h3>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="time">🕐 Start Time</div>
                    <p style="margin: 5px 0 0 0;">Saturday, November 16, 2024 - 02:00 AM UTC</p>
                </div>
                <div class="timeline-item">
                    <div class="time">⏱️ Duration</div>
                    <p style="margin: 5px 0 0 0;">Approximately 4-6 hours</p>
                </div>
                <div class="timeline-item">
                    <div class="time">✅ Expected Completion</div>
                    <p style="margin: 5px 0 0 0;">Saturday, November 16, 2024 - 08:00 AM UTC</p>
                </div>
            </div>
            
            <h3 style="color: #2c3e50;">🌍 Affected Server Locations</h3>
            <div class="affected-servers">
                <ul class="server-list">
                    <li>🇺🇸 <strong>USA - New York</strong> <span style="float: right; color: #ffc107;">⚠️ Maintenance</span></li>
                    <li>🇬🇧 <strong>UK - London</strong> <span style="float: right; color: #ffc107;">⚠️ Maintenance</span></li>
                    <li>🇩🇪 <strong>Germany - Frankfurt</strong> <span style="float: right; color: #ffc107;">⚠️ Maintenance</span></li>
                </ul>
            </div>
            
            <h3 style="color: #28a745;">✅ Alternative Servers (Fully Operational)</h3>
            <div class="affected-servers" style="background: #d4edda; border-color: #c3e6cb;">
                <ul class="server-list">
                    <li>🇺🇸 <strong>USA - Los Angeles</strong> <span style="float: right; color: #28a745;">✓ Available</span></li>
                    <li>🇨🇦 <strong>Canada - Toronto</strong> <span style="float: right; color: #28a745;">✓ Available</span></li>
                    <li>🇳🇱 <strong>Netherlands - Amsterdam</strong> <span style="float: right; color: #28a745;">✓ Available</span></li>
                    <li>🇸🇬 <strong>Singapore</strong> <span style="float: right; color: #28a745;">✓ Available</span></li>
                    <li>🇯🇵 <strong>Japan - Tokyo</strong> <span style="float: right; color: #28a745;">✓ Available</span></li>
                </ul>
            </div>
            
            <h3 style="color: #2c3e50;">🚀 What\'s Being Improved</h3>
            <ul>
                <li>⚡ 30% faster connection speeds</li>
                <li>🔒 Enhanced security protocols</li>
                <li>💪 Increased server capacity</li>
                <li>🛠️ Latest infrastructure updates</li>
                <li>📊 Improved load balancing</li>
            </ul>
            
            <div style="background: #e7f3ff; border-left: 4px solid #0066cc; padding: 20px; margin: 25px 0; border-radius: 5px;">
                <h4 style="margin: 0 0 10px 0; color: #0066cc;">💡 Pro Tip</h4>
                <p style="margin: 0; color: #004085;">Enable "Auto-Connect to Fastest Server" in your app settings. This will automatically connect you to the best available server, even during maintenance.</p>
            </div>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="{website_url}" class="btn">🌐 View All Server Status</a>
            </div>
            
            <p>We apologize for any inconvenience and appreciate your patience as we work to provide you with an even better VPN experience.</p>
            
            <p>Thank you for your understanding!</p>
        </div>
        <div class="footer">
            <p style="margin: 0 0 10px 0; font-weight: bold;">VPN Operations Team</p>
            <p style="margin: 0; font-size: 12px; opacity: 0.8;">
                <a href="{website_url}" style="color: white;">Server Status</a> | 
                <a href="{unsubscribe_url}" style="color: white;">Unsubscribe</a>
            </p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'announcement'
    ),
    
    array(
        'name' => 'VPN Speed Test Results',
        'subject' => '⚡ Your VPN Performance Report - See Your Speeds!',
        'content' => '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; padding: 0; font-family: "Segoe UI", Arial, sans-serif; background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); }
        .container { max-width: 600px; margin: 0 auto; background: white; }
        .header { background: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%); padding: 40px; text-align: center; color: white; }
        .header h1 { margin: 0; font-size: 32px; }
        .content { padding: 40px 30px; }
        .speed-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 20px; padding: 30px; margin: 25px 0; text-align: center; color: white; box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3); }
        .speed-value { font-size: 60px; font-weight: bold; margin: 20px 0; }
        .speed-label { font-size: 18px; opacity: 0.9; text-transform: uppercase; letter-spacing: 2px; }
        .stats-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 30px 0; }
        .stat-box { background: #f8f9fa; padding: 25px; border-radius: 15px; text-align: center; border: 2px solid #e9ecef; }
        .stat-value { font-size: 32px; font-weight: bold; color: #0072ff; margin: 10px 0; }
        .stat-label { color: #666; font-size: 14px; }
        .comparison { background: #e7f3ff; border-left: 5px solid #0072ff; padding: 20px; margin: 25px 0; border-radius: 5px; }
        .progress-bar { background: #e9ecef; height: 30px; border-radius: 15px; overflow: hidden; margin: 15px 0; }
        .progress-fill { background: linear-gradient(90deg, #00c6ff 0%, #0072ff 100%); height: 100%; display: flex; align-items: center; justify-content: flex-end; padding-right: 15px; color: white; font-weight: bold; font-size: 14px; }
        .recommendation { background: #d4edda; border: 2px solid #28a745; border-radius: 10px; padding: 20px; margin: 25px 0; }
        .btn { display: inline-block; background: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%); color: white; padding: 15px 35px; text-decoration: none; border-radius: 25px; margin: 20px 0; font-weight: bold; }
        .footer { background: #1a1a2e; color: white; padding: 25px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⚡ Speed Test Results</h1>
            <p style="margin: 10px 0 0 0; font-size: 18px; opacity: 0.9;">Your VPN performance analysis</p>
        </div>
        <div class="content">
            <p>Hi <strong>{name}</strong>,</p>
            
            <p>Great news! We have completed your VPN speed test. Here are your personalized performance results:</p>
            
            <div class="speed-card">
                <div class="speed-label">Average Download Speed</div>
                <div class="speed-value">247 <span style="font-size: 30px;">Mbps</span></div>
                <p style="margin: 0; opacity: 0.9;">🚀 Excellent performance!</p>
            </div>
            
            <div class="stats-grid">
                <div class="stat-box">
                    <div class="stat-label">Upload Speed</div>
                    <div class="stat-value">189</div>
                    <div style="color: #666; font-size: 12px;">Mbps</div>
                </div>
                <div class="stat-box">
                    <div class="stat-label">Ping</div>
                    <div class="stat-value">12</div>
                    <div style="color: #666; font-size: 12px;">ms</div>
                </div>
            </div>
            
            <h3 style="color: #2c3e50;">📊 Performance Breakdown</h3>
            
            <div style="margin: 25px 0;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                    <span>Connection Speed</span>
                    <span style="font-weight: bold; color: #0072ff;">98%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 98%;">Excellent</div>
                </div>
            </div>
            
            <div style="margin: 25px 0;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                    <span>Stability</span>
                    <span style="font-weight: bold; color: #0072ff;">95%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 95%;">Excellent</div>
                </div>
            </div>
            
            <div style="margin: 25px 0;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                    <span>Security Rating</span>
                    <span style="font-weight: bold; color: #0072ff;">100%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 100%;">Perfect</div>
                </div>
            </div>
            
            <div class="comparison">
                <h4 style="margin: 0 0 15px 0; color: #0066cc;">📈 Comparison with Average VPN</h4>
                <p style="margin: 0; color: #004085;">
                Your VPN is <strong>3.2x faster</strong> than the industry average! You\'re experiencing premium-grade performance with minimal speed loss.
                </p>
            </div>
            
            <h3 style="color: #2c3e50;">🎯 Top Performing Servers for You</h3>
            <div style="background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;">
                <ul style="margin: 0; padding-left: 20px;">
                    <li style="margin: 10px 0;">🇺🇸 <strong>USA - Los Angeles</strong> - 289 Mbps</li>
                    <li style="margin: 10px 0;">🇬🇧 <strong>UK - London</strong> - 267 Mbps</li>
                    <li style="margin: 10px 0;">🇸🇬 <strong>Singapore</strong> - 253 Mbps</li>
                    <li style="margin: 10px 0;">🇩🇪 <strong>Germany - Frankfurt</strong> - 241 Mbps</li>
                </ul>
            </div>
            
            <div class="recommendation">
                <h4 style="margin: 0 0 10px 0; color: #155724;">💡 Recommendations</h4>
                <ul style="margin: 0; padding-left: 20px; color: #155724;">
                    <li>Your current setup is optimal!</li>
                    <li>For gaming, use servers with ping < 20ms</li>
                    <li>For streaming 4K, any of your top servers work perfectly</li>
                    <li>Run speed tests weekly to monitor performance</li>
                </ul>
            </div>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="{website_url}" class="btn">🔄 Run Another Speed Test</a>
            </div>
            
            <hr style="border: none; border-top: 1px solid #e9ecef; margin: 40px 0;">
            
            <p style="font-size: 14px; color: #666;">Speed test conducted on: <strong>November 15, 2024 at 14:30 UTC</strong></p>
        </div>
        <div class="footer">
            <p style="margin: 0 0 10px 0;">Keep your VPN optimized! 🚀</p>
            <p style="margin: 0; font-size: 12px; opacity: 0.8;">
                <a href="{website_url}" style="color: white;">Dashboard</a> | 
                <a href="{unsubscribe_url}" style="color: white;">Unsubscribe</a>
            </p>
        </div>
    </div>
</body>
</html>',
        'template_type' => 'notification'
    )
);

$values['response'] = 1;
$values['presets'] = $template_presets;

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

