<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

if(!isset($_POST['search'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
	
	$name = $_POST['search'];
	
	if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
	    $sql = "SELECT user_id, user_name, user_level FROM users WHERE user_name LIKE '%".$name."%' AND user_id!='$user_id_2' AND (user_level = 'normal' OR user_level = 'bulk' OR user_level = 'trial' OR user_level = 'reseller') LIMIT 5";
	}else{
	    $sql = "SELECT user_id, user_name, user_level FROM users WHERE user_name LIKE '%".$name."%' AND user_id!='$user_id_2' AND upline='$user_id_2' AND (user_level = 'normal' OR user_level = 'bulk' OR user_level = 'trial' OR user_level = 'reseller') LIMIT 5";
	}
    
    $qry = $db->sql_query("$sql") OR die();
	$totalData = $db->sql_numrows($qry);
	while($row = $db->sql_fetchrow($qry)){
	    $uid = $row['user_id'];
	    $uname = $row['user_name'];
	    $ulevel = $row['user_level'];
	    
	    $sql2 = "SELECT profile_image FROM users_profile WHERE profile_id='$uid'";
        $qry2 = $db->sql_query("$sql2") OR die();
    	$row2 = $db->sql_fetchrow($qry2);
    	
    	$reseller_image = $row2['profile_image'];
    	
    	if($reseller_image == ''){
    	    $reseller_img = '<img src="profile/avatar-1.png" alt="'.$uname.'">';
    	}else{
            $reseller_img = '<img src="profile/'.$uid.'/'.$reseller_image.'" alt="'.$uname.'">';
    	}
	    
	    if($ulevel == 'reseller'){
	        $img = $reseller_img;
	    }else{
	        $img = '<img src="profile/avatar-1.png" alt="'.$uname.'">';
	    }
	    
	    if($ulevel == 'reseller'){
	        $userlevel = 'Reseller';
	    }elseif($ulevel == 'normal'){
	        $userlevel = 'Normal User';
	    }elseif($ulevel == 'trial'){
	        $userlevel = 'Trial User';
	    }elseif($ulevel == 'bulk'){
	        $userlevel = 'Bulk User';
	    }else{
	        $userlevel = 'Invalid User';
	    }
	    
	    $ulist .= '<div class="search-item">
                        <a type="button" href="javascript:void(0);" onclick="searchuser('.$uid.')">
                            <figure class="avatar mr-2 avatar-sm border-primary">
                                '.$img.'
                            </figure> 
                            <div class="dropdown-item-desc">
                                <b>'.$uname.'</b>
                    <div class="time">'.$userlevel.'</div>
                            </div>
                        </a>
                    </div>';
	}
	
	if($totalData > 0){
        $values['ulist'] = $ulist;
		$values['response'] = 1;
	}else{
		$values['response'] = 2;
	}
	
	echo json_encode($values);
}
?>
