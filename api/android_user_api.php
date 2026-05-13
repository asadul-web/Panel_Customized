<?php
/**
 * Android User Management API
 * Endpoints: Create Trial User, Create Normal User, Renew User
 * 
 * Usage:
 * POST /api/android_user_api.php
 * 
 * Actions:
 * - create_trial: Create a new trial user
 * - create_user: Create a new normal/bulk user
 * - renew_user: Renew/extend user subscription
 * - check_user: Check user account status
 */

error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
header('Content-Type: application/json');

require_once '../includes/functions.php';

// Helper function to validate API key
function validateApiKey($db, $api_key) {
    if (empty($api_key)) {
        return false;
    }
    
    // Check if API key matches admin/reseller API key
    $query = $db->sql_query("SELECT user_id, user_level FROM users WHERE api_key='".$db->SanitizeForSQL($api_key)."' AND (user_level='administrator' OR user_level='superadmin' OR user_level='developer' OR user_level='reseller')");
    
    if ($db->sql_numrows($query) > 0) {
        return $db->sql_fetchrow($query);
    }
    
    return false;
}

// Get request data
$raw_input = file_get_contents('php://input');
$request = json_decode($raw_input, true);

if (!is_array($request)) {
    $request = $_POST;
}

// Extract parameters
$action = $request['action'] ?? '';
$api_key = $request['api_key'] ?? '';

// Validate API key
$api_user = validateApiKey($db, $api_key);

if (!$api_user) {
    echo json_encode([
        'response' => 0,
        'status' => 'error',
        'message' => 'Invalid or missing API key'
    ]);
    exit;
}

$upline_id = $api_user['user_id'];
$upline_level = $api_user['user_level'];

// Route to appropriate action
switch ($action) {
    case 'create_trial':
        createTrialUser($db, $request, $upline_id);
        break;
    
    case 'create_user':
        createNormalUser($db, $request, $upline_id, $upline_level);
        break;
    
    case 'renew_user':
        renewUser($db, $request, $upline_id, $upline_level);
        break;
    
    case 'check_user':
        checkUser($db, $request, $upline_id);
        break;
    
    default:
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Invalid action. Available actions: create_trial, create_user, renew_user, check_user'
        ]);
        exit;
}

/**
 * Create Trial User
 * Required: username, password
 */
function createTrialUser($db, $request, $upline_id) {
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    $password = $db->Sanitize(trim($request['password'] ?? ''));
    
    $errors = [];
    
    // Validation
    if (empty($username)) {
        $errors[] = 'Username is required';
    }
    
    if (empty($password)) {
        $errors[] = 'Password is required';
    }
    
    if (strlen($username) < 5) {
        $errors[] = 'Username must be at least 5 characters';
    }
    
    if (strlen($password) < 5) {
        $errors[] = 'Password must be at least 5 characters';
    }
    
    if (preg_match('/[^a-z-A-Z-0-9]/', $username)) {
        $errors[] = 'Username can only contain letters and numbers';
    }
    
    if (preg_match('/[^a-z-A-Z-0-9]/', $password)) {
        $errors[] = 'Password can only contain letters and numbers';
    }
    
    // Check if username exists
    $username_qry = $db->sql_query("SELECT user_name FROM users WHERE user_name='".$db->SanitizeForSQL($username)."'");
    if ($db->sql_numrows($username_qry) > 0) {
        $errors[] = 'Username already exists';
    }
    
    if (!empty($errors)) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Validation failed',
            'errors' => $errors
        ]);
        exit;
    }
    
    // Get trial duration from settings
    $trial_qry = $db->sql_query("SELECT trial_duration FROM site_options WHERE id='1'");
    $trial_row = $db->sql_fetchrow($trial_qry);
    $duration = $trial_row['trial_duration'] ?? 86400; // Default 1 day
    
    // Create user
    $user_pass = $db->encryptor('encrypt', $password);
    $auth_vpn = md5($password);
    $code = rand(0, 999999999);
    $user_email = $username . '@trial.com';
    $full_name = 'Trial User';
    
    $result = $db->sql_query("INSERT INTO users 
        (user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze, user_level, code, is_ban, is_validated, upline, duration, device_connected)
        VALUES
        ('".$db->SanitizeForSQL($username)."', '".$db->SanitizeForSQL($user_pass)."', '".$db->SanitizeForSQL($auth_vpn)."',
        '".$db->SanitizeForSQL($user_email)."', '".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d H:i:s')."', 'trial', 1, 0,
        'trial', '".$db->SanitizeForSQL($code)."', 0, 1, '".$db->SanitizeForSQL($upline_id)."', '".$db->SanitizeForSQL($duration)."', 1)");
    
    $result2 = $db->sql_query("INSERT INTO radcheck 
        (username, attribute, op, value)
        VALUES
        ('".$db->SanitizeForSQL($username)."', 'Cleartext-Password', ':=', '".$db->SanitizeForSQL($password)."')");
    
    if ($result && $result2) {
        // Calculate expiry date
        $expiry_date = date('Y-m-d H:i:s', time() + $duration);
        
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'Trial user created successfully',
            'data' => [
                'username' => $username,
                'password' => $password,
                'user_type' => 'trial',
                'duration_seconds' => $duration,
                'expiry_date' => $expiry_date,
                'created_at' => date('Y-m-d H:i:s')
            ]
        ]);
    } else {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Failed to create trial user'
        ]);
    }
}

