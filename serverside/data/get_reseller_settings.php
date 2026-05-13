<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

// Check if user is logged in and has proper permissions
if(!is_logged_in($user)) {
    echo json_encode(array('success' => false, 'message' => 'Unauthorized'));
    exit;
}

if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    echo json_encode(array('success' => false, 'message' => 'Insufficient permissions'));
    exit;
}

$query = "SELECT setting_name, setting_value FROM reseller_settings";
$result = $db->sql_query($query);

$settings = array();
while($row = $db->sql_fetchrow($result)) {
    $settings[$row['setting_name']] = $row['setting_value'];
}

echo json_encode(array('success' => true, 'data' => $settings));
?>

