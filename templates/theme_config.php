<?php
/**
 * Theme Configuration File
 * This file contains theme-related configurations and settings
 */

// Prevent direct access
if (preg_match("/theme_config.php/i", $_SERVER['SCRIPT_NAME'])) {
    Header("Location: /"); die();
}

// Default theme settings
$default_theme = 'default';
$available_themes = array('default', 'dark', 'light', 'blue');

// Get theme from database or use default
$theme_query = $db->sql_query("SELECT theme FROM site_options WHERE id='1'");
if ($theme_query && $db->sql_numrows($theme_query) > 0) {
    $theme_row = $db->sql_fetchrow($theme_query);
    $current_theme = !empty($theme_row['theme']) ? $theme_row['theme'] : $default_theme;
} else {
    $current_theme = $default_theme;
}

// Validate theme
if (!in_array($current_theme, $available_themes)) {
    $current_theme = $default_theme;
}

// Set Smarty template directories
$smarty->setTemplateDir(DOC_ROOT_PATH . 'templates/');
$smarty->setCompileDir(DOC_ROOT_PATH . 'templates_c/');
$smarty->setCacheDir(DOC_ROOT_PATH . 'cache/');

// Assign theme variables to Smarty
$smarty->assign('site_theme', $current_theme);
$smarty->assign('current_theme', $current_theme);
$smarty->assign('available_themes', $available_themes);

// Site branding variables
$site_info_query = $db->sql_query("SELECT name, description, logo FROM site_options WHERE id='1'");
if ($site_info_query && $db->sql_numrows($site_info_query) > 0) {
    $site_info = $db->sql_fetchrow($site_info_query);
    $smarty->assign('site_name', $site_info['name']);
    $smarty->assign('site_description', $site_info['description']);
    $smarty->assign('site_logo', $site_info['logo']);
} else {
    // Default values if database is not accessible
    $smarty->assign('site_name', 'VPN Panel');
    $smarty->assign('site_description', 'VPN Management System');
    $smarty->assign('site_logo', '/dist/img/logo.png');
}

// Additional theme-specific configurations
switch ($current_theme) {
    case 'dark':
        $smarty->assign('theme_class', 'theme-dark');
        $smarty->assign('navbar_class', 'navbar-dark');
        break;
    case 'light':
        $smarty->assign('theme_class', 'theme-light');
        $smarty->assign('navbar_class', 'navbar-light');
        break;
    case 'blue':
        $smarty->assign('theme_class', 'theme-blue');
        $smarty->assign('navbar_class', 'navbar-blue');
        break;
    default:
        $smarty->assign('theme_class', 'theme-default');
        $smarty->assign('navbar_class', 'navbar-default');
        break;
}

// Asset versioning for cache busting
$assets_version = '1.0.0';
$smarty->assign('assets_version', $assets_version);

// Additional template variables
$smarty->assign('base_path', DOC_ROOT_PATH);
$smarty->assign('template_path', '/templates/');
$smarty->assign('dist_path', '/dist/');
?>
