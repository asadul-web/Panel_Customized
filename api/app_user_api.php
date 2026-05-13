<?php
/**
 * Enhanced Android App User Management API
 * 
 * Features:
 * - Trial User: 2 hours free, auto-activated
 * - Normal User: Requires name, mobile, email + admin approval
 * - Renewal: Payment-based with approval
 * - User Status Check
 * 
 * Endpoints:
 * - create_trial: Create 2-hour free trial user
 * - create_normal: Create normal user (pending approval)
 * - renew_user: Renew user subscription (pending payment verification)
 * - check_user: Check user status and details
 * - approve_user: Admin endpoint to approve pending users
 * - verify_payment: Admin endpoint to verify payment and activate/renew
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
    
    case 'create_normal':
        createNormalUser($db, $request, $upline_id);
        break;
    
    case 'renew_user':
        renewUser($db, $request, $upline_id);
        break;
    
    case 'check_user':
        checkUser($db, $request);
        break;
    
    case 'approve_user':
        approveUser($db, $request, $upline_level);
        break;
    
    case 'verify_payment':
        verifyPayment($db, $request, $upline_level);
        break;
    
    default:
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Invalid action. Available: create_trial, create_normal, renew_user, check_user, approve_user, verify_payment'
        ]);
        exit;
}

/**
 * Create Trial User - 2 Hours Free
 * Required: username, password
 */
