<?php
// API to get real-time user session data and usage statistics
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../includes/functions.php';

header('Content-Type: application/json');

if (!isset($_GET['username'])) {
    echo json_encode(array('success' => false, 'error' => 'Username required'));
    exit;
}

$username = $db->Sanitize(trim($_GET['username']));
$response = array();

try {
    // Get user data
    $user_query = $db->sql_query("
        SELECT 
            user_id,
            user_name,
            duration,
            device_connected,
            active_address,
            last_login,
            is_freeze
        FROM users 
        WHERE user_name = '$username'
        LIMIT 1
    ");
    
    if ($user_row = $db->sql_fetchrow($user_query)) {
        $response['user_id'] = $user_row['user_id'];
        $response['username'] = $user_row['user_name'];
        $response['is_online'] = (int)$user_row['device_connected'] === 1;
        $response['is_frozen'] = (int)$user_row['is_freeze'] === 1;
        $response['active_address'] = $user_row['active_address'] ?? 'N/A';
        $response['last_login'] = $user_row['last_login'] ?? 'Never';
        
        // Calculate remaining time
        $duration = (int)$user_row['duration'];
        if ($duration > 0) {
            $dur = $db->calc_time($duration);
            $response['remaining_time'] = array(
                'days' => $dur['days'],
                'hours' => $dur['hours'],
                'minutes' => $dur['minutes'],
                'seconds' => $dur['seconds'],
                'formatted' => $dur['days'] . 'd ' . $dur['hours'] . 'h ' . $dur['minutes'] . 'm ' . $dur['seconds'] . 's'
            );
            $response['is_expired'] = false;
        } else {
            $response['remaining_time'] = null;
            $response['is_expired'] = true;
        }
        
        // Get usage statistics (if available in login_attempts_logs or similar table)
        $usage_query = $db->sql_query("
            SELECT 
                COUNT(*) as connection_count,
                MAX(timestamp) as last_connection
            FROM login_attempts_logs 
            WHERE username = '$username'
            AND timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        ");
        
        if ($usage_row = $db->sql_fetchrow($usage_query)) {
            $response['usage_24h'] = array(
                'connections' => (int)$usage_row['connection_count'],
                'last_connection' => $usage_row['last_connection'] ?? 'N/A'
            );
        }
        
        $response['success'] = true;
        
    } else {
        $response['success'] = false;
        $response['error'] = 'User not found';
    }
    
    $response['timestamp'] = date('Y-m-d H:i:s');
    
} catch (Exception $e) {
    $response['success'] = false;
    $response['error'] = $e->getMessage();
}

echo json_encode($response);
