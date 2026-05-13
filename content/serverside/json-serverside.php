<?php

chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
	
}else{
	header("Location: /dashboard");	
}

$requestData= $_REQUEST;
if(empty($requestData)){
	$db->RedirectToURL($db->base_url());
	exit;	
}

$columns = array( 
    0	=> 'name',
	1	=> 'encryption'
);

// Optimize: Get total records count with COUNT(*)
$totalDataQuery = $db->sql_query("SELECT COUNT(*) as total FROM json_update") or die();
$count_row = $db->sql_fetchrow($totalDataQuery);
$totalData = $count_row['total'];

// Build search query
$searchWhere = "";
if( !empty($requestData['search']['value']) ) { 
	$searchValue = $db->Sanitize($requestData['search']['value']);
	$searchWhere = " AND ( name LIKE '%".$searchValue."%' OR encryption LIKE '%".$searchValue."%' ) ";
}

// Optimize: Use COUNT(*) for filtered count
$sql = "SELECT COUNT(*) as total FROM json_update WHERE 1=1" . $searchWhere;
$query = $db->sql_query($sql) or die();
$count_row = $db->sql_fetchrow($query);
$totalFiltered = $count_row['total'];

// Now get the actual data with specific columns
$sql = "SELECT id, name, type, encryption FROM json_update WHERE 1=1" . $searchWhere;
$sql.=" ORDER BY ". $columns[$requestData['order'][0]['column']]."  ".$requestData['order'][0]['dir']."  LIMIT ".$requestData['start']." ,".$requestData['length']." ";

$query = $db->sql_query($sql) or die();


$data = array();
while( $row = $db->sql_fetchrow($query) ) {
	$nestedData=array();
	$jid = $row['id'];
	$name = $row['name'];
	$type_ = $row['type'];
	$encryption = $row['encryption'];
	
	if($type_ == 1){
	    $type = 'OPENVPN';
	}elseif($type_ == 2){
	    $type = 'OPENCONNECT';
	}elseif($type_ == 3){
	    $type = 'OPENSSH';
	}elseif($type_ == 4){
	    $type = 'ALL-IN-ONE';
	}elseif($type_ == 5){
	    $type = 'CONFIG';
	}elseif($type_ == 6){
	    $type = 'NOTICE';
	}
	
	$nestedData[] = $name;
	$nestedData[] = $type;
	$nestedData[] = $encryption;
	$nestedData[] = '<div class="btn-group btn-group-md" role="group">
                    	<button type="button" class="btn btn-primary mr-1 btn-json-view" data-hash="'.$encryption.'"><i class="far fa-eye"></i></button>
                    	<button type="button" class="btn btn-primary mr-1 btn-json-edit" data-hash="'.$encryption.'" data-name="'.$name.'"><i class="fas fa-edit"></i></button>
                    	<button type="button" class="btn btn-danger btn-json-delete" data-hash="'.$encryption.'"><i class="fas fa-trash-alt"></i></button>
                    </div>';

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