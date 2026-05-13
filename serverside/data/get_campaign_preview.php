<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json; charset=utf-8');

require_once '../../includes/functions.php';

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

// Get campaign ID
$campaign_id = isset($_POST['campaign_id']) ? intval($_POST['campaign_id']) : 0;

if(empty($campaign_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing campaign ID';
    echo json_encode($values);
    exit;
}

try {
    
    // Get campaign details
    $query = "SELECT id, name, subject, content, content_type, status, created_date, total_recipients 
              FROM email_campaigns 
              WHERE id = $campaign_id";
    
    $result = $db->sql_query($query);
    
    if($result && $db->sql_numrows($result) > 0) {
        $campaign = $db->sql_fetchrow($result);
        
        // Process content for preview
        $preview_content = $campaign['content'];
        
        // Replace placeholders with sample data for preview
        $placeholders = array(
            '{name}' => 'John Doe',
            '{email}' => 'john.doe@example.com',
            '{website_name}' => 'VPN Service',
            '{website_url}' => 'http://localhost',
            '{unsubscribe_url}' => 'http://localhost/unsubscribe'
        );
        
        foreach($placeholders as $placeholder => $replacement) {
            $preview_content = str_replace($placeholder, $replacement, $preview_content);
        }
        
        // Create preview HTML with proper styling
        $preview_html = '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaign Preview: ' . htmlspecialchars($campaign['name']) . '</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background: #f4f4f4;
        }
        .preview-header {
            background: #007bff;
            color: white;
            padding: 15px;
            border-radius: 5px 5px 0 0;
            margin-bottom: 0;
        }
        .preview-content {
            background: white;
            padding: 20px;
            border-radius: 0 0 5px 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .preview-info {
            background: #e9ecef;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="preview-header">
        <h2 style="margin: 0;">📧 ' . htmlspecialchars($campaign['name']) . '</h2>
        <p style="margin: 5px 0 0 0; opacity: 0.9;">Subject: ' . htmlspecialchars($campaign['subject']) . '</p>
    </div>
    
    <div class="preview-info">
        <strong>📊 Campaign Info:</strong><br>
        Status: <span style="color: #007bff;">' . ucfirst($campaign['status']) . '</span> | 
        Recipients: <strong>' . number_format($campaign['total_recipients']) . '</strong> | 
        Created: <strong>' . date('M j, Y', strtotime($campaign['created_date'])) . '</strong>
    </div>
    
    <div class="preview-content">';
        
        if($campaign['content_type'] === 'html') {
            $preview_html .= $preview_content;
        } else {
            $preview_html .= '<pre style="white-space: pre-wrap; font-family: Arial, sans-serif;">' . htmlspecialchars($preview_content) . '</pre>';
        }
        
        $preview_html .= '
    </div>
    
    <div style="text-align: center; margin-top: 20px; font-size: 12px; color: #666;">
        <p>📋 This is a preview with sample data. Actual emails will use real subscriber information.</p>
    </div>
</body>
</html>';
        
        $values['response'] = 1;
        $values['content'] = $preview_html;
        $values['campaign_name'] = $campaign['name'];
        $values['campaign_subject'] = $campaign['subject'];
        
    } else {
        $values['response'] = 2;
        $values['msg'] = 'Campaign not found';
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error loading campaign: ' . $e->getMessage();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

