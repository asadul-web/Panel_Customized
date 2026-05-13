<?php
// Create Email Template - Full Page Editor
require_once './includes/functions.php';

// Check if user is logged in and has proper permissions
if(!isset($user) || !is_logged_in($user)) {
    header("Location: /login");
    exit;
}

if(!isset($user_level_2) || ($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator')) {
    header("Location: /dashboard");
    exit;
}

// Get template ID if editing
$template_id = isset($_GET['id']) ? intval($_GET['id']) : 0;
$is_editing = $template_id > 0;
$template_data = null;

if($is_editing) {
    // Get template data for editing
    $query = "SELECT * FROM email_templates WHERE id = $template_id";
    $result = $db->sql_query($query);
    if($result && $db->sql_numrows($result) > 0) {
        $template_data = $db->sql_fetchrow($result);
    } else {
        header("Location: /email-templates");
        exit;
    }
}

// Assign variables to Smarty
$smarty->assign('site_name', $site_name);
$smarty->assign('site_logo', $site_logo);
$smarty->assign('site_theme', $site_theme);
$smarty->assign('user', $user);
$smarty->assign('is_editing', $is_editing);
$smarty->assign('template_data', $template_data);

// Display the template
$smarty->display('create-email-template.tpl');
?>
