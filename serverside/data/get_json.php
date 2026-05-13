<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

if(!isset($_GET['json']) || empty($_GET['json'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
	$json = $_GET['json'];
	
	$file = fopen($_SERVER['DOCUMENT_ROOT'] . "/uploads/json/$json.json", "r");
	$content_ = fread($file,filesize($_SERVER['DOCUMENT_ROOT'] . "/uploads/json/$json.json"));
	if($content_ == ''){
	    $content = '';
	}else{
	    $content = $content_;
	}
	fclose($file);
	
	$values = array();
	$valid = true;
    
	if($row){
		$values['content'] = $content;
        
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
