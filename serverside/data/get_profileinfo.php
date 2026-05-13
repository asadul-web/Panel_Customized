<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

    $sql = "SELECT first_name, last_name, profile_number, bio_link FROM users_profile WHERE profile_id='$user_id_2'";
    $qry = $db->sql_query("$sql") OR die();
	$row = $db->sql_fetchrow($qry);
	
	$sql2 = "SELECT user_email, user_email_verified, user_2fa, credits FROM users WHERE user_id='$user_id_2'";
    $qry2 = $db->sql_query("$sql2") OR die();
	$row2 = $db->sql_fetchrow($qry2);
	
	$firstname = $row['first_name'];
	$lastname = $row['last_name'];
	$pnumber = $row['profile_number'];
	$blink = $row['bio_link'];
	$emailadd = $row2['user_email'];
	$emailver = $row2['user_email_verified'];
	$user_2fa = $row2['user_2fa'];
	
	$file = fopen($_SERVER['DOCUMENT_ROOT'] . "/profile/$user_id_2/$blink", "r");
	$content_ = fread($file,filesize($_SERVER['DOCUMENT_ROOT'] . "/profile/$user_id_2/$blink"));
	if($content_ == ''){
	    $content = 'I am a freelance writer based in New York City, passionate about career development and helping people find new roles.';
	}else{
	    $content = $content_;
	}
	fclose($file);
	
	#Reseller
    if($user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
        $reseller = $db->sql_query("SELECT user_name FROM users WHERE is_groupname='reseller' AND user_id!='".$user_id_2."'");
    }else{
        $reseller = $db->sql_query("SELECT user_name FROM users WHERE is_groupname='reseller' AND user_id!='".$user_id_2."' AND upline='".$user_id_2."'");
    }
    $reseller = $db->sql_numrows($reseller);
    
    //Users
    if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
        $user = $db->sql_query("SELECT user_name FROM users WHERE user_level='normal' OR user_level='bulk' OR user_level='trial'");
    }else{
    	$user = $db->sql_query("SELECT user_name FROM users WHERE (user_level='normal' OR user_level='bulk' OR user_level='trial') AND user_id!='$user_id_2' AND upline='$user_id_2'");
    }
    $user = $db->sql_numrows($user);
	
	if($user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
	    $total_credit = '&#8734';
	}else{
	    $total_credit = $row2['credits'];
	}
	
	$values = array();
	$valid = true;
    
	if($valid == true){
	    $values['uid'] = $user_id_2;
		$values['firstname'] = $firstname;
		$values['lastname'] = $lastname;
		$values['emailadd'] = $emailadd;
		$values['emailver'] = $emailver;
		$values['pnumber'] = $pnumber;
		$values['user2fa'] = $user_2fa;
		$values['bio'] = $content;
		$values['total_user'] = $user;
		$values['total_reseller'] = $reseller;
		$values['mycredit'] = $total_credit;
		$values['rank'] = $rank;
		$values['rank2'] = $rank2;
		$values['response'] = 1;
	}else{
		$values['response'] = 2;
	}
	if($valid == false){
		$values['response'] = 0;
	}
	echo json_encode($values);

?>
