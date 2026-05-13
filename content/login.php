<?php
// Initialize $user variable if not set
if (!isset($user)) {
    $user = '';
}

if (is_logged_in($user)) {
    header("Location: /dashboard");
    exit;
}

$qry = $db->sql_query("SELECT login_note, maintenance_status FROM site_options WHERE id='1'") OR die();
$row = $db->sql_fetchrow($qry);
// ✅ FIX: Initialize array if null/false
if ($row === null || $row === false) {
    $row = array('login_note' => '', 'maintenance_status' => '0');
}
$maintenance = $row['maintenance_status'] ?? '0';

// Maintenance alert
if ($maintenance == '1') {
    $mainte = '
        <div class="alert alert-warning text-center">
            <div class="alert-body">
                <div class="alert-title">Maintenance</div>
                We are upgrading something.
            </div>
        </div>';
} else {
    $mainte = '';
}

// 🔐 Login note handling
$notetitle = $db->encryptor('decrypt', $row['login_note'] ?? '');
$gettitle  = basename($db->Sanitize($notetitle)); // sanitize filename
$file      = "uploads/" . $gettitle;

$editor = '';
if (!empty($gettitle) && file_exists($file) && is_readable($file)) {
    $filesize = filesize($file);
    if ($filesize > 0) {
        $myfile = fopen($file, "r");
        if ($myfile !== false) {
            $editor_ = fread($myfile, $filesize);
            fclose($myfile);
            if ($editor_ !== false && $editor_ !== 'EMPTY_VALUE_541') {
                $editor = $editor_;
            }
        }
    }
}

if (!empty($editor)) {
    $alertf = '
    <div class="alert alert-primary alert-dismissible show fade">
        <div class="alert-body text-center">
            <button class="close" data-dismiss="alert"><span>&times;</span></button>
            <div class="text-white">' . $editor . '</div>
        </div>
    </div>';
} else {
    $alertf = '';
}

// 📲 Applications
$app1_qry = $db->sql_query("SELECT name, link, date FROM application WHERE id=1");
$app2_qry = $db->sql_query("SELECT name, link, date FROM application WHERE id=2");
$app3_qry = $db->sql_query("SELECT name, link, date FROM application WHERE id=3");

$app1_row = $db->sql_fetchrow($app1_qry);
$app2_row = $db->sql_fetchrow($app2_qry);
$app3_row = $db->sql_fetchrow($app3_qry);

// ✅ FIX: Initialize arrays if null/false
if ($app1_row === null || $app1_row === false) {
    $app1_row = array('name' => '', 'link' => '', 'date' => '');
}
if ($app2_row === null || $app2_row === false) {
    $app2_row = array('name' => '', 'link' => '', 'date' => '');
}
if ($app3_row === null || $app3_row === false) {
    $app3_row = array('name' => '', 'link' => '', 'date' => '');
}

function renderApp($name, $url) {
    if (!empty($name) && !empty($url)) {
        return '
        <div class="text-center mt-4 mb-3">
            <div class="text-job text-muted">' . htmlspecialchars($name) . '</div>
            <a href="' . htmlspecialchars($url) . '" target="_blank">
                <img src="dist/img/google-play-badge-new.png" width="200" alt="download" />
            </a>
        </div>';
    }
    return '';
}

$app1 = renderApp($app1_row['name'] ?? '', $app1_row['link'] ?? '');
$app2 = renderApp($app2_row['name'] ?? '', $app2_row['link'] ?? '');
$app3 = renderApp($app3_row['name'] ?? '', $app3_row['link'] ?? '');

resizetable($tblcontent);

// 🛡 Extra code generation
$strng = 'cc';
$stringgen = $db->encrypt_key($db->encryptor('encrypt', $strng));
$smarty->assign('strgen', $stringgen);

$spam = $db->encryptor('encrypt', 'try to hack');
$spam = $db->encryptor('encrypt', $spam);

// 🎨 Assign to template
$smarty->assign('login_note', $alertf);
$smarty->assign('app1', $app1);
$smarty->assign('app2', $app2);
$smarty->assign('app3', $app3);
$smarty->assign('code', $spam);
$smarty->assign('mainte', $mainte);
$smarty->assign('user_name', ''); // Initialize empty user_name for login form

$smarty->display("login.tpl");
?>
