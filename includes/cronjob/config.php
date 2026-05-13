<?php
include '../db_config.php';
include "mysql.class.php";
$db = new mysql_db();
$db->InitDB($DB_host,$DB_user,$DB_pass,$DB_name);

$bak_query = $db->sql_query("SELECT name, owner, description, bak_to, bak_cc FROM site_options WHERE id='1'");
$bak_row = $db->sql_fetchrow($bak_query);
$bak_to = $bak_row['bak_to'];
$bak_cc = $bak_row['bak_cc'];
$bak_sitename = $bak_row['name'];
$bak_siteowner = $bak_row['owner'];
$bak_sitedesc = $bak_row['description'];

$db->SetWebsiteName($bak_sitename);
$db->SetWebsiteTitle($bak_sitedesc);
$db->SetBakTo($bak_to);
$db->SetBakCC($bak_cc);
?>