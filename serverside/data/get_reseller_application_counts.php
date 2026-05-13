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

// Get application counts
$counts_query = "SELECT 
    COUNT(*) as total,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending,
    COUNT(CASE WHEN status = 'under_review' THEN 1 END) as under_review,
    COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved,
    COUNT(CASE WHEN status = 'rejected' THEN 1 END) as rejected
    FROM reseller_applications";

$result = $db->sql_query($counts_query);

if($result) {
    $counts = $db->sql_fetchrow($result);
    
    $response = array(
        'total' => intval($counts['total']),
        'pending' => intval($counts['pending']),
        'under_review' => intval($counts['under_review']),
        'approved' => intval($counts['approved']),
        'rejected' => intval($counts['rejected'])
    );
    
    echo json_encode($response);
} else {
    echo json_encode(array(
        'total' => 0,
        'pending' => 0,
        'under_review' => 0,
        'approved' => 0,
        'rejected' => 0
    ));
}
?>

