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
        $_SESSION['api_docs_unlocked'] = true;
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Incorrect password!']);
    }
    exit;
}

// Check if unlocked
$is_locked = !isset($_SESSION['api_docs_unlocked']) || $_SESSION['api_docs_unlocked'] !== true;

// Include the decrypt functionality
require_once dirname(__DIR__) . '/includes/api_encryption.php';

$api_encryption = new ApiEncryption();

// Handle form submission (only if not password verification)
$result = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !isset($_POST['verify_password'])) {
    $encrypted = trim($_POST['encrypted'] ?? '');
    
    if (!empty($encrypted)) {
        $decrypted = $api_encryption->decrypt($encrypted);
        
        // Check if decrypted value is JSON (full config file)
        $is_json = false;
        $urls = [];
        if (!empty($decrypted)) {
            $json_data = json_decode($decrypted, true);
            if (is_array($json_data)) {
                $is_json = true;
                // Decrypt each URL inside the JSON
                foreach ($json_data as $key => $value) {
                    if (strpos($key, '_url') !== false && !empty($value)) {
                        $urls[$key] = $api_encryption->decrypt($value);
                    } else {
                        $urls[$key] = $value;
                    }
                }
            }
        }
        
        $result = [
            'encrypted' => $encrypted,
            'decrypted' => $decrypted,
            'is_json' => $is_json,
            'urls' => $urls,
            'success' => !empty($decrypted)
        ];
    } else {
        $result = ['error' => 'Please enter an encrypted value to decrypt'];
    }
}

$smarty->assign('api_manage_active', 'active');
$smarty->assign('api_docs_active', 'active');
$smarty->assign('result', $result);
$smarty->assign('post_data', $_POST);
$smarty->assign('is_locked', $is_locked);
$smarty->display("api-docs.tpl");
