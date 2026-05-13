<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();

if($user_id_2 == 2 || $user_level_2 == 'developer'){
}else{
    echo json_encode(['response' => 2, 'msg' => 'Permission denied!']);
    exit;
}

$key = $db->encryptor('decrypt', $_POST['_key']);
$get_key = $db->Sanitize($key);
$domain_id = $db->Sanitize($_POST['domain_id']);
$current_status = $db->Sanitize($_POST['current_status']);

if(isset($_POST['submitted']) == 'toggle_cf_status'){
    if($get_key == 'firenetdev'){
        $new_status = ($current_status == 1) ? 0 : 1;
        
        $update = $db->sql_query("UPDATE cloudflare_domains SET is_active='".$new_status."' WHERE id='".$db->SanitizeForSQL($domain_id)."'");
        
        if($update){
            $status_text = ($new_status == 1) ? 'activated' : 'deactivated';
            $values['response'] = 1;
            $values['msg'] = 'Domain '.$status_text.' successfully!';
        }else{
            $values['response'] = 2;
            $values['msg'] = 'Failed to update status!';
        }
    }else{
        $values['response'] = 2;
        $values['msg'] = 'Invalid key!';
    }
}

echo json_encode($values);
?>
