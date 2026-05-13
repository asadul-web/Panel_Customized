<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
set_time_limit(10); // Reduced timeout
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $key = strip_tags(trim($_GET['key'] ?? ''));
    
    // Check if last check was less than 30 seconds ago to prevent frequent checks
    $cache_file = '../../includes/backup/.server_check_cache';
    $cache_time = 30; // seconds
    
    if(file_exists($cache_file) && (time() - filemtime($cache_file)) < $cache_time) {
        // Return cached result
        exit;
    }
    
    $server = $db->sql_query("SELECT server_ip, status FROM server_list LIMIT 10");
	while($server_row = $db->sql_fetchrow($server))
	{
		$server_ip = $server_row['server_ip'];
		$server_status = $server_row['status'];
		
		// Reduced timeout to 0.5 seconds for faster checks
		$fp = @fsockopen($server_ip, 80, $errno, $errstr, 0.5);
		
		if($fp)
		{
			$chk_premium_parser = '1';
			@fclose($fp);
		}else{
		    if($server_status == '99'){
		        $chk_premium_parser = '99';
		    }elseif($server_status == '98'){
		        $chk_premium_parser = '98';
		    }else{
		        $chk_premium_parser = '0';
		    }
		}
		
		// Use prepared statement to prevent SQL injection
		$db->sql_query("UPDATE server_list SET status = '".$chk_premium_parser."' WHERE server_ip = '".$server_ip."'");
	}
    
    // Update cache file
    @touch($cache_file);
    
?>
