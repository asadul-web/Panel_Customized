<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

    //Get Total Resellers (optimized with COUNT)
    if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
        $qry_reseller = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level='reseller'");
    }else{
        $qry_reseller = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level='reseller' AND user_id!='$user_id_2' AND upline='$user_id_2'");
    }
	$reseller_row = $db->sql_fetchrow($qry_reseller);
	$reseller = $reseller_row['total'];
	
	//Get Total Users (optimized with COUNT)
	if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
        $qry_user = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level IN ('normal','bulk','trial')");
	}else{
	    $qry_user = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level IN ('normal','bulk','trial') AND user_id!='$user_id_2' AND upline='$user_id_2'");
	}
	$user_row = $db->sql_fetchrow($qry_user);
	$user = $user_row['total'];
	
	//Get Total Normal (optimized with COUNT)
	if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
        $qry_normal = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level='normal'");
	}else{
	    $qry_normal = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level='normal' AND user_id!='$user_id_2' AND upline='$user_id_2'");
	}
	$normal_row = $db->sql_fetchrow($qry_normal);
	$normal = $normal_row['total'];
	
	//Get Total Bulk (optimized with COUNT)
	if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
        $qry_bulk = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level='bulk'");
	}else{
	    $qry_bulk = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level='bulk' AND user_id!='$user_id_2' AND upline='$user_id_2'");
	}
	$bulk_row = $db->sql_fetchrow($qry_bulk);
	$bulk = $bulk_row['total'];
	
	//Get Total Trial (optimized with COUNT)
	if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
        $qry_trial = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level='trial'");
	}else{
	    $qry_trial = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level='trial' AND user_id!='$user_id_2' AND upline='$user_id_2'");
	}
	$trial_row = $db->sql_fetchrow($qry_trial);
	$trial = $trial_row['total'];
	
	//Get Total Server (optimized with COUNT)
    $q_server = $db->sql_query("SELECT COUNT(*) as total FROM server_list");
	$server_row = $db->sql_fetchrow($q_server);
	$servercount = $server_row['total'];
	
	if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
    	if($servercount > '0'){
    	    //Get Total Online from all active servers
            $qry_online = $db->sql_query("SELECT COALESCE(SUM(online),0) as total_online FROM server_list WHERE status='1'");
        	$online_row = $db->sql_fetchrow($qry_online);
    	    $online = $online_row['total_online'] ?? 0;
    	}else{
    	    $online = '0';
    	}
	}else{
        $qry_online = $db->sql_query("SELECT COUNT(*) as total FROM users WHERE user_level IN ('normal', 'bulk', 'trial') AND active_address!='' AND user_id!='$user_id_2' AND upline='$user_id_2'");
        $online_row = $db->sql_fetchrow($qry_online);
        $online = $online_row['total'];
	}
	
	//Get Account Info - optimized with specific columns
	$qry_info = $db->sql_query("SELECT user_name, upline, credits FROM users WHERE user_id='".$user_id_2."'");
	$info_row = $db->sql_fetchrow($qry_info);	
	$my_username = $info_row['user_name'];
	$upline = $info_row['upline'];
	$my_credits = $info_row['credits'];
	
	//Get Upline Name
	$qry_info2 = $db->sql_query("SELECT user_name FROM users WHERE user_id='".$upline."'");
	$info2_row = $db->sql_fetchrow($qry_info2);
	$my_upline = isset($info2_row['user_name']) ? $info2_row['user_name'] : 'N/A';
	
	if($user_id_2 == 1){
	    $credits = '∞';
	}else{
	    $credits = $my_credits;
	}
	
	//Get Activities
	$activity = ''; // Initialize activity variable
    $qry_activity = $db->sql_query("SELECT date, device_os, action FROM activity_logs WHERE user_id='$user_id_2' ORDER BY date DESC LIMIT 10");
	while($activity_row = $db->sql_fetchrow($qry_activity)){
    	$activity_ = $activity_row['action'];
    	$date_ = $activity_row['date'];
    	$deviceos = $activity_row['device_os'];
    	$logs_date = strtotime($date_);
    	$elapse = $db->time_elapsed_string($logs_date);
    	
    	$pos_login = 'Login';
    	$pos_added_user = 'Added new user';
    	$pos_blocked = 'blocked';
    	$pos_unblocked = 'unblocked';
    	$pos_deleted = 'deleted';
    	$pos_device = 'device';
    	$pos_extended = 'Extended';
    	$pos_credit = 'credits';
    	$pos_password = 'password';
    	
    	$strpost_login = strpos($activity_, $pos_login);
    	$strpost_added_user = strpos($activity_, $pos_added_user);
    	$strpost_blocked = strpos($activity_, $pos_blocked);
    	$strpost_unblocked = strpos($activity_, $pos_unblocked);
    	$strpost_deleted = strpos($activity_, $pos_deleted);
    	$strpost_device = strpos($activity_, $pos_device);
    	$strpost_extended = strpos($activity_, $pos_extended);
    	$strpost_credit = strpos($activity_, $pos_credit);
    	$strpost_password = strpos($activity_, $pos_password);
    	
    	if ($strpost_login !== false && $strpost_added_user == false && $strpost_blocked == false && $strpost_unblocked == false && $strpost_deleted == false && $strpost_device == false && $strpost_extended == false && $strpost_credit == false && $strpost_password == false) {
            $imgz = 'fas fa-sign-out-alt';
        }
        else if ($strpost_login == false && $strpost_added_user !== false && $strpost_blocked == false && $strpost_unblocked == false && $strpost_deleted == false && $strpost_device == false && $strpost_extended == false && $strpost_credit == false && $strpost_password == false) {
            $imgz = 'fas fa-user-plus';
        }
        else if ($strpost_login == false && $strpost_added_user == false && $strpost_blocked !== false && $strpost_unblocked == false && $strpost_deleted == false && $strpost_device == false && $strpost_extended == false && $strpost_credit == false && $strpost_password == false) {
            $imgz = 'fas fa-lock';
        }
        else if ($strpost_login == false && $strpost_added_user == false && $strpost_blocked == false && $strpost_unblocked !== false && $strpost_deleted == false && $strpost_device == false && $strpost_extended == false && $strpost_credit == false && $strpost_password == false) {
            $imgz = 'fas fa-unlock';
        }
        else if ($strpost_login == false && $strpost_added_user == false && $strpost_blocked == false && $strpost_unblocked == false && $strpost_deleted !== false && $strpost_device == false && $strpost_extended == false && $strpost_credit == false && $strpost_password == false) {
            $imgz = 'fas fa-user-times';
        }
        else if ($strpost_login == false && $strpost_added_user == false && $strpost_blocked == false && $strpost_unblocked == false && $strpost_deleted == false && $strpost_device !== false && $strpost_extended == false && $strpost_credit == false && $strpost_password == false) {
            $imgz = 'fas fa-mobile';
        }
        else if ($strpost_login == false && $strpost_added_user == false && $strpost_blocked == false && $strpost_unblocked == false && $strpost_deleted == false && $strpost_device == false && $strpost_extended !== false && $strpost_credit == false && $strpost_password == false) {
            $imgz = 'fas fa-user-clock';
        }
        else if ($strpost_login == false && $strpost_added_user == false && $strpost_blocked == false && $strpost_unblocked == false && $strpost_deleted == false && $strpost_device == false && $strpost_extended == false && $strpost_credit !== false && $strpost_password == false) {
            $imgz = 'fas fa-coins';
        }
        else if ($strpost_login == false && $strpost_added_user == false && $strpost_blocked == false && $strpost_unblocked == false && $strpost_deleted == false && $strpost_device == false && $strpost_extended == false && $strpost_credit == false && $strpost_password !== false) {
            $imgz = 'fas fa-user-lock';
        }
        else {
            $imgz = 'fas fa-list-alt';
        }
    	
    	$activity .= '<li class="media">';
        $activity .= '              <div class="activitys-icon bg-primary text-white shadow-primary"><i class="'.$imgz.'" aria-hidden="true"></i></div>';
        $activity .= '              <div class="media-body">';
        $activity .= '                <div class="float-right text-primary text-small">'.$elapse.'</div>';
        $activity .= '                <div class="media-title text-small">'.$deviceos.'</div>';
        $activity .= '                <span class="text-small text-muted">'.$activity_.'</span>';
        $activity .= '              </div>';
        $activity .= '            </li>';
    	
    	
	}
	
	//Get Servers
	$servers = []; // Initialize array to prevent undefined variable error
    $qry_server = $db->sql_query("SELECT server_name, flag FROM server_list ORDER BY server_id DESC LIMIT 5");
	while($server_row = $db->sql_fetchrow($qry_server)){
    	$server_name = $server_row['server_name'];
    	$server_flag = $server_row['flag'];
    	$servers[] = '<li class="list-group-item d-flex justify-content-between align-items-center">'.$server_name.'<span class="flag-icon"><img src="https://flagcdn.com/'.strtolower($server_flag).'.svg" width="35" height="25" alt="flagicon"></span></li>';
	}
	
	//Get Panel Duration - OPTIMIZED with caching and timeout
	$cache_file = '../../cache/license_cache.json';
    $cache_time = 3600; // 1 hour cache
    
    $apiData = null;
    $statusCode = null;
    $MSG = '';
    
    // Check if cache exists and is fresh
    if(file_exists($cache_file) && (time() - filemtime($cache_file) < $cache_time)){
        $cached_data = file_get_contents($cache_file);
        $apiData = json_decode($cached_data, true);
        $statusCode = isset($apiData['status']) ? $apiData['status'] : null;
        $MSG = isset($apiData['msg']) ? $apiData['msg'] : '';
    }else{
        // Fetch from API with timeout
        $apiLink2 = $chk2;
        $api_02 = $db->decrypt_key($apiLink2);
        $linkapi2 = $db->encryptor('decrypt', $api_02);
        $lic = '&code='.$site_license;
        $apiURL = $linkapi2.$lic;
        
        $curl = curl_init($apiURL);
        curl_setopt($curl, CURLOPT_URL, $apiURL);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_TIMEOUT, 3); // 3 second timeout
        curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 2); // 2 second connection timeout
        
        $resp = curl_exec($curl);
        $curl_error = curl_error($curl);
        curl_close($curl);
        
        if($resp && empty($curl_error)){
            $apiData = json_decode($resp, true);
            $statusCode = isset($apiData['status']) ? $apiData['status'] : null;
            $MSG = isset($apiData['msg']) ? $apiData['msg'] : '';
            
            // Save to cache
            @file_put_contents($cache_file, $resp);
        }
    }
	
	//Domain Status - OPTIMIZED with caching and timeout
	$domin = get_domain($_SERVER['SERVER_NAME']);
	if(empty($domain_created) && empty($domain_expired)){
	
    	$whois_cache_file = '../../cache/whois_cache.json';
        $whois_cache_time = 86400; // 24 hour cache for WHOIS
        
        // Check if WHOIS cache exists and is fresh
        if(file_exists($whois_cache_file) && (time() - filemtime($whois_cache_file) < $whois_cache_time)){
            $cached_whois = file_get_contents($whois_cache_file);
            $response = json_decode($cached_whois, true);
            $created_ = isset($response['result']['creation_date']) ? $response['result']['creation_date'] : '';
            $expired_ = isset($response['result']['expiration_date']) ? $response['result']['expiration_date'] : '';
        }else{
            // Fetch from WHOIS API with timeout
            $whois_api = $site_whois;
            $domin = get_domain($_SERVER['SERVER_NAME']);
            
            $curl = curl_init();
        
            curl_setopt_array($curl, array(
              CURLOPT_URL => "https://api.apilayer.com/whois/query?domain=$domin",
              CURLOPT_HTTPHEADER => array(
                "Content-Type: text/plain",
                "apikey: $whois_api"
              ),
              CURLOPT_RETURNTRANSFER => true,
              CURLOPT_ENCODING => "",
              CURLOPT_MAXREDIRS => 10,
              CURLOPT_TIMEOUT => 5, // 5 second timeout
              CURLOPT_CONNECTTIMEOUT => 3, // 3 second connection timeout
              CURLOPT_FOLLOWLOCATION => true,
              CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
              CURLOPT_CUSTOMREQUEST => "GET"
            ));
            
            $content = curl_exec($curl);
            $curl_error = curl_error($curl);
            curl_close($curl);
            
            if($content && empty($curl_error)){
                $response = json_decode($content,true);
                // Save to cache
                @file_put_contents($whois_cache_file, $content);
            }else{
                $response = array();
            }
            
            $created_ = isset($response['result']['creation_date']) ? $response['result']['creation_date'] : '';
            $expired_ = isset($response['result']['expiration_date']) ? $response['result']['expiration_date'] : '';
        }
	    
	    // Note: domain_created and domain_expired columns don't exist in site_options table
	    // Store in variables only, don't update database
	    $created = $created_;
	    $expired = $expired_;
	}else{
        
        $currentDate = date('Y-m-d h:m:s');
        
        if($currentDate > $domain_expired){ 
            // Domain expired, clear values
            $created = '';
    	    $expired = '';
        }else{
            $created = $domain_created;
    	    $expired = $domain_expired;
        }
	}
	
	// Initialize date variables
	$created_date = '';
	$expired_date = '';
	if(!empty($created)){
	    $mycreated = strtotime($created);
        $created_date = date('F d, Y \a\t h:m:s A', $mycreated);
    }
    if(!empty($expired)){
        $myexpired= strtotime($expired);
        $expired_date = date('F d, Y \a\t h:m:s A', $myexpired);
    }
    
    
	$values = array();
	$valid = true;
    
	if($row){
	    
	    if($statusCode === 1){
	        
	        $dur = $db->calc_time($MSG);
	        $nday = $dur['days'];
	        $nhour = $dur['hours'];
	        $nminute = $dur['minutes'];
	        
	        if($nday > 1){
	            $dday = 'Days';
	        }else{
	            $dday = 'Day';
	        }
	        
	        if($nhour > 1){
	            $dhour = 'Hours';
	        }else{
	            $dhour = 'Hour';
	        }
	        
	        if($nminute > 1){
	            $dminute = 'Minutes';
	        }else{
	            $dminute = 'Minute';
	        }
	        
	        $duration = $nday.' '.$dday.', '.$nhour.' '.$dhour.' & '.$nminute.' '.$dminute.' Left';
	        
    		$values['licdur'] = $duration;
        }elseif($statusCode === 2){
            $values['licdur'] = $MSG;
        }elseif($statusCode === 3){
            $values['licdur'] = $MSG;
        }
	    
		$values['reseller'] = $reseller;
		$values['user'] = $user;
		$values['normal'] = $normal;
		$values['trial'] = $trial;
		$values['bulk'] = $bulk;
		$values['online'] = $online;
		$values['servercount'] = $servercount;
		$values['profile_username'] = $my_username;
		$values['profile_upline'] = $my_upline;
		$values['profile_credits'] = $credits;
		$values['activity'] = $activity;
		$values['servers'] = $servers;
		
		$values['domain_name'] = $domin;
		$values['domain_created'] = $created_date;
		$values['domain_expired'] = $expired_date;
		$values['response'] = 1;
	}else{
		$values['response'] = 2;
	}
	if($valid == false){
		$values['response'] = 0;
	}
	echo json_encode($values);
?>