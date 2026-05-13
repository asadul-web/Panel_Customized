<?php
// Info Edit page with full content management features
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');

// Check if user is logged in
if(!isset($user) || empty($user) || !is_logged_in($user)) {
    $db->RedirectToURL($db->base_url().'login');
    exit;
}

// Check if user has admin permissions for content management
$is_admin = ($user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'administrator');

// Get page content from database or set defaults
$page_content = array();
try {
    $content_query = "SELECT * FROM page_content WHERE page_name = 'info-edit' ORDER BY section_order ASC";
    $content_result = $db->sql_query($content_query);
    
    if($content_result) {
        while($content = $db->sql_fetchrow($content_result)) {
            $page_content[] = $content;
        }
    }
} catch(Exception $e) {
    // If table doesn't exist, create default content with comprehensive sections
    $page_content = array(
        array('id' => 1, 'section_name' => 'hero_title', 'section_content' => 'Info Edit & Services', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 1),
        array('id' => 2, 'section_name' => 'hero_description', 'section_content' => 'Comprehensive information about our platform and services', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 2),
        array('id' => 3, 'section_name' => 'main_description', 'section_content' => 'Discover detailed information about our platform features, service offerings, and technical specifications. Learn about our infrastructure, security measures, and support services.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 3),
        array('id' => 4, 'section_name' => 'features_title', 'section_content' => 'Platform Features', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 4),
        array('id' => 5, 'section_name' => 'features_description', 'section_content' => 'Our platform offers advanced features including real-time monitoring, automated management, comprehensive reporting, and 24/7 support services.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 5),
        array('id' => 6, 'section_name' => 'security_title', 'section_content' => 'Security', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 6),
        array('id' => 7, 'section_name' => 'security_description', 'section_content' => 'Enterprise-grade security with advanced encryption, multi-factor authentication, and continuous monitoring.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 7),
        array('id' => 8, 'section_name' => 'performance_title', 'section_content' => 'Performance', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 8),
        array('id' => 9, 'section_name' => 'performance_description', 'section_content' => 'High-performance infrastructure with optimized servers, CDN integration, and real-time monitoring.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 9),
        array('id' => 10, 'section_name' => 'support_title', 'section_content' => 'Support', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 10),
        array('id' => 11, 'section_name' => 'support_description', 'section_content' => '24/7 professional support with dedicated team, live chat, and comprehensive documentation.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 11),
        array('id' => 12, 'section_name' => 'infrastructure_title', 'section_content' => 'Infrastructure', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 12),
        array('id' => 13, 'section_name' => 'infrastructure_description', 'section_content' => 'Our robust infrastructure includes multiple data centers, redundant systems, and automated failover capabilities to ensure maximum uptime and reliability.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 13),
        array('id' => 14, 'section_name' => 'management_title', 'section_content' => 'Management Tools', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 14),
        array('id' => 15, 'section_name' => 'management_description', 'section_content' => 'Comprehensive management tools provide complete control over your services with intuitive interfaces and powerful automation capabilities.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 15)
    );
}

// Get slider content from database or set defaults
$slider_texts = array();
try {
    $slider_query = "SELECT * FROM slider_content WHERE page_name = 'info-edit' AND is_active = 1 ORDER BY display_order ASC";
    $slider_result = $db->sql_query($slider_query);
    
    if($slider_result) {
        while($slider = $db->sql_fetchrow($slider_result)) {
            $slider_texts[] = $slider;
        }
    }
} catch(Exception $e) {
    // If table doesn't exist, create default slider content
    $slider_texts = array(
        array('id' => 0, 'text_content' => '🚀 Advanced platform infrastructure'),
        array('id' => 1, 'text_content' => '🔒 Enterprise-grade security measures'),
        array('id' => 2, 'text_content' => '📊 Real-time monitoring and analytics'),
        array('id' => 3, 'text_content' => '⚡ High-performance server architecture'),
        array('id' => 4, 'text_content' => '🛠️ Comprehensive management tools'),
        array('id' => 5, 'text_content' => '📞 24/7 professional support services')
    );
}

// Set page title and meta
$smarty->assign('page_title', 'Info Edit');
$smarty->assign('page_description', 'Comprehensive Info Edit and platform details');

// Set navigation active states
$smarty->assign('info_manage_active', 'active');
$smarty->assign('site_info_active', 'active');

// Helper function to get package content
function get_package_content($page_content, $section_name, $default_content = "") {
    if (is_array($page_content)) {
        foreach ($page_content as $content) {
            if (isset($content["section_name"]) && $content["section_name"] == $section_name && 
                isset($content["is_active"]) && $content["is_active"]) {
                return $content["section_content"];
            }
        }
    }
    return $default_content;
}

// Assign variables to template
$smarty->assign('page_content', $page_content);
$smarty->assign('slider_texts', $slider_texts);
$smarty->assign('user_level_2', $user_level_2);
$smarty->assign('is_admin', $is_admin);

// Add encryption key for form security
$smarty->assign('firenet_encrypt', $db->encryptor('encrypt', 'firenetdev'));

// Display the template
$smarty->display('site-info.tpl');
?>