/**
 * Create Normal/Bulk User
 * Required: username, password, user_type (normal/bulk), duration_months
 */
function createNormalUser($db, $request, $upline_id, $upline_level) {
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    $password = $db->Sanitize(trim($request['password'] ?? ''));
    $user_type = $db->Sanitize(trim($request['user_type'] ?? 'normal'));
    $duration_months = (int)($request['duration_months'] ?? 1);
    $bulk_count = (int)($request['bulk'] ?? 1);
    
    $errors = [];
    
    // Validation
    if (empty($username)) {
        $errors[] = 'Username is required';
    }
    
    // Auto-generate password if not provided (for bulk users)
    if (empty($password)) {
        $password = substr(str_shuffle('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'), 0, 8);
    }
    
    if (!in_array($user_type, ['normal', 'bulk'])) {
        $errors[] = 'Invalid user type. Must be: normal or bulk';
    }
    
    if ($duration_months < 1 || $duration_months > 12) {
        $errors[] = 'Duration must be between 1 and 12 months';
    }
    
    if (strlen($username) < 5) {
        $errors[] = 'Username must be at least 5 characters';
    }
    
    if (strlen($password) < 5) {
        $errors[] = 'Password must be at least 5 characters';
    }
    
    if (preg_match('/[^a-z-A-Z-0-9]/', $username)) {
        $errors[] = 'Username can only contain letters and numbers';
    }
    
    if (preg_match('/[^a-z-A-Z-0-9]/', $password)) {
        $errors[] = 'Password can only contain letters and numbers';
    }
    
    // Check if username exists
    $username_qry = $db->sql_query("SELECT user_name FROM users WHERE user_name='".$db->SanitizeForSQL($username)."'");
    if ($db->sql_numrows($username_qry) > 0) {
        $errors[] = 'Username already exists';
    }
    
    // Check if upline is blocked
    $blocked_qry = $db->sql_query("SELECT is_freeze, credits FROM users WHERE user_id='".$db->SanitizeForSQL($upline_id)."'");
    $blocked_row = $db->sql_fetchrow($blocked_qry);
    
    if ($blocked_row['is_freeze'] == 1) {
        $errors[] = 'Your account is blocked. Contact administrator';
    }
    
    // Check credits for resellers
    if ($upline_level == 'reseller' || $upline_level == 'subreseller') {
        $credits = $blocked_row['credits'] ?? 0;
        if ($credits < $duration_months) {
            $errors[] = 'Insufficient credits. Required: '.$duration_months.', Available: '.$credits;
        }
    }
    
    if (!empty($errors)) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Validation failed',
            'errors' => $errors
        ]);
        exit;
    }
    
    // Calculate duration in seconds (30 days per month)
    $duration = 2592000 * $duration_months; // 30 days * months
    
    // Handle bulk creation
    if ($bulk_count > 1) {
        $created_users = [];
        $failed_users = [];
        $total_credits_needed = $duration_months * $bulk_count;
        
        // Check if reseller has enough credits for bulk
        if ($upline_level == 'reseller' || $upline_level == 'subreseller') {
            $credit_qry = $db->sql_query("SELECT credits FROM users WHERE user_id='".$db->SanitizeForSQL($upline_id)."'");
            $credit_row = $db->sql_fetchrow($credit_qry);
            $available_credits = $credit_row['credits'] ?? 0;
            
            if ($available_credits < $total_credits_needed) {
                echo json_encode([
                    'response' => 0,
                    'status' => 'error',
                    'message' => 'Insufficient credits for bulk creation',
                    'required' => $total_credits_needed,
                    'available' => $available_credits
                ]);
                exit;
            }
        }
        
        // Create multiple users
        for ($i = 1; $i <= $bulk_count; $i++) {
            $bulk_username = $username . $i;
            $bulk_password = substr(str_shuffle('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'), 0, 8);
            
            // Check if username exists
            $check = $db->sql_query("SELECT user_name FROM users WHERE user_name='".$db->SanitizeForSQL($bulk_username)."'");
            if ($db->sql_numrows($check) > 0) {
                $failed_users[] = ['username' => $bulk_username, 'reason' => 'Username already exists'];
                continue;
            }
            
            $user_pass = $db->encryptor('encrypt', $bulk_password);
            $auth_vpn = md5($bulk_password);
            $code = rand(0, 999999999);
            $user_email = $bulk_username . '@user.com';
            $full_name = ucfirst($user_type) . ' User';
            $is_active = ($user_type == 'normal') ? 0 : 1;
            
            $result = $db->sql_query("INSERT INTO users 
                (user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze, user_level, code, is_ban, is_validated, upline, duration)
                VALUES
                ('".$db->SanitizeForSQL($bulk_username)."', '".$db->SanitizeForSQL($user_pass)."', '".$db->SanitizeForSQL($auth_vpn)."',
                '".$db->SanitizeForSQL($user_email)."', '".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($user_type)."', '".$db->SanitizeForSQL($is_active)."', 0,
                '".$db->SanitizeForSQL($user_type)."', '".$db->SanitizeForSQL($code)."', 0, 1, '".$db->SanitizeForSQL($upline_id)."', '".$db->SanitizeForSQL($duration)."')");
            
            $result2 = $db->sql_query("INSERT INTO radcheck 
                (username, attribute, op, value)
                VALUES
                ('".$db->SanitizeForSQL($bulk_username)."', 'Cleartext-Password', ':=', '".$db->SanitizeForSQL($bulk_password)."')");
            
            if ($result && $result2) {
                $expiry_date = date('Y-m-d H:i:s', time() + $duration);
                $created_users[] = [
                    'username' => $bulk_username,
                    'password' => $bulk_password,
                    'expiry_date' => $expiry_date
                ];
            } else {
                $failed_users[] = ['username' => $bulk_username, 'reason' => 'Database insert failed'];
            }
        }
        
        // Deduct credits for successfully created users
        if (!empty($created_users) && ($upline_level == 'reseller' || $upline_level == 'subreseller')) {
            $credits_to_deduct = count($created_users) * $duration_months;
            $db->sql_query("UPDATE users SET credits=credits-".$credits_to_deduct." WHERE user_id='".$db->SanitizeForSQL($upline_id)."'");
        }
        
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'Bulk user creation completed',
            'data' => [
                'total_requested' => $bulk_count,
                'total_created' => count($created_users),
                'total_failed' => count($failed_users),
                'users' => $created_users,
                'failed' => $failed_users,
                'user_type' => $user_type,
                'duration_months' => $duration_months,
                'credits_deducted' => ($upline_level == 'reseller' || $upline_level == 'subreseller') ? count($created_users) * $duration_months : 0
            ]
        ]);
        exit;
    }
    
    // Single user creation
    $user_pass = $db->encryptor('encrypt', $password);
    $auth_vpn = md5($password);
    $code = rand(0, 999999999);
    $user_email = $username . '@user.com';
    $full_name = ucfirst($user_type) . ' User';
    $is_active = ($user_type == 'normal') ? 0 : 1;
    
    $result = $db->sql_query("INSERT INTO users 
        (user_name, user_pass, auth_vpn, user_email, full_name, regdate, is_groupname, is_active, is_freeze, user_level, code, is_ban, is_validated, upline, duration)
        VALUES
        ('".$db->SanitizeForSQL($username)."', '".$db->SanitizeForSQL($user_pass)."', '".$db->SanitizeForSQL($auth_vpn)."',
        '".$db->SanitizeForSQL($user_email)."', '".$db->SanitizeForSQL($full_name)."', '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($user_type)."', '".$db->SanitizeForSQL($is_active)."', 0,
        '".$db->SanitizeForSQL($user_type)."', '".$db->SanitizeForSQL($code)."', 0, 1, '".$db->SanitizeForSQL($upline_id)."', '".$db->SanitizeForSQL($duration)."')");
    
    $result2 = $db->sql_query("INSERT INTO radcheck 
        (username, attribute, op, value)
        VALUES
        ('".$db->SanitizeForSQL($username)."', 'Cleartext-Password', ':=', '".$db->SanitizeForSQL($password)."')");
    
    if ($result && $result2) {
        // Deduct credits for resellers
        if ($upline_level == 'reseller' || $upline_level == 'subreseller') {
            $db->sql_query("UPDATE users SET credits=credits-".$duration_months." WHERE user_id='".$db->SanitizeForSQL($upline_id)."'");
        }
        
        // Calculate expiry date
        $expiry_date = date('Y-m-d H:i:s', time() + $duration);
        
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'User created successfully',
            'data' => [
                'username' => $username,
                'password' => $password,
                'user_type' => $user_type,
                'duration_months' => $duration_months,
                'duration_seconds' => $duration,
                'expiry_date' => $expiry_date,
                'created_at' => date('Y-m-d H:i:s'),
                'credits_deducted' => ($upline_level == 'reseller' || $upline_level == 'subreseller') ? $duration_months : 0
            ]
        ]);
    } else {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Failed to create user'
        ]);
    }
}

