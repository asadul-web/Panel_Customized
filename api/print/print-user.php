<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
require_once '../../includes/fpdf/fpdf.php';
chkSession();

if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'normal'){
    
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

if(isset($_GET['data']) && !empty($_GET['data'])){
    
    $filename = ran_prefix();
    $data = $_GET['data'];
    $GLOBALS['data'] = $_GET['data'];
     
    if($user_id_2 == 1 || $user_level_2 == 'superadmin'){
        $sql = "SELECT * FROM users WHERE 1=1";
    }else{
    	$sql = "SELECT * FROM users WHERE 1=1 AND upline='$user_id_2'";
    }
    
    if(!empty($data)){
        if($data == 'normal'){
            $sql.=" AND user_level = 'normal' "; 
        }elseif($data == 'bulk'){
            $sql.=" AND user_level = 'bulk' "; 
        }elseif($data == 'inactive'){
            $sql.=" AND device_connected='' AND (user_level='normal' OR user_level='bulk' OR user_level='trial') "; 
        }elseif($data == 'trial'){
            $sql.=" AND user_level = 'trial' "; 
        }else{
            
        }
    }
    
    class PDF extends FPDF
    {  
        // Page header
        function Header()
        {
            if($GLOBALS['data'] == 'normal'){
                $_data = 'Normal Users';
            }elseif($GLOBALS['data'] == 'bulk'){
                $_data = 'Bulk Users';
            }elseif($GLOBALS['data'] == 'inactive'){
                $_data = 'Inactive Users';
            }elseif($GLOBALS['data'] == 'trial'){
                $_data = 'Trial Users';
            }else{
                $_data = 'NULL';
            }
            
            if ( $this->PageNo() == 1 ) {
                //DATA HEADER
                $this->setFillColor(255,255,255);
                $this->SetTextColor(false);
                
                $this->SetFont('Times','B',12);
                $this->MultiCell(20,12,'DATA :',0,'L','1');
                
                //DATA VALUE
                $x = $this->GetX();
                $y = $this->GetY();
                $this->SetXY($x + 20, $y - 12);
                
                $this->setFillColor(255,255,255);
                $this->SetTextColor(false);
                $this->SetFont('Times','I',12);
                $this->MultiCell(50,12,$_data,'','L','');
                
                $this->Ln(1);
            }
            
            //ID HEADER
            $this->setFillColor(179,179,179);
            $this->SetTextColor(false);
            
            $this->SetFont('Times','B',12);
            $this->MultiCell(15,12,'ID',1,'L','1');
            
            //USERNAME HEADER
            $x = $this->GetX();
            $y = $this->GetY();
            $this->SetXY($x + 15, $y - 12);
            
            $this->setFillColor(179,179,179);
            $this->SetTextColor(false);
            
            $this->SetFont('Times','B',12);
            $this->MultiCell(50,12,'USERNAME',1,'L','1');
            
            //PASSWORD HEADER
            $x = $this->GetX();
            $y = $this->GetY();
            $this->SetXY($x + 65, $y - 12);
        
            $this->SetFont('Times','B',12);
            $this->MultiCell(50,12,'PASSWORD',1,'L','1');
            
            //STATUS HEADER
            $x = $this->GetX();
            $y = $this->GetY();
            $this->SetXY($x + 115, $y - 12);
        
            $this->SetFont('Times','B',12);
            $this->MultiCell(50,12,'STATUS',1,'L','1');
        }    
        
        // Page footer
        function Footer()
        {
            // Go to 1.5 cm from bottom
            $this->SetY(-15);
            $this->SetX(0);
            // Select Arial italic 8
            $this->SetFont('Arial','I',8);
            // Print centered page number
            $this->Cell(0,10,'- '.$this->PageNo().' -',0,0,'C');
        }

    }

    $pdf = new PDF('P','mm','A4');
    $pdf->isFinished = false;
    
    $pdf->SetMargins(22.5,15,0);
    $pdf->AddPage();
    
    
    //TABLE RESULT
    
    $query = $db->sql_query($sql) or die();
    $total = $db->sql_numrows($query);
    $count = 1;
    while( $zrow = $db->sql_fetchrow($query) ) {
        $id = $count; 
        $username = $zrow['user_name'];
        $password = $zrow['user_pass'];
        $user_pass = $db->decrypt_key($password);
	    $userpass = $db->encryptor('decrypt', $user_pass);
	    $is_freeze = $zrow['is_freeze'];
	    $userduration = $zrow['duration'];
	    $stat = $zrow['device_connected'];
	    
	    $dur = $db->calc_time($userduration);	
    	$pdays = $dur['days'] . " days";
    	$phours = $dur['hours'] . " hours";
    	$pminutes = $dur['minutes'] . " minutes";
    	$pseconds = $dur['seconds'] . " seconds";
    	
    	if($userduration == 0){
    	    $duration = 'Expired';
    	}else{
    		$duration = strtotime($pdays . $phours . $pminutes . $pseconds);
    		$duration = date('M d, Y', $duration);
    	}	
    	
    	if($stat == 0){
    	    $expired = 'Inactive';
    	}else{
    	    $expired = $duration;
    	}
	    
        $pdf->setFillColor(255,255,255);
        $pdf->SetTextColor(false);
        $pdf->SetFont('Times','',11);
        
        $pdf->Cell(15,8,''.$id.'',1,'','L');
    	$pdf->Cell(50,8,''.$username.'',1,'','L');
        $pdf->Cell(50,8,''.$userpass.'',1,'','L');
        $pdf->Cell(50,8,''.$expired.'',1,'','L');
        $pdf->Ln();
        $count++;
    }
    
    if($total < 20){
        $additional_row = 20 - $total;
        for($i=1;$i<=$additional_row;$i++){
    	$pdf->Cell(51,8,'',1,'','L');
        $pdf->Cell(51,8,'',1,'','L');
        $pdf->Cell(51,8,'',1,'','L');
    	$pdf->Ln();
        }
    	
    }else{
        
    }
    
    $pdf->isFinished = true;
    $pdf->Output($data.'-'.$filename.'.pdf','D');

}else{
    echo 'Invalid Tansaction!';
}
?>