function createTrialUser($db, $request, $upline_id) {
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    $password = $db->Sanitize(trim($request['password'] ?? ''));
    
    $errors = [];
    
    // Validation
    if (empty($username) || strlen($username) < 5) {
        $errors[] = 'Username must be at least 5 characters';
    }
    
    if (empty($password) || strlen($password) < 5) {
        $errors[] = 'Password must be at least 5 characters';
    }
    
    if (preg_match('/[^a-z-A-Z-0-9]/', $username)) {
        $errors[] = 'Username can only contain letters and numbers';
    }
    
    // Check if username exists
    $check = $db->sql_query("SELECT user_name FROM users WHERE user_name='".$db->SanitizeForSQL($username)."'");
    if ($db->sql_numrows($check) > 0) {
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
    
    // 2 hours = 7200 seconds
    $duration = 7200;
    
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
        $expiry_date = date('Y-m-d H:i:s', time() + $duration);
        
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'Trial user created successfully - 2 hours free access',
            'data' => [
                'username' => $username,
                'password' => $password,
                'user_type' => 'trial',
                'duration_hours' => 2,
                'duration_seconds' => $duration,
                'expiry_date' => $expiry_date,
                'is_active' => true,
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
 * Create Normal User - Requires Approval
 * Required: username, password, full_name, mobile, email
 */
function createNormalUser($db, $request, $upline_id) {
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    $password = $db->Sanitize(trim($request['password'] ?? ''));
    $full_name = $db->Sanitize(trim($request['full_name'] ?? ''));
    $mobile = $db->Sanitize(trim($request['mobile'] ?? ''));
    $email = $db->Sanitize(trim($request['email'] ?? ''));
    $duration_months = (int)($request['duration_months'] ?? 1);
    
    $errors = [];
    
    // Validation
    if (empty($username) || strlen($username) < 5) {
        $errors[] = 'Username must be at least 5 characters';
    }
    
    if (empty($password) || strlen($password) < 5) {
        $errors[] = 'Password must be at least 5 characters';
    }
    
    if (empty($full_name)) {
        $errors[] = 'Full name is required';
    }
    
    if (empty($mobile) || strlen($mobile) < 10) {
        $errors[] = 'Valid mobile number is required (min 10 digits)';
    }
    
    if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'Valid email address is required';
    }
    
    if ($duration_months < 1 || $duration_months > 12) {
        $errors[] = 'Duration must be between 1 and 12 months';
    }
    
    if (preg_match('/[^a-z-A-Z-0-9]/', $username)) {
        $errors[] = 'Username can only contain letters and numbers';
    }
    
    // Check if username exists
    $check = $db->sql_query("SELECT user_name FROM users WHERE user_name='".$db->SanitizeForSQL($username)."'");
    if ($db->sql_numrows($check) > 0) {
        $errors[] = 'Username already exists';
    }
    
    // Check if email exists
    $email_check = $db->sql_query("SELECT user_email FROM users WHERE user_email='".$db->SanitizeForSQL($email)."'");
    if ($db->sql_numrows($email_check) > 0) {
        $errors[] = 'Email already registered';
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
    $duration = 2592000 * $duration_months;
    
    // Create user (inactive, pending approval)
    $user_pass = $db->encryptor('encrypt', $password);
    $auth_vpn = md5($password);
    $code = rand(0, 999999999);
    
    $result = $db->sql_query("INSERT INTO users 
        (user_name, user_pass, auth_vpn, user_email, full_name, mobile, regdate, is_groupname, is_active, is_freeze, user_level, code, is_ban, is_validated, upline, duration)
        VALUES
        ('".$db->SanitizeForSQL($username)."', '".$db->SanitizeForSQL($user_pass)."', '".$db->SanitizeForSQL($auth_vpn)."',
        '".$db->SanitizeForSQL($email)."', '".$db->SanitizeForSQL($full_name)."', '".$db->SanitizeForSQL($mobile)."', '".date('Y-m-d H:i:s')."', 'normal', 0, 0,
        'normal', '".$db->SanitizeForSQL($code)."', 0, 0, '".$db->SanitizeForSQL($upline_id)."', '".$db->SanitizeForSQL($duration)."')");
    
    $result2 = $db->sql_query("INSERT INTO radcheck 
        (username, attribute, op, value)
        VALUES
        ('".$db->SanitizeForSQL($username)."', 'Cleartext-Password', ':=', '".$db->SanitizeForSQL($password)."')");
    
    if ($result && $result2) {
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'User registration submitted. Pending admin approval.',
            'data' => [
                'username' => $username,
                'full_name' => $full_name,
                'mobile' => $mobile,
                'email' => $email,
                'user_type' => 'normal',
                'duration_months' => $duration_months,
                'is_active' => false,
                'is_validated' => false,
                'status' => 'pending_approval',
                'created_at' => date('Y-m-d H:i:s'),
                'message' => 'Your account will be activated once admin approves and payment is verified'
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
 * Renew User - Pending Payment Verification
 * Required: username, duration_months, payment_reference
 */
function renewUser($db, $request, $upline_id) {
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    $duration_months = (int)($request['duration_months'] ?? 1);
    $payment_reference = $db->Sanitize(trim($request['payment_reference'] ?? ''));
    
    $errors = [];
    
    if (empty($username)) {
        $errors[] = 'Username is required';
    }
    
    if ($duration_months < 1 || $duration_months > 12) {
        $errors[] = 'Duration must be between 1 and 12 months';
    }
    
    if (empty($payment_reference)) {
        $errors[] = 'Payment reference is required';
    }
    
    // Check if user exists
    $user_qry = $db->sql_query("SELECT user_id, user_name, user_level, duration, is_validated FROM users WHERE user_name='".$db->SanitizeForSQL($username)."'");
    
    if ($db->sql_numrows($user_qry) < 1) {
        $errors[] = 'User not found';
    } else {
        $user_row = $db->sql_fetchrow($user_qry);
        
        if (!in_array($user_row['user_level'], ['normal', 'bulk'])) {
            $errors[] = 'Only normal/bulk users can be renewed';
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
    
    // Mark user as pending renewal (is_validated = 2 means pending payment)
    $duration = 2592000 * $duration_months;
    
    $update = $db->sql_query("UPDATE users SET 
        is_validated=2,
        duration='".$db->SanitizeForSQL($duration)."'
        WHERE user_name='".$db->SanitizeForSQL($username)."'");
    
    // Log payment reference (you can create a payments table for this)
    // For now, we'll just return success
    
    if ($update) {
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'Renewal request submitted. Pending payment verification.',
            'data' => [
                'username' => $username,
                'duration_months' => $duration_months,
                'payment_reference' => $payment_reference,
                'status' => 'pending_payment_verification',
                'message' => 'Your account will be renewed once payment is verified by admin'
            ]
        ]);
    } else {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Failed to process renewal request'
        ]);
    }
}

/**
 * Check User Status
 * Required: username
 */
function checkUser($db, $request) {
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    
    if (empty($username)) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Username is required'
        ]);
        exit;
    }
    
    $query = $db->sql_query("SELECT user_id, user_name, full_name, user_email, mobile, user_level, is_active, is_validated, is_freeze, duration, regdate FROM users WHERE user_name='".$db->SanitizeForSQL($username)."'");
    
    if ($db->sql_numrows($query) > 0) {
        $user = $db->sql_fetchrow($query);
        
        // Determine status
        $status = 'inactive';
        $status_message = '';
        
        if ($user['is_validated'] == 0) {
            $status = 'pending_approval';
            $status_message = 'Account pending admin approval';
        } elseif ($user['is_validated'] == 2) {
            $status = 'pending_payment';
            $status_message = 'Renewal pending payment verification';
        } elseif ($user['is_active'] == 1 && $user['is_freeze'] == 0) {
            $status = 'active';
            $status_message = 'Account is active';
        } elseif ($user['is_freeze'] == 1) {
            $status = 'frozen';
            $status_message = 'Account is frozen';
        }
        
        // Calculate expiry
        $expiry_date = date('Y-m-d H:i:s', strtotime($user['regdate']) + $user['duration']);
        $time_remaining = strtotime($expiry_date) - time();
        
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'data' => [
                'username' => $user['user_name'],
                'full_name' => $user['full_name'],
                'email' => $user['user_email'],
                'mobile' => $user['mobile'],
                'user_type' => $user['user_level'],
                'account_status' => $status,
                'status_message' => $status_message,
                'is_active' => (bool)$user['is_active'],
                'is_validated' => (bool)$user['is_validated'],
                'is_frozen' => (bool)$user['is_freeze'],
                'created_at' => $user['regdate'],
                'expiry_date' => $expiry_date,
                'time_remaining_seconds' => max(0, $time_remaining),
                'time_remaining_hours' => max(0, round($time_remaining / 3600, 2))
            ]
        ]);
    } else {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'User not found'
        ]);
    }
}

