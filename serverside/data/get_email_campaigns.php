<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json; charset=utf-8');

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
$draw = isset($_POST['draw']) ? intval($_POST['draw']) : 1;
$start = isset($_POST['start']) ? intval($_POST['start']) : 0;
$length = isset($_POST['length']) ? intval($_POST['length']) : 25;
$search = isset($_POST['search']['value']) ? $_POST['search']['value'] : '';
$status_filter = isset($_POST['status_filter']) ? $_POST['status_filter'] : '';
$date_filter = isset($_POST['date_filter']) ? $_POST['date_filter'] : '';

// Base query
$base_query = "FROM email_campaigns WHERE 1=1";

// Status filter
if(!empty($status_filter)) {
    $base_query .= " AND status = '".addslashes($status_filter)."'";
}

// Date filter
if(!empty($date_filter)) {
    $base_query .= " AND DATE(created_date) = '".addslashes($date_filter)."'";
}

// Search filter
if(!empty($search)) {
    $base_query .= " AND (name LIKE '%".addslashes($search)."%' OR subject LIKE '%".addslashes($search)."%')";
}

// Count total records
$count_query = "SELECT COUNT(*) as total " . $base_query;
$count_result = $db->sql_query($count_query);
$total_records = $count_result ? $db->sql_fetchrow($count_result)['total'] : 0;

// Order
$order_column = isset($_POST['order'][0]['column']) ? $_POST['order'][0]['column'] : 6;
$order_dir = isset($_POST['order'][0]['dir']) ? $_POST['order'][0]['dir'] : 'desc';

$columns = array('name', 'subject', 'status', 'total_recipients', 'emails_sent', 'opens', 'created_date');
$order_by = isset($columns[$order_column]) ? $columns[$order_column] : 'created_date';

// Main query
$main_query = "SELECT id, name, subject, status, total_recipients, emails_sent, opens, clicks, created_date, scheduled_date, sent_date " . 
              $base_query . 
              " ORDER BY $order_by $order_dir LIMIT $start, $length";

$result = $db->sql_query($main_query);

$data = array();
if($result) {
    while($row = $db->sql_fetchrow($result)) {
        $data[] = array(
            'id' => $row['id'],
            'name' => htmlspecialchars($row['name']),
            'subject' => htmlspecialchars($row['subject']),
            'status' => $row['status'],
            'total_recipients' => intval($row['total_recipients']),
            'emails_sent' => intval($row['emails_sent']),
            'opens' => intval($row['opens']),
            'clicks' => intval($row['clicks']),
            'created_date' => $row['created_date'],
            'scheduled_date' => $row['scheduled_date'],
            'sent_date' => $row['sent_date']
        );
    }
}

$response = array(
    'draw' => $draw,
    'recordsTotal' => $total_records,
    'recordsFiltered' => $total_records,
    'data' => $data
);

echo json_encode($response, JSON_UNESCAPED_UNICODE);
?>

