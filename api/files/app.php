<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../includes/functions.php';
$values = array();
$valid = true;

//If json contains special characters
if(preg_match('/[^a-z-A-Z-0-9]/',$_GET['json'])){
    $valid = false;
    $response = '/app denied.';
}

//If json is empty
if(!isset($_GET['json']) || empty($_GET['json']) && $_GET['json'] !== '0'){
    $valid = false;
    $response = '/app denied.';
}

if($valid){
 	$json = strip_tags(trim($_GET['json']));
 
 	$sql = "SELECT id FROM json_update WHERE encryption='$json'";
 	$query = $db->sql_query($sql) or die();
 	$chk_json = $db->sql_numrows($query);
 	    
 	if($chk_json > 0){
 	    $file = "../../uploads/json/$json.json";
 	    ob_end_clean();
 	    $file = file_get_contents($file);
 	    die($file);
 	}else{
 	    die('Request was denied');
 	}
}else{
 	die($response);
}
?>