/**
 * Approve User - Admin Only
 * Required: username
 */
function approveUser($db, $request, $upline_level) {
    if (!in_array($upline_level, ['administrator', 'superadmin', 'developer'])) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Access denied. Admin only.'
        ]);
        exit;
    }
    
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    
    if (empty($username)) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Username is required'
        ]);
        exit;
    }
    
    // Activate user
    $update = $db->sql_query("UPDATE users SET is_active=1, is_validated=1 WHERE user_name='".$db->SanitizeForSQL($username)."' AND is_validated=0");
    
    if ($update && $db->sql_affectedrows() > 0) {
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'User approved and activated successfully',
            'data' => [
                'username' => $username,
                'is_active' => true,
                'is_validated' => true
            ]
        ]);
    } else {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'User not found or already approved'
        ]);
    }
}

/**
 * Verify Payment and Activate/Renew - Admin Only
 * Required: username
 */
function verifyPayment($db, $request, $upline_level) {
    if (!in_array($upline_level, ['administrator', 'superadmin', 'developer'])) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Access denied. Admin only.'
        ]);
        exit;
    }
    
    $username = $db->Sanitize(trim($request['username'] ?? ''));
    
    if (empty($username)) {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'Username is required'
        ]);
        exit;
    }
    
    // Verify payment and activate/renew user
    $update = $db->sql_query("UPDATE users SET is_active=1, is_validated=1, regdate='".date('Y-m-d H:i:s')."' WHERE user_name='".$db->SanitizeForSQL($username)."' AND is_validated=2");
    
    if ($update && $db->sql_affectedrows() > 0) {
        // Get user details
        $user_qry = $db->sql_query("SELECT duration FROM users WHERE user_name='".$db->SanitizeForSQL($username)."'");
        $user = $db->sql_fetchrow($user_qry);
        $expiry = date('Y-m-d H:i:s', time() + $user['duration']);
        
        echo json_encode([
            'response' => 1,
            'status' => 'success',
            'message' => 'Payment verified. User activated/renewed successfully.',
            'data' => [
                'username' => $username,
                'is_active' => true,
                'is_validated' => true,
                'renewed_at' => date('Y-m-d H:i:s'),
                'expiry_date' => $expiry
            ]
        ]);
    } else {
        echo json_encode([
            'response' => 0,
            'status' => 'error',
            'message' => 'User not found or no pending payment'
        ]);
    }
}
?>
