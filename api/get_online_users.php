<?php
// API to get real-time online users and session data
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../includes/functions.php';

header('Content-Type: application/json');

$response = array();

try {
    // Get total online users from all active servers
    $online_query = $db->sql_query("
        SELECT 
            SUM(COALESCE(online, 0)) as total_online
        FROM server_list 
        WHERE status = '1'
    ");
    
    if ($online_row = $db->sql_fetchrow($online_query)) {
        $response['total_online'] = (int)$online_row['total_online'];
        $response['grand_total'] = $response['total_online'];
    } else {
        $response['total_online'] = 0;
        $response['grand_total'] = 0;
    }
    
    // Get server-wise breakdown
    $servers = array();
    $server_query = $db->sql_query("
        SELECT 
            server_name,
            server_ip,
            COALESCE(online, 0) as online,
            status
        FROM server_list 
        ORDER BY server_id DESC
    ");
    
    while ($server = $db->sql_fetchrow($server_query)) {
        $servers[] = array(
            'name' => $server['server_name'],
            'ip' => $server['server_ip'],
            'online' => (int)$server['online'],
            'total' => (int)$server['online'],
            'status' => $server['status']
        );
    }
    
    $response['servers'] = $servers;
    $response['success'] = true;
    $response['timestamp'] = date('Y-m-d H:i:s');
    
} catch (Exception $e) {
    $response['success'] = false;
    $response['error'] = $e->getMessage();
}

echo json_encode($response);
