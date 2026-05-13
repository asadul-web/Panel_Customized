<?php
/**
 * Firebase Cloud Messaging (FCM) Helper
 * Sends push notifications to mobile apps
 */

class FCMHelper {
    private $serverKey;
    private $fcmUrl = 'https://fcm.googleapis.com/fcm/send';
    
    public function __construct($serverKey = null) {
        // Default Firebase Server Key for Ruzain VPN
        $this->serverKey = $serverKey ?: 'AIzaSyAZdq5EZd5VzhPPMJ7jFxhnMnog4GPf-z8';
    }
    
    /**
     * Send notification to all users (topic-based)
     */
    public function sendToAll($title, $message, $data = []) {
        return $this->sendNotification('/topics/all_users', $title, $message, $data);
    }
    
    /**
     * Send notification to specific user token
     */
    public function sendToUser($token, $title, $message, $data = []) {
        return $this->sendNotification($token, $title, $message, $data);
    }
    
    /**
     * Send notification to multiple users
     */
    public function sendToUsers($tokens, $title, $message, $data = []) {
        if (empty($tokens) || !is_array($tokens)) {
            return ['success' => false, 'error' => 'Invalid tokens'];
        }
        
        $notification = [
            'registration_ids' => $tokens,
            'notification' => [
                'title' => $title,
                'body' => $message,
                'sound' => 'default',
                'badge' => '1'
            ],
            'data' => array_merge([
                'title' => $title,
                'message' => $message,
                'timestamp' => time()
            ], $data),
            'priority' => 'high'
        ];
        
        return $this->sendRequest($notification);
    }
    
    /**
     * Core notification sender
     */
    private function sendNotification($to, $title, $message, $data = []) {
        $notification = [
            'to' => $to,
            'notification' => [
                'title' => $title,
                'body' => $message,
                'sound' => 'default',
                'badge' => '1',
                'click_action' => 'FLUTTER_NOTIFICATION_CLICK'
            ],
            'data' => array_merge([
                'title' => $title,
                'message' => $message,
                'timestamp' => time()
            ], $data),
            'priority' => 'high',
            'content_available' => true
        ];
        
        return $this->sendRequest($notification);
    }
    
    /**
     * Send HTTP request to FCM
     */
    private function sendRequest($payload) {
        $headers = [
            'Authorization: key=' . $this->serverKey,
            'Content-Type: application/json'
        ];
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->fcmUrl);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        
        $result = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);
        
        if ($error) {
            return [
                'success' => false,
                'error' => $error,
                'http_code' => $httpCode
            ];
        }
        
        $response = json_decode($result, true);
        
        return [
            'success' => ($httpCode == 200 && isset($response['success']) && $response['success'] > 0),
            'response' => $response,
            'http_code' => $httpCode,
            'raw' => $result
        ];
    }
    
    /**
     * Set Firebase Server Key
     */
    public function setServerKey($key) {
        $this->serverKey = $key;
    }
}
?>
