<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

chkSession();
define('resize_width', 512);
define('resize_height', 512);

$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $uid = $db->Sanitize(trim($_POST['id']));
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'avatar_change'){
        if($get_key == 'firenetdev'){
        
            $dirpath = "../../profile/".$uid."/";
    		if(is_dir($dirpath) == false)
    		{
    			mkdir($dirpath, 0777, true) or die('Error: ');
    		}
    		if(!empty( $_FILES['images'] ))
    		{
    			$images = restructure_array( $_FILES );
    			$allowedExts = array("gif", "jpeg", "jpg", "png");
    				
    			foreach ( $images as $key => $value)
    			{		
    				$i = $key+1;
    										
    				$image_name = $value['name'];
    				$ext = strtolower(pathinfo($image_name, PATHINFO_EXTENSION));
    				$name = $i*time().'.'.$ext;
    				$image_size = $value["size"] / 1024;
    				$image_flag = true;
    				$max_size = 2097152;
    				if( in_array($ext, $allowedExts) && $image_size < $max_size )
    				{
    					$image_flag = true;
    				} 
    				else 
    				{
    					$errormsg[] = 'Maybe '.$image_name. ' exceeds max '.$max_size.' KB size or incorrect file extension'.PHP_EOL;
                        $image_flag = false;
    				} 
    						
    				if( $value["error"] > 0 ){
    					$errormsg[] = $image_name.' Image contains error - Error Code : '.$value["error"].PHP_EOL;
                        $image_flag = false;
    				}
    						
    				if($image_flag)
    				{
    				    $valid = true;
    					$pic = $db->sql_query("SELECT * FROM users_profile WHERE profile_id = '".$db->SanitizeForSQL($uid)."'");
    					while($rows = $db->sql_fetchrow($pic))
    					{
    						$profile_image = $rows['profile_image'];
    						if($profile_image == '')
    						{
    							
    						}else{
    							$path_photo = $dirpath . $profile_image;
    							unlink($path_photo);	
    						}
    					}
    
    					move_uploaded_file($value["tmp_name"], $dirpath.$name);
    								
    					$original = $name;
    					$filename = $dirpath.$name;
    					$resized = $dirpath.$name;
    					if (resizeImage($filename, resize_width, resize_height, $resized))  
    					{  
    					}else{  
    						$errormsg[] = 'There was an error resizing your image.'.PHP_EOL;
                            $valid = false;
    					}
    					
    					if($valid){		
        					$update = $db->sql_query("UPDATE users_profile SET profile_image='".$original."'  WHERE profile_id='".$db->SanitizeForSQL($uid)."'");
        					
        					if($update)
        					{
        						$success_message = 'Avatar updated successfully!';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
        					}else{
        						$error_message = 'Avatar update failed!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
        					}
    					}else{
    					    $values['response'] = 3;
                            $errors = implode('',$errormsg);
                            $values['errormsg'] = $errors;
    					}
    				}else{
    				    $values['response'] = 3;
                        $errors = implode('',$errormsg);
                        $values['errormsg'] = $errors;
    				}
    			}
    		}else{
    			$error_message = 'Please upload a photo.';
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
