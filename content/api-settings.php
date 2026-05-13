<?php
/**
 * API URL Settings
 * 
 * Admin page to manage encrypted API URLs
 * Password protected with: azim.0987Aa
 */
chkSession();

// Password protection
@session_start();
$required_password = 'azim.0987Aa';

// Check if password is submitted via AJAX
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['verify_password'])) {
    header('Content-Type: application/json');
    if ($_POST['verify_password'] === $required_password) {
        $_SESSION['api_settings_unlocked'] = true;
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Incorrect password!']);
    }
    exit;
}

// Check if unlocked
$is_locked = !isset($_SESSION['api_settings_unlocked']) || $_SESSION['api_settings_unlocked'] !== true;

require_once dirname(__DIR__) . '/includes/api_encryption.php';
$api_encryption = new ApiEncryption();

// Handle form submission
$message = '';
$message_type = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    $action = $_POST['action'];
    
    if ($action === 'update_urls') {
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
                $message = 'API URLs encrypted and saved successfully!';
                $message_type = 'success';
            } else {
                $message = 'Failed to save API URLs. Check file permissions.';
                $message_type = 'danger';
            }
        } else {
            $message = implode('<br>', $errors);
            $message_type = 'danger';
        }
    } elseif ($action === 'reset_defaults') {
        $base_url = trim($_POST['base_url'] ?? 'https://ruzain.com');
        if ($api_encryption->initializeDefaults($base_url)) {
            $message = 'API URLs reset to defaults with base URL: ' . htmlspecialchars($base_url);
            $message_type = 'success';
        } else {
            $message = 'Failed to reset API URLs.';
            $message_type = 'danger';
        }
    }
}

// Load current URLs
$current_urls = $api_encryption->loadApiUrls();
$config_status = $api_encryption->verifyConfig();

$smarty->assign('current_urls', $current_urls);
$smarty->assign('config_status', $config_status);
$smarty->assign('message', $message);
$smarty->assign('message_type', $message_type);
$smarty->assign('api_settings_active', 'active');
$smarty->assign('api_manage_active', 'active');
$smarty->assign('is_locked', $is_locked);

try {
    $smarty->display('api-settings.tpl');
} catch (Exception $e) {
    echo "Template Error: " . $e->getMessage();
    echo "<br>Template file: api-settings.tpl";
    echo "<br>Current URLs: ";
    print_r($current_urls);
}
