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

if(!isset($_POST['application_id'])) {
    echo json_encode(array('success' => false, 'message' => 'Application ID required'));
    exit;
}

$application_id = intval($_POST['application_id']);

$query = "SELECT ra.*, u.user_name as reviewed_by_username 
          FROM reseller_applications ra 
          LEFT JOIN users u ON ra.reviewed_by = u.user_id 
          WHERE ra.id = $application_id";

$result = $db->sql_query($query);

if($db->sql_numrows($result) > 0) {
    $row = $db->sql_fetchrow($result);
    
    $data = array(
        'id' => $row['id'],
        'business_name' => $row['business_name'],
        'full_name' => $row['full_name'],
        'email' => $row['email'],
        'username' => $row['username'],
        'phone' => $row['phone'],
        'country' => $row['country'],
        'website' => $row['website'],
        'experience' => $row['experience'],
        'expected_sales' => $row['expected_sales'],
        'message' => $row['message'],
        'status' => $row['status'],
        'admin_notes' => $row['admin_notes'],
        'applied_date' => $row['applied_date'],
        'reviewed_date' => $row['reviewed_date'],
        'reviewed_by' => $row['reviewed_by'],
        'reviewed_by_username' => $row['reviewed_by_username'],
        'ip_address' => $row['ip_address'],
        'has_password' => !empty($row['password']) ? true : false
    );
    
    echo json_encode(array('success' => true, 'data' => $data));
} else {
    echo json_encode(array('success' => false, 'message' => 'Application not found'));
}
?>