/**
 * Renew/Extend User Subscription
 * Required: username, duration_months
 */
function renewUser($db, $request, $upline_id, $upline_level) {
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    $duration_months = (int)($request['duration_months'] ?? 1);
    
    $errors = [];
    
    // Validation
    if (empty($username)) {
        $errors[] = 'Username is required';
    }
    
    if ($duration_months < 1 || $duration_months > 12) {
        $errors[] = 'Duration must be between 1 and 12 months';
    }
    
    // Check if user exists and belongs to upline
    $user_qry = $db->sql_query("SELECT user_id, user_name, user_level, duration FROM users WHERE user_name='".$db->SanitizeForSQL($username)."' AND upline='".$db->SanitizeForSQL($upline_id)."'");
    
    if ($db->sql_numrows($user_qry) < 1) {
        $errors[] = 'User not found or does not belong to your account';
    } else {
        $user_row = $db->sql_fetchrow($user_qry);
        $user_id = $user_row['user_id'];
        $user_level = $user_row['user_level'];
        $current_duration = $user_row['duration'];
        
        // Only allow renewal for normal, bulk, and trial users
        if (!in_array($user_level, ['normal', 'bulk', 'trial'])) {
            $errors[] = 'Cannot renew this user type';
        }
    }
    
    // Check if upline is blocked
    $blocked_qry = $db->sql_query("SELECT is_freeze, credits FROM users WHERE user_id='".$db->SanitizeForSQL($upline_id)."'");
    $blocked_row = $db->sql_fetchrow($blocked_qry);
    
    if ($blocked_row['is_freeze'] == 1) {
        $errors[] = 'Your account is blocked. Contact administrator';
    }
    
    // Check credits for resellers
    if ($upline_level == 'reseller' || $upline_level == 'subreseller') {
        $credits = $blocked_row['credits'] ?? 0;
        if ($credits < $duration_months) {
            $errors[] = 'Insufficient credits. Required: '.$duration_months.', Available: '.$credits;
        }
    }
    
    if (!empty($errors)) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Validation failed',
            'errors' => $errors
        ]);
        exit;
    }
    
    // Calculate duration in seconds (30 days per month)
    $duration_time = 2592000 * $duration_months;
    
    // Update user duration
    $update = $db->sql_query("UPDATE users SET duration=duration+".$duration_time." WHERE user_id='".$db->SanitizeForSQL($user_id)."'");
    
    if ($update) {
        // Deduct credits for resellers
        if ($upline_level == 'reseller' || $upline_level == 'subreseller') {
            $db->sql_query("UPDATE users SET credits=credits-".$duration_months." WHERE user_id='".$db->SanitizeForSQL($upline_id)."'");
        }
        
        // Calculate new expiry date
        $new_duration = $current_duration + $duration_time;
        $expiry_date = date('Y-m-d H:i:s', time() + $new_duration);
        
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'User subscription renewed successfully',
            'data' => [
                'username' => $username,
                'duration_added_months' => $duration_months,
                'duration_added_seconds' => $duration_time,
                'new_expiry_date' => $expiry_date,
                'renewed_at' => date('Y-m-d H:i:s'),
                'credits_deducted' => ($upline_level == 'reseller' || $upline_level == 'subreseller') ? $duration_months : 0
            ]
        ]);
    } else {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Failed to renew user subscription'
        ]);
    }
}

