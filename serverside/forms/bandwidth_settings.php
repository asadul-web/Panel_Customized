<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();

if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);

if(isset($_POST['submitted']) == 'bandwidth_limit'){
    $xray_limit = $db->Sanitize(trim($_POST['xray_limit']));
    $bandwidth_value = $db->Sanitize(trim($_POST['bandwidth_value']));
    $bandwidth_unit = $db->Sanitize(trim($_POST['bandwidth_unit']));
    $valid = true;
    
    if(empty($bandwidth_value) || !is_numeric($bandwidth_value) || $bandwidth_value < 0){
        $errormsg[] = 'Enter a valid bandwidth value (minimum 0).'.PHP_EOL;
        $valid = false;
    }
    
    if(empty($bandwidth_unit)){
        $errormsg[] = 'Please select a unit.'.PHP_EOL;
        $valid = false;
    }
    
    // Calculate bytes
    $bytes = 0;
    if($valid) {
        switch($bandwidth_unit) {
            case 'bytes':
                $bytes = $bandwidth_value;
                break;
            case 'kb':
                $bytes = $bandwidth_value * 1024;
                break;
            case 'mb':
                $bytes = $bandwidth_value * 1024 * 1024;
                break;
            case 'gb':
                $bytes = $bandwidth_value * 1024 * 1024 * 1024;
                break;
            case 'tb':
                $bytes = $bandwidth_value * 1024 * 1024 * 1024 * 1024;
                break;
            default:
                $bytes = 0;
        }
    }
    
    if($valid){
        if($get_key == 'firenetdev'){
            // Check if bandwidth_limit column exists, if not create it
            $check_column = $db->sql_query("SHOW COLUMNS FROM site_options LIKE 'bandwidth_limit'");
            if($db->sql_numrows($check_column) == 0){
                $add_column = $db->sql_query("ALTER TABLE site_options ADD COLUMN bandwidth_limit INT DEFAULT 0");
            }
            
            // Check if additional columns exist, if not create them
            $check_xray = $db->sql_query("SHOW COLUMNS FROM site_options LIKE 'xray_limit'");
            if($db->sql_numrows($check_xray) == 0){
                $add_xray = $db->sql_query("ALTER TABLE site_options ADD COLUMN xray_limit VARCHAR(20) DEFAULT 'disabled'");
            }
            
            $check_value = $db->sql_query("SHOW COLUMNS FROM site_options LIKE 'bandwidth_value'");
            if($db->sql_numrows($check_value) == 0){
                $add_value = $db->sql_query("ALTER TABLE site_options ADD COLUMN bandwidth_value DECIMAL(10,2) DEFAULT 0");
            }
            
            $check_unit = $db->sql_query("SHOW COLUMNS FROM site_options LIKE 'bandwidth_unit'");
            if($db->sql_numrows($check_unit) == 0){
                $add_unit = $db->sql_query("ALTER TABLE site_options ADD COLUMN bandwidth_unit VARCHAR(10) DEFAULT 'gb'");
            }
            
            $update = $db->sql_query("UPDATE site_options SET 
                bandwidth_limit='".$db->SanitizeForSQL($bytes)."',
                xray_limit='".$db->SanitizeForSQL($xray_limit)."',
                bandwidth_value='".$db->SanitizeForSQL($bandwidth_value)."',
                bandwidth_unit='".$db->SanitizeForSQL($bandwidth_unit)."'
                WHERE id=1"); 
            if($update){
                $success_message = 'Bandwidth limit updated to '.$bandwidth_value.' '.$bandwidth_unit.' ('.number_format($bytes).' bytes).';
                $values['response'] = 1;
                $values['msg'] = $success_message;
            }else{
                $error_message = 'Failed updating bandwidth limit!';
                $values['response'] = 2;
                $values['msg'] = $error_message;
            }
        }else{
            $error_message = 'Site key invalid!';
            $values['response'] = 2;
            $values['msg'] = $error_message;
        }
    }else{
        $values['response'] = 3;
        $errors = implode('',$errormsg);
        $values['errormsg'] = $errors;
    }
}


echo json_encode($values);
?>

