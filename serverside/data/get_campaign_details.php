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

// Get campaign ID
$campaign_id = isset($_POST['campaign_id']) ? intval($_POST['campaign_id']) : 0;

if(empty($campaign_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing campaign ID';
    echo json_encode($values);
    exit;
}

try {
    
    // Check if database connection exists
    if(!isset($db) || !is_object($db)) {
        $values['response'] = 2;
        $values['msg'] = 'Database connection not available';
        echo json_encode($values);
        exit;
    }
    
    // Get campaign details (handle missing columns gracefully)
    $query = "SELECT id, name, subject, content, content_type, status, created_date, total_recipients 
              FROM email_campaigns 
              WHERE id = $campaign_id";
    
    $result = $db->sql_query($query);
    
    if($result) {
        $num_rows = $db->sql_numrows($result);
        
        if($num_rows > 0) {
            $campaign = $db->sql_fetchrow($result);
            
            $values['response'] = 1;
            $values['data'] = array(
                'id' => $campaign['id'],
                'name' => $campaign['name'],
                'subject' => $campaign['subject'],
                'content' => $campaign['content'],
                'content_type' => $campaign['content_type'] ?: 'html',
                'status' => $campaign['status'],
                'created_date' => $campaign['created_date'],
                'total_recipients' => $campaign['total_recipients'] ?: 0,
                'recipient_type' => 'all' // Default value since column doesn't exist yet
            );
        } else {
            // Check if any campaigns exist at all
            $count_query = "SELECT COUNT(*) as total FROM email_campaigns";
            $count_result = $db->sql_query($count_query);
            $total_campaigns = $count_result ? $db->sql_fetchrow($count_result)['total'] : 0;
            
            $values['response'] = 2;
            $values['msg'] = "Campaign with ID $campaign_id not found. Total campaigns in database: $total_campaigns";
        }
    } else {
        $db_error = $db->sql_error();
        $error_msg = is_array($db_error) ? json_encode($db_error) : $db_error;
        
        $values['response'] = 2;
        $values['msg'] = 'Database query failed: ' . $error_msg;
    }
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error loading campaign: ' . $e->getMessage();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

