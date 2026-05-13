<?php
if(!is_logged_in($user)){
    $btn_val = 'Login Page';
    $btn_link = 'login';
}else{
    $btn_val = 'Dashboard';
    $btn_link = 'dashboard';
}

$totalhits = $db->sql_query("UPDATE site_options SET hits=hits + 1");
$smarty->assign("totalhits", $totalhits);

$sfile = "uploads/SDESC";
$sfiles = fopen($sfile, "r");
$sdesc = fread($sfiles,filesize($sfile));

$lfile = "uploads/LDESC";
$lfiles = fopen($lfile, "r");
$ldesc = fread($lfiles,filesize($lfile));

//List Of Application
$query = $db->sql_query("SELECT * FROM applications ORDER BY date_uploaded DESC");
$total_app = $db->sql_numrows($query);

if($total_app > 0){
while($row = $db->sql_fetchrow($query)){
    $id = $row['id'];
	$app_title = $row['app_title'];
	$app_website = $row['app_website'];
	$logo = $row['logo'];
	$filename = $row['filename'];
	$total_downloads = $row['downloads'];
	
	$appdata .= '   <div class="col-lg-3 col-md-6 col-sm-6 mt-3">';
    $appdata .= '      <div class="text-center" style="border: 2px solid var(--primary); padding: 10px; box-shadow: 3px 3px var(--primary); border-radius: 10px;">';
    $appdata .= '        <div class="thumb text-center">';
    $appdata .= '          <a href="#"><img src="/uploads/application/logo/'.$logo.'" style="width: 100px !important; height: 100px !important;" alt=""></a>';
    $appdata .= '            <h6 class="text-primary mt-3">'.$app_title.'</h6>';
    $appdata .= '            <span class="text-small mt-2">Downloads: '.$total_downloads.'</span>';
    $appdata .= '        </div><hr>';
    $appdata .= '        <button type="button" class="btn btn-primary btn-download mt-2 mb-2" onclick="view_app('.$id.')">Download</button>';
    $appdata .= '      </div>';
    $appdata .= '   </div>';
    
    
}
}else{
    $appdata .= '   <div class="col-lg-12 col-md-12 col-sm-12">';
    $appdata .= '          <h6 class="text-center">NO AVAILABLE APPLICATION.</h6>';
    $appdata .= '   </div>';
}

$smarty->assign('btn_value', $btn_val);
$smarty->assign('btn_link', $btn_link);
$smarty->assign('appdata', $appdata);
$smarty->assign('sdesc', $sdesc);
$smarty->assign('ldesc', $ldesc);
$smarty->display("download.tpl");
?>