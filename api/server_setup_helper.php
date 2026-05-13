<?php
// Helper script to generate server setup commands
error_reporting(E_ALL);
ini_set('display_errors', '1');
require_once '../includes/functions.php';

if (!isset($_GET['server_ip'])) {
    die('Server IP required');
}

$server_ip = $db->Sanitize(trim($_GET['server_ip']));

// Get server details
$server_query = $db->sql_query("SELECT * FROM server_list WHERE server_ip = '$server_ip' LIMIT 1");
$server = $db->sql_fetchrow($server_query);

if (!$server) {
    die('Server not found');
}

header('Content-Type: text/plain');

echo "#!/bin/bash\n";
echo "# Server Monitoring Setup Script\n";
echo "# Generated: " . date('Y-m-d H:i:s') . "\n";
echo "# Server: {$server['server_name']} ({$server_ip})\n\n";

// Create database config file
echo "# Create database configuration\n";
echo "cat > /etc/.db-base << 'EOF'\n";
echo "HOST='{$DB_ip}'\n";
echo "USER='{$DB_user}'\n";
echo "PASS='{$DB_pass}'\n";
echo "DB='{$DB_name}'\n";
echo "EOF\n\n";

echo "chmod 600 /etc/.db-base\n\n";

// Also create in /root for compatibility
echo "cp /etc/.db-base /root/.db-base\n";
echo "chmod 600 /root/.db-base\n\n";

// Download monitor script
echo "# Download monitoring script\n";
echo "wget -q -O /etc/.monitor 'https://gitlab.com/dextereskalarte/Mtk-dev/-/raw/main/monitorz'\n";
echo "chmod +x /etc/.monitor\n\n";

// Determine service type
$protocol = $server['protocol'] ?? '1';
$service_map = array(
    '1' => 'openvpn',
    '2' => 'openconnect',
    '4' => 'openvpn',
    '5' => 'aio',
    '7' => 'xray',
    '8' => 'openvpn',
    '9' => 'openconnect',
    '13' => 'aio',
    '31' => 'xray',
    '41' => 'hysteria',
    '42' => 'hysteria',
    '51' => 'socksip',
    '91' => 'ssh',
    '81' => 'ssh'
);

$service_type = $service_map[$protocol] ?? 'openvpn';

// Set up cron job
echo "# Set up cron job for monitoring\n";
echo "(crontab -l 2>/dev/null; echo \"* * * * * /bin/bash /etc/.monitor $service_type >/dev/null 2>&1\") | crontab -\n\n";

// Restart cron
echo "# Restart cron service\n";
echo "systemctl restart cron || service cron restart\n\n";

// Test monitor script
echo "# Test monitor script\n";
echo "bash /etc/.monitor $service_type\n\n";

echo "echo 'Monitoring setup complete!'\n";
echo "echo 'Monitor script will run every minute'\n";
echo "echo 'Check /etc/.db-base for database configuration'\n";
