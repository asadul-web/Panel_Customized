<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
require_once 'config.php';
$ip = $db->get_client_ip();
if($db->get_client_ip() == 'UNKNOWN')
{
    //Durations every 5min (300sec = 5min)
	$db->sql_query("UPDATE users SET user_2fa_duration=user_2fa_duration -60");
	
	//Check if negative values reason of -900
	//And Removal value to false is_vip and is_private 
	$db->sql_query("UPDATE users SET user_2fa_duration=0 WHERE user_2fa_duration < 1");
}else{
	echo '<script> alert("You are a Mother Fucker! Damn shit!... Your IP Address: '.$ip.'"); window.location.href="http://www.google.com"; </script>';
}
?>

