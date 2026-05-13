<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

if(!isset($_GET['id']) || empty($_GET['id'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
	$id = $_GET['id'];
	
    $sql = "SELECT * FROM applications WHERE id='$id'";
    $qry = $db->sql_query("$sql") OR die();
	$row = $db->sql_fetchrow($qry);
	
	$app_title = $row['app_title'];
	$app_image = $row['logo'];
	$app_downloads = $row['downloads'];
	$app_version = $row['app_version'];
	$app_website = $row['app_website'];
	$app_description = $row['app_description'];
	
	$app_img = 'uploads/application/logo/'.$app_image;
	$appimg = '<img class="rounded-circle profile-widget-picture" width="250" src="'.$app_img.'" alt="'.$app_title.'">';
	
	$appdesc = '../../uploads/application/description/'.$app_description;
    $appdescs = fopen($appdesc, "r");
    $app_descx = fread($appdescs,filesize($appdesc));

	$values = array();
	$valid = true;
    
	if($row){
		$values['app_title'] = $app_title;
		$values['app_image'] = $appimg;
		$values['app_downloads'] = $app_downloads;
		$values['app_version'] = $app_version;
		$values['app_website'] = $app_website;
		$values['app_description'] = $app_descx;
		$values['response'] = 1;
	}else{
		$values['response'] = 2;
	}
	if($valid == false){
		$values['response'] = 0;
	}
	echo json_encode($values);
}
?>
