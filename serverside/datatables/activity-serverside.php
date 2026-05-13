<?php
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
	
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
	1	=> 'date',
	2	=> 'action',
	3	=> 'ipaddress',
	4	=> 'device_os',
	5	=> 'device_client'
);

$sql = "SELECT * FROM activity_logs";
$query = $db->sql_query($sql) or die();
$totalData = $db->sql_numrows($query);
$totalFiltered = $totalData;

$sql = "SELECT * FROM credits_logs WHERE 1=1";
if( !empty($requestData['search']['value']) ) {
	$sql.=" AND ( id LIKE '%".$requestData['search']['value']."%' "; 
	$sql.=" OR date LIKE '%".$requestData['search']['value']."%' ";
	$sql.=" OR action LIKE '%".$requestData['search']['value']."%' ";
	$sql.=" OR ipaddress LIKE '%".$requestData['search']['value']."%' ";
	$sql.=" OR device_os LIKE '%".$requestData['search']['value']."%' ";
	$sql.=" OR device_client LIKE '%".$requestData['search']['value']."%' ) ";
}

$query = $db->sql_query($sql) or die();
$totalFiltered = $db->sql_numrows($query);

$sql.="ORDER BY ". $columns[$requestData['order'][0]['column']]."  ".$requestData['order'][0]['dir']."  LIMIT ".$requestData['start']." ,".$requestData['length']."   ";

$query = $db->sql_query($sql) or die();


$data = array();
while( $row = $db->sql_fetchrow($query) ) {
	$nestedData=array(); 
	$id = $row['id'];
	$action = $row['action'];
    $ipaddress = $row['ipaddress'];
    $deviceos = $row['device_os'];
    $deviceclient = $row['device_client'];
	$logs_date = strtotime($row['date']);
	$date = date('F d, Y h:i', $logs_date);
	$elapse = $db->time_elapsed_string($logs_date);

    $nestedData[] = $elapse;
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