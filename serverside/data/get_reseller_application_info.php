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

// Get application details
$query = "SELECT id, business_name, full_name, email, phone, country, website, username, password,
          experience, expected_sales, message, status, applied_date, reviewed_date, admin_notes
          FROM reseller_applications
          WHERE id = $application_id";

$result = $db->sql_query($query);

if($result && $db->sql_numrows($result) > 0) {
    $application = $db->sql_fetchrow($result);

    // Decrypt password for admin viewing
    $admin_viewable_password = 'Not available';
    if(!empty($application['password'])) {
        // Check if password is hashed (bcrypt) or encrypted
        if(password_verify('test', $application['password']) || strpos($application['password'], '$2y$') === 0) {
            $admin_viewable_password = 'Encrypted (bcrypt hash)';
        } else {
            $admin_viewable_password = $db->encryptor('decrypt', $application['password']);
        }
    }

    // Format the data for display
    $response = array(
        'id' => $application['id'],
        'business_name' => !empty($application['business_name']) ? $application['business_name'] : 'Not provided',
        'full_name' => !empty($application['full_name']) ? $application['full_name'] : 'Not provided',
        'email' => !empty($application['email']) ? $application['email'] : 'Not provided',
        'phone' => !empty($application['phone']) ? $application['phone'] : 'Not provided',
        'country' => !empty($application['country']) ? $application['country'] : 'Not provided',
        'website' => !empty($application['website']) ? $application['website'] : 'Not provided',
        'username' => !empty($application['username']) ? $application['username'] : 'Not provided',
        'password' => $admin_viewable_password,
        'experience' => !empty($application['experience']) ? $application['experience'] : 'Not provided',
        'expected_sales' => !empty($application['expected_sales']) ? $application['expected_sales'] : 'Not provided',
        'message' => !empty($application['message']) ? $application['message'] : 'No message provided',
        'status' => ucfirst(str_replace('_', ' ', $application['status'])),
        'applied_date' => !empty($application['applied_date']) ? date('Y-m-d H:i:s', strtotime($application['applied_date'])) : 'Not available',
        'reviewed_date' => !empty($application['reviewed_date']) ? date('Y-m-d H:i:s', strtotime($application['reviewed_date'])) : 'Not reviewed',
        'admin_notes' => !empty($application['admin_notes']) ? $application['admin_notes'] : 'No admin notes'
    );

    echo json_encode($response);
} else {
    echo json_encode(array('error' => 'Application not found'));
}
?>

