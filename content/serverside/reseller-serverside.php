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

// Optimized: Use COUNT instead of SELECT *
$countSql = "SELECT COUNT(*) as total FROM users WHERE user_id!='$user_id_2' AND user_level='reseller'";
if($user_id_2 != 1 && $user_level_2 != 'superadmin'){
    $countSql .= " AND upline='$user_id_2'";
}
$countQuery = $db->sql_query($countSql);
$countRow = $db->sql_fetchrow($countQuery);
$totalData = $countRow['total'];
$totalFiltered = $totalData;

if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
    $sql = "SELECT user_id, user_name, user_pass, credits, is_freeze FROM users WHERE user_id!='$user_id_2' AND user_level='reseller'";
}else{
	$sql = "SELECT user_id, user_name, user_pass, credits, is_freeze FROM users WHERE user_id!='$user_id_2' AND upline='$user_id_2' AND user_level='reseller'";
}

if( !empty($requestData['search']['value']) ) {
	$searchValue = $db->Sanitize($requestData['search']['value']);
	$sql.=" AND ( user_id LIKE '%".$searchValue."%' OR user_name LIKE '%".$searchValue."%' ) ";
	// Recalculate filtered count
	$filterCountQuery = $db->sql_query(str_replace('SELECT user_id, user_name, user_pass', 'SELECT COUNT(*) as total', $sql));
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
	$usercredits = isset($row['credits']) ? $row['credits'] : 0;
	$is_freeze = isset($row['is_freeze']) ? $row['is_freeze'] : 0;
	
	// Simplified - show 0 for speed (can be calculated on-demand)
	$total_client = 0;
	
	// Use default avatar for speed
	$reseller_img = 'profile/avatar-1.png';
	
	if($is_freeze == 0){
	    $is_blocked = '<span class="badge badge-success"><span class="fas fa-user"></span> Active</span>';
	    $icon_blocked = '';
	    $badge_blocked = 'primary';
	}else{
	    $is_blocked = '<span class="badge badge-danger"><span class="fas fa-user-slash"></span> Blocked</span>';
	    $icon_blocked = '<img src="dist/img/block.png" class="avatar-icon" alt="...">';
	    $badge_blocked = 'danger';
	}
	
	$nestedData[] = '<span style="white-space:nowrap">
	                <figure class="avatar mr-2 avatar-sm border-primary">
                      <img src="'.$reseller_img.'" alt="'.$username.'">
                      '.$icon_blocked.'
                    </figure> <span class="badge badge-'.$badge_blocked.'"><a class="username-class" onclick="view_info('.$userid.')">'.$username.'</a></span></span>';
	$nestedData[] = '<span class="badge badge-primary"><i class="fas fa-coins"></i> '.$usercredits.'</span>';
	$nestedData[] = '<span class="badge badge-primary"><i class="fas fa-users"></i> '.$total_client.'</span>';
	$nestedData[] = $is_blocked;
	$nestedData[] = '<div class="btn-group btn-group-md" role="group">
                    	<button type="button" class="btn btn-primary mr-1" onclick="view_info('.$userid.')"><i class="far fa-eye"></i></button>
                    	<button type="button" class="btn btn-success btn-copy" data-clipboard-text="Reseller Details 

Username : '.$username.' 
Password : '.$userpass.'
Credits : '.$usercredits.'
URL Link : '.$base_url.'/login" data-id="'.$userid.'"><i class="far fa-copy"></i></button>
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