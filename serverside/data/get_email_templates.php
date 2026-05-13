<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
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

// Get active templates
$query = "SELECT id, name, subject, template_type FROM email_templates WHERE is_active = 1 ORDER BY name";
$result = $db->sql_query($query);

$templates = array();
if($result) {
    while($row = $db->sql_fetchrow($result)) {
        $templates[] = array(
            'id' => $row['id'],
            'name' => htmlspecialchars($row['name']),
            'subject' => htmlspecialchars($row['subject']),
            'template_type' => $row['template_type']
        );
    }
}

$values['response'] = 1;
$values['templates'] = $templates;

echo json_encode($values);
?>

