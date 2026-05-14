<?php
date_default_timezone_set('Asia/Riyadh');
$DB_ip = "68.168.220.235";
$DB_host = "localhost";
$DB_user = "asalosit_vpnpanelnew";
$DB_pass = "asalosit_vpnpanelnew";
$DB_name = "asalosit_vpnpanelnew";

// Optimize MySQL connection with performance settings
$mysqli = new MySQLi($DB_host,$DB_user,$DB_pass,$DB_name);
if($mysqli->connect_error){
   die('Error : ('. $mysqli->connect_errno .') '. $mysqli->connect_error);
}

// Set charset for better performance and security
$mysqli->set_charset("utf8mb4");

// Optimize MySQL settings for performance (only session-level settings)
$mysqli->query("SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO'");
$mysqli->query("SET SESSION innodb_lock_wait_timeout = 5");
// Note: query_cache settings require GLOBAL privileges, skip for shared hosting
?>