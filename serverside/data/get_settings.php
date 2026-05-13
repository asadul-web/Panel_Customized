<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
	$values = array();
	$valid = true;
	
    $qry = $db->sql_query("SELECT * FROM site_options WHERE id='1'") OR die();
	$row = $db->sql_fetchrow($qry);
	
    $uqry = $db->sql_query("SELECT user_name FROM users WHERE user_level='trial'") OR die();
	$trialusers = $db->sql_numrows($uqry);
    
    $notetitle = $db->encryptor('decrypt', $row['login_note']);
	$gettitle = $db->Sanitize($notetitle);
	
	$file = "../../uploads/".$gettitle;
	$myfile = fopen($file, "r");
    $editor_ = fread($myfile,filesize($file));
    
    if($editor_ == 'EMPTY_VALUE_541'){
        $editor = '';
    }else{
        $editor = $editor_;
    }
    
    if($row['logo_status'] > 0){
        $logoshow = 'Current : On';
    }else{
        $logoshow = 'Current : Off';
    }
    
    if($row['maintenance_status'] > 0){
        $maintenancestat = 'Current : On';
    }else{
        $maintenancestat = 'Current : Off';
    }
    
    if($row['prefix_status'] > 0){
        $prefixstat = 'Current : On';
    }else{
        $prefixstat = 'Current : Off';
    }
	
	if($row['trial_duration'] == '3600'){
	    $tridur = '1';
	    $trial_dura = 'Current : 1 Hour';
	}elseif($row['trial_duration'] == '7200'){
	    $tridur = '2';
	    $trial_dura = 'Current : 2 Hours';
	}elseif($row['trial_duration'] == '86400'){
	    $tridur = '3';
	    $trial_dura = 'Current : 24 Hours';
	}elseif($row['trial_duration'] == '1800'){
	    $tridur = '4';
	    $trial_dura = 'Current : 30 Minutes';
	}elseif($row['trial_duration'] == '259200'){
	    $tridur = '5';
	    $trial_dura = 'Current : 3 Days';
	}elseif($row['trial_duration'] == '432000'){
	    $tridur = '6';
	    $trial_dura = 'Current : 5 Days';
	}else{
	    
	}
	
    if($row['theme'] == 'default'){
        $mtheme = 'Default';
    }elseif($row['theme'] == 'cyan'){
        $mtheme = 'Cyan';
    }elseif($row['theme'] == 'dark'){
        $mtheme = 'Dark';
    }elseif($row['theme'] == 'green'){
        $mtheme = 'Green';
    }elseif($row['theme'] == 'orange'){
        $mtheme = 'Orange';
    }elseif($row['theme'] == 'pink'){
        $mtheme = 'Pink';
    }elseif($row['theme'] == 'red'){
        $mtheme = 'Red';
    }elseif($row['theme'] == 'yellow'){
        $mtheme = 'Yellow';
    }elseif($row['theme'] == 'blue'){
        $mtheme = 'Blue';
    }elseif($row['theme'] == 'purple'){
        $mtheme = 'Purple';
    }
    
	if($row){
		$values['name'] = $row['name'];
		$values['description'] = $row['description'];
		$values['owner'] = $row['owner'];
		$values['logo'] = $row['logo'];
		$values['logoshow'] = $logoshow;
		$values['logoshow_'] = $row['logo_status'];
		$values['maintenance'] = $maintenancestat;
		$values['maintenance_'] = $row['maintenance_status'];
		$values['prefixz'] = $prefixstat;
		$values['prefixz_'] = $row['prefix_status'];
		$values['uprefix'] = $row['prefix'];
		$values['theme_'] = $row['theme'];
		$values['theme'] = 'Current : '.$mtheme;
		$values['notetitle'] = $row['login_note'];
		$values['note'] = $editor;
		$values['trialuser'] = $trialusers;
		$values['sessions'] = $row['session_limit'];
		
		$values['trialdura'] = $trial_dura;
		$values['trialdura_'] = $tridur;
		$values['response'] = 1;
	}else{
		$values['response'] = 2;
	}
	if($valid == false){
		$values['response'] = 0;
	}
	echo json_encode($values);
?>
