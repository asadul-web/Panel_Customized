<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'reseller' || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

function rancode() {
	$chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	srand((double)microtime()*1000000);
	$i = 0;
	$pwd = ''; // Initialize variable
	while ($i <= 8)
	{
		$num = rand() % 33;
		$tmp = substr($chars, $num, 1);
		$pwd = $pwd . $tmp;
		$i++;
	}
	return $pwd;
}

if(!isset($_GET['uid']) || empty($_GET['uid'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
	$uid = $_GET['uid'];
	
    $sqlemail = $db->sql_query("SELECT user_email, user_name, user_2fa_duration FROM users WHERE user_id='$uid'");					
	$rowso = $db->sql_fetchrow($sqlemail);
    
	$email = $rowso['user_email'];
	$username = $rowso['user_name'];
	$user_2fa_duration = $rowso['user_2fa_duration'];
    $code = rancode();
    $otpid = rancode();
    
    $dur = $db->calc_time($user_2fa_duration);	
    $pminutes = $dur['minutes'] . " minutes";
    $pseconds = $dur['seconds'] . " seconds";
    $qryotp = false; // Initialize variable
        	
    if($user_2fa_duration > 0){
        $otp_duration = "Request again after " . $dur['minutes'] . " minutes";
    }else{
        $otp_duration = '';
        $msgz = "Hello " . $username . ",\r\n\r\n";
        $msgz .= "Copy the verification code given below and paste it in email verification page. \r\n \r\n";
        $msgz .= "Verification Code: ".$code . "\r\n \r\n";
        $msgz .= "Regards, \r\n";
        $msgz .= "Security Department\r\n";
        $subject = $db->sitename . ' - Email Verification';
                            			
        #set email headers  to aviod spam filters
        $headers  = 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
        //$headers .= "From: ".$db->siteTitle." <no-reply@".$db->sitename.">".$eol;
        $headers = 'From: support@no-reply.net' . "\r\n" .
        'Reply-To: support@no-reply.net' . "\r\n" .
        'X-Mailer: PHP/' . phpversion();
                            			
        $sendmail = mail($email, $subject, $msgz, $headers);	
        if($sendmail){
            $qryotp = $db->sql_query("UPDATE users SET user_2fa_otp='$code', user_2fa_id='$otpid', user_2fa_duration='600' WHERE user_id = '$uid'");
        }
    }
			
    if($qryotp){
        $values['response'] = 1;
        $values['request'] = $otp_duration;
    }else{
        $values['response'] = 2;
        $values['request'] = $otp_duration;
    }
    
	echo json_encode($values);
}
?>
