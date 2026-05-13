<?php
/**
 * Firebase Configuration for Ruzain VPN
 * Project: ruzain-vpn-bd889
 */

// Firebase Project Configuration
define('FIREBASE_PROJECT_ID', 'ruzain-vpn-bd889');
define('FIREBASE_PROJECT_NUMBER', '329050539134');
define('FIREBASE_STORAGE_BUCKET', 'ruzain-vpn-bd889.firebasestorage.app');

// Firebase Cloud Messaging
define('FIREBASE_SERVER_KEY', 'AIzaSyAZdq5EZd5VzhPPMJ7jFxhnMnog4GPf-z8');
define('FIREBASE_SENDER_ID', '329050539134');

// Firebase Web Push (VAPID)
define('FIREBASE_VAPID_KEY', 'BMgmmQq5ks7INaHvzBp8g1C_EatCZg7tp1nCmojvRrKGDrx4SriGNyzoAhM9_xDCPW1TsTYPbJPxO524ia_tEiQ');

// Android App Configuration
define('FIREBASE_ANDROID_APP_ID', '1:329050539134:android:89a7266e101cfe7ffe442f');
define('FIREBASE_ANDROID_PACKAGE', 'com.ruzainvpn.apps');

// FCM Topics
define('FCM_TOPIC_ALL_USERS', '/topics/all_users');
define('FCM_TOPIC_PREMIUM_USERS', '/topics/premium_users');
define('FCM_TOPIC_TRIAL_USERS', '/topics/trial_users');
define('FCM_TOPIC_ANNOUNCEMENTS', '/topics/announcements');

// FCM API Endpoint
define('FCM_API_URL', 'https://fcm.googleapis.com/fcm/send');

/**
 * Get Firebase Configuration as Array
 */
function getFirebaseConfig() {
    return [
        'project_id' => FIREBASE_PROJECT_ID,
        'project_number' => FIREBASE_PROJECT_NUMBER,
        'storage_bucket' => FIREBASE_STORAGE_BUCKET,
        'server_key' => FIREBASE_SERVER_KEY,
        'sender_id' => FIREBASE_SENDER_ID,
        'vapid_key' => FIREBASE_VAPID_KEY,
        'android_app_id' => FIREBASE_ANDROID_APP_ID,
        'android_package' => FIREBASE_ANDROID_PACKAGE,
        'api_url' => FCM_API_URL
    ];
}

/**
 * Get Firebase Configuration as JSON
 */
function getFirebaseConfigJSON() {
    return json_encode(getFirebaseConfig(), JSON_PRETTY_PRINT);
}
?>
