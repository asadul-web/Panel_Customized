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
        $_SESSION['notice_api_unlocked'] = true;
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Incorrect password!']);
    }
    exit;
}

// Check if unlocked
$is_locked = !isset($_SESSION['notice_api_unlocked']) || $_SESSION['notice_api_unlocked'] !== true;

$smarty->assign('api_manage_active', 'active');
$smarty->assign('notice_api_active', 'active');
$smarty->assign('is_locked', $is_locked);
$smarty->assign('notice_api_proxy', $db->base_url() . 'serverside/data/notice_proxy.php');
$smarty->display("notice-api.tpl");
