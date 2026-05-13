<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../includes/functions.php';
chkSession();

if($user_id_2 == 2 || $user_level_2 == 'developer'){
}else{
    exit;
}

$table = 'cloudflare_domains';
$primaryKey = 'id';

$columns = array(
    array('db' => 'id', 'dt' => 0, 'field' => 'id'),
    array('db' => 'domain_name', 'dt' => 1, 'field' => 'domain_name'),
    array('db' => 'zone_id', 'dt' => 2, 'field' => 'zone_id'),
    array('db' => 'email', 'dt' => 3, 'field' => 'email'),
    array('db' => 'is_active', 'dt' => 4, 'field' => 'is_active'),
    array('db' => 'id', 'dt' => 5, 'field' => 'id')
);

$sql_details = array(
    'user' => $DB_user,
    'pass' => $DB_pass,
    'db'   => $DB_name,
    'host' => $DB_ip
);

require('../dist/modules/datatables/ssp.class.php');

$data = SSP::simple($_POST, $sql_details, $table, $primaryKey, $columns);

foreach($data['data'] as $key => $row){
    $domain_id = $row[0];
    $domain_name = $row[1];
    
    // Decrypt zone_id for display (show only first 20 chars)
    $encrypted_zone = $row[2];
    $decrypted_zone = $db->decrypt_key2($encrypted_zone);
    $zone_id = $db->encryptor2('decrypt', $decrypted_zone);
    $zone_display = substr($zone_id, 0, 20) . '...';
    
    // Decrypt email
    $encrypted_email = $row[3];
    $decrypted_email = $db->decrypt_key2($encrypted_email);
    $email = $db->encryptor2('decrypt', $decrypted_email);
    
    $is_active = $row[4];
    
    // Status badge
    if($is_active == 1){
        $status_badge = '<span class="badge badge-success">Active</span>';
        $toggle_btn = '<button class="btn btn-sm btn-warning btn-toggle-cf-status" data-id="'.$domain_id.'" data-status="'.$is_active.'"><i class="fas fa-toggle-on"></i></button>';
    }else{
        $status_badge = '<span class="badge badge-secondary">Inactive</span>';
        $toggle_btn = '<button class="btn btn-sm btn-success btn-toggle-cf-status" data-id="'.$domain_id.'" data-status="'.$is_active.'"><i class="fas fa-toggle-off"></i></button>';
    }
    
    // Action buttons
    $action = '
        '.$toggle_btn.'
        <button class="btn btn-sm btn-danger btn-delete-cf-domain" data-id="'.$domain_id.'" data-domain="'.$domain_name.'"><i class="fas fa-trash"></i></button>
    ';
    
    $data['data'][$key] = array(
        $domain_name,
        $zone_display,
        $email,
        $status_badge,
        $action
    );
}

echo json_encode($data);
?>
