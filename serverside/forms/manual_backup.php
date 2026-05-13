<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

ini_set('max_execution_time', 150);
chkSession();
if($user_id_2 == 2 || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    
    $path = '../../includes/backup/';
	$para = array(
		'db_host'=> $DB_host,
		'db_uname' => $DB_user,
		'db_password' => $DB_pass,
		'db_to_backup' => $DB_name,
		'db_backup_path' => $path,
		'db_exclude_tables' => array()
	);
	
    $db->__backup_mysql_database($para);
    
	if($para){
        $success_message = 'Database backup successfuly sent.';
        $values['response'] = 1;
        $values['msg'] = $success_message;
    }else{
        $error_message = 'Failed to sent database backup!';
        $values['response'] = 2;
        $values['msg'] = $error_message;
    }

	echo json_encode($values);
?>
