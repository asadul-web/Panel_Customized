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
    $content_query = "SELECT * FROM page_content WHERE page_name = 'site-info' ORDER BY section_order ASC";
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
        array('id' => 15, 'section_name' => 'management_description', 'section_content' => 'Comprehensive management tools provide complete control over your services with intuitive interfaces and powerful automation capabilities.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 15),
        array('id' => 16, 'section_name' => 'sim_companies_title', 'section_content' => 'Saudi Arabia SIM Companies', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 16),
        array('id' => 17, 'section_name' => 'sim_companies_description', 'section_content' => 'Choose from premium telecom services offering high-speed internet, unlimited calls, and exclusive packages. Compare FREE plans and PREMIUM packages from leading operators across the Kingdom.', 'section_type' => 'textarea', 'is_active' => 1, 'section_order' => 17),
        
        // STC Package Information
        array('id' => 18, 'section_name' => 'stc_package_type', 'section_content' => 'FREE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 18),
        array('id' => 19, 'section_name' => 'stc_package_title', 'section_content' => 'STC Free Plan', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 19),
        array('id' => 20, 'section_name' => 'stc_package_description', 'section_content' => '<strong>Free SIM activation</strong><br><em>Basic calling & SMS</em><br><span style="color: #28a745;">✓ No monthly fees</span><br><span style="color: #007bff;">✓ Pay-as-you-go</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 20),
        array('id' => 21, 'section_name' => 'stc_package_features', 'section_content' => '📞 <strong>Calls:</strong> 0.25 SAR/min<br>📱 <strong>SMS:</strong> 0.15 SAR each<br>🌐 <strong>Data:</strong> 1 SAR/MB', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 21),
        
        // Mobily Package Information
        array('id' => 22, 'section_name' => 'mobily_package_type', 'section_content' => 'PACKAGE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 22),
        array('id' => 23, 'section_name' => 'mobily_package_title', 'section_content' => 'Mobily Premium', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 23),
        array('id' => 24, 'section_name' => 'mobily_package_description', 'section_content' => '<strong>Premium monthly plan</strong><br><em>Unlimited calls & SMS</em><br><span style="color: #28a745;">✓ 50GB high-speed data</span><br><span style="color: #007bff;">✓ 5G network access</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 24),
        array('id' => 25, 'section_name' => 'mobily_package_features', 'section_content' => '💰 <strong>Price:</strong> 99 SAR/month<br>📞 <strong>Calls:</strong> Unlimited<br>🌐 <strong>Data:</strong> 50GB + unlimited 2G', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 25),
        
        // Zain Package Information
        array('id' => 26, 'section_name' => 'zain_package_type', 'section_content' => 'FREE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 26),
        array('id' => 27, 'section_name' => 'zain_package_title', 'section_content' => 'Zain Starter', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 27),
        array('id' => 28, 'section_name' => 'zain_package_description', 'section_content' => '<strong>Free SIM with credit</strong><br><em>10 SAR welcome bonus</em><br><span style="color: #28a745;">✓ Free delivery</span><br><span style="color: #007bff;">✓ Instant activation</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 28),
        array('id' => 29, 'section_name' => 'zain_package_features', 'section_content' => '🎁 <strong>Bonus:</strong> 10 SAR credit<br>📞 <strong>Calls:</strong> 0.20 SAR/min<br>🌐 <strong>Data:</strong> 0.5 SAR/MB', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 29),
        
        // Virgin Package Information
        array('id' => 30, 'section_name' => 'virgin_package_type', 'section_content' => 'PACKAGE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 30),
        array('id' => 31, 'section_name' => 'virgin_package_title', 'section_content' => 'Virgin Unlimited', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 31),
        array('id' => 32, 'section_name' => 'virgin_package_description', 'section_content' => '<strong>All-in-one package</strong><br><em>Unlimited everything</em><br><span style="color: #28a745;">✓ Unlimited calls & SMS</span><br><span style="color: #007bff;">✓ 100GB data</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 32),
        array('id' => 33, 'section_name' => 'virgin_package_features', 'section_content' => '💰 <strong>Price:</strong> 149 SAR/month<br>📞 <strong>Calls:</strong> Unlimited<br>🌐 <strong>Data:</strong> 100GB high-speed', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 33),
        
        // Lebara Package Information
        array('id' => 34, 'section_name' => 'lebara_package_type', 'section_content' => 'FREE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 34),
        array('id' => 35, 'section_name' => 'lebara_package_title', 'section_content' => 'Lebara Basic', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 35),
        array('id' => 36, 'section_name' => 'lebara_package_description', 'section_content' => '<strong>International calling</strong><br><em>Best rates worldwide</em><br><span style="color: #28a745;">✓ Free SIM delivery</span><br><span style="color: #007bff;">✓ No contracts</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 36),
        array('id' => 37, 'section_name' => 'lebara_package_features', 'section_content' => '🌍 <strong>International:</strong> From 0.05 SAR/min<br>📞 <strong>Local calls:</strong> 0.30 SAR/min<br>🌐 <strong>Data:</strong> 2 SAR/MB', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 37),
        
        // Friendi Package Information
        array('id' => 38, 'section_name' => 'friendi_package_type', 'section_content' => 'PACKAGE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 38),
        array('id' => 39, 'section_name' => 'friendi_package_title', 'section_content' => 'Friendi Smart', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 39),
        array('id' => 40, 'section_name' => 'friendi_package_description', 'section_content' => '<strong>Smart monthly plan</strong><br><em>Great value for money</em><br><span style="color: #28a745;">✓ 30GB data included</span><br><span style="color: #007bff;">✓ Free local calls</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 40),
        array('id' => 41, 'section_name' => 'friendi_package_features', 'section_content' => '💰 <strong>Price:</strong> 79 SAR/month<br>📞 <strong>Calls:</strong> Free local<br>🌐 <strong>Data:</strong> 30GB + unlimited 2G', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 41),
        
        // Red Bull Package Information
        array('id' => 42, 'section_name' => 'redbull_package_type', 'section_content' => 'FREE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 42),
        array('id' => 43, 'section_name' => 'redbull_package_title', 'section_content' => 'RedBull Energy', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 43),
        array('id' => 44, 'section_name' => 'redbull_package_description', 'section_content' => '<strong>Energy-powered SIM</strong><br><em>Free with energy drink</em><br><span style="color: #28a745;">✓ 5 SAR bonus credit</span><br><span style="color: #007bff;">✓ Special youth rates</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 44),
        array('id' => 45, 'section_name' => 'redbull_package_features', 'section_content' => '⚡ <strong>Bonus:</strong> 5 SAR credit<br>📞 <strong>Calls:</strong> 0.15 SAR/min<br>🌐 <strong>Data:</strong> 0.75 SAR/MB', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 45),
        
        // Salam Package Information
        array('id' => 46, 'section_name' => 'salam_package_type', 'section_content' => 'PACKAGE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 46),
        array('id' => 47, 'section_name' => 'salam_package_title', 'section_content' => 'Salam Family', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 47),
        array('id' => 48, 'section_name' => 'salam_package_description', 'section_content' => '<strong>Family-friendly plan</strong><br><em>Perfect for families</em><br><span style="color: #28a745;">✓ Shared data pool</span><br><span style="color: #007bff;">✓ Parental controls</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 48),
        array('id' => 49, 'section_name' => 'salam_package_features', 'section_content' => '💰 <strong>Price:</strong> 199 SAR/month<br>👨‍👩‍👧‍👦 <strong>Lines:</strong> Up to 5 lines<br>🌐 <strong>Data:</strong> 200GB shared', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 49),
        
        // Jawwy Package Information
        array('id' => 50, 'section_name' => 'jawwy_package_type', 'section_content' => 'FREE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 50),
        array('id' => 51, 'section_name' => 'jawwy_package_title', 'section_content' => 'Jawwy Digital', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 51),
        array('id' => 52, 'section_name' => 'jawwy_package_description', 'section_content' => '<strong>Digital-first experience</strong><br><em>App-based management</em><br><span style="color: #28a745;">✓ Free eSIM delivery</span><br><span style="color: #007bff;">✓ Digital wallet integration</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 52),
        array('id' => 53, 'section_name' => 'jawwy_package_features', 'section_content' => '📱 <strong>eSIM:</strong> Instant activation<br>📞 <strong>Calls:</strong> 0.18 SAR/min<br>🌐 <strong>Data:</strong> 0.8 SAR/MB', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 53),
        
        // Yaqoot Package Information
        array('id' => 54, 'section_name' => 'yaqoot_package_type', 'section_content' => 'PACKAGE', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 54),
        array('id' => 55, 'section_name' => 'yaqoot_package_title', 'section_content' => 'Yaqoot Infinity', 'section_type' => 'text', 'is_active' => 1, 'section_order' => 55),
        array('id' => 56, 'section_name' => 'yaqoot_package_description', 'section_content' => '<strong>Infinite possibilities</strong><br><em>Premium unlimited plan</em><br><span style="color: #28a745;">✓ Truly unlimited data</span><br><span style="color: #007bff;">✓ 5G+ network access</span>', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 56),
        array('id' => 57, 'section_name' => 'yaqoot_package_features', 'section_content' => '💰 <strong>Price:</strong> 299 SAR/month<br>📞 <strong>Calls:</strong> Unlimited<br>🌐 <strong>Data:</strong> Truly unlimited 5G+', 'section_type' => 'html', 'is_active' => 1, 'section_order' => 57)
    );
}

// Get slider content from database or set defaults
$slider_texts = array();
try {
    $slider_query = "SELECT * FROM slider_content WHERE page_name = 'site-info' AND is_active = 1 ORDER BY display_order ASC";
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

// Create package content array for easier template access
$package_content = array();
$companies = array('stc', 'mobily', 'zain', 'virgin', 'lebara', 'friendi', 'redbull', 'salam', 'jawwy', 'yaqoot');
foreach ($companies as $company) {
    $package_content[$company] = array(
        'type' => get_package_content($page_content, $company . '_package_type', 'FREE'),
        'title' => get_package_content($page_content, $company . '_package_title', ucfirst($company) . ' Plan'),
        'description' => get_package_content($page_content, $company . '_package_description', 'Package description'),
        'features' => get_package_content($page_content, $company . '_package_features', 'Package features')
    );
}

// Assign variables to template
$smarty->assign('page_content', $page_content);
$smarty->assign('package_content', $package_content);
$smarty->assign('slider_texts', $slider_texts);
$smarty->assign('user_level_2', $user_level_2);
$smarty->assign('is_admin', $is_admin);

// Add encryption key for form security
$smarty->assign('firenet_encrypt', $db->encryptor('encrypt', 'firenetdev'));

// Display the template
$smarty->display('site-info.tpl');
?>

