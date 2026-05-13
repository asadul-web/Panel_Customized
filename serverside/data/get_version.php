<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    // Cache version check for 1 hour to reduce API calls
    $cache_file = '../../cache/version_cache.json';
    $cache_time = 3600; // 1 hour
    $apiResponse = '';
    
    if(file_exists($cache_file) && (time() - filemtime($cache_file) < $cache_time)){
        // Use cached data
        $apiResponse = file_get_contents($cache_file);
    }else{
        // Fetch fresh data from API
        $apiURL = $site_update;
        $ch = curl_init($apiURL); 
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5); // 5 second timeout
        $apiResponse = curl_exec($ch); 
        curl_close($ch);
        
        // Save to cache if successful
        if($apiResponse){
            @file_put_contents($cache_file, $apiResponse);
        }
    } 
                
    $apiData = json_decode($apiResponse, true); 
    $list = isset($apiData['updateList']) && is_array($apiData['updateList']) ? $apiData['updateList'] : [];
    $elementCount  = count($list);
    $update = []; // Initialize update array
    
    foreach ($list as $key => $value) {
        if(isset($value["description"])){
            $description = $value["description"];
            $update[] = '<li>'.$description.'</li>';
        }
    }
    
    if(!empty($apiData)){ 
        $values['version'] = $apiData['versionCode'];
        $values['versiontype'] = $apiData['versionType'];
        $values['versiontitle'] = $apiData['versionTitle'];
        $values['versionmsg'] = $apiData['versionMSG'];
        $values['content'] = $update;
        $values['length'] = $elementCount;
		$values['response'] = 1;
    }else{
        $values['response'] = 2;
    }
    echo json_encode($values);
?>