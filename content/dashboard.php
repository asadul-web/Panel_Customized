<?php
// ✅ FIX: Ensure functions.php is loaded before calling chkSession
if (!function_exists('chkSession')) {
    require_once __DIR__ . '/../includes/functions.php';
}
chkSession();

// ✅ PERFORMANCE FIX: Use license_check from chkSession() instead of calling chkLicense() again
// chkSession() already calls chkLicense() and assigns it to $smarty as 'license_check'
// Just reuse that value to avoid duplicate API calls
$license_info = $smarty->getTemplateVars('license_check');
if (empty($license_info)) {
    // Fallback: read from cache file if not set (for non-admin users)
    $license_cache_file = dirname(__DIR__) . DIRECTORY_SEPARATOR . 'includes' . DIRECTORY_SEPARATOR . 'backup' . DIRECTORY_SEPARATOR . 'license_check_cache.json';
    if (file_exists($license_cache_file)) {
        $license_info = json_decode(@file_get_contents($license_cache_file), true);
    }
}
$smarty->assign('license_info', $license_info);

// Initialize variables
$download = array();
$download2 = array();

#Reseller (optimized with COUNT)
$reseller_result = $db->sql_query("SELECT COUNT(*) as count FROM users WHERE is_groupname='reseller' AND user_id!='".$user_id_2."'");
$reseller_row = $db->sql_fetchrow($reseller_result);
$reseller = $reseller_row['count'] ?? 0;
$smarty->assign("reseller", $reseller);

$reseller_result2 = $db->sql_query("SELECT COUNT(*) as count FROM users WHERE is_groupname='reseller' AND user_id!='".$user_id_2."' AND upline='".$user_id_2."'");
$reseller_row2 = $db->sql_fetchrow($reseller_result2);
$reseller_ = $reseller_row2['count'] ?? 0;
$smarty->assign("reseller_", $reseller_);

if (!empty($user)) {
    $decrypted = $db->decrypt_key($user);
    if (!empty($decrypted)) {
        $read_cookie = explode("|", $decrypted);
        if (count($read_cookie) >= 3) {
            $userdata = $db->sql_query("SELECT * FROM users WHERE user_name='" . $db->Sanitize($read_cookie[1]) . "' AND user_pass='" . $db->Sanitize($read_cookie[2]) . "'");
        } else {
            $read_cookie = array('', '', '');
            $userdata = null;
        }
    } else {
        $read_cookie = array('', '', '');
        $userdata = null;
    }
} else {
    $read_cookie = array('', '', '');
    $userdata = null;
}
$user_row = $userdata ? $db->sql_fetchrow($userdata) : null;
if ($user_row === null || $user_row === false) {
    $user_row = array(
        'user_id' => '', 'user_name' => '', 'credits' => 0, 'user_level' => 'user',
        'duration' => 0, 'vip_duration' => 0, 'private_duration' => 0
    );
}

