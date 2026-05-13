<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');

// Set proper UTF-8 encoding for Unicode characters
header('Content-Type: application/json; charset=utf-8');
mb_internal_encoding('UTF-8');

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

// Get template ID
$template_id = intval($_POST['template_id']);

if(empty($template_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing template ID';
    echo json_encode($values);
    exit;
}

// Get template content
$query = "SELECT subject, content, content_type FROM email_templates WHERE id = $template_id AND is_active = 1";
$result = $db->sql_query($query);

if($result && $db->sql_numrows($result) > 0) {
    $template = $db->sql_fetchrow($result);
    
    $values['response'] = 1;
    $values['subject'] = $template['subject'];
    $values['content'] = $template['content'];
    $values['content_type'] = $template['content_type'];
} else {
    $values['response'] = 2;
    $values['msg'] = 'Template not found';
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

