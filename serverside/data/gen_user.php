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

    $qry = $db->sql_query("SELECT prefix_status, prefix, trial_duration FROM site_options WHERE id='1'") OR die();
	$row = $db->sql_fetchrow($qry);
	$prefix_statz = $row['prefix_status'];
	$curprefix = $row['prefix'];
	$tri_dur = $row['trial_duration'];
    
    if($tri_dur == '3600'){
	    $trial_dura = 'Trial (1 Hour)';
	}elseif($tri_dur == '7200'){
	    $trial_dura = 'Trial (2 Hours)';
	}elseif($tri_dur == '86400'){
	    $trial_dura = 'Trial (24 Hours)';
	}elseif($tri_dur == '1800'){
	    $trial_dura = 'Trial (30 Minutes)';
	}else{
	    
	}
	
	$ran_user = rand(0,99919);
    $ran_pass = rand(0,99919);
	$values = array();
    
    if($prefix_statz == '0'){
        $values['ran_user'] = $ran_user;
    }else{
        $values['ran_user'] = $curprefix.$ran_user;
    }
    $values['ran_pass'] = $ran_pass;
    $values['tri_dur'] = $trial_dura;

	echo json_encode($values);
?>
