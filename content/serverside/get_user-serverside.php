<?php

chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'reseller'){
	
}else{
	header("Location: /dashboard");	
}

if(!isset($_GET['type']) || empty($_GET['type'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
$requestData= $_REQUEST;
$type = $_GET['type'];
if(empty($requestData)){
	$db->RedirectToURL($db->base_url());
	exit;	
}

$columns = array( 
    0	=> 'user_id',
	1	=> 'user_name',
	2	=> null
);

// Optimized: Use COUNT instead of SELECT *
$countSql = "SELECT COUNT(*) as total FROM users WHERE user_id!='$user_id_2' AND user_level='$type'";
if($user_id_2 != 1 && $user_level_2 != 'superadmin'){
    $countSql .= " AND upline='$user_id_2'";
}
$countQuery = $db->sql_query($countSql);
$countRow = $db->sql_fetchrow($countQuery);
$totalData = $countRow['total'];
$totalFiltered = $totalData;

// Build main query
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
    $sql = "SELECT user_id, user_name FROM users WHERE user_id!='$user_id_2' AND user_level='$type'";
}else{
	$sql = "SELECT user_id, user_name FROM users WHERE user_id!='$user_id_2' AND upline='$user_id_2' AND user_level='$type'";
}

if( !empty($requestData['search']['value']) ) { 
	$searchValue = $db->Sanitize($requestData['search']['value']);
	$sql.=" AND ( user_id LIKE '%".$searchValue."%' OR user_name LIKE '%".$searchValue."%' ) ";
	// Recalculate filtered count
	$filterCountQuery = $db->sql_query(str_replace('SELECT user_id, user_name', 'SELECT COUNT(*) as total', $sql));
	$filterCountRow = $db->sql_fetchrow($filterCountQuery);
	$totalFiltered = $filterCountRow['total'];
}

$sql.=" ORDER BY ". $columns[$requestData['order'][0]['column']]." ".$requestData['order'][0]['dir']." LIMIT ".$requestData['start'].",".$requestData['length'];

$query = $db->sql_query($sql) or die();


$data = array();
while( $row = $db->sql_fetchrow($query) ) {
	$nestedData=array();
	$userid = $row['user_id'];
	$username = $row['user_name'];
	
	$nestedData[] = $username;
	$nestedData[] = $username;
	$nestedData[] = $username;
	$nestedData[] = $username;
	$nestedData[] = $username;

	$data[] = $nestedData;	
}

$json_data = array(
			"draw"            => intval( $requestData['draw'] )? intval( $_REQUEST['draw'] ) : 0,
			"recordsTotal"    => intval( $totalData ),
			"recordsFiltered" => intval( $totalFiltered ),
			"data"            => ($data )
			);

echo json_encode($json_data);
}
?>