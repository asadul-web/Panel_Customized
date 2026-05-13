<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

$values = array();

// Check if user is logged in and has proper permissions
if(!is_logged_in($user)) {
    $values['response'] = 2;
    $values['msg'] = 'Unauthorized';
    echo json_encode($values);
    exit;
}

if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    $values['response'] = 2;
    $values['msg'] = 'Insufficient permissions';
    echo json_encode($values);
    exit;
}

// Check if file was uploaded
if(!isset($_FILES['csv_file']) || $_FILES['csv_file']['error'] !== UPLOAD_ERR_OK) {
    $values['response'] = 2;
    $values['msg'] = 'Please select a valid CSV file';
    echo json_encode($values);
    exit;
}

$skip_duplicates = isset($_POST['skip_duplicates']) && $_POST['skip_duplicates'] == '1';

// Read CSV file
$csv_file = $_FILES['csv_file']['tmp_name'];
$handle = fopen($csv_file, 'r');

if(!$handle) {
    $values['response'] = 2;
    $values['msg'] = 'Failed to read CSV file';
    echo json_encode($values);
    exit;
}

$imported = 0;
$skipped = 0;
$errors = 0;
$line_number = 0;

// Read header row
$header = fgetcsv($handle);
if(!$header || !in_array('email', $header)) {
    $values['response'] = 2;
    $values['msg'] = 'CSV file must contain an "email" column';
    echo json_encode($values);
    exit;
}

// Find column indexes
$email_index = array_search('email', $header);
$name_index = array_search('name', $header);
$tags_index = array_search('tags', $header);

// Process each row
while(($row = fgetcsv($handle)) !== FALSE) {
    $line_number++;
    
    if(count($row) <= $email_index) {
        $errors++;
        continue;
    }
    
    $email = trim($row[$email_index]);
    $name = $name_index !== false && isset($row[$name_index]) ? trim($row[$name_index]) : '';
    $tags = $tags_index !== false && isset($row[$tags_index]) ? trim($row[$tags_index]) : '';
    
    // Validate email
    if(empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors++;
        continue;
    }
    
    // Check if email already exists
    $check_query = "SELECT id FROM email_subscribers WHERE email = '".$db->SanitizeForSQL($email)."'";
    $check_result = $db->sql_query($check_query);
    
    if($db->sql_numrows($check_result) > 0) {
        if($skip_duplicates) {
            $skipped++;
            continue;
        } else {
            $errors++;
            continue;
        }
    }
    
    // Insert subscriber
    $insert_query = "INSERT INTO email_subscribers (email, name, tags, source, subscribed_date, ip_address) 
                    VALUES ('".$db->SanitizeForSQL($email)."', 
                            '".$db->SanitizeForSQL($name)."', 
                            '".$db->SanitizeForSQL($tags)."', 
                            'import', 
                            '".date('Y-m-d H:i:s')."',
                            '".$_SERVER['REMOTE_ADDR']."')";
    
    if($db->sql_query($insert_query)) {
        $imported++;
    } else {
        $errors++;
    }
}

fclose($handle);

// Log activity
$action = "Imported $imported email subscribers from CSV";
$log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client) 
              VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".$db->SanitizeForSQL($action)."', 
              '".$_SERVER['REMOTE_ADDR']."', '', '')";
$db->sql_query($log_query);

$values['response'] = 1;
$values['msg'] = "Import completed successfully!<br>";
$values['msg'] .= "Imported: $imported subscribers<br>";
if($skipped > 0) {
    $values['msg'] .= "Skipped duplicates: $skipped<br>";
}
if($errors > 0) {
    $values['msg'] .= "Errors: $errors rows";
}

echo json_encode($values);
?>

