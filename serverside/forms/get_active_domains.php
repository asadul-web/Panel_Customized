<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();

if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
    // Get all active Cloudflare domains
    $query = $db->sql_query("SELECT id, domain_name FROM cloudflare_domains WHERE is_active=1 ORDER BY domain_name ASC");
    
    $domains = array();
    while($row = $db->sql_fetchrow($query)){
        $domains[] = array(
            'id' => $row['id'],
            'domain_name' => $row['domain_name']
        );
    }
    
    if(count($domains) > 0){
        $values['response'] = 1;
        $values['domains'] = $domains;
    }else{
        $values['response'] = 2;
        $values['msg'] = 'No active domains found!';
        $values['domains'] = array();
    }
}else{
    $values['response'] = 2;
    $values['msg'] = 'Permission denied!';
    $values['domains'] = array();
}

echo json_encode($values);
?>
