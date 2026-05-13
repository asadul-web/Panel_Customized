<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../includes/functions.php';

// Validate inputs
if (!isset($_GET['ip']) || empty($_GET['ip'])) {
    echo 'failed';
    exit;
}

$ip = strip_tags(trim($_GET['ip']));
$total = isset($_GET['total']) ? (int)$_GET['total'] : 0;

// Validate IP format
if (!filter_var($ip, FILTER_VALIDATE_IP)) {
    echo 'failed';
    exit;
}

// Update server online count
$sql = "UPDATE server_list SET online='$total', last_update=NOW() WHERE server_ip='$ip'";
$qry = $db->sql_query($sql);

if ($qry) {
    echo 'success';
} else {
    echo 'failed';
}