<?php
error_reporting(E_ALL);
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

try {
    // Check if table exists
    $table_check = "SHOW TABLES LIKE 'email_campaigns'";
    $table_result = $db->sql_query($table_check);
    
    if(!$table_result || $db->sql_numrows($table_result) == 0) {
        // Table doesn't exist, create it
        $create_table = "CREATE TABLE IF NOT EXISTS `email_campaigns` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `name` varchar(255) NOT NULL,
            `subject` varchar(500) NOT NULL,
            `content` longtext NOT NULL,
            `content_type` enum('html','text') DEFAULT 'html',
            `status` enum('draft','scheduled','sending','sent','paused') DEFAULT 'draft',
            `recipient_type` varchar(50) DEFAULT 'all',
            `total_recipients` int(11) DEFAULT 0,
            `emails_sent` int(11) DEFAULT 0,
            `opens` int(11) DEFAULT 0,
            `clicks` int(11) DEFAULT 0,
            `created_by` int(11) DEFAULT NULL,
            `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
            `updated_date` datetime DEFAULT NULL,
            `scheduled_date` datetime DEFAULT NULL,
            `sent_date` datetime DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `status` (`status`),
            KEY `created_by` (`created_by`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
        
        if($db->sql_query($create_table)) {
            $values['table_created'] = true;
            
            // Insert sample data
            $sample_campaigns = array(
                array(
                    'name' => 'Welcome Campaign',
                    'subject' => 'Welcome to Our Service!',
                    'content' => '<h2>Welcome!</h2><p>Thank you for joining our service. We\'re excited to have you on board!</p>',
                    'status' => 'draft',
                    'total_recipients' => 0
                ),
                array(
                    'name' => 'Newsletter Campaign',
                    'subject' => 'Monthly Newsletter - November 2025',
                    'content' => '<h2>Monthly Update</h2><p>Here\'s what\'s new this month...</p>',
                    'status' => 'draft',
                    'total_recipients' => 0
                )
            );
            
            foreach($sample_campaigns as $campaign) {
                $insert_query = "INSERT INTO email_campaigns (name, subject, content, status, total_recipients, created_date) 
                                VALUES ('" . addslashes($campaign['name']) . "', 
                                       '" . addslashes($campaign['subject']) . "', 
                                       '" . addslashes($campaign['content']) . "', 
                                       '" . $campaign['status'] . "', 
                                       " . $campaign['total_recipients'] . ", 
                                       '" . date('Y-m-d H:i:s') . "')";
                $db->sql_query($insert_query);
            }
            
            $values['sample_data_added'] = true;
        }
    }
    
    // Get table info
    $count_query = "SELECT COUNT(*) as total FROM email_campaigns";
    $count_result = $db->sql_query($count_query);
    $total_campaigns = $count_result ? $db->sql_fetchrow($count_result)['total'] : 0;
    
    // Get all campaigns
    $campaigns_query = "SELECT id, name, status, created_date FROM email_campaigns ORDER BY id DESC LIMIT 10";
    $campaigns_result = $db->sql_query($campaigns_query);
    $campaigns = array();
    
    if($campaigns_result) {
        while($row = $db->sql_fetchrow($campaigns_result)) {
            $campaigns[] = $row;
        }
    }
    
    $values['response'] = 1;
    $values['total_campaigns'] = $total_campaigns;
    $values['campaigns'] = $campaigns;
    $values['msg'] = "Email campaigns table checked. Total campaigns: $total_campaigns";
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

