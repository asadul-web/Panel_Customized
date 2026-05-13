<?php
chkSession();

// Only allow admin, superadmin, developer, and reseller accounts
if (!in_array($user_level_2, ['administrator', 'superadmin', 'developer', 'reseller'])) {
    header("Location: /dashboard");
    exit;
}

// Check if api_key column exists, if not show setup instructions
$check_column = $db->sql_query("SHOW COLUMNS FROM users LIKE 'api_key'");
$column_exists = ($db->sql_numrows($check_column) > 0);

// Handle form submissions
$message = '';
$message_type = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action == 'generate' || $action == 'regenerate') {
        if ($column_exists) {
            // Generate new API key
            $api_key = bin2hex(random_bytes(32));
            
            $update = $db->sql_query("UPDATE users SET api_key='".$db->SanitizeForSQL($api_key)."' WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
            
            if ($update) {
                $message = ($action == 'generate') ? 'API key generated successfully!' : 'API key regenerated successfully! Your old key is now invalid.';
                $message_type = 'success';
            } else {
                $message = 'Failed to generate API key. Please try again.';
                $message_type = 'error';
            }
        }
    }
}

// Get current API key
$current_api_key = '';
if ($column_exists) {
    $query = $db->sql_query("SELECT api_key FROM users WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
    $row = $db->sql_fetchrow($query);
    $current_api_key = $row['api_key'] ?? '';
}

$smarty->assign('page_title', 'API Key Manager');
$smarty->assign('column_exists', $column_exists);
$smarty->assign('current_api_key', $current_api_key);
$smarty->assign('message', $message);
$smarty->assign('message_type', $message_type);
$smarty->assign('user_name', $user_name_2);
$smarty->assign('user_level', $user_level_2);
$smarty->display('api-key-manager.tpl');
?>
