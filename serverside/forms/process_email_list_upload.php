<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json; charset=utf-8');

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
if(!isset($_FILES['email_list_file']) || $_FILES['email_list_file']['error'] !== UPLOAD_ERR_OK) {
    $values['response'] = 2;
    $values['msg'] = 'No file uploaded or upload error';
    echo json_encode($values);
    exit;
}

$file = $_FILES['email_list_file'];
$file_extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));

// Validate file type
if(!in_array($file_extension, array('csv', 'txt', 'xlsx'))) {
    $values['response'] = 2;
    $values['msg'] = 'Invalid file type. Only CSV, TXT, and Excel files are allowed.';
    echo json_encode($values);
    exit;
}

// Validate file size (10MB max)
if($file['size'] > 10 * 1024 * 1024) {
    $values['response'] = 2;
    $values['msg'] = 'File size too large. Maximum 10MB allowed.';
    echo json_encode($values);
    exit;
}

try {
    $emails = array();
    $total_emails = 0;
    $valid_emails = 0;
    $invalid_emails = 0;
    $duplicates = 0;
    
    // Read file content
    $file_content = file_get_contents($file['tmp_name']);
    
    if($file_extension === 'csv') {
        // Parse CSV file
        $lines = str_getcsv($file_content, "\n");
        foreach($lines as $line) {
            $data = str_getcsv($line);
            if(!empty($data[0])) {
                $email = trim($data[0]);
                if(!empty($email)) {
                    $total_emails++;
                    if(filter_var($email, FILTER_VALIDATE_EMAIL)) {
                        if(!in_array($email, $emails)) {
                            $emails[] = $email;
                            $valid_emails++;
                        } else {
                            $duplicates++;
                        }
                    } else {
                        $invalid_emails++;
                    }
                }
            }
        }
    } else if($file_extension === 'txt') {
        // Parse TXT file (one email per line)
        $lines = explode("\n", $file_content);
        foreach($lines as $line) {
            $email = trim($line);
            if(!empty($email)) {
                $total_emails++;
                if(filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    if(!in_array($email, $emails)) {
                        $emails[] = $email;
                        $valid_emails++;
                    } else {
                        $duplicates++;
                    }
                } else {
                    $invalid_emails++;
                }
            }
        }
    } else {
        // For Excel files, we'd need a library like PhpSpreadsheet
        $values['response'] = 2;
        $values['msg'] = 'Excel file processing not yet implemented. Please use CSV or TXT format.';
        echo json_encode($values);
        exit;
    }
    
    // Store processed emails in session for later use
    $_SESSION['uploaded_emails'] = $emails;
    
    $values['response'] = 1;
    $values['msg'] = 'Email list processed successfully';
    $values['total_emails'] = $total_emails;
    $values['valid_emails'] = $valid_emails;
    $values['invalid_emails'] = $invalid_emails;
    $values['duplicates'] = $duplicates;
    $values['processed_emails'] = count($emails);
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error processing file: ' . $e->getMessage();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