//List Of Notices (limit to last 10 for performance)
$query = $db->sql_query("SELECT * FROM download ORDER BY download_date DESC LIMIT 10");
while($download_row = $db->sql_fetchrow($query)){
	$id = $download_row['id'];
	$title = nl2br($download_row['download_title']);
	$msg = nl2br($download_row['download_msg']);
	$network = $download_row['download_network'];
	$dt = date("F d, Y h:i:s", strtotime($download_row['download_date']));
	$file = $db->base_url() . '_uploads/'.$download_row['download_file'];
	if($download_row['download_file'] == ""){
		$DLfiles = "";
	}else{
		$DLfiles = "<a class='text-white' href='".$file."'>Click Here to DOWNLOAD</a>";
	}

	// Initialize variables
	$ico = '';
	$ttl = '';
	$icon = 'mdi mdi-help';

	if($download_row['download_network'] == 'NOTICE'){
	    $ico = 'icon-success';
	    $ttl = 'text-success';
	}else
	if($download_row['download_network'] == 'UPDATE'){
	    $ico = 'icon-primary';
	    $ttl = 'text-primary';
	}

	if($download_row['download_device'] == 'ANDROID'){
	    $icon = 'mdi mdi-android';
	}else
	if($download_row['download_device'] == 'IOS'){
	    $icon = 'mdi mdi-apple';
	}else
	if($download_row['download_device'] == 'WINDOWS'){
	    $icon = 'mdi mdi-windows';
	}else
	if($download_row['download_device'] == 'CONFIG'){
	    $icon = 'mdi mdi-folder-network-outline';
	}else
	if($download_row['download_device'] == 'OTHERS'){
	    $icon = 'mdi mdi-shield-check';
	}

	$download[]  = '<i class="'.$icon.' '.$ico.'"></i>';
	$download[] .= '<div class="time-item">';
	$download[] .= '<div class="item-info">';
	$download[] .= '<div class="d-flex justify-content-between align-items-center">';
	$download[] .= '<h6 class="m-0 '.$ttl.'">'.$title.'</h6>';
	$download[] .= '<span class="text-muted">'.$dt.'</span>';
	$download[] .= '</div>';

	$download[] .= '<p class="text-muted mt-3">';
	$download[] .= ''.$msg.'';
	$download[] .= '</p>';

    $download[] .= '<div>';
    $download[] .= '<span class="badge badge-soft-secondary text-secondary">'.$DLfiles.'</span>';
    $download[] .= '</div>';
    $download[] .= '</div>';
    $download[] .= '</div>';

    $download2[]  = '<div class="d-flex justify-content-between align-items-start align-items-sm-center mb-4 flex-column flex-sm-row">';
    $download2[]  = '<div class="left d-flex ">';
    $download2[]  = '<div class="icon icon-lg shadow mr-3 text-gray"><i class="fab fa-dropbox"></i></div>';
    $download2[]  = '<div class="text">';
    $download2[]  = '<h6 class="mb-0 d-flex align-items-center"> <span>'.$title.'</span>&nbsp<span class="small">['.$dt.']</span></h6><small class="text-gray">'.$msg.'</small>';
    $download2[]  = '<p>';
    $download2[] .= '<span class="badge badge-primary">'.$DLfiles.'</span>';
    $download2[] .= '</p>';
    $download2[]  = '</div>';
    $download2[]  = '</div>';
    $download2[]  = '</div>';
}

$smarty->assign('download', $download);
$smarty->assign('download2', $download2);

$qry = $db->sql_query("SELECT maintenance_status FROM site_options WHERE id='1'") OR die();
$maintenance_row = $db->sql_fetchrow($qry);
// ✅ FIX: Initialize array if null/false
if ($maintenance_row === null || $maintenance_row === false) {
    $maintenance_row = array('maintenance_status' => '0');
}
$maintenance = $maintenance_row['maintenance_status'] ?? '0';

// Load Notice API data - ONLY for admin accounts
$notice_data = null;
$notice_html = '';
$is_admin = ($user_id_2 == '1' || $user_level_2 == 'superadmin' || $user_level_2 == 'administrator');

if ($is_admin) {
    // Read notice directly from JSON file
    $notice_file = dirname(__DIR__) . '/includes/backup/notice.json';
    if (file_exists($notice_file)) {
        $notice_data = json_decode(@file_get_contents($notice_file), true);
        
        if ($notice_data && isset($notice_data['active']) && $notice_data['active']) {
            // Always use green background for notice
            $alert_class = 'alert-success';
            
            $notice_html .= '<div class="alert ' . $alert_class . '" role="alert">';
            $notice_html .= '<strong><i class="fas fa-bullhorn"></i> ' . htmlspecialchars($notice_data['title'], ENT_QUOTES, 'UTF-8') . '</strong><br>';
            $notice_html .= $notice_data['message'];
            $notice_html .= '</div>';
        }
    }
}

// Fallback to maintenance notice if no API notice - ONLY for admin
$mainte = '';
if ($is_admin && empty($notice_html) && $maintenance == '1'){
    $mainte .= '<div class="alert alert-warning" role="alert">';
    $mainte .= '    <marquee>';
    $mainte .= '        <strong><i class="fas fa-bullhorn"></i> NOTICE</strong> : We are conducting a maintenance we&#39;re doing our best to improve our service, vpn connections might be interrupted at any moment please inform your clients. Thank you ! </marquee>';
    $mainte .= '</div>';
}

// Use notice API if available, otherwise use maintenance (ADMIN ONLY)
$smarty->assign('mainte', !empty($notice_html) ? $notice_html : $mainte);
$smarty->assign('dashboard_active', 'active');
$smarty->assign('notice_api_proxy', $db->base_url() . 'serverside/data/notice_proxy.php');

$smarty->display("dashboard.tpl");
?>
