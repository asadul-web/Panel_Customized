<?php

chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'reseller'){
	
}else{
	header("Location: /dashboard");	
}

$requestData= $_REQUEST;
if(empty($requestData)){
	$db->RedirectToURL($db->base_url());
	exit;	
}

$columns = array( 
    0	=> 'id',
	1	=> 'user_id',
	2	=> 'date', 
	3	=> 'action',
	4	=> 'ipaddress',
	5	=> 'device_os',
	6	=> 'device_client',
	7	=> null
);

// Get total count
$countSql = "SELECT COUNT(*) as total FROM activity_logs";
$countQuery = $db->sql_query($countSql);
$countRow = $db->sql_fetchrow($countQuery);
$totalData = $countRow['total'];
$totalFiltered = $totalData;

// Main query - show all logs for current user
$sql = "SELECT id, user_id, date, action, ipaddress, device_os, device_client FROM activity_logs WHERE user_id='$user_id_2'";

if( !empty($requestData['search']['value']) ) {
	$searchValue = $db->Sanitize($requestData['search']['value']);
	$sql.=" AND ( user_id LIKE '%".$searchValue."%' OR id LIKE '%".$searchValue."%' OR date LIKE '%".$searchValue."%' OR action LIKE '%".$searchValue."%' OR ipaddress LIKE '%".$searchValue."%' OR device_os LIKE '%".$searchValue."%' OR device_client LIKE '%".$searchValue."%' ) ";
}

// Get filtered count
$filterQuery = $db->sql_query($sql);
$totalFiltered = $db->sql_numrows($filterQuery);

$sql.=" ORDER BY ". $columns[$requestData['order'][0]['column']]." ".$requestData['order'][0]['dir']." LIMIT ".$requestData['start'].",".$requestData['length'];

$query = $db->sql_query($sql) or die();


$data = array();
while( $row = $db->sql_fetchrow($query) ) {
	$nestedData=array();
	$id = $row['id'];
	$uid = $row['user_id'];
	$date_ = $row['date'];
	$logs_date = strtotime($date_);
	$elapse = $db->time_elapsed_string($logs_date);
	$action = $row['action'];
	$ipaddress = $row['ipaddress'];
	$deviceos = $row['device_os'];
	$deviceclient = $row['device_client'];
	
	$nestedData[] = '<span class="badge badge-primary">'.$elapse.'</span>';
	$nestedData[] = $action;
	$nestedData[] = $ipaddress;
	$nestedData[] = $deviceos;
	$nestedData[] = $deviceclient;

	$data[] = $nestedData;	
}

$json_data = array(
			"draw"            => intval( $requestData['draw'] )? intval( $_REQUEST['draw'] ) : 0,
			"recordsTotal"    => intval( $totalData ),
			"recordsFiltered" => intval( $totalFiltered ),
			"data"            => ($data )
			);

echo json_encode($json_data);
?>