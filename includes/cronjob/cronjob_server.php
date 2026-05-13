<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
require_once 'config.php';
$ip = $db->get_client_ip();
if($db->get_client_ip() == 'UNKNOWN'){
	$premium = $db->sql_query("SELECT * FROM server_list ORDER BY server_name ASC");
	while($premium_row= $db->sql_fetchrow($premium ))
	{
		$server_ip = $premium_row['server_ip'];
		$servers = @fsockopen($server_ip, 22, $errno, $errstr, 2);
		if(!$servers)
		{
			$chk_premium_parser = '0';
		}else{
			$chk_premium_parser = '1';
		}
		$db->sql_query("UPDATE server_list SET status = '".$chk_premium_parser."' WHERE server_ip = '".$server_ip."'");
	}
	
}else{
	echo '<script> alert("You are a Mother Fucker! Damn shit!... Your IP Address: '.$ip.'");
	window.location.href="http://www.google.com"; </script>';
}
?>