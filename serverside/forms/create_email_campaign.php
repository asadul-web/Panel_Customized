<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json');

try {
    require_once '../../includes/functions.php';
    require_once '../../includes/smtp_helper.php';

    $values = array();

    // Check if user is logged in and has proper permissions
    if(!isset($user) || !is_logged_in($user)) {
        $values['response'] = 2;
        $values['msg'] = 'Unauthorized - Please login as admin';
        echo json_encode($values);
        exit;
    }

    if(!isset($user_level_2) || ($user_level_2 != 'superadmin' && $user_level_2 != 'developer' && $user_level_2 != 'administrator')) {
        $values['response'] = 2;
        $values['msg'] = 'Insufficient permissions - Admin access required';
        echo json_encode($values);
        exit;
    }

    // Get form data
    $name = isset($_POST['name']) ? trim($_POST['name']) : '';
    $subject = isset($_POST['subject']) ? trim($_POST['subject']) : '';
    $content = isset($_POST['content']) ? trim($_POST['content']) : '';
    $content_type = isset($_POST['content_type']) ? trim($_POST['content_type']) : 'html';
    $recipient_type = isset($_POST['recipient_type']) ? trim($_POST['recipient_type']) : 'all';
    $status = isset($_POST['status']) ? trim($_POST['status']) : 'draft';

    // Validate required fields
    if(empty($name)) {
        $values['response'] = 2;
        $values['msg'] = 'Campaign name is required';
        echo json_encode($values);
        exit;
    }

    if(empty($subject)) {
        $values['response'] = 2;
        $values['msg'] = 'Email subject is required';
        echo json_encode($values);
        exit;
    }

    if(empty($content)) {
        $values['response'] = 2;
        $values['msg'] = 'Email content is required';
        echo json_encode($values);
        exit;
    }

    // Validate content type
    if(!in_array($content_type, array('html', 'text'))) {
        $content_type = 'html';
    }

    // Validate status
    if(!in_array($status, array('draft', 'scheduled', 'sending', 'sent', 'paused'))) {
        $status = 'draft';
    }

    // Count recipients
    $recipient_count = 0;
    if($recipient_type == 'all') {
        $count_query = "SELECT COUNT(*) as count FROM email_subscribers WHERE status = 'active'";
        $count_result = $db->sql_query($count_query);
        if($count_result) {
            $count_row = $db->sql_fetchrow($count_result);
            $recipient_count = $count_row['count'];
        }
    }

    // Escape data for database
    $name_escaped = addslashes($name);
    $subject_escaped = addslashes($subject);
    $content_escaped = addslashes($content);
    $content_type_escaped = addslashes($content_type);
    $status_escaped = addslashes($status);

    // Insert campaign (handle missing columns gracefully)
    $insert_query = "INSERT INTO email_campaigns
                    (name, subject, content, content_type, status, created_date, total_recipients)
                    VALUES (
                        '$name_escaped',
                        '$subject_escaped',
                        '$content_escaped',
                        '$content_type_escaped',
                        '$status_escaped',
                        '".date('Y-m-d H:i:s')."',
                        $recipient_count
                    )";

    if($db->sql_query($insert_query)) {
        $campaign_id = $db->sql_nextid();

        // Log activity
        $action = "Created email campaign: $name";
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client)
                      VALUES ($user_id_2, '".date('Y-m-d H:i:s')."', '".addslashes($action)."',
                      '".$_SERVER['REMOTE_ADDR']."', '', '')";
        $db->sql_query($log_query);

        // If status is 'sending', automatically send the campaign immediately
        if($status === 'sending') {
            if(!isset($smtp_configured) || !$smtp_configured) {
                // SMTP not configured, change status back to draft
                $db->sql_query("UPDATE email_campaigns SET status = 'draft' WHERE id = $campaign_id");
                $values['response'] = 2;
                $values['msg'] = 'Campaign created as draft. SMTP is not configured - please configure email settings first.';
            } else {
                // Send emails immediately
                $subscribers_query = "SELECT id, email, name FROM email_subscribers WHERE status = 'active'";
                $subscribers_result = $db->sql_query($subscribers_query);

                $sent_count = 0;
                $failed_count = 0;

                if($subscribers_result && $db->sql_numrows($subscribers_result) > 0) {
                    while($subscriber = $db->sql_fetchrow($subscribers_result)) {
                        $recipient_email = $subscriber['email'];
                        $recipient_name = !empty($subscriber['name']) ? $subscriber['name'] : $subscriber['email'];

                        // Prepare email body
                        $body = $content;
                        $website_url = $db->base_url();
                        $unsubscribe_url = $website_url . 'unsubscribe?email=' . urlencode($recipient_email);

                        $body = str_replace(
                            array('{name}', '{email}', '{website_url}', '{unsubscribe_url}'),
                            array($recipient_name, $recipient_email, $website_url, $unsubscribe_url),
                            $body
                        );

                        // Determine if content is HTML or plain text
                        $is_html = ($content_type === 'html') ? true : false;
                        
                        if(!$is_html) {
                            // For plain text emails, convert line breaks to HTML
                            $body = nl2br(htmlspecialchars($body));
                            $is_html = true;
                        }

                        $email_result = sendEmailWithSMTP($recipient_email, $recipient_name, $subject, $body, $is_html);

                        if($email_result) {
                            $sent_count++;
                            // Update subscriber stats
                            $db->sql_query("UPDATE email_subscribers SET last_email_sent = '" . date('Y-m-d H:i:s') . "', email_count = email_count + 1 WHERE id = " . intval($subscriber['id']));
                        } else {
                            $failed_count++;
                        }

                        // Small delay to prevent spam flags
                        if(($sent_count + $failed_count) > 1) {
                            usleep(300000); // 0.3 second delay
                        }
                    }

                    // Update campaign with final status and counts
                    $final_status = ($sent_count > 0) ? 'sent' : 'draft';
                    $sent_date = ($sent_count > 0) ? "'" . date('Y-m-d H:i:s') . "'" : "NULL";

                    $update_query = "UPDATE email_campaigns SET
                                    status = '$final_status',
                                    emails_sent = $sent_count,
                                    emails_failed = $failed_count,
                                    total_recipients = " . ($sent_count + $failed_count) . ",
                                    sent_date = $sent_date,
                                    updated_date = '" . date('Y-m-d H:i:s') . "'
                                    WHERE id = $campaign_id";
                    $db->sql_query($update_query);

                    // Log sending activity
                    $send_action = "Campaign '$name' automatically sent after creation - Sent: $sent_count, Failed: $failed_count";
                    $send_log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client)
                                      VALUES ($user_id_2, '" . date('Y-m-d H:i:s') . "', '" . addslashes($send_action) . "',
                                      '" . $_SERVER['REMOTE_ADDR'] . "', '', '')";
                    $db->sql_query($send_log_query);

                    if($sent_count > 0) {
                        $values['response'] = 1;
                        $values['msg'] = "🚀 Campaign '$name' created and sent successfully! Delivered to $sent_count subscribers." . ($failed_count > 0 ? " Failed: $failed_count" : "");
                    } else {
                        $values['response'] = 2;
                        $values['msg'] = "Campaign '$name' created but no emails were sent. Check your subscriber list and SMTP settings.";
                    }
                } else {
                    // No active subscribers
                    $db->sql_query("UPDATE email_campaigns SET status = 'draft' WHERE id = $campaign_id");
                    $values['response'] = 2;
                    $values['msg'] = "Campaign '$name' created as draft. No active subscribers found - please add subscribers first.";
                }
            }
        } else {
            // Regular draft creation
            $values['response'] = 1;
            $values['msg'] = "Campaign '$name' created successfully! Recipients: $recipient_count";
        }

    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to create campaign. Database error: ' . $db->sql_error();
    }

} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['response'] = 2;
    $values['msg'] = 'Fatal Error: ' . $e->getMessage();
}

echo json_encode($values);
?>

