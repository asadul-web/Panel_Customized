<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

if(!isset($_GET['exportmode']) || empty($_GET['exportmode']) || !isset($_GET['ugroup']) || empty($_GET['ugroup'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
	$exportmode = trim($_GET['exportmode']);
	$ugroup = trim($_GET['ugroup']);
	$uregdate = trim($_GET['rdate']);
	
	header("Content-Type:text/plain");
    header("Content-Type: application/download");
    header('Content-Disposition: attachment; filename='.$uregdate.'.'.$exportmode.'');
    
    $output = fopen('php://output', 'w');
    ob_end_clean();
    if($exportmode == 'txt'){
        fwrite($output, "USERNAME\tPASSWORD\tACTIVATED".PHP_EOL);
    }elseif($exportmode == 'csv'){
        fputcsv($output, array('USERNAME', 'PASSWORD', 'ACTIVATED'));
    }
    
    $sql = "SELECT user_name, user_pass, is_active FROM users WHERE user_group='$ugroup' order by user_id ASC";
	$qry = $db->sql_query($sql);
    $total = $db->sql_numrows($qry);
    
    if($total > 0){
        while($row = $db->sql_fetchrow($qry)){
            $username = $row['user_name'];
            $password = $row['user_pass'];
            $user_pass = $db->decrypt_key($password);
    	    $userpass = $db->encryptor('decrypt', $user_pass);
            
            $active_ = $row['is_active'];
            if($active_ == 1){
                $activated = 'Yes';
            }else{
                $activated = 'No';
            }
            if($exportmode == 'txt'){
                fwrite($output, "$username\t\t$userpass\t\t$activated".PHP_EOL);
            }elseif($exportmode == 'csv'){
                fputcsv($output, array($username, $userpass, $activated));
            }
        }
    }else{
        if($exportmode == 'txt'){
            fwrite($output, "none\t\tnone\t\tNONE".PHP_EOL);
        }elseif($exportmode == 'csv'){
            fputcsv($output, array('none', 'none', 'NONE'));
        }
    }

	fclose($output);
    exit();
}
?>