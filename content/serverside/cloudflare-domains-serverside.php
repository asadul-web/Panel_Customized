<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

chkSession();

if($user_id_2 == 2 || $user_level_2 == 'developer'){
}else{
    header("Location: /dashboard");	
    exit;
}

$requestData = $_REQUEST;

// Set default values for DataTables parameters
$draw = isset($requestData['draw']) ? intval($requestData['draw']) : 1;
$start = isset($requestData['start']) ? intval($requestData['start']) : 0;
$length = isset($requestData['length']) ? intval($requestData['length']) : 10;
$orderColumn = isset($requestData['order'][0]['column']) ? intval($requestData['order'][0]['column']) : 0;
$orderDir = isset($requestData['order'][0]['dir']) ? $requestData['order'][0]['dir'] : 'DESC';
$searchValue = isset($requestData['search']['value']) ? $db->Sanitize($requestData['search']['value']) : '';

$columns = array( 
    0 => 'id',
    1 => 'domain_name',
    2 => 'zone_id',
    3 => 'email',
    4 => 'is_active'
);

$sql = "SELECT * FROM cloudflare_domains WHERE 1=1";

// Get total records count
$totalDataQuery = $db->sql_query("SELECT * FROM cloudflare_domains") or die();
$totalData = $db->sql_numrows($totalDataQuery);

if(!empty($searchValue)) { 
	$sql .= " AND (domain_name LIKE '%".$searchValue."%')"; 
}

$query = $db->sql_query($sql) or die();
$totalFiltered = $db->sql_numrows($query);
$sql .= " ORDER BY ". $columns[$orderColumn]." ".$orderDir." LIMIT ".$start.", ".$length."";

$query = $db->sql_query($sql) or die();

$data = array();
while($row = $db->sql_fetchrow($query)) {
	$nestedData = array();
	
	$domain_id = $row['id'];
	$domain_name = $row['domain_name'];
	
	// Decrypt zone_id for display (show only first 20 chars)
	$encrypted_zone = $row['zone_id'];
	$decrypted_zone = $db->decrypt_key2($encrypted_zone);
	$zone_id = $db->encryptor2('decrypt', $decrypted_zone);
	$zone_display = substr($zone_id, 0, 20) . '...';
	
	// Decrypt email
	$encrypted_email = $row['email'];
	$decrypted_email = $db->decrypt_key2($encrypted_email);
	$email = $db->encryptor2('decrypt', $decrypted_email);
	
	$is_active = $row['is_active'];
	
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
	
	$nestedData[] = $domain_name;
	$nestedData[] = $zone_display;
	$nestedData[] = $email;
	$nestedData[] = $status_badge;
	$nestedData[] = $action;
	
	$data[] = $nestedData;
}

$json_data = array(
	"draw"            => $draw,
	"recordsTotal"    => intval($totalData),
	"recordsFiltered" => intval($totalFiltered),
	"data"            => $data
);

echo json_encode($json_data);
?>
