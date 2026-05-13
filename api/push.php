<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
ini_set('log_errors', '1');
ini_set('error_log', dirname(__DIR__) . '/logs/push_api.log');

// Log start
error_log("=== Push API Called at " . date('Y-m-d H:i:s') . " ===");
error_log("Request: " . $_SERVER['REQUEST_URI']);

require_once '../includes/functions.php';

// Check if required variables are loaded
error_log("Git Username: " . ($git_username ?? 'EMPTY'));
error_log("Git Token: " . (empty($git_token) ? 'EMPTY' : 'SET (length: ' . strlen($git_token) . ')'));
error_log("DB Config: IP=" . ($DB_ip ?? 'EMPTY') . ", User=" . ($DB_user ?? 'EMPTY') . ", Name=" . ($DB_name ?? 'EMPTY'));

if (empty($git_username) || empty($git_token)) {
    $error = 'GitHub configuration missing. Please configure GitHub settings in Developer Settings.';
    error_log("ERROR: " . $error);
    echo json_encode(['error' => $error]);
    exit;
}

if (empty($DB_ip) || empty($DB_user) || empty($DB_name)) {
    $error = 'Database configuration missing.';
    error_log("ERROR: " . $error);
    echo json_encode(['error' => $error]);
    exit;
}

// Use site_url if set, otherwise use github_repo
if (empty($site_url)) {
    $site_url = $git_repo ?? 'ruzain.com';
}

