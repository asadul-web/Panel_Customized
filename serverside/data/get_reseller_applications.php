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
$table_type = isset($_POST['table_type']) ? $_POST['table_type'] : 'all';
$status_filter = isset($_POST['status_filter']) ? $_POST['status_filter'] : $table_type;

// Base query
$base_query = "FROM reseller_applications WHERE 1=1";
$params = array();

// Status filter
if($status_filter != 'all') {
    $base_query .= " AND status = ?";
    $params[] = $status_filter;
}

// Search filter
if(!empty($search)) {
    $base_query .= " AND (business_name LIKE ? OR full_name LIKE ? OR email LIKE ? OR username LIKE ? OR country LIKE ?)";
    $search_param = "%$search%";
    $params[] = $search_param;
    $params[] = $search_param;
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

$columns = array('id', 'business_name', 'full_name', 'email', 'username', 'country', 'experience', 'expected_sales', 'status', 'applied_date');
$order_by = isset($columns[$order_column]) ? $columns[$order_column] : 'applied_date';

// Main query
$main_query = "SELECT id, business_name, full_name, email, username, phone, country, website, experience, expected_sales, status, applied_date, reviewed_date " . 
              $base_query . 
              " ORDER BY $order_by $order_dir LIMIT $start, $length";

$result = $db->sql_query($main_query);

$data = array();
while($row = $db->sql_fetchrow($result)) {
    $data[] = array(
        'id' => $row['id'],
        'business_name' => htmlspecialchars($row['business_name'] ?? ''),
        'full_name' => htmlspecialchars($row['full_name'] ?? ''),
        'email' => htmlspecialchars($row['email'] ?? ''),
        'username' => htmlspecialchars($row['username'] ?? ''),
        'phone' => htmlspecialchars($row['phone'] ?? ''),
        'country' => htmlspecialchars($row['country'] ?? ''),
        'website' => htmlspecialchars($row['website'] ?? ''),
        'experience' => htmlspecialchars($row['experience'] ?? ''),
        'expected_sales' => htmlspecialchars($row['expected_sales'] ?? ''),
        'status' => $row['status'] ?? 'pending',
        'applied_date' => $row['applied_date'] ?? '',
        'reviewed_date' => $row['reviewed_date'] ?? ''
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

