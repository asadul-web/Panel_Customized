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
    0	=> 'id',
	1	=> 'app_title',
	2	=> null
);

// Optimize: Use COUNT(*) instead of SELECT * for counting
$sql = "SELECT COUNT(*) as total FROM applications";
$query = $db->sql_query($sql) or die();
$count_row = $db->sql_fetchrow($query);
$totalData = $count_row['total'];
$totalFiltered = $totalData;

// Build search query
$searchWhere = "";
if( !empty($requestData['search']['value']) ) { 
	$searchValue = $db->Sanitize($requestData['search']['value']);
	$searchWhere = " AND ( id LIKE '%".$searchValue."%' OR app_title LIKE '%".$searchValue."%' ) ";
}

// Optimize: Use COUNT(*) for filtered count
$sql = "SELECT COUNT(*) as total FROM applications WHERE 1=1" . $searchWhere;
$query = $db->sql_query($sql) or die();
$count_row = $db->sql_fetchrow($query);
$totalFiltered = $count_row['total'];

// Now get the actual data
$sql = "SELECT id, app_title, app_version, app_website, logo, app_description, filename, date_uploaded, downloads FROM applications WHERE 1=1" . $searchWhere;
$sql.=" ORDER BY ". $columns[$requestData['order'][0]['column']]."  ".$requestData['order'][0]['dir']."  LIMIT ".$requestData['start']." ,".$requestData['length']." ";

$query = $db->sql_query($sql) or die();


$data = array();
while( $row = $db->sql_fetchrow($query) ) {
	$nestedData=array();
	
	$id = $row['id'];
	$app_title = $row['app_title'];
	$app_version = $row['app_version'];
	$app_website = $row['app_website'];
	$logo = $row['logo'];
	$app_description = $row['app_description'];
	$filename = $row['filename'];
	$date_uploaded = $row['date_uploaded'];
	$downloads = $row['downloads'];
	
	$nestedData[] = '<span style="white-space:nowrap">
	                <figure class="avatar mr-2 avatar-sm border-primary">
                      <img src="uploads/application/logo/'.$logo.'" alt="'.$app_title.'">
                    </figure> <a class="username-class" onclick="user_option('.$id.')">'.$app_title.'</a></span>';
	$nestedData[] = $app_version;
	$nestedData[] = $downloads;
	$nestedData[] = '<span class="badge badge-info"><i class="fas fa-tachometer-alt"></i> '.$date_uploaded.'</span>';
	$nestedData[] = '<div class="btn-group btn-group-md" role="group">
                    	<button type="button" class="btn btn-primary mr-1" onclick="update_app('.$id.')"><i class="fas fa-edit"></i></button>
                    	<button type="button" class="btn btn-danger mr-1" onclick="delete_app('.$id.')"><i class="fas fa-trash"></i></button>';
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