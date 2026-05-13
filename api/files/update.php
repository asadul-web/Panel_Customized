<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../includes/functions.php';
$values = array();
$valid = true;

//If hash contains special characters
if(preg_match('/[^a-z-A-Z-0-9]/',$_POST['hash'])){
    $valid = false;
    $response = 'Invalid request!';
}

//If hash is empty
if(!isset($_POST['hash']) || empty($_POST['hash']) && $_POST['hash'] !== '0'){
    $valid = false;
    $response = 'Invalid request!';
}

//If code is empty
if(!isset($_POST['code']) || empty($_POST['code']) && $_POST['code'] !== '0'){
    $valid = false;
    $response = 'Invalid request!';
}

if($valid){
    
    $hash = strip_tags(trim(strtolower($_POST['hash'])));
 	$code = strip_tags(trim($_POST['code']));
    
    $query = $db->sql_query("SELECT encryption FROM json_update WHERE encryption='".$hash."' LIMIT 1") or die('Database Error.');
    $row = $db->sql_fetchrow($query);
 	$check_hash = $db->sql_numrows($query);
    
    if($check_hash > 0){
     	$file = fopen("../../uploads/json/$hash.json","w");
        ob_end_clean();
        $fwrite = fwrite($file,$code);
        $fclose = fclose($file);
        
        if($fwrite && $fclose){
                    echo 'Update Json Success!!';
                }else{
                    echo 'Update Json Failed!!';
                }
         }else{
 	echo 'Request denied';
}
}else{
 	die($response);
}
?>