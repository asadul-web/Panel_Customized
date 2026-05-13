<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
	
	$id = $db->Sanitize(trim($_POST['id']));
    
    $qry = $db->sql_query("SELECT * FROM applications WHERE id='$id'");
    $row = $db->sql_fetchrow($qry);
    
    $app_title = $row['app_title'];
    $logo = $row['logo'];
    $app_description = $row['app_description'];
    $filename = $row['filename'];
    $date_uploaded = $row['date_uploaded'];
    
    if(isset($_POST['submitted'])  == 'delete_app'){
        $valid = true;
        
        if($valid){
            if($get_key == 'firenetdev')
            {
				$logo_file = $_SERVER['DOCUMENT_ROOT'] . "/uploads/application/logo/$logo";
                if (file_exists($logo_file)){
                    $delete_logo_file = unlink($logo_file);
                }else{
                    
                }
                
                $app_file = $_SERVER['DOCUMENT_ROOT'] . "/uploads/application/file/$filename";
                if (file_exists($app_file)){
                    $delete_app_file = unlink($app_file);
                }else{
                    
                }
                
                $description_file = $_SERVER['DOCUMENT_ROOT'] . "/uploads/application/description/$app_description";
                if (file_exists($description_file)){
                    $delete_desc_file = unlink($description_file);
                }else{
                    
                }
				
				if($logo_file && $app_file && $app_file){
    				$action = 'Application <code>'.$app_title.'</code> was deleted.';
                    $addactivity = $db->sql_query("INSERT INTO activity_logs 
        							(user_id, date, action, ipaddress, device_os, device_client) 
        							values
        							('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
        			$addactivity2 = $db->sql_query("INSERT INTO deleted_app_logs 
            						(app_id, app_title, date_uploaded, date_deleted) 
            						values
            						('$id', '$app_title', '$date_uploaded', '".date('Y-m-d H:i:s')."')");
    				if($addactivity && $addactivity2){
    					$deleted = $db->sql_query("DELETE from applications WHERE id='$id'");
    						if($deleted){
                                $success_message = 'Application <code>'.$app_title.'</code> deleted successfully!';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
    						}else{
    						    $error_message = 'Application <code>'.$app_title.'</code> delete failed!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
    						}
                    }else{
                        $error_message = 'Application <code>'.$app_title.'</code> delete failed!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
				}else{
				    $error_message = 'Error deleting file!';
                    $values['response'] = 2;
                    $values['msg'] = $error_message;
				}
            }else{
                $error_message = 'Site key invalid!';
                $values['response'] = 2;
                $values['msg'] = $error_message;
            }
        }else{
            $values['response'] = 3;
            $errors = implode('',$errormsg);
            $values['errormsg'] = $errors;
        }
    }
    echo json_encode($values);
?>
