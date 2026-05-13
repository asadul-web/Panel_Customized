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

try {
    // Get total campaigns
    $total_query = "SELECT COUNT(*) as count FROM email_campaigns";
    $total_result = $db->sql_query($total_query);
    $total_campaigns = $total_result ? $db->sql_fetchrow($total_result)['count'] : 0;
    
    // Get sent campaigns
    $sent_query = "SELECT COUNT(*) as count FROM email_campaigns WHERE status = 'sent'";
    $sent_result = $db->sql_query($sent_query);
    $sent_campaigns = $sent_result ? $db->sql_fetchrow($sent_result)['count'] : 0;
    
    // Get draft campaigns
    $draft_query = "SELECT COUNT(*) as count FROM email_campaigns WHERE status = 'draft'";
    $draft_result = $db->sql_query($draft_query);
    $draft_campaigns = $draft_result ? $db->sql_fetchrow($draft_result)['count'] : 0;
    
    // Get total emails sent
    $emails_query = "SELECT SUM(emails_sent) as total FROM email_campaigns WHERE status = 'sent'";
    $emails_result = $db->sql_query($emails_query);
    $total_emails_sent = $emails_result ? ($db->sql_fetchrow($emails_result)['total'] ?: 0) : 0;
    
    // Calculate open rate (simplified)
    $opens_query = "SELECT SUM(opens) as total_opens FROM email_campaigns WHERE status = 'sent'";
    $opens_result = $db->sql_query($opens_query);
    $total_opens = $opens_result ? ($db->sql_fetchrow($opens_result)['total_opens'] ?: 0) : 0;
    
    $open_rate = $total_emails_sent > 0 ? round(($total_opens / $total_emails_sent) * 100, 2) : 0;
    
    $values['response'] = 1;
    $values['total_campaigns'] = intval($total_campaigns);
    $values['sent_campaigns'] = intval($sent_campaigns);
    $values['draft_campaigns'] = intval($draft_campaigns);
    $values['total_emails_sent'] = intval($total_emails_sent);
    $values['total_opens'] = intval($total_opens);
    $values['open_rate'] = $open_rate;
    
} catch(Exception $e) {
    $values['response'] = 1; // Return success with zeros instead of error
    $values['total_campaigns'] = 0;
    $values['sent_campaigns'] = 0;
    $values['draft_campaigns'] = 0;
    $values['total_emails_sent'] = 0;
    $values['total_opens'] = 0;
    $values['open_rate'] = 0;
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

