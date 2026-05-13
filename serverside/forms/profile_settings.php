<?php
ob_start();
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

function rancode() {
	$chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	srand((double)microtime()*1000000);
	$i = 0;
	while ($i <= 8)
	{
		$num = rand() % 33;
		$tmp = substr($chars, $num, 1);
		$pwd = $pwd . $tmp;
		$i++;
	}
	return $pwd;
}
  
    $firstname = $db->Sanitize(trim($_POST['firstname']));
    $lastname = $db->Sanitize(trim($_POST['lastname']));
    $email = $db->Sanitize(trim($_POST['email']));
    $phone = $db->Sanitize(trim($_POST['phone']));
    $bio = $_POST['bio'];
    $twofactor = $_POST['2fa'];
    
    if(isset($twofactor)){
        $twofactorauth = 1;
    }else{
        $twofactorauth = 0;
    }
    
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
    
    if(isset($_POST['submitted'])  == 'updateprofile'){
        $valid = true;
        
        if(empty($firstname)){
            $errormsg[] = '<li>Enter first name.</li>';
            $valid = false;
        }
        
        if(empty($lastname)){
            $errormsg[] = '<li>Enter last name.</li>';
            $valid = false;
        }
        
        if(empty($email)){
            $errormsg[] = '<li>Enter email address.</li>';
            $valid = false;
        }
        
        if(empty($phone)){
            $errormsg[] = '<li>Enter phone number.</li>';
            $valid = false;
        }
        
        if(preg_match('/[^a-z-A-Z]/', $firstname)){
    	    $errormsg[] = '<li>Only letters are allowed in first name.</li>';
            $valid = false;
    	}
    	
    	if(preg_match('/[^a-z-A-Z]/', $lastname)){
    	    $errormsg[] = '<li>Only letters are allowed in last name.</li>';
            $valid = false;
    	}
    	
    	if(preg_match('/[^0-9]/', $phone)){
    	    $errormsg[] = '<li>Please enter a valid phone number.</li>';
            $valid = false;
    	}
    	
    	if(!preg_match('/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$/i', $email)){
    	    $errormsg[] = '<li>Enter a valid email address.</li>';
            $valid = false;
    	}
    	
    	if($twofactorauth == 1){
    	    $twofa_qry = $db->sql_query("SELECT user_2fa, user_email_verified FROM users WHERE user_id='$user_id_2'");
    	    $twofa_row = $db->sql_fetchrow($twofa_qry);
    	    $twofac = $twofa_row['user_2fa'];
    	    $user_email_verified = $twofa_row['user_email_verified'];
    	    
    	    if($user_email_verified == 0){
    	        $errormsg[] = '<li>You must verify your email first before enabling 2FA.</li>';
                $valid = false;
    	    }else{
    	        $valid = true;
    	    }
    	}
        
        $email_chkqry = $db->sql_query("SELECT user_email, user_email_verified FROM users WHERE user_id='$user_id_2'");
    	$email_chkrow = $db->sql_fetchrow($email_chkqry);
    	$email_chk = $email_chkrow['user_email'];
    	$email_verified_chk = $email_chkrow['user_email_verified'];
    	
    	if($email_chk == $email){
    	    $email_verify = $email_verified_chk;
    	    $twofauth = $twofactorauth;
    	}else{
    	    $eml_qry = $db->sql_query("SELECT user_email FROM users WHERE user_email='$email'");
        	$eml_chk = $db->sql_numrows($eml_qry);
        	if($eml_chk > 0){
                $errormsg[] = '<li>Email is already taken.</li>';
                $valid = false;
        	}else{
        	    $email_verify = 0;
    	        $twofauth = 0;
    	        $update = $db->sql_query("UPDATE users SET user_2fa_otp='', user_2fa_id='', user_2fa_duration='' WHERE user_id='$user_id_2'");
        	}
    	}
        
        $username_qry = $db->sql_query("SELECT * FROM users_profile WHERE profile_id='$user_id_2'");
    	$username_chk = $db->sql_numrows($username_qry);
    	$profile_row = $db->sql_fetchrow($username_qry);
        $biolink = $profile_row['bio_link'];
        
        if(!empty($biolink)){
            $blink = $biolink;
        }else{
            $blink = rancode();
        }
        
        $dirpath = "../../profile/".$user_id_2."/";
		if(is_dir($dirpath) == false)
		{
			mkdir($dirpath, 0777, true) or die('Error: ');
		}
        
        if($valid){
            if($get_key == 'firenetdev'){
                            
                $update1 = $db->sql_query("UPDATE users SET user_email='$email', user_2fa='$twofauth', user_email_verified='$email_verify' WHERE user_id='$user_id_2'");
                
                $file = fopen($_SERVER['DOCUMENT_ROOT'] . "/profile/$user_id_2/$blink","w");
                ob_end_clean();
                $fwrite = fwrite($file,$bio);
                $fclose = fclose($file);
                
                if($username_chk > 0){
                    $update2 = $db->sql_query("UPDATE users_profile SET first_name='$firstname', last_name='$lastname', profile_number='$phone', bio_link='$blink' WHERE profile_id='$user_id_2'");
                }else{
                    $update2 = $db->sql_query("INSERT INTO users_profile 
                								(first_name, last_name, profile_number, profile_id, bio_link) 
                								values
                								('$firstname', '$lastname', '$phone', '$user_id_2', '$blink')");
                }

                if($fwrite && $fclose && $update1 && $update2){
                    $success_message = 'Profile was successfully updated.';
                    $values['response'] = 1;
                    $values['msg'] = $success_message;
                }else{
                    $error_message = 'Failed updating profile.';
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