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
	1	=> 'credits_id',
	2	=> 'credits_id2', 
	3	=> 'credits_type',
	4	=> 'credits_qty',
	5	=> 'credits_date'
);

$sql = "SELECT * FROM credits_logs";
$query = $db->sql_query($sql) or die();
$totalData = $db->sql_numrows($query);
$totalFiltered = $totalData;
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
	$sql = "SELECT * FROM credits_logs WHERE 1=1";
}else{
    $sql = "SELECT * FROM credits_logs WHERE (1=1 AND credits_id='$user_id_2') OR credits_id2='$user_name_2' ";
}

if( !empty($requestData['search']['value']) ) { 
	$searchValue = $db->Sanitize($requestData['search']['value']);
	$sql.=" AND ( id LIKE '%".$searchValue."%' "; 
	$sql.=" OR credits_id LIKE '%".$searchValue."%' ";
	$sql.=" OR credits_id2 LIKE '%".$searchValue."%' ";
	$sql.=" OR credits_type LIKE '%".$searchValue."%' ";
	$sql.=" OR credits_qty LIKE '%".$searchValue."%' ";
	$sql.=" OR credits_date LIKE '%".$searchValue."%' ) ";
}

$query = $db->sql_query($sql) or die();
$totalFiltered = $db->sql_numrows($query);
$sql.=" ORDER BY ". $columns[$requestData['order'][0]['column']]."   ".$requestData['order'][0]['dir']."  LIMIT ".$requestData['start']." ,".$requestData['length']."   ";

$query = $db->sql_query($sql) or die();


$data = array();
while( $row = $db->sql_fetchrow($query) ) {
	$nestedData=array();
	$id = $row['id'];
	$sender_ = $row['credits_id'];
	$receiver = $row['credits_id2'];
	$amount = $row['credits_qty'];
	$transaction = $row['credits_type'];
	$date = $row['credits_date'];
	
	$sender_qry = $db->sql_query("SELECT user_name FROM users WHERE user_id='$sender_'") OR die();
	$sender_row = $db->sql_fetchrow($sender_qry);
	$sender = $sender_row['user_name'];
	
	$nestedData[] = '<span class="badge badge-primary">'.$date.'</span>';;
	$nestedData[] = $sender;
	$nestedData[] = $receiver;
	$nestedData[] = $transaction;
	$nestedData[] = $amount;

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