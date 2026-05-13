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
    0	=> 'title',
	1	=> 'type'
);

// Optimize: Get total records count with COUNT(*)
$totalDataQuery = $db->sql_query("SELECT COUNT(*) as total FROM notification") or die();
$count_row = $db->sql_fetchrow($totalDataQuery);
$totalData = $count_row['total'];

// Build search query
$searchWhere = "";
if( !empty($requestData['search']['value']) ) { 
	$searchValue = $db->Sanitize($requestData['search']['value']);
	$searchWhere = " AND ( title LIKE '%".$searchValue."%' OR type LIKE '%".$searchValue."%' ) ";
}

// Optimize: Use COUNT(*) for filtered count
$sql = "SELECT COUNT(*) as total FROM notification WHERE 1=1" . $searchWhere;
$query = $db->sql_query($sql) or die();
$count_row = $db->sql_fetchrow($query);
$totalFiltered = $count_row['total'];

// Now get the actual data with specific columns
$sql = "SELECT id, title, type, filename, date FROM notification WHERE 1=1" . $searchWhere;
$sql.=" ORDER BY ". $columns[$requestData['order'][0]['column']]."  ".$requestData['order'][0]['dir']."  LIMIT ".$requestData['start']." ,".$requestData['length']." ";

$query = $db->sql_query($sql) or die();


$data = array();
while( $row = $db->sql_fetchrow($query) ) {
	$nestedData=array();
	$nid = $row['id'];
	$title = $row['title'];
	$type_ = $row['type'];
	$filename = $row['filename'];
	$date = $row['date'];
	
	if($type_ == 1){
	    $type = 'Information';
	}elseif($type_ == 2){
	    $type = 'Emergency';
	}elseif($type_ == 3){
	    $type = 'Critical';
	}
	
	$nestedData[] = $title;
	$nestedData[] = $type;
	$nestedData[] = $date;
	$nestedData[] = '<div class="btn-group btn-group-md" role="group">
                    	<button type="button" class="btn btn-primary mr-1 btn-notification-view" data-id="'.$nid.'"><i class="far fa-eye"></i></button>
                    	<button type="button" class="btn btn-danger btn-notification-delete" data-id="'.$nid.'"><i class="fas fa-trash-alt"></i></button>
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