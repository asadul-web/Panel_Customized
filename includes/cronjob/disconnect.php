<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
require_once 'config.php';

// Update user durations every 5 minutes (300sec = 5min)
// Decrease duration for connected users
$update_duration = $db->sql_query("
    UPDATE users 
    SET duration = GREATEST(0, duration - 300)
    WHERE device_connected = 1 
    AND is_freeze = 0 
    AND duration > 0
");

if($update_duration){
    echo "Duration Update Success <br />";
}else{
    echo "Duration Update Failed <br />";
}

// Disconnect users with zero duration
$disconnect_expired = $db->sql_query("
    UPDATE users 
    SET device_connected = 0,
        active_address = ''
    WHERE duration <= 0
");

if($disconnect_expired){
    echo "Expired Users Disconnected <br />";
}

// Clean old login attempts (older than 24 hours)
$disco = $db->sql_query("DELETE FROM login_attempts_logs WHERE timestamp < DATE_SUB(NOW(), INTERVAL 24 HOUR)");

if($disco){
    echo "Old Logs Cleanup Success <br />";
}else{
    echo "Old Logs Cleanup Failed <br />";
}

?>

