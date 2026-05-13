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

// DataTables parameters
$draw = intval($_POST['draw']);
$start = intval($_POST['start']);
$length = intval($_POST['length']);
$search = $_POST['search']['value'];
$status_filter = isset($_POST['status_filter']) ? $_POST['status_filter'] : '';
$source_filter = isset($_POST['source_filter']) ? $_POST['source_filter'] : '';
$date_filter = isset($_POST['date_filter']) ? $_POST['date_filter'] : '';

// Base query
$base_query = "FROM email_subscribers WHERE 1=1";
$params = array();

// Status filter
if(!empty($status_filter)) {
    $base_query .= " AND status = ?";
    $params[] = $status_filter;
}

// Source filter
if(!empty($source_filter)) {
    $base_query .= " AND source = ?";
    $params[] = $source_filter;
}

// Date filter
if(!empty($date_filter)) {
    $base_query .= " AND DATE(subscribed_date) = ?";
    $params[] = $date_filter;
}

// Search filter
if(!empty($search)) {
    $base_query .= " AND (email LIKE ? OR name LIKE ? OR tags LIKE ?)";
    $search_param = "%$search%";
    $params[] = $search_param;
    $params[] = $search_param;
    $params[] = $search_param;
}

// Count total records
$count_query = "SELECT COUNT(*) as total " . $base_query;
$count_result = $db->sql_query($count_query);
$total_records = $db->sql_fetchrow($count_result)['total'];

// Order
$order_column = $_POST['order'][0]['column'];
$order_dir = $_POST['order'][0]['dir'];

$columns = array('id', 'email', 'name', 'status', 'source', 'subscribed_date', 'last_email_sent', 'email_count');
$order_by = isset($columns[$order_column]) ? $columns[$order_column] : 'subscribed_date';

// Main query
$main_query = "SELECT id, email, name, status, source, subscribed_date, unsubscribed_date, last_email_sent, email_count, tags " . 
              $base_query . 
              " ORDER BY $order_by $order_dir LIMIT $start, $length";

$result = $db->sql_query($main_query);

$data = array();
while($row = $db->sql_fetchrow($result)) {
    $data[] = array(
        'id' => $row['id'],
        'email' => htmlspecialchars($row['email']),
        'name' => htmlspecialchars($row['name'] ?: 'N/A'),
        'status' => $row['status'],
        'source' => htmlspecialchars($row['source']),
        'subscribed_date' => $row['subscribed_date'],
        'unsubscribed_date' => $row['unsubscribed_date'],
        'last_email_sent' => $row['last_email_sent'],
        'email_count' => intval($row['email_count']),
        'tags' => htmlspecialchars($row['tags'])
    );
}

$response = array(
    'draw' => $draw,
    'recordsTotal' => $total_records,
    'recordsFiltered' => $total_records,
    'data' => $data
);

echo json_encode($response);
?>

