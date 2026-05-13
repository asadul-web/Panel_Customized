<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

// Check if user is logged in and has proper permissions
if(!is_logged_in($user)) {
    echo json_encode(array('error' => 'Unauthorized'));
    exit;
}

if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    echo json_encode(array('error' => 'Insufficient permissions'));
    exit;
}

// Get application ID
$application_id = isset($_GET['aid']) ? intval($_GET['aid']) : 0;

if(empty($application_id)) {
    echo json_encode(array('error' => 'Missing application ID'));
    exit;
}

// Get application status to determine available options
$query = "SELECT id, status FROM reseller_applications WHERE id = $application_id";
$result = $db->sql_query($query);

if($result && $db->sql_numrows($result) > 0) {
    $application = $db->sql_fetchrow($result);
    
    $response = array(
        'id' => $application['id'],
        'status' => $application['status']
    );
    
    echo json_encode($response);
} else {
    echo json_encode(array('error' => 'Application not found'));
}
?>

