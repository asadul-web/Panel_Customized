<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

// Check if user is logged in and has proper permissions
if(!is_logged_in($user)) {
    header('HTTP/1.0 403 Forbidden');
    echo 'Unauthorized';
    exit;
}

if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    header('HTTP/1.0 403 Forbidden');
    echo 'Insufficient permissions';
    exit;
}

// Get export parameters
$status_filter = isset($_GET['status']) ? $_GET['status'] : '';
$source_filter = isset($_GET['source']) ? $_GET['source'] : '';
$selected_ids = isset($_GET['ids']) ? explode(',', $_GET['ids']) : array();

// Build query
$query = "SELECT email, name, status, source, tags, subscribed_date, last_email_sent, email_count FROM email_subscribers WHERE 1=1";
$params = array();

// Apply filters
if(!empty($status_filter)) {
    $query .= " AND status = '".$db->SanitizeForSQL($status_filter)."'";
}

if(!empty($source_filter)) {
    $query .= " AND source = '".$db->SanitizeForSQL($source_filter)."'";
}

if(!empty($selected_ids)) {
    $ids_str = implode(',', array_map('intval', $selected_ids));
    $query .= " AND id IN ($ids_str)";
}

$query .= " ORDER BY subscribed_date DESC";

$result = $db->sql_query($query);

if(!$result) {
    header('HTTP/1.0 500 Internal Server Error');
    echo 'Database error';
    exit;
}

// Set headers for CSV download
$filename = 'email_subscribers_' . date('Y-m-d_H-i-s') . '.csv';
header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Expires: 0');

// Open output stream
$output = fopen('php://output', 'w');

// Write CSV header
fputcsv($output, array(
    'Email',
    'Name', 
    'Status',
    'Source',
    'Tags',
    'Subscribed Date',
    'Last Email Sent',
    'Email Count'
));

// Write data rows
while($row = $db->sql_fetchrow($result)) {
    fputcsv($output, array(
        $row['email'],
        $row['name'] ?: '',
        $row['status'],
        $row['source'],
        $row['tags'] ?: '',
        $row['subscribed_date'],
        $row['last_email_sent'] ?: '',
        $row['email_count']
    ));
}

// Close output stream
fclose($output);

// Log activity
$action = "Exported email subscribers";
$log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
              VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
              '".$_SERVER['REMOTE_ADDR']."', '', '')";
$db->sql_query($log_query);

exit;
?>

