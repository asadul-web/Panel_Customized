<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json; charset=utf-8');

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

// Get campaign ID
$campaign_id = isset($_POST['campaign_id']) ? intval($_POST['campaign_id']) : 0;

if(empty($campaign_id)) {
    $values['response'] = 2;
    $values['msg'] = 'Missing campaign ID';
    echo json_encode($values);
    exit;
}

try {
    // Get campaign details
    $query = "SELECT id, name, subject, content, content_type, status, total_recipients, recipient_type, sent_date, emails_sent
              FROM email_campaigns
              WHERE id = $campaign_id";
    $result = $db->sql_query($query);

    if(!$result || $db->sql_numrows($result) == 0) {
        $values['response'] = 2;
        $values['msg'] = 'Campaign not found or access denied';
        echo json_encode($values);
        exit;
    }

    $campaign = $db->sql_fetchrow($result);

    // Check if campaign was recently sent (within last 5 minutes)
    if($campaign['status'] == 'sent' && $campaign['sent_date']) {
        $recent_send_check = "SELECT TIMESTAMPDIFF(MINUTE, sent_date, NOW()) as minutes_ago
                             FROM email_campaigns
                             WHERE id = $campaign_id";
        $recent_result = $db->sql_query($recent_send_check);

        if($recent_result) {
            $recent_row = $db->sql_fetchrow($recent_result);
            if($recent_row['minutes_ago'] < 5) {
                $values['response'] = 2;
                $values['msg'] = 'Campaign was already sent ' . $recent_row['minutes_ago'] . ' minutes ago. Please wait before resending.';
                echo json_encode($values);
                exit;
            }
        }
    }

    // Check if campaign can be sent
    if($campaign['status'] !== 'draft' && $campaign['status'] !== 'sending') {
        $values['response'] = 2;
        $values['msg'] = 'Only draft campaigns can be sent. Current status: ' . $campaign['status'];
        echo json_encode($values);
        exit;
    }

    // Additional check for already sent campaigns
    if($campaign['status'] == 'sent' && $campaign['emails_sent'] > 0) {
        $values['response'] = 2;
        $values['msg'] = 'Campaign already sent to ' . $campaign['emails_sent'] . ' subscribers on ' . $campaign['sent_date'] . '. Reset to draft first if you want to resend.';
        echo json_encode($values);
        exit;
    }

    // Update campaign status to sending
    $update_query = "UPDATE email_campaigns
                     SET status = 'sending',
                         sent_date = '" . date('Y-m-d H:i:s') . "',
                         updated_date = '" . date('Y-m-d H:i:s') . "'
                     WHERE id = $campaign_id";

    if($db->sql_query($update_query)) {

        // Log activity
        $action = "Started sending email campaign: " . $campaign['name'];
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client)
                      VALUES ($user_id_2, '" . date('Y-m-d H:i:s') . "', '" . addslashes($action) . "',
                      '" . $_SERVER['REMOTE_ADDR'] . "', '', '')";
        $db->sql_query($log_query);

        // In a real implementation, you would:
        // 1. Queue the emails for sending
        // 2. Process recipients in batches
        // 3. Handle email delivery
        // 4. Update sent counts and status

        // Check if SMTP is configured before sending
        if(!isset($smtp_configured) || !$smtp_configured) {
            $values['response'] = 2;
            $values['msg'] = 'SMTP is not properly configured. Please check your email settings.';
            echo json_encode($values);
            exit;
        }

        // Fetch active subscribers (basic recipient handling for now)
        $subscribers_query = "SELECT id, email, name FROM email_subscribers WHERE status = 'active'";
        $subscribers_result = $db->sql_query($subscribers_query);

        $sent_count = 0;
        $failed_count = 0;
        $error_details = array();

        if($subscribers_result && $db->sql_numrows($subscribers_result) > 0) {
            while($subscriber = $db->sql_fetchrow($subscribers_result)) {
                $recipient_email = $subscriber['email'];
                $recipient_name = !empty($subscriber['name']) ? $subscriber['name'] : $subscriber['email'];

                // Prepare email body with basic placeholder replacement
                $body = $campaign['content'];
                $website_url = $db->base_url();
                $unsubscribe_url = $website_url . 'unsubscribe?email=' . urlencode($recipient_email);

                $body = str_replace(
                    array('{name}', '{email}', '{website_url}', '{unsubscribe_url}'),
                    array($recipient_name, $recipient_email, $website_url, $unsubscribe_url),
                    $body
                );

                // Determine content type
                $is_html = ($campaign['content_type'] === 'html') ? true : false;

                if(!$is_html) {
                    // For plain text emails, convert line breaks to HTML
                    $body = nl2br(htmlspecialchars($body));
                    // But still send as HTML for better rendering
                    $is_html = true;
                }
                // If content_type is 'html', $body already contains HTML, so don't modify it

                $result = sendEmailWithSMTP($recipient_email, $recipient_name, $campaign['subject'], $body, $is_html);

                if($result) {
                    $sent_count++;
                    // Update subscriber stats
                    $db->sql_query(
                        "UPDATE email_subscribers
                         SET last_email_sent = '" . date('Y-m-d H:i:s') . "',
                             email_count = email_count + 1
                         WHERE id = " . intval($subscriber['id'])
                    );
                } else {
                    $failed_count++;
                    $error_details[] = "Failed to send to: " . $recipient_email;

                    // Log the failure
                    error_log("Email send failed for campaign {$campaign_id} to {$recipient_email}");
                }

                // Add small delay between sends to prevent spam flags
                if(($sent_count + $failed_count) > 1) {
                    usleep(500000); // 0.5 second delay
                }
            }
        }

        // Finalize campaign status and stats
        $total_recipients = $sent_count + $failed_count;
        $final_status = ($sent_count > 0) ? 'sent' : 'draft';
        $sent_date = ($sent_count > 0) ? "'" . date('Y-m-d H:i:s') . "'" : "NULL";

        $complete_query = "UPDATE email_campaigns
                          SET status = '$final_status',
                              emails_sent = " . intval($sent_count) . ",
                              emails_failed = " . intval($failed_count) . ",
                              total_recipients = " . intval($total_recipients) . ",
                              updated_date = '" . date('Y-m-d H:i:s') . "',
                              sent_date = $sent_date
                          WHERE id = $campaign_id";
        $db->sql_query($complete_query);

        // Log the activity
        $action = "Sent email campaign '" . $campaign['name'] . "' (ID: $campaign_id) - Sent: $sent_count, Failed: $failed_count";
        $log_query = "INSERT INTO activity_logs (user_id, date, action, ipaddress, device_os, device_client)
                      VALUES ($user_id_2, '" . date('Y-m-d H:i:s') . "', '" . addslashes($action) . "',
                      '" . $_SERVER['REMOTE_ADDR'] . "', '', '')";
        $db->sql_query($log_query);

        if($sent_count > 0) {
            $values['response'] = 1;
            $values['msg'] = "✅ Campaign '" . $campaign['name'] . "' sent successfully to " . number_format($sent_count) . " subscribers." . ($failed_count > 0 ? " Failed: " . number_format($failed_count) : "");
        } else {
            $values['response'] = 2;
            $values['msg'] = "❌ No emails were sent. Check your subscriber list and SMTP configuration.";
        }

        // Include error details if there were failures
        if($failed_count > 0 && !empty($error_details)) {
            $values['error_details'] = array_slice($error_details, 0, 5); // Limit to first 5 errors
        }

    } else {
        $values['response'] = 2;
        $values['msg'] = 'Failed to send campaign. Database error: ' . $db->sql_error();
    }

} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['response'] = 2;
    $values['msg'] = 'Fatal Error: ' . $e->getMessage();
}

echo json_encode($values, JSON_UNESCAPED_UNICODE);
?>

