<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';


    $qry = $db->sql_query("SELECT prefix_status, prefix, trial_duration FROM site_options WHERE id='1'") OR die();
	$row = $db->sql_fetchrow($qry);
	$prefix_statz = $row['prefix_status'];
	$curprefix = $row['prefix'];
	$tri_dur = $row['trial_duration'];
    
    if($tri_dur == '3600'){
	    $trial_dura = '1 Hour';
	}elseif($tri_dur == '7200'){
	    $trial_dura = '2 Hours';
	}elseif($tri_dur == '86400'){
	    $trial_dura = '24 Hours';
	}elseif($tri_dur == '1800'){
	    $trial_dura = '30 Minutes';
	}elseif($tri_dur == '259200'){
	    $trial_dura = '3 Days';
	}elseif($tri_dur == '432000'){
	    $trial_dura = '5 Days';
	}else{
	    
	}
	
	$ran_user = rand(0,999999);
    $ran_pass = rand(0,999999);
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
