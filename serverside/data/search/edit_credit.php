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
	
    if(isset($_POST['submitted'])  == 'edit_credit'){
        $valid = true;
        $uid = $db->Sanitize(trim($_POST['id']));
	    $creditamount = $db->Sanitize(trim($_POST['creditamount']));
	    $credittype = $db->Sanitize(trim($_POST['credittype']));
	
        //Get client info
    	$client_qry = $db->sql_query("SELECT user_name, credits FROM users WHERE user_id='$uid'");
    	$client_chk = $db->sql_numrows($client_qry);
    	$client_row = $db->sql_fetchrow($client_qry);
    	$client_credit = $client_row['credits'];
    	$client_username = $client_row['user_name'];
    	
    	//Get my info
    	$my_qry = $db->sql_query("SELECT user_name, credits FROM users WHERE user_id='$user_id_2'");
    	$my_chk = $db->sql_numrows($my_qry);
    	$my_row = $db->sql_fetchrow($my_qry);
    	$my_credit = $my_row['credits'];
    	$my_username = $my_row['user_name'];
    	
    	$blocked_qry = $db->sql_query("SELECT is_freeze FROM users WHERE user_id='$user_id_2'");
    	$blocked_row = $db->sql_fetchrow($blocked_qry);
    	if($blocked_row['is_freeze'] == 1){
            $errormsg[] = '<li>You are blocked, contact your upline.</li>';
            $valid = false;
    	}
    	
        if($valid){
            if($get_key == 'firenetdev')
            {
                if($client_chk > 0){
                    if($creditamount>0){
                        if($credittype == 'add'){
                            if($creditamount<1000000){
                                if($user_id_2 == 1 && $user_level_2 == 'superadmin'){
                                    $result = $db->sql_query("UPDATE users SET credits = credits+'".$creditamount."' WHERE user_id='".$db->SanitizeForSQL($uid)."'");
                                    $action = 'Added credits to <code>'.$client_username.'</code> with an amount of <code>'.$creditamount.'</code>.';
                                    $addactivity = $db->sql_query("INSERT INTO activity_logs 
                    								(user_id, date, action, ipaddress, device_os, device_client) 
                    								values
                    								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                    				$addactivity2 = $db->sql_query("INSERT INTO credits_logs 
                    								(credits_id, credits_id2, credits_type, credits_qty, credits_date) 
                    								values
                    								('$user_id_2', '$client_username', 'add','$creditamount', '".date('Y-m-d H:i:s')."')");
                                    if($result && $addactivity && $addactivity2){
                                        $success_message = 'Successfully added <code>'.$creditamount.'</code> credit(s) to <code>'.$client_username.'</code>';
                                        $values['response'] = 1;
                                        $values['msg'] = $success_message;
                                    }else{
                                        $error_message = 'Failed adding credit(s)!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                                }elseif($user_level_2 == 'reseller'){
                                    if($my_credit == 0){
                    					$error_message = 'You have insufficient credits to add.';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                    				}elseif($my_credit < $creditamount){
                    					$error_message = 'You have insufficient credits to add.';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                    				}else{
                                        $result = $db->sql_query("UPDATE users SET credits = credits+'".$creditamount."' WHERE user_id='".$db->SanitizeForSQL($uid)."'");
                                        $action = 'Added credits to <code>'.$client_username.'</code> with an amount of <code>'.$creditamount.'</code>.';
                                        $addactivity = $db->sql_query("INSERT INTO activity_logs 
                        								(user_id, date, action, ipaddress, device_os, device_client) 
                        								values
                        								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                        				$addactivity2 = $db->sql_query("INSERT INTO credits_logs 
                        								(credits_id, credits_id2, credits_type, credits_qty, credits_date) 
                        								values
                        								('$user_id_2', '$client_username', 'add','$creditamount', '".date('Y-m-d H:i:s')."')");
                                        if($result && $addactivity && $addactivity2){
                                            $success_message = 'Successfully added <code>'.$creditamount.'</code> credit(s) to <code>'.$client_username.'</code>';
                                            $values['response'] = 1;
                                            $values['msg'] = $success_message;
                                        }else{
                                            $error_message = 'Failed adding credit(s)!';
                                            $values['response'] = 2;
                                            $values['msg'] = $error_message;
                                        }
                                        $db->sql_query("UPDATE users SET credits = credits-'".$creditamount."' WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
                    				}
                                }else{
                                    $error_message = 'Invalid transaction!';
                                    $values['response'] = 2;
                                    $values['msg'] = $error_message;
                                }
                            }else{
                                $error_message = 'Maximum credit value is 999,999';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                        }else if($credittype == 'deduct'){
                            if($user_id_2 == 1 && $user_level_2 == 'superadmin'){
                                if($client_credit < $creditamount){
                					$error_message = 'Client has insufficient credits to deduct.';
                                    $values['response'] = 2;
                                    $values['msg'] = $error_message;
                				}else{
                                    $result = $db->sql_query("UPDATE users SET credits = credits-'".$creditamount."' WHERE user_id='".$db->SanitizeForSQL($uid)."'");
                                    $action = 'Deducted credits to <code>'.$client_username.'</code> with an amount of <code>'.$creditamount.'</code>.';
                                    $addactivity = $db->sql_query("INSERT INTO activity_logs 
                    								(user_id, date, action, ipaddress, device_os, device_client) 
                    								values
                    								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                    				$addactivity2 = $db->sql_query("INSERT INTO credits_logs 
                    								(credits_id, credits_id2, credits_type, credits_qty, credits_date) 
                    								values
                    								('$user_id_2', '$client_username', 'deduct','$creditamount', '".date('Y-m-d H:i:s')."')");
                                    if($result && $addactivity && $addactivity2){
                                        $success_message = 'Successfully deducted <code>'.$creditamount.'</code> credit(s) to <code>'.$client_username.'</code>';
                                        $values['response'] = 1;
                                        $values['msg'] = $success_message;
                                    }else{
                                        $error_message = 'Failed adding credit(s)!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                				}
                            }elseif($user_level_2 == 'reseller'){
                                if($client_credit < $creditamount){
                					$error_message = 'Client has insufficient credits to deduct.';
                                    $values['response'] = 2;
                                    $values['msg'] = $error_message;
                				}else{
                                    $result = $db->sql_query("UPDATE users SET credits = credits-'".$creditamount."' WHERE user_id='".$db->SanitizeForSQL($uid)."'");
                                    $action = 'Deducted credits to <code>'.$client_username.'</code> with an amount of <code>'.$creditamount.'</code>.';
                                    $addactivity = $db->sql_query("INSERT INTO activity_logs 
                    								(user_id, date, action, ipaddress, device_os, device_client) 
                    								values
                    								('$user_id_2', '".date('Y-m-d H:i:s')."', '$action', '".$_SERVER['REMOTE_ADDR']."','$deviceOS','$device_client')");
                    				$addactivity2 = $db->sql_query("INSERT INTO credits_logs 
                    								(credits_id, credits_id2, credits_type, credits_qty, credits_date) 
                    								values
                    								('$user_id_2', '$client_username', 'deduct','$creditamount', '".date('Y-m-d H:i:s')."')");
                                    if($result && $addactivity && $addactivity2){
                                        $success_message = 'Successfully deducted <code>'.$creditamount.'</code> credit(s) to <code>'.$client_username.'</code>';
                                        $values['response'] = 1;
                                        $values['msg'] = $success_message;
                                    }else{
                                        $error_message = 'Failed adding credit(s)!';
                                        $values['response'] = 2;
                                        $values['msg'] = $error_message;
                                    }
                                    $db->sql_query("UPDATE users SET credits = credits+'".$creditamount."' WHERE user_id='".$db->SanitizeForSQL($user_id_2)."'");
                				}
                            }else{
                                $error_message = 'Invalid transaction!';
                                $values['response'] = 2;
                                $values['msg'] = $error_message;
                            }
                        }else{
                            $error_message = 'Invalid transaction!';
                            $values['response'] = 2;
                            $values['msg'] = $error_message;
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
