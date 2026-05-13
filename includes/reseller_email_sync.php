<?php
/**
 * Reseller Email Sync Functions
 * Automatically sync reseller application emails to email subscribers
 */

function add_reseller_to_subscribers($email, $name, $ip_address = '', $user_agent = '') {
    global $db;
    
    try {
        // Validate email
        if(empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return false;
        }
        
        // Check if email already exists in subscribers
        $check_query = "SELECT id FROM email_subscribers WHERE email = '".$db->SanitizeForSQL($email)."'";
        $check_result = $db->sql_query($check_query);
        
        if($check_result && $db->sql_numrows($check_result) > 0) {
            // Email already exists, just return true
            return true;
        }
        
        // Add to email subscribers
        $name = !empty($name) ? $name : 'Reseller Applicant';
        $insert_query = "INSERT INTO email_subscribers 
                        (email, name, status, source, tags, subscribed_date, ip_address, user_agent) 
                        VALUES ('".$db->SanitizeForSQL($email)."', 
                                '".$db->SanitizeForSQL($name)."', 
                                'active', 
                                'reseller_application', 
                                'reseller,vpn', 
                                NOW(), 
                                '".$db->SanitizeForSQL($ip_address)."', 
                                '".$db->SanitizeForSQL($user_agent)."')";
        
        $result = $db->sql_query($insert_query);
        
        return $result !== false;
        
    } catch(Exception $e) {
        error_log("Reseller email sync error: " . $e->getMessage());
        return false;
    }
}

function sync_all_reseller_emails() {
    global $db;
    
    try {
        // Get all reseller emails not in subscribers
        $query = "SELECT DISTINCT ra.email, ra.full_name, ra.applied_date, ra.ip_address, ra.user_agent
                  FROM reseller_applications ra 
                  LEFT JOIN email_subscribers es ON ra.email = es.email 
                  WHERE es.email IS NULL 
                  AND ra.email IS NOT NULL 
                  AND ra.email != ''
                  AND ra.email LIKE '%@%'";
        
        $result = $db->sql_query($query);
        
        if(!$result) {
            return array('success' => false, 'message' => 'Database query failed');
        }
        
        $synced_count = 0;
        $errors = array();
        
        while($row = $db->sql_fetchrow($result)) {
            $email = trim($row['email']);
            $name = !empty($row['full_name']) ? $row['full_name'] : 'Reseller Applicant';
            $ip_address = $row['ip_address'] ?? '';
            $user_agent = $row['user_agent'] ?? '';
            $subscribed_date = $row['applied_date'];
            
            // Validate email format
            if(!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                $errors[] = "Invalid email: $email";
                continue;
            }
            
            // Insert into email_subscribers with original application date
            $insert_query = "INSERT INTO email_subscribers 
                            (email, name, status, source, tags, subscribed_date, ip_address, user_agent) 
                            VALUES ('".$db->SanitizeForSQL($email)."', 
                                    '".$db->SanitizeForSQL($name)."', 
                                    'active', 
                                    'reseller_application', 
                                    'reseller,vpn', 
                                    '".$db->SanitizeForSQL($subscribed_date)."', 
                                    '".$db->SanitizeForSQL($ip_address)."', 
                                    '".$db->SanitizeForSQL($user_agent)."')";
            
            $insert_result = $db->sql_query($insert_query);
            
            if($insert_result) {
                $synced_count++;
            } else {
                $errors[] = "Failed to add: $email";
            }
        }
        
        return array(
            'success' => true,
            'synced_count' => $synced_count,
            'error_count' => count($errors),
            'errors' => $errors
        );
        
    } catch(Exception $e) {
        return array('success' => false, 'message' => 'Error: ' . $e->getMessage());
    }
}
?>
