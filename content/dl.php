<?php
$url = $_SERVER['REQUEST_URI'];

$url_components = parse_url($url);
parse_str($url_components['query'], $params);
$id = $params['id'];

$query = $db->sql_query("SELECT * FROM applications WHERE id = '$id'");

if($db->sql_numrows($query) > 0){
    $row = $db->sql_fetchrow($query);
    $filename = $row['filename'];
    $file = 'uploads/application/file/'.$filename;
    
    if (file_exists($file))
    {
        header('Content-Description: File Download');
        header('Content-Type: application/force-download');
        header("Content-Disposition: attachment; filename=\"" . basename($file) . "\";");
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        header('Content-Length: ' . filesize($file));
        ob_clean();
        flush();
        $readfile = readfile($file); //showing the path to the server where the file is to be download
        if($readfile){
            $db->sql_query("UPDATE applications SET downloads=downloads + 1 WHERE id='".$db->SanitizeForSQL($id)."'");
        }
        exit;
    }else{
        exit;
    }
}else{
    header("Location: $base_url");
}

?>