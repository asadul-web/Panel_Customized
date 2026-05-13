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

$domain_id = isset($_POST['domain_id']) ? $db->Sanitize($_POST['domain_id']) : '';

if(!empty($domain_id)){
    $delete = $db->sql_query("DELETE FROM cloudflare_domains WHERE id='".$db->SanitizeForSQL($domain_id)."'");
    
    if($delete){
        $values['response'] = 1;
        $values['msg'] = 'Domain deleted successfully!';
    }else{
        $values['response'] = 2;
        $values['msg'] = 'Failed to delete domain!';
    }
}else{
    $values['response'] = 2;
    $values['msg'] = 'Domain ID is required!';
}

echo json_encode($values);
?>