if(isset($_GET['ip']) && isset($_GET['service'])){
 	$port_tcp = strip_tags(trim($_GET['tcp'] ?? ''));
 	$port_udp = strip_tags(trim($_GET['udp'] ?? ''));
 	$port_ssl = strip_tags(trim($_GET['ssl'] ?? ''));
 	$port_vless = strip_tags(trim($_GET['vless'] ?? ''));
 	$obfs = strip_tags(trim($_GET['obfs'] ?? ''));
 	$authstr = strip_tags(trim($_GET['authstr'] ?? ''));
 	$hysteria = strip_tags(trim($_GET['hysteria'] ?? ''));
 	$service = strip_tags(trim($_GET['service']));
 	$serverip = strip_tags(trim($_GET['ip']));
    
    $SUB_DOMAIN = strip_tags(trim($_GET['subdomain'] ?? ''));
    $NS_DOMAIN = strip_tags(trim($_GET['nsdomain'] ?? ''));
    
 	if (empty($serverip) || empty($service)) {
    echo json_encode(['error' => 'Server IP or service type is missing.']);
    exit;
} else {
    $validServices = [
        'debian_aio', 'ubuntu_aio', 'ubuntu_ultimate',
        'debian_ovpn', 'debian_ovpnws',
        'debian_openconnect', 'debian_openconnectws',
        'ubuntu_ovpn', 'ubuntu_ovpnws',
        'ubuntu_openconnect', 'ubuntu_openconnectws',
        'centos_ovpn', 'centos_ovpnws',
        'debian_xray', 'ubuntu_xray',
        'debian_ssh', 'ubuntu_ssh',
        'debian_psiphon',
        'debian_hysteria', 'ubuntu_hysteria', 'centos_hysteria',
        'debian_hysteria_free', 'ubuntu_hysteria_free', 'centos_hysteria_free',
        'ubuntu_socksip', 'debian_socksip',
        'debian_zivpn', 'ubuntu_zivpn'
    ];
    
    // Enhanced database config setup function (injected into all scripts)
    $dbConfigSetup = PHP_EOL . "# Create database config for VPN panel integration" . PHP_EOL;
    $dbConfigSetup .= "mkdir -p /etc/xray /etc/firenet /root" . PHP_EOL;
    $dbConfigSetup .= "cat > /etc/.db-base << 'DBEOF'" . PHP_EOL;
    $dbConfigSetup .= "HOST='$DB_ip'" . PHP_EOL;
    $dbConfigSetup .= "USER='$DB_user'" . PHP_EOL;
    $dbConfigSetup .= "PASS='$DB_pass'" . PHP_EOL;
    $dbConfigSetup .= "DBNAME='$DB_name'" . PHP_EOL;
    $dbConfigSetup .= "API_KEY='azimaxus'" . PHP_EOL;
    $dbConfigSetup .= "PANEL_URL='$base_url'" . PHP_EOL;
    $dbConfigSetup .= "DB='$DB_name'" . PHP_EOL;
    $dbConfigSetup .= "DBEOF" . PHP_EOL;
    $dbConfigSetup .= "chmod 600 /etc/.db-base" . PHP_EOL;
    $dbConfigSetup .= "cp /etc/.db-base /root/.db-base" . PHP_EOL;
    $dbConfigSetup .= "cp /etc/.db-base /etc/xray/.db-base 2>/dev/null || true" . PHP_EOL;
    $dbConfigSetup .= "cp /etc/.db-base /etc/openvpn/login/config.sh 2>/dev/null || true" . PHP_EOL . PHP_EOL;
    
    // Add web server setup for server.txt
    $dbConfigSetup .= "# Setup web server for server info" . PHP_EOL;
    $dbConfigSetup .= "mkdir -p /var/www/html" . PHP_EOL;
    $dbConfigSetup .= "cat > /etc/systemd/system/serverinfo.service << 'SRVEOF'" . PHP_EOL;
    $dbConfigSetup .= "[Unit]" . PHP_EOL;
    $dbConfigSetup .= "Description=Server Info Web Server" . PHP_EOL;
    $dbConfigSetup .= "After=network.target" . PHP_EOL . PHP_EOL;
    $dbConfigSetup .= "[Service]" . PHP_EOL;
    $dbConfigSetup .= "Type=simple" . PHP_EOL;
    $dbConfigSetup .= "WorkingDirectory=/var/www/html" . PHP_EOL;
    $dbConfigSetup .= "ExecStart=/usr/bin/python3 -m http.server 5623" . PHP_EOL;
    $dbConfigSetup .= "Restart=always" . PHP_EOL;
    $dbConfigSetup .= "RestartSec=3" . PHP_EOL . PHP_EOL;
    $dbConfigSetup .= "[Install]" . PHP_EOL;
    $dbConfigSetup .= "WantedBy=multi-user.target" . PHP_EOL;
    $dbConfigSetup .= "SRVEOF" . PHP_EOL;
    $dbConfigSetup .= "systemctl daemon-reload" . PHP_EOL;
    $dbConfigSetup .= "systemctl enable serverinfo" . PHP_EOL;
    $dbConfigSetup .= "systemctl start serverinfo" . PHP_EOL . PHP_EOL;
    
    if (in_array($service, $validServices)) {
        $scriptContent  = "#!/bin/bash" . PHP_EOL;
        $scriptContent .= "# Script Variables" . PHP_EOL;
        $scriptContent .= "HOST='$DB_ip';" . PHP_EOL;
        $scriptContent .= "USER='$DB_user';" . PHP_EOL;
        $scriptContent .= "PASS='$DB_pass';" . PHP_EOL;
        $scriptContent .= "DBNAME='$DB_name';" . PHP_EOL;
        $scriptContent .= $dbConfigSetup;
        $scriptContent .= "PORT_TCP='$port_tcp';" . PHP_EOL;
        $scriptContent .= "PORT_UDP='$port_udp';" . PHP_EOL;
        $scriptContent .= "PORT_SSL='$port_ssl';" . PHP_EOL;
        $scriptContent .= "OBFS='$obfs';" . PHP_EOL;
        $scriptContent .= "HYSTERIA_TYPE='$hysteria';" . PHP_EOL;
        
        // Shared block for AIO and Ultimate services
        if (in_array($service, ['debian_aio', 'ubuntu_aio', 'ubuntu_ultimate', 'debian_zivpn', 'ubuntu_zivpn'])) {
            $scriptContent .= "API_LINK='https://$site_url/api/authentication';" . PHP_EOL;
            $scriptContent .= "API_KEY='azimaxus';" . PHP_EOL;
            $scriptContent .= "DOMAIN=$SUB_DOMAIN" . PHP_EOL;
            $scriptContent .= "NS=$NS_DOMAIN" . PHP_EOL;
        }
        
    } else {
        echo "Error: Unknown service type '$service'";
        exit;
    }
    
    // Download base script from GitHub (vollams/server_script/main branch)
    $download_url = "https://raw.githubusercontent.com/$git_username/server_script/main/$service";
    error_log("Downloading script from: " . $download_url);
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $download_url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    
    $headers = array();
    $headers[] = "Authorization: token $git_token";
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    
    $data = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    error_log("GitHub download HTTP code: " . $http_code);
    error_log("Downloaded data length: " . strlen($data ?? ''));
    
    if (curl_errno($ch)) {
        $error = 'Error: ' . curl_error($ch);
        error_log("cURL Error: " . $error);
        echo $error;
        curl_close ($ch);
        exit;
    }
    curl_close ($ch);
    
    if(empty($data) || $http_code != 200){
        $error = "Error: GitHub returned empty data or HTTP $http_code. Check if script exists at: $download_url";
        error_log($error);
        echo $error;
        exit;
    }
    
    error_log("Script downloaded successfully");
    
    // Combine DB config + base script
    $combinedScript = $scriptContent.$data;
    
    // Convert to Unix line endings (remove \r characters)
    $combinedScript = str_replace("\r\n", "\n", $combinedScript);
    $combinedScript = str_replace("\r", "\n", $combinedScript);
    
    // Encode for GitHub upload
    $contentScript = base64_encode($combinedScript);
        
    // Upload combined script to GitHub repository
    // pushFile params: username, token, repo (username/reponame), branch, filepath, base64content
    error_log("Attempting to push to GitHub...");
    error_log("Username: $git_username");
    error_log("Site URL: $site_url");
    error_log("Repo: $git_username/$site_url");
    error_log("Branch: server_script");
    error_log("File: $service");
    error_log("Script size: " . strlen($combinedScript) . " bytes");
    
    $result = pushFile("$git_username","$git_token","$git_username/$site_url","server_script","$service","$contentScript");
    
    error_log("Push result: " . ($result ? 'SUCCESS' : 'FAILED'));
    
    if($result){
        error_log("Successfully pushed to GitHub: https://github.com/$git_username/$site_url/blob/server_script/$service");
        echo 'Success';
    } else {
        error_log("ERROR: Failed to push to repository $git_username/$site_url");
        echo 'Error: Failed to push to repository';
    }
    
 	}
 }else{
 	echo json_encode(['error' => 'Request was denied. Missing required parameters.']);
}
?>
