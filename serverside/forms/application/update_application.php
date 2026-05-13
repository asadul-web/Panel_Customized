<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';
chkSession();
$values = array();
ini_set('post_max_size','1024M');
ini_set('upload_max_filesize','1024M');
if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $id = $db->Sanitize(trim($_POST['id']));
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
	
	$title = $db->Sanitize(trim($_POST['title']));
	$version = $db->Sanitize(trim($_POST['version']));
	$description = $db->Sanitize(trim($_POST['description']));
	
	define('resize_width', 300);
    define('resize_height', 300);

	$logopath = "../../../uploads/application/logo/";
	$filepath = "../../../uploads/application/file/";
	$descpath = "../../../uploads/application/description/";
	
	$logo_max_size = '5000000';
	$app_max_size = '100000000';
	
	$logo_allowedExts = array("gif", "jpeg", "jpg", "png");
	$app_allowedExts = array("apk");
	
	//Logo Variables
	$image_name_ = $_FILES['imidz']['name'];
	$image_name = str_replace(' ', '_', $image_name_);
	$image_ext = strtolower(pathinfo($image_name, PATHINFO_EXTENSION));
	$iname = time().'.'.$image_ext;
    $image_size = $_FILES['imidz']['size'];
    $image_tmp = $_FILES['imidz']['tmp_name'];
    $uploadImageTo = $logopath.$iname;
	
	$image_data = getimagesize($image_tmp);
    $image_width = $image_data[0];
    $image_height = $image_data[1];
	
	//File Variables
	$app_name_ = $_FILES['appfile']['name'];
	$app_name = str_replace(' ', '_', $app_name_);
	$app_ext = strtolower(pathinfo($app_name, PATHINFO_EXTENSION));
    $app_size = $_FILES['appfile']['size'];
    $app_tmp = $_FILES['appfile']['tmp_name'];
    $uploadAppTo = $filepath.$app_name;
	
	if(is_dir($logopath) == false)
    {
        mkdir($logopath, 0777, true) or die('Error: ');
    }
        		
    if(is_dir($filepath) == false)
    {
        mkdir($filepath, 0777, true) or die('Error: ');
    }
	
	$sql = "SELECT * FROM applications WHERE id='$id'";
    $qry = $db->sql_query("$sql") OR die();
	$row = $db->sql_fetchrow($qry);
	
	$current_app_version = $row['app_version'];
	$desc_title = $row['app_description'];
	$current_app_logo = $row['logo'];
	$current_app_filename = $row['filename'];
	
    if(isset($_POST['submitted'])  == 'update_application'){
        $valid = true;
    	if(empty($title)){
            $errormsg[] = '<li>Title is required.</li>';
            $valid = false;
        }
        
        if(empty($version)){
            $errormsg[] = '<li>Version is required.</li>';
            $valid = false;
        }
        
        if(empty($description)){
            $errormsg[] = '<li>Description is required.</li>';
            $valid = false;
        }
        		
        if(empty( $_FILES['appfile'] )){
            
        }else{
            if( !in_array($app_ext, $app_allowedExts)){
        	    $errormsg[] = '<li>Invalid file extension.</li>';
                $valid = false;
        	}
        }
        
        if(strlen($title) < 3){
            $errormsg[] = '<li>Title is too short.</li>';
            $valid = false;
        }
    	
    	if(!empty( $_FILES['imidz'] )){
        	if($image_size > $logo_max_size){
        	    $errormsg[] = '<li>Logo exceeds max size .</li>';
                $valid = false;
        	}
        	
        	if( !in_array($image_ext, $logo_allowedExts)){
        	    $errormsg[] = '<li>Invalid logo extension.</li>';
                $valid = false;
        	}
        	
        	if($image_width != '300' && $image_height != '300'){
        	    $errormsg[] = '<li>Invalid image resolution.</li>';
                $valid = false;
        	}
    	}else{
    	    
    	}
    	
    	if($app_size > $app_max_size){
    	    $errormsg[] = '<li>File exceeds max size .</li>';
            $valid = false;
    	}
    	
        if($valid){
            if($get_key == 'firenetdev')
            {
                //IF NOT EMPTY(LOGO) AND NOT EMPTY(FILE)
                if(!empty( $_FILES['imidz'] ) && !empty( $_FILES['appfile'] )){
                    
                    $current_logo = $logopath.$current_app_logo;;
        			$remove_logo = unlink($current_logo);
                    
                    if($remove_logo){
                        
                        $current_app = $filepath.$current_app_filename;;
        			    $remove_app = unlink($current_app);
                        
                        if($remove_app){
                            //Uploading File
                            if(isset($_FILES['appfile'])){
                                $moveApp = move_uploaded_file($app_tmp,$uploadAppTo);
                            }
                            
                            if($moveApp){
                                //Uploading Logo
                                if(isset($_FILES['imidz'])){
                                    $moveImage = move_uploaded_file($image_tmp,$uploadImageTo);
                                }
                                
                                if($moveImage){
                                    //Uploading Description
                                    $files = "../../../uploads/application/description/".$desc_title;
                                    $fh = fopen($files, "w");
                                    $fwrite = fwrite($fh, $description);
                                    $fclose = fclose($fh);
                                    
                                    if($fwrite && $fclose){
                                        $action = 'Uploaded application <code>'.$app_title.'</code>.';
                                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
                            							(user_id, date, action, ipaddress, device_os, device_client) 
                            							values
                            							('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                                        $update = $db->sql_query("UPDATE applications SET 
                                                        app_title='".$db->SanitizeForSQL($title)."',
                                                        app_version='".$db->SanitizeForSQL($version)."',
                                                        logo='".$db->SanitizeForSQL($iname)."',
                                                        app_description='".$db->SanitizeForSQL($desc_title)."',
                                                        filename='".$db->SanitizeForSQL($app_name)."',
                                                        date_uploaded='".date('Y-m-d h:i:s')."'"); 
                                         
                                            if($update && $addactivity){
                                                $success_message = 'Application updated successfully.';
                                                $values['response'] = 1;
                                                $values['msg'] = $success_message;
                                            }else{
                                                $error_message = 'Failed updating application!';
                                                $values['response'] = 2;
                                                $values['msg'] = $error_message;
                                            }
                                    }else{
                                        $error_message = 'Failed updating description!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                                    
                                }else{
                                    $error_message = 'Failed uploading logo!';
                                    $values['response'] = 2;
                                    $values['msg'] = $error_message;
                                }
                                
                            }else{
                                $error_message = 'Failed uploading application!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                        }else{
                            $error_message = 'Failed deleting current file!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
                        }
                    }else{
                        $error_message = 'Failed deleting current logo!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                //IF EMPTY(LOGO) AND NOT EMPTY(FILE)
                }elseif(empty( $_FILES['imidz'] ) && !empty( $_FILES['appfile'] )){
                    
                    $current_app = $filepath.$current_app_filename;;
        			$remove_app = unlink($current_app);
                        
                    if($remove_app){
                    
                        //Uploading File
                        if(isset($_FILES['appfile'])){
                            $moveApp = move_uploaded_file($app_tmp,$uploadAppTo);
                        }
                        
                        if($moveApp){
                            
                            //Uploading Description
                            $files = "../../../uploads/application/description/".$desc_title;
                            $fh = fopen($files, "w");
                            $fwrite = fwrite($fh, $description);
                            $fclose = fclose($fh);
                                    
                                if($fwrite && $fclose){
                                    $update = $db->sql_query("UPDATE applications SET 
                                                    app_title='".$db->SanitizeForSQL($title)."',
                                                    app_version='".$db->SanitizeForSQL($version)."',
                                                    app_website='".$db->SanitizeForSQL($website)."',
                                                    app_description='".$db->SanitizeForSQL($desc_title)."',
                                                    filename='".$db->SanitizeForSQL($app_name)."',
                                                    date_uploaded='".date('Y-m-d h:i:s')."'"); 
                                         
                                    if($update){
                                        $success_message = 'Application updated successfully.';
                                        $values['response'] = 1;
                                        $values['msg'] = $success_message;
                                    }else{
                                        $error_message = 'Failed updating application!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                                }else{
                                    $error_message = 'Failed updating description!';
                                    $values['response'] = 2;
                                    $values['msg'] = $error_message;
                                }
                                
                            }else{
                                $error_message = 'Failed uploading application!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                    }else{
                        $error_message = 'Failed deleting current file!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                 
                //IF NOT EMPTY(LOGO) AND EMPTY(FILE)
                }elseif(!empty( $_FILES['imidz'] ) && empty( $_FILES['appfile'] )){
                    
                    $current_logo = $logopath.$current_app_logo;;
        			$remove_logo = unlink($current_logo);
                    
                    if($remove_logo){
                        //Uploading Logo
                                if(isset($_FILES['imidz'])){
                                    $moveImage = move_uploaded_file($image_tmp,$uploadImageTo);
                                }
                                
                                if($moveImage){
                                    //Uploading Description
                                    $files = "../../../uploads/application/description/".$desc_title;
                                    $fh = fopen($files, "w");
                                    $fwrite = fwrite($fh, $description);
                                    $fclose = fclose($fh);
                                    
                                if($fwrite && $fclose){
                                    $update = $db->sql_query("UPDATE applications SET 
                                                    app_title='".$db->SanitizeForSQL($title)."',
                                                    logo='".$db->SanitizeForSQL($iname)."',
                                                    app_version='".$db->SanitizeForSQL($version)."',
                                                    app_website='".$db->SanitizeForSQL($website)."',
                                                    app_description='".$db->SanitizeForSQL($desc_title)."',
                                                    date_uploaded='".date('Y-m-d h:i:s')."'"); 
                                         
                                    if($update){
                                        $success_message = 'Application updated successfully.';
                                        $values['response'] = 1;
                                        $values['msg'] = $success_message;
                                    }else{
                                        $error_message = 'Failed updating application!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                                }else{
                                        $error_message = 'Failed updating description!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                                    
                                }else{
                                    $error_message = 'Failed uploading logo!';
                                    $values['response'] = 2;
                                    $values['msg'] = $error_message;
                                }
                    }else{
                        $error_message = 'Failed deleting current logo!';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }           
                    
                //IF EMPTY(LOGO) AND EMPTY(FILE)
                    }elseif(empty( $_FILES['imidz'] ) && empty( $_FILES['appfile'] )){
                        //Uploading Description
                                    $files = "../../../uploads/application/description/".$desc_title;
                                    $fh = fopen($files, "w");
                                    $fwrite = fwrite($fh, $description);
                                    $fclose = fclose($fh);
                                    
                                if($fwrite && $fclose){
                                    $update = $db->sql_query("UPDATE applications SET 
                                                    app_title='".$db->SanitizeForSQL($title)."',
                                                    app_version='".$db->SanitizeForSQL($version)."',
                                                    app_website='".$db->SanitizeForSQL($website)."',
                                                    app_description='".$db->SanitizeForSQL($desc_title)."',
                                                    date_uploaded='".date('Y-m-d h:i:s')."'"); 
                                         
                                    if($update){
                                        $success_message = 'Application updated successfully.';
                                        $values['response'] = 1;
                                        $values['msg'] = $success_message;
                                    }else{
                                        $error_message = 'Failed updating application!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                                }else{
                                        $error_message = 'Failed updating description!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
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
