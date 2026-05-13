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
        $_SESSION['api_logs_unlocked'] = true;
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Incorrect password!']);
    }
    exit;
}

// Check if unlocked
$is_locked = !isset($_SESSION['api_logs_unlocked']) || $_SESSION['api_logs_unlocked'] !== true;

// Include the save URLs functionality
require_once dirname(__DIR__) . '/includes/api_encryption.php';

$api_encryption = new ApiEncryption();

// Load current URLs
$current_urls = $api_encryption->loadApiUrls();

// Handle form submission
$result = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !isset($_POST['verify_password'])) {
    $license_api_url = trim($_POST['license_api_url'] ?? '');
    $notice_api_url = trim($_POST['notice_api_url'] ?? '');
    $popup_notice_api_url = trim($_POST['popup_notice_api_url'] ?? '');
    
    // Validate URLs
    $errors = [];
    if (!empty($license_api_url) && !filter_var($license_api_url, FILTER_VALIDATE_URL)) {
        $errors[] = 'Invalid License API URL format';
    }
    if (!empty($notice_api_url) && !filter_var($notice_api_url, FILTER_VALIDATE_URL)) {
        $errors[] = 'Invalid Notice API URL format';
    }
    if (!empty($popup_notice_api_url) && !filter_var($popup_notice_api_url, FILTER_VALIDATE_URL)) {
        $errors[] = 'Invalid Popup Notice API URL format';
    }
    
    if (empty($errors)) {
        $urls = [
            'license_api_url' => $license_api_url,
            'notice_api_url' => $notice_api_url,
            'popup_notice_api_url' => $popup_notice_api_url
        ];
        
        if ($api_encryption->saveApiUrls($urls)) {
            // Get the encrypted values to show user
            $encrypted_license = $api_encryption->encrypt($license_api_url);
            $encrypted_notice = $api_encryption->encrypt($notice_api_url);
            $encrypted_popup = $api_encryption->encrypt($popup_notice_api_url);
            
            $result = [
                'success' => true, 
                'message' => 'All API URLs encrypted and saved successfully!',
                'encrypted' => [
                    'license_api_url' => $encrypted_license,
                    'notice_api_url' => $encrypted_notice,
                    'popup_notice_api_url' => $encrypted_popup
                ],
                'urls' => $urls
            ];
            
            // Reload current URLs to show updated values
            $current_urls = $api_encryption->loadApiUrls();
        } else {
            $result = ['success' => false, 'message' => 'Failed to save API URLs. Check file permissions.'];
        }
    } else {
        $result = ['success' => false, 'errors' => $errors];
    }
}

$smarty->assign('current_urls', $current_urls);
$smarty->assign('result', $result);
$smarty->assign('post_data', $_POST);
$smarty->assign('api_logs_active', 'active');
$smarty->assign('is_locked', $is_locked);
$smarty->display("api-logs.tpl");
