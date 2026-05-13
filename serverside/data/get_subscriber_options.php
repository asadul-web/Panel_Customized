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

// Get subscriber ID
$subscriber_id = intval($_POST['subscriber_id']);

// Validate input
if(empty($subscriber_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing subscriber ID';
    echo json_encode($values);
    exit;
}

// Get subscriber details for options
$query = "SELECT id, email, name, status, source, tags, subscribed_date, unsubscribed_date, last_email_sent, email_count 
          FROM email_subscribers 
          WHERE id = $subscriber_id";

$result = $db->sql_query($query);

if($result && $db->sql_numrows($result) > 0) {
    $subscriber = $db->sql_fetchrow($result);
    
    $values['response'] = 1;
    $values['subscriber'] = array(
        'id' => $subscriber['id'],
        'email' => $subscriber['email'],
        'name' => $subscriber['name'],
        'status' => $subscriber['status'],
        'source' => $subscriber['source'],
        'tags' => $subscriber['tags'],
        'subscribed_date' => $subscriber['subscribed_date'],
        'unsubscribed_date' => $subscriber['unsubscribed_date'],
        'last_email_sent' => $subscriber['last_email_sent'],
        'email_count' => $subscriber['email_count']
    );
} else {
    $values['response'] = 2;
    $values['msg'] = 'Subscriber not found';
}

echo json_encode($values);
?>

