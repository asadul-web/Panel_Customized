<?php
chkSession();
if($user_id_2 == 2 || $user_level_2 == 'developer'){
	
}else{
	header("Location: /dashboard");	
}

// Password protection
@session_start();
$required_password = 'azim.0987Aa';

// Check if password is submitted via AJAX
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['verify_password'])) {
    header('Content-Type: application/json');
    if ($_POST['verify_password'] === $required_password) {
        $_SESSION['auth_api_unlocked'] = true;
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Incorrect password!']);
    }
    exit;
}

// Check if unlocked
$is_locked = !isset($_SESSION['auth_api_unlocked']) || $_SESSION['auth_api_unlocked'] !== true;

// DEBUG: Force locked state for testing
// $is_locked = true;

// Include the encrypt_all functionality
require_once dirname(__DIR__) . '/includes/api_encryption.php';

$api_encryption = new ApiEncryption();

// Load current URLs
$current_urls = $api_encryption->loadApiUrls();

// Handle form submission (only if not password verification)
$result = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !isset($_POST['verify_password'])) {
    $license_api_url = trim($_POST['license_api_url'] ?? '');
    $notice_api_url = trim($_POST['notice_api_url'] ?? '');
    $popup_notice_api_url = trim($_POST['popup_notice_api_url'] ?? '');
    
    // Validate URLs
    $errors = [];
    if (empty($license_api_url)) {
        $errors[] = 'License API URL is required';
    } elseif (!filter_var($license_api_url, FILTER_VALIDATE_URL)) {
        $errors[] = 'Invalid License API URL format';
    }
    if (empty($notice_api_url)) {
        $errors[] = 'Notice API URL is required';
    } elseif (!filter_var($notice_api_url, FILTER_VALIDATE_URL)) {
        $errors[] = 'Invalid Notice API URL format';
    }
    if (empty($popup_notice_api_url)) {
        $errors[] = 'Popup Notice API URL is required';
    } elseif (!filter_var($popup_notice_api_url, FILTER_VALIDATE_URL)) {
        $errors[] = 'Invalid Popup Notice API URL format';
    }
    
    if (empty($errors)) {
        // Encrypt each URL individually first
        $encrypted_license = $api_encryption->encrypt($license_api_url);
        $encrypted_notice = $api_encryption->encrypt($notice_api_url);
        $encrypted_popup = $api_encryption->encrypt($popup_notice_api_url);
        
        // Create the data structure (same as saveApiUrls)
        $data = [
            'license_api_url' => $encrypted_license,
            'notice_api_url' => $encrypted_notice,
            'popup_notice_api_url' => $encrypted_popup,
            'updated_at' => time(),
            'version' => '1.0'
        ];
        
        // Encrypt the entire JSON (double encryption - same as api_urls_encrypted.dat)
        $json_data = json_encode($data);
        $final_encrypted = $api_encryption->encrypt($json_data);
        
        $result = [
            'success' => true,
            'final_encrypted' => $final_encrypted,
            'urls' => [
                'license_api_url' => $license_api_url,
                'notice_api_url' => $notice_api_url,
                'popup_notice_api_url' => $popup_notice_api_url
            ]
        ];
    } else {
        $result = ['success' => false, 'errors' => $errors];
    }
}

$smarty->assign('api_manage_active', 'active');
$smarty->assign('auth_api_active', 'active');
$smarty->assign('current_urls', $current_urls);
$smarty->assign('result', $result);
$smarty->assign('post_data', $_POST);
$smarty->assign('is_locked', $is_locked);
$smarty->display("auth-api.tpl");
