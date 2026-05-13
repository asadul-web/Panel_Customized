<?php
// Enhanced user sync for VPN servers - integrates with your panel
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../includes/functions.php';

// API key validation
$key = $_GET['key'] ?? '';
if ($key !== 'azimaxus') {
    http_response_code(403);
    echo "Access denied";
    exit;
}

// Action parameter
$action = $_GET['action'] ?? 'active';

/**
 * Decrypt password using panel encryption
 */
function decrypt_user_pass($db, $pass) {
    try {
        return $db->encryptor('decrypt', $pass);
    } catch (Exception $e) {
        return false;
    }
}

/**
 * Sanitize username for system use
 */
function safe_username($username) {
    $safe = preg_replace('/[^a-zA-Z0-9_-]/', '', $username);
    return (strlen($safe) > 0 && strlen($safe) <= 32) ? $safe : null;
}

$data = '';

switch ($action) {
    case 'active':
        // Get active users for system account creation
        $query = $db->sql_query("
            SELECT user_name, user_pass, duration 
            FROM users 
            WHERE duration > 0 
              AND is_freeze = 0 
              AND user_level IN ('member', 'vpn', 'normal')
            ORDER BY user_id DESC
        ");
        
        while ($row = $db->sql_fetchrow($query)) {
            $username = safe_username($row['user_name']);
            $user_pass = decrypt_user_pass($db, $row['user_pass']);
            
            if (!$username || !$user_pass) continue;
            
            // Calculate expiry date
            $duration_seconds = intval($row['duration']);
            $expiry_date = date('Y-m-d', time() + $duration_seconds);
            
            // Create system user with expiry
            $data .= "/usr/sbin/useradd --badname -p \$(openssl passwd -1 '$user_pass') -s /bin/false -M -e $expiry_date $username &> /dev/null;" . PHP_EOL;
        }
        break;
        
    case 'openvpn':
        // OpenVPN authentication format
        $query = $db->sql_query("
            SELECT user_name, auth_vpn 
            FROM users 
            WHERE duration > 0 
              AND is_freeze = 0 
              AND user_level IN ('member', 'vpn', 'normal')
        ");
        
        while ($row = $db->sql_fetchrow($query)) {
            $username = safe_username($row['user_name']);
            if (!$username) continue;
            
            $data .= "$username\n";
        }
        break;
        
    case 'cleanup':
        // Remove expired users
        $query = $db->sql_query("
            SELECT user_name 
            FROM users 
            WHERE (duration <= 0 OR is_freeze = 1)
              AND user_level IN ('member', 'vpn', 'normal')
        ");
        
        while ($row = $db->sql_fetchrow($query)) {
            $username = safe_username($row['user_name']);
            if (!$username) continue;
            
            $data .= "/usr/sbin/userdel $username &> /dev/null;" . PHP_EOL;
        }
        break;
}

echo $data;
?>