/**
 * Check User Account Status
 * Required: username
 */
function checkUser($db, $request, $upline_id) {
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    
    if (empty($username)) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Username is required'
        ]);
        exit;
    }
    
    // Get user info
    $user_qry = $db->sql_query("SELECT user_id, user_name, user_level, duration, regdate, is_active, is_freeze, is_ban, device_connected, active_address FROM users WHERE user_name='".$db->SanitizeForSQL($username)."' AND upline='".$db->SanitizeForSQL($upline_id)."'");
    
    if ($db->sql_numrows($user_qry) < 1) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'User not found or does not belong to your account'
        ]);
        exit;
    }
    
    $user = $db->sql_fetchrow($user_qry);
    
    // Calculate expiry
    $created_time = strtotime($user['regdate']);
    $expiry_time = $created_time + $user['duration'];
    $current_time = time();
    $is_expired = ($expiry_time < $current_time);
    $remaining_seconds = max(0, $expiry_time - $current_time);
    $remaining_days = floor($remaining_seconds / 86400);
    
    echo json_encode([
        'response' => 1,
        'status' => 'success',
        'message' => 'User information retrieved',
        'data' => [
            'username' => $user['user_name'],
            'user_type' => $user['user_level'],
            'is_active' => (bool)$user['is_active'],
            'is_frozen' => (bool)$user['is_freeze'],
            'is_banned' => (bool)$user['is_ban'],
            'is_expired' => $is_expired,
            'created_at' => $user['regdate'],
            'expiry_date' => date('Y-m-d H:i:s', $expiry_time),
            'remaining_days' => $remaining_days,
            'remaining_seconds' => $remaining_seconds,
            'device_limit' => $user['device_connected'],
            'is_online' => !empty($user['active_address']),
            'online_ip' => $user['active_address'] ?? null
        ]
    ]);
}
?>
