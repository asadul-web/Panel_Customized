<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer' || $user_level_2 == 'reseller'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}
    $key = $db->encryptor('decrypt', $_POST['_key']);
	$get_key = $db->Sanitize($key);
	
	$transferusername = $db->Sanitize(trim($_POST['transferusername']));
	$transferamount = $db->Sanitize(trim($_POST['transferamount']));
	$transferauthorized = $db->Sanitize(trim($_POST['transferauthorized']));
	
    if(isset($_POST['submitted'])  == 'transfer_credit'){
        $valid = true;
    	if(empty($transferusername)){
            $errormsg[] = 'Enter reseller&#39;s username.<br>';
            $valid = false;
        }
        
    	if(preg_match('/[^a-z-A-Z-0-9]/', $transferusername)){
    	    $errormsg[] = 'Only letters/numbers allowed in username.<br>';
            $valid = false;
    	}
        
        if($transferusername == $user_name_2){
            $errormsg[] = 'You cannot transfer in your own account.<br>';
            $valid = false; 
        }
        
    	$username_qry = $db->sql_query("SELECT user_name FROM users WHERE user_name='$transferusername' AND user_level='reseller'");
    	$username_chk = $db->sql_numrows($username_qry);
    	
    	$blocked_qry = $db->sql_query("SELECT is_freeze FROM users WHERE user_id='$user_id_2'");
    	$blocked_row = $db->sql_fetchrow($blocked_qry);
    	if($blocked_row['is_freeze'] == 1){
            $errormsg[] = 'You are blocked, contact your upline.<br>';
            $valid = false;
    	}
    	
        if($valid){
            if($get_key == 'firenetdev')
            {
                if($username_chk > 0){
                    if($transferamount>0){
                        
                        if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
                            $result = $db->sql_query("UPDATE users SET credits = credits+'".$transferamount."' WHERE user_name='".$db->SanitizeForSQL($transferusername)."'");
                            $action = 'Transferred credits to <code>'.$transferusername.'</code> with an amount of <code>'.$transferamount.'</code>.';
                            $addactivity = $db->sql_query("INSERT INTO activity_logs 
            								(user_id, date, action, ipaddress, device_os, device_client) 
            								values
            								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
            				$addactivity2 = $db->sql_query("INSERT INTO credits_logs 
            								(credits_id, credits_id2, credits_type, credits_qty, credits_date) 
            								values
            								('$user_id_2', '$transferusername', 'transfer','$transferamount', '".date('Y-m-d H:i:s')."')");
                            if($result && $addactivity && $addactivity2){
                                $success_message = 'Transferred credits to <code>'.$transferusername.'</code> with an amount of <code>'.$transferamount.'</code>.';
                                $values['response'] = 1;
                                $values['msg'] = $success_message;
                            }else{
                                $error_message = 'Failed creating reseller!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                        }else{
                            if($credits_2 == 0){
            					$error_message = 'Not enough credits.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
            				}elseif($credits_2 < $transferamount){
            					$error_message = 'Not enough credits.';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
            				}else{
                                $result = $db->sql_query("UPDATE users SET credits = credits+'".$transferamount."' WHERE user_name='".$db->SanitizeForSQL($transferusername)."'");
                                $action = 'Transferred credits to <code>'.$transferusername.'</code> with an amount of <code>'.$transferamount.'</code>.';
                                $addactivity = $db->sql_query("INSERT INTO activity_logs 
                								(user_id, date, action, ipaddress, device_os, device_client) 
                								values
                								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                				$addactivity2 = $db->sql_query("INSERT INTO credits_logs 
                								(credits_id, credits_id2, credits_type, credits_qty, credits_date) 
                								values
                								('$user_id_2', '$transferusername', 'transfer','$transferamount', '".date('Y-m-d H:i:s')."')");
                                if($result && $addactivity && $addactivity2){
                                    $success_message = 'Transferred credits to <code>'.$transferusername.'</code> with an amount of <code>'.$transferamount.'</code>.';
                                    $values['response'] = 1;
                                    $values['msg'] = $success_message;
                                }else{
                                    $error_message = 'Transfer failed!';
                                    $values['response'] = 2;
                                    $values['msg'] = $error_message;
                                }
                                $db->sql_query("UPDATE users SET credits = credits-'".$transferamount."' WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
            				}
                        }
                    }else{
                        $error_message = 'Enter a valid amount.';
                        $values['response'] = 2;
                        $values['msg'] = $error_message;
                    }
                }else{
                    $error_message = 'Sorry this reseller does&#39;nt exist.';
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
