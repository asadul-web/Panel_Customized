<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
require_once 'config.php';
$ip = $db->get_client_ip();
if($db->get_client_ip() == 'UNKNOWN')
{
    //Durations every 5min (300sec = 5min)
	$db->sql_query("UPDATE users SET duration=duration -300 WHERE user_id > 1 AND user_level!='superadmin' AND is_freeze=0 AND duration > 0 AND device_connected=1");
	
	//Check if negative values reason of -900
	//And Removal value to false is_vip and is_private 
	$db->sql_query("UPDATE users SET duration=0 WHERE user_id > 1 AND user_level!='superadmin' AND is_freeze=0 AND duration < 1");
	
	//Auto delete expired
    $rup = "is_groupname!='subadmin' AND is_groupname!='reseller' AND is_groupname!='subreseller' AND is_groupname!='administrator' AND is_groupname!='superadmin' AND is_groupname!='developer'";
	$rquery = $db->sql_query("SELECT * FROM users WHERE user_id!=1 AND user_level!='superadmin' AND  duration<1 AND $rup");
		        				
    while($rad_row = $db->sql_fetchrow($rquery)) {
    $rad_username = $rad_row['user_name'];
    $u_id = $rad_row['user_id'];
    
    $thirtydays = time() + 2592000;
    $update = $db->sql_query("INSERT INTO users_delete
						(delete_timestamp,
						user_id,
						user_name,
						user_pass,
						auth_vpn,
						user_email,
						full_name,
						regdate,
						ipaddress,
						lastlogin,
						timestamp,
						code,
						reset_code,
						is_groupname,
						is_active,
						is_freeze,
						last_freeze_date,
						is_validated,
						is_connected,
						is_offense,
						is_ban,
						suspended_date,
						duration,
						vip_duration,
						is_vip,
						private_duration,
						is_private,
						private_slot,
						private_control,
						credits,
						upline,
						login_status,
						last_active_time,
						user_level,
						status,
						device_id,
						device_model,
						device_connected)
						VALUES
						('".$thirtydays."',
						'".$rad_row['user_id']."',
						'".$rad_row['user_name']."',
						'".$rad_row['user_pass']."',
						'".$rad_row['auth_vpn']."',
						'".$rad_row['user_email']."',
						'".$rad_row['full_name']."',
						'".$rad_row['regdate']."',
						'".$rad_row['ipaddress']."',
						'".$rad_row['lastlogin']."',
						'".$rad_row['timestamp']."',
						'".$rad_row['code']."',
						'".$rad_row['reset_code']."',
						'".$rad_row['is_groupname']."',
						'".$rad_row['is_active']."',
						'".$rad_row['is_freeze']."',
						'".$rad_row['last_freeze_date']."',
						'".$rad_row['is_validated']."',
						'".$rad_row['is_connected']."',
						'".$rad_row['is_offense']."',
						'".$rad_row['is_ban']."',
						'".$rad_row['suspended_date']."',
						'".$rad_row['duration']."',
						'".$rad_row['vip_duration']."',
						'".$rad_row['is_vip']."',
						'".$rad_row['private_duration']."',
						'".$rad_row['is_private']."',
						'".$rad_row['private_slot']."',
						'".$rad_row['private_control']."',
						'".$rad_row['credits']."',
						'".$rad_row['upline']."',
						'".$rad_row['login_status']."',
						'".$rad_row['last_active_time']."',
						'".$rad_row['user_level']."',
						'".$rad_row['status']."',
						'".$rad_row['device_id']."',
						'".$rad_row['device_model']."',
						'".$rad_row['device_connected']."')");
						
    $rad_delete = $db->sql_query("DELETE FROM radcheck WHERE username = '$rad_username'");
    $u_delete = $db->sql_query("DELETE FROM users WHERE user_id = '$u_id'");
    }
	
}else{
	echo '<script> alert("You are a Mother Fucker! Damn shit!... Your IP Address: '.$ip.'"); window.location.href="http://www.google.com"; </script>';
}
?>

