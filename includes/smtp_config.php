<?php
// Gmail SMTP Configuration
$gmail_config = [
    'username' => 'vollamltd@gmail.com',  // Your Gmail address
    'app_password' => 'vckxapmxtauzfhuu',         // App Password (16 characters, no spaces)
    'from_name' => 'VPN Panel System',
    'smtp_host' => 'smtp.gmail.com',
    'smtp_port' => 587,
    'smtp_secure' => 'tls',
    'debug' => 2  // 0=off, 1=client messages, 2=client and server messages
];

// Check if required functions exist
if (!function_exists('fsockopen')) {
    $smtp_configured = false;
    $smtp_error = 'PHP function fsockopen() is required but not available. Please enable it in php.ini';
}
// Validate configuration
elseif (empty($gmail_config['username']) || empty($gmail_config['app_password'])) {
    $smtp_configured = false;
    $smtp_error = 'Gmail SMTP is not properly configured. Please check your username and app password.';
}
// Check if we can resolve the SMTP host
elseif (!gethostbyname($gmail_config['smtp_host'])) {
    $smtp_configured = false;
    $smtp_error = 'Could not resolve SMTP host: ' . $gmail_config['smtp_host'];
}
// Check if we can connect to the SMTP port
elseif (!@fsockopen($gmail_config['smtp_host'], $gmail_config['smtp_port'], $errno, $errstr, 5)) {
    $smtp_configured = false;
    $smtp_error = sprintf(
        'Could not connect to %s:%s - %s (%s)',
        $gmail_config['smtp_host'],
        $gmail_config['smtp_port'],
        $errstr,
        $errno
    );
}
// All checks passed
else {
    $smtp_configured = true;
    $smtp_error = '';
}

// Make configuration available globally
$GLOBALS['gmail_config'] = $gmail_config;
$GLOBALS['smtp_configured'] = $smtp_configured;
$GLOBALS['smtp_error'] = $smtp_error;
?>
