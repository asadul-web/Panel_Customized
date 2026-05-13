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

	// Optimize: Only fetch recent notifications (last 10) and cache result
	$cache_file = '../../cache/notifications_cache.json';
    $cache_time = 60; // 1 minute cache
    
    if(file_exists($cache_file) && (time() - filemtime($cache_file) < $cache_time)){
        // Use cached data
        $cached = json_decode(file_get_contents($cache_file), true);
        $values = $cached;
    }else{
        // Fetch fresh data
        $sql = "SELECT id, title, filename, type, date FROM notification ORDER BY date DESC LIMIT 10";
        $qry = $db->sql_query("$sql") OR die();
        $total_notif = $db->sql_numrows($qry);
        $notifica = array();
        
        while($row = $db->sql_fetchrow($qry)){
            $id = $row['id'];
            $title = $row['title'];
            $filename = $row['filename'];
            $type = $row['type'];
            $date = $row['date'];
            $time = get_time_elapsed("$date");
    	
    	if($type == 1){
    	    $icon = '<i class="fas fa-bullhorn"></i>';
    	    $bg = 'bg-primary';
    	    $ntype = 'Info';
    	}elseif($type == 2){
    	    $icon = '<i class="fas fa-bolt"></i>';
			$bg = 'bg-danger';
			$ntype = 'Emergency';
    	}elseif($type == 3){
    	    $icon = '<i class="fas fa-exclamation-triangle"></i>';
			$bg = 'bg-warning';
			$ntype = 'Critical';
    	}
    	
    	$notifica[] = '<a href="javascript:void(0)" class="dropdown-item dropdown-item-unread view-notification" data-type="'.$ntype.'" data-date="'.$time.'" data-id="'.$id.'">
	                        <div class="dropdown-item-icon '.$bg.' text-white"> '.$icon.' </div>
	                        <div class="dropdown-item-desc"> '.$title.' <div class="time text-primary">'.$time.'</div>
	                        </div>
	                    </a>';

        }
        
        $values = array();
        $values['notifica'] = $notifica;
        $values['notiftotal'] = $total_notif;
        $values['response'] = 1;
        
        // Save to cache
        @file_put_contents($cache_file, json_encode($values));
    }
    
    echo json_encode($values);

?>
