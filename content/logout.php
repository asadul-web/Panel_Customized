<?php
// Logout functionality - clear session and redirect
if (isset($user) && !empty($user)) {
    try {
        // Decrypt user data and update login status
        $read_cookie = explode("|", $db->decrypt_key($user));
        if (isset($read_cookie[1]) && isset($read_cookie[2])) {
            $username = $db->Sanitize($read_cookie[1]);
            $password = $db->Sanitize($read_cookie[2]);
            
            // Update user status to offline
            $db->sql_query("UPDATE users SET login_status='offline' WHERE user_name='$username' AND user_pass='$password'");
            
            // Log the logout activity
            $user_id = $db->Sanitize($read_cookie[0]);
            $ip_address = $db->get_client_ip();
            $browser_info = $db->getBrowser();
            $device_info = $browser_info['name'];
            
            $db->sql_query("INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
                           VALUES ('$user_id', NOW(), 'Logout', '$ip_address', '$device_info', 'Web Browser')");
        }
    } catch (Exception $e) {
        // Continue with logout even if logging fails
    }
}

// Clear all session data
setcookie("user", "", time()-3600, "/"); 
setcookie("user_name", "", time()-3600, "/");
unset($_COOKIE['user']);
unset($_COOKIE['user_name']);

// Clear session variables
session_start();
session_destroy();

// Clear global variables
$user = "";
unset($user);

// Redirect to login page
$redirect_url = $db->base_url() . "login";
header("Location: $redirect_url");
exit();
?>