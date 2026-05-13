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
    0	=> 'user_id',
	1	=> 'user_name',
	2	=> null
);

// Optimized: Fast COUNT query
$countSql = "SELECT COUNT(*) as total FROM users WHERE user_id != '$user_id_2' AND user_level = 'normal' AND duration = '0'";
if($user_id_2 != 1 && $user_level_2 != 'superadmin'){
    $countSql .= " AND upline = '$user_id_2'";
}
$countQuery = $db->sql_query($countSql);
$countRow = $db->sql_fetchrow($countQuery);
$totalData = $countRow['total'];
$totalFiltered = $totalData;

// Build main query - NO JOIN for speed
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
    $sql = "SELECT * FROM users WHERE user_id != '$user_id_2' AND user_level = 'normal' AND duration = '0'";
}else{
	$sql = "SELECT * FROM users WHERE user_id != '$user_id_2' AND upline = '$user_id_2' AND user_level = 'normal' AND duration = '0'";
}

if( !empty($requestData['search']['value']) ) {
	$searchValue = $db->Sanitize($requestData['search']['value']);
	$sql.=" AND ( user_id LIKE '%".$searchValue."%' OR user_name LIKE '%".$searchValue."%' ) ";
	// Recalculate filtered count
	$filterCountSql = str_replace('SELECT *', 'SELECT COUNT(*) as total', $sql);
	$filterCountQuery = $db->sql_query($filterCountSql);
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
	$password = $row['user_pass'];
	$user_pass = $db->decrypt_key($password);
	$userpass = $db->encryptor('decrypt', $user_pass);
	$userduration = $row['duration'];
	$stat = $row['device_connected'];
	$is_online = $row['is_connected'] ?? 0;
	$active_date = $row['active_date'] ?? '0000-00-00 00:00:00';
	$is_freeze = $row['is_freeze'] ?? 0;
	
	// Get bandwidth usage from database
	$bandwidth_bytes = isset($row['bandwidth_used']) ? intval($row['bandwidth_used']) : 0;
	$bandwidth_used = formatBytes($bandwidth_bytes);
	
	$dur = $db->calc_time($userduration);	
	$pdays = $dur['days'] . " days";
	$phours = $dur['hours'] . " hours";
	$pminutes = $dur['minutes'] . " minutes";
	$pseconds = $dur['seconds'] . " seconds";
	
	$elapse = get_time_elapsed("$active_date");
	
	if($is_freeze == 0){
	    $is_blocked = '';
	    $badge_blocked = 'primary';
	}else{
	    $is_blocked = '<img src="dist/img/block.png" class="avatar-icon" alt="...">';
	    $badge_blocked = 'danger';
	}
	
	if($userduration == 0){
	    $duration = '<span class="badge badge-danger"><span class="fas fa-clock"></span> Expired</span>';
	}else{
		$duration = strtotime($pdays . $phours . $pminutes . $pseconds);
		$duration = '<span class="badge badge-primary"><span class="far fa-calendar-alt"></span> '.date('Y-m-d H:m:s', $duration).'</span>';
	}	
	
	if($stat == 0){
	    $expired = '<span class="badge badge-primary"><span class="far fa-calendar-alt"></span> none</span>';
	}else{
	    $expired = $duration;
	}
	
	if($is_online == 0){
	    $status = '<span class="badge badge-danger"><i class="fa fa-times-circle"></i> No</span>';
	}else{
	    $status = '<span class="badge badge-success"><i class="fa fa-check-circle"></i> Yes</span>';
	}
	
	if($active_date == '0000-00-00 00:00:00'){
	    $session = '<span class="badge badge-info"><i class="far fa-clock"></i> none</span>';
	}else{
	    $session = '<span class="badge badge-info" data-timestamp="'.$active_date.'"><i class="far fa-clock"></i> '.$elapse.'</span>';
	}
	
	$nestedData[] = '<span style="white-space:nowrap">
	                <figure class="avatar mr-2 avatar-sm border-primary">
                      <img src="profile/avatar-1.png" alt="'.$username.'">
                      '.$is_blocked.'
                    </figure> <span class="badge badge-'.$badge_blocked.'"><a class="username-class" onclick="user_option('.$userid.')">'.$username.'</a></span></span>';
	$nestedData[] = $status;
	$nestedData[] = $session;
	$nestedData[] = '<span class="badge badge-info"><i class="fas fa-tachometer-alt"></i> '.$bandwidth_used.'</span>';
	$nestedData[] = $expired;
	$nestedData[] = '<div class="btn-group btn-group-md" role="group">
                    	<button type="button" class="btn btn-primary mr-1" onclick="view_info('.$userid.')"><i class="far fa-eye"></i></button>
                    	<button type="button" class="btn btn-primary mr-1" onclick="user_option('.$userid.')"><i class="fas fa-edit"></i></button>
                    	<button type="button" class="btn btn-success btn-copy" data-clipboard-text="User Details 

Username : '.$username.' 
Password : '.$userpass.'" data-id="'.$userid.'"><i class="far fa-copy"></i></button>
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