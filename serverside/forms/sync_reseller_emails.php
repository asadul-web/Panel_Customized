<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';

// Check if user is logged in and has proper permissions
if(!is_logged_in($user)) {
    echo json_encode(array('response' => 0, 'msg' => 'Unauthorized access'));
    exit;
}

if($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator') {
    echo json_encode(array('response' => 0, 'msg' => 'Insufficient permissions'));
    exit;
}

try {
    // First, let's add some debug info
    $debug_info = array();
    
    // Check total reseller applications
    $total_resellers = $db->sql_query("SELECT COUNT(*) as total FROM reseller_applications WHERE email IS NOT NULL AND email != ''");
    $total_count = $db->sql_fetchrow($total_resellers)['total'];
    $debug_info[] = "Total reseller applications: $total_count";
    
    // Check existing subscribers from reseller source
    $existing_reseller_subs = $db->sql_query("SELECT COUNT(*) as total FROM email_subscribers WHERE source = 'reseller_application'");
    $existing_count = $db->sql_fetchrow($existing_reseller_subs)['total'];
    $debug_info[] = "Existing reseller subscribers: $existing_count";
    
    // Get all reseller application emails that are not already in subscribers
    $query = "SELECT DISTINCT ra.email, ra.full_name, ra.applied_date, ra.ip_address 
              FROM reseller_applications ra 
              LEFT JOIN email_subscribers es ON ra.email = es.email 
              WHERE es.email IS NULL 
              AND ra.email IS NOT NULL 
              AND ra.email != ''
              AND ra.email LIKE '%@%'";
    
    $result = $db->sql_query($query);
    
    if(!$result) {
        echo json_encode(array('response' => 0, 'msg' => 'Database query failed'));
        exit;
    }
    
    $synced_count = 0;
    $errors = array();
    
    while($row = $db->sql_fetchrow($result)) {
        $email = trim($row['email']);
        $name = !empty($row['full_name']) ? $row['full_name'] : 'Reseller Applicant';
        $ip_address = $row['ip_address'] ?? '';
        $subscribed_date = $row['applied_date'];
        
        // Validate email format
        if(!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $errors[] = "Invalid email format: $email";
            continue;
        }
        
        // Insert into email_subscribers
        $insert_query = "INSERT INTO email_subscribers 
                        (email, name, status, source, tags, subscribed_date, ip_address) 
                        VALUES ('".$db->SanitizeForSQL($email)."', 
                                '".$db->SanitizeForSQL($name)."', 
                                'active', 
                                'reseller_application', 
                                'reseller,vpn', 
                                '".$db->SanitizeForSQL($subscribed_date)."', 
                                '".$db->SanitizeForSQL($ip_address)."')";
        
        $insert_result = $db->sql_query($insert_query);
        
        if($insert_result) {
            $synced_count++;
        } else {
            $errors[] = "Failed to add: $email";
        }
    }
    
    // Prepare response message
    $message = "Successfully synced $synced_count reseller emails to subscribers list.";
    if(!empty($errors)) {
        $message .= " Errors: " . implode(', ', array_slice($errors, 0, 5));
        if(count($errors) > 5) {
            $message .= " and " . (count($errors) - 5) . " more...";
        }
    }
    
    echo json_encode(array(
        'response' => 1, 
        'msg' => $message,
        'synced_count' => $synced_count,
        'error_count' => count($errors),
        'debug' => $debug_info
    ));
    
} catch(Exception $e) {
    echo json_encode(array('response' => 0, 'msg' => 'Error: ' . $e->getMessage()));
}
?>

