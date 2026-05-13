<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
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
	
	$title = isset($_POST['title']) ? $db->Sanitize(trim($_POST['title'])) : '';
	$description = isset($_POST['description']) ? $db->Sanitize(trim($_POST['description'])) : '';
	$owner = isset($_POST['owner']) ? $db->Sanitize(trim($_POST['owner'])) : '';
	$logo = isset($_POST['logo']) ? $db->Sanitize(trim($_POST['logo'])) : '';
	$logoshow = isset($_POST['logoshow']) ? $db->Sanitize(trim($_POST['logoshow'])) : '';
	$maintenance = isset($_POST['maintenance']) ? $db->Sanitize(trim($_POST['maintenance'])) : '';
	$theme = isset($_POST['theme']) ? $db->Sanitize(trim($_POST['theme'])) : '';
	$notetitle = isset($_POST['notetitle']) ? $db->Sanitize(trim($_POST['notetitle'])) : '';
	$content_ = isset($_POST['note']) ? $db->Sanitize(trim($_POST['note'])) : '';
	$dirpath = "../../uploads/images/";
	
	if(empty($content_)){
	    $content = 'EMPTY_VALUE_541';
	}else{
	    $content = $content_;
	}
	
	$ntitle = $db->encryptor('decrypt', $notetitle);
	$get_title = $db->Sanitize($ntitle);
	
    if(isset($_POST['submitted'])  == 'web_settings'){
        $valid = true;
        
        if(empty($title)){
            $errormsg[] = 'Enter a title.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($description)){
            $errormsg[] = 'Enter a description.'.PHP_EOL;
            $valid = false;
        }
        
        if(empty($owner)){
            $errormsg[] = 'Enter a owner name.'.PHP_EOL;
            $valid = false;
        }
    	
        if($valid){
            if($get_key == 'firenetdev'){
                
                if(is_dir($dirpath) == false)
        		{
        			mkdir($dirpath, 0777, true) or die('Error: ');
        		}
                
                if(!empty( $_FILES['images'] ))
        		{
        		    define('resize_width', 720);
                    define('resize_height', 480);

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
        				
        				if( in_array($ext, $allowedExts) && $image_size < $max_size ){
        					$image_flag = true;
        				}else {
        					$image_flag = false;
        					$error_message = 'Maybe '.$image_name. ' exceeds max '.$max_size.' KB size or incorrect file extension';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
        				} 
        						
        				if( $value["error"] > 0 ){
        					$image_flag = false;
        					$error_message = $image_name.' Image contains error - Error Code : '.$value["error"];
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
        				}
        						
        				if($image_flag)
        				{
        					$logo_qry = $db->sql_query("SELECT logo FROM site_options");
        					$logo_row = $db->sql_fetchrow($logo_qry);
        					
        					$site_logo = $logo_row['logo'];
        						if($site_logo == ''){
        							
        						}else{
        							$path_photo = $dirpath . $site_logo;
        							unlink($path_photo);	
        						}
        
        					move_uploaded_file($value["tmp_name"], $dirpath.$name);
        								
        					$original = $name;
        					$filename = $dirpath.$name;
        					$resized = $dirpath.$name;
        					
        					if (resizeImage($filename, resize_width, resize_height, $resized)){  
        					
        					}else{  
        						$error_message = 'There was an error resizing your image.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
        					}
        							
        					$files = "../../uploads/".$get_title;
                    		$fh = fopen($files, "w");
                    		$fwrite = fwrite($fh, $content);
                		    $fclose = fclose($fh);
                		
                            if($fwrite && $fclose){
                                $update = $db->sql_query("UPDATE site_options SET 
                                            name='".$db->SanitizeForSQL($title)."', description='".$db->SanitizeForSQL($description)."',
                                            owner='".$db->SanitizeForSQL($owner)."', logo_status='".$db->SanitizeForSQL($logoshow)."', 
                                            maintenance_status='".$db->SanitizeForSQL($maintenance)."', owner='".$db->SanitizeForSQL($owner)."',
                                            theme='".$db->SanitizeForSQL($theme)."', logo='".$db->SanitizeForSQL($original)."'"); 
                                if($update){
                                    $success_message = 'Panel settings updated.';
                                    $values['response'] = 1;
                                    $values['msg'] = $success_message;
                                }else{
                                    $error_message = 'Failed updating settings!';
                                    $values['response'] = 2;
                                    $values['msg'] = $error_message;
                                }
                            }else{
                                $values['response'] = 3;
                                $errors = implode('',$errormsg);
                                $values['errormsg'] = $errors;
                            }
        				}
        			}
        		}else{
                    $files = "../../uploads/".$get_title;
            		$fh = fopen($files, "w");
            		$fwrite = fwrite($fh, $content);
        		    $fclose = fclose($fh);
        		
                    if($fwrite && $fclose){
                        $update = $db->sql_query("UPDATE site_options SET 
                                    name='".$db->SanitizeForSQL($title)."', description='".$db->SanitizeForSQL($description)."',
                                    owner='".$db->SanitizeForSQL($owner)."', logo_status='".$db->SanitizeForSQL($logoshow)."', 
                                    maintenance_status='".$db->SanitizeForSQL($maintenance)."', owner='".$db->SanitizeForSQL($owner)."',
                                    theme='".$db->SanitizeForSQL($theme)."'"); 
                        if($update){
                            $success_message = 'Panel settings updated.';
                            $values['response'] = 1;
                            $values['msg'] = $success_message;
                        }else{
                            $error_message = 'Failed updating settings!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
                        }
                    }else{
                        $values['response'] = 3;
                        $errors = implode('',$errormsg);
                        $values['errormsg'] = $errors;
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
