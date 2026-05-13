<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../../includes/functions.php';
chkSession();
$values = array();
if($user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'){
}else{
	echo "<script> swal({ title: 'Error!' , text: 'Sorry, you dont have permission to access this page.', button: false, closeOnClickOutside: false, icon: 'error' })  </script>";
	$db->RedirectToURL($db->base_url());
	exit;
}

if(!isset($_GET['server_ip']) || empty($_GET['server_ip'])){
	echo '<script>alert("Error");</script>';
	$db->RedirectToURL($db->base_url());
	exit;	
}else{
	$serverip = strip_tags(trim($_GET['server_ip']));
	
	$valid = true;
    
    if($valid){
        
        $query = $db->sql_query("SELECT * FROM server_list WHERE server_ip='$serverip'");
        $row = $db->sql_fetchrow($query);
     		
     		// Initialize XRAY variables to prevent undefined variable errors
     		$xray_tls = '';
     		$xray_ntls = '';
     		$vmess_link = '';
     		$vless_link = '';
     		$trojan_link = '';
     		$ss_link = '';
     		
     		if($row['proto'] == 'aio' || $row['protocol'] == '99'){
     		    $proto = ($row['protocol'] == '99') ? 'ultimate' : 'openvpn';
     		    $online_ssh = strtoupper($row['ssh_online']);
     		    
     		     		//XRAY STATUS - Modern Card Design
     		$xray_status_class = ($row['xray_status'] == 'active') ? 'success' : 'danger';
     		$xray_status_icon = ($row['xray_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$xray_port_display = (!empty($row['xray_port']) && $row['xray_port'] != '0') ? $row['xray_port'] : '8444';
     		$xray = '
     		<div class="protocol-status-card protocol-card-'.$xray_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-paper-plane"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">XRAY VLESS</div>
     		        <div class="protocol-port">Port: '.strtoupper($xray_port_display).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$xray_status_class.'">
     		        <i class="fas '.$xray_status_icon.'"></i>
     		        <span>'.strtoupper($row['xray_status']).'</span>
     		    </div>
     		</div>';
     		$xray_status = $xray;
     		
     		//XRAY TLS STATUS - Modern Card Design
     		$xraytls_status_class = ($row['xray_status'] == 'active') ? 'success' : 'danger';
     		$xraytls_status_icon = ($row['xray_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$xray_tls_port = (!empty($row['xray_tls']) && $row['xray_tls'] != '0') ? $row['xray_tls'] : '8444';
     		$xraytls = '
     		<div class="protocol-status-card protocol-card-'.$xraytls_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-certificate"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">XRAY TLS</div>
     		        <div class="protocol-port">Port: '.strtoupper($xray_tls_port).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$xraytls_status_class.'">
     		        <i class="fas '.$xraytls_status_icon.'"></i>
     		        <span>'.strtoupper($row['xray_status']).'</span>
     		    </div>
     		</div>';
     		$xray_tls = $xraytls;
         		
         		//XRAY NTLS STATUS - Modern Card Design
         		$xrayntls_status_class = ($row['xray_status'] == 'active') ? 'success' : 'danger';
         		$xrayntls_status_icon = ($row['xray_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
         		$xray_ntls_port = (!empty($row['xray_ntls']) && $row['xray_ntls'] != '0') ? $row['xray_ntls'] : '8444';
         		$xrayntls = '
         		<div class="protocol-status-card protocol-card-'.$xrayntls_status_class.'">
         		    <div class="protocol-icon">
         		        <i class="fas fa-stream"></i>
         		    </div>
         		    <div class="protocol-info">
         		        <div class="protocol-name">XRAY Non-TLS</div>
         		        <div class="protocol-port">Port: '.strtoupper($xray_ntls_port).'</div>
         		    </div>
         		    <div class="protocol-status status-'.$xrayntls_status_class.'">
         		        <i class="fas '.$xrayntls_status_icon.'"></i>
         		        <span>'.strtoupper($row['xray_status']).'</span>
         		    </div>
         		</div>';
         		$xray_ntls = $xrayntls;
         		
         		// XRAY Configuration Links with URL Display
         		$vmess_filename = !empty($row['xray_vmess']) ? $row['xray_vmess'] : 'vmess_config';
         		$vless_filename = !empty($row['xray_vless']) ? $row['xray_vless'] : 'vless_config';
         		$trojan_filename = !empty($row['xray_trojan']) ? $row['xray_trojan'] : 'trojan_config';
         		$ss_filename = !empty($row['xray_ss']) ? $row['xray_ss'] : 'ss_config';
         		
         		$vmess_url = 'https://'.$serverip.':81/'.$vmess_filename.'.txt';
         		$vless_url = 'https://'.$serverip.':81/'.$vless_filename.'.txt';
         		$trojan_url = 'https://'.$serverip.':81/'.$trojan_filename.'.txt';
         		$ss_url = 'https://'.$serverip.':81/'.$ss_filename.'.txt';
         		
         		$vmess_link = '
         		<div class="xray-config-card">
         		    <div class="xray-config-header">
         		        <i class="fas fa-paper-plane"></i> VMESS Configuration
         		    </div>
         		    <div class="xray-config-url">
         		        <code>'.$vmess_url.'</code>
         		    </div>
         		    <a href="'.$vmess_url.'" class="btn btn-primary btn-block" target="_blank">
         		        <i class="fas fa-external-link-alt"></i> Open VMESS Details
         		    </a>
         		</div>';
         		
         		$vless_link = '
         		<div class="xray-config-card">
         		    <div class="xray-config-header">
         		        <i class="fas fa-shield-alt"></i> VLESS Configuration
         		    </div>
         		    <div class="xray-config-url">
         		        <code>'.$vless_url.'</code>
         		    </div>
         		    <a href="'.$vless_url.'" class="btn btn-success btn-block" target="_blank">
         		        <i class="fas fa-external-link-alt"></i> Open VLESS Details
         		    </a>
         		</div>';
         		
         		$trojan_link = '
         		<div class="xray-config-card">
         		    <div class="xray-config-header">
         		        <i class="fas fa-horse-head"></i> Trojan Configuration
         		    </div>
         		    <div class="xray-config-url">
         		        <code>'.$trojan_url.'</code>
         		    </div>
         		    <a href="'.$trojan_url.'" class="btn btn-warning btn-block" target="_blank">
         		        <i class="fas fa-external-link-alt"></i> Open Trojan Details
         		    </a>
         		</div>';
         		
         		$ss_link = '
         		<div class="xray-config-card">
         		    <div class="xray-config-header">
         		        <i class="fas fa-user-secret"></i> Shadowsocks Configuration
         		    </div>
         		    <div class="xray-config-url">
         		        <code>'.$ss_url.'</code>
         		    </div>
         		    <a href="'.$ss_url.'" class="btn btn-info btn-block" target="_blank">
         		        <i class="fas fa-external-link-alt"></i> Open Shadowsocks Details
         		    </a>
         		</div>';
         		
     		    //SSH STATUS - Modern Card Design
     		$ssh_status_class = ($row['ssh_status'] == 'active') ? 'success' : 'danger';
     		$ssh_status_icon = ($row['ssh_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$ssh = '
     		<div class="protocol-status-card protocol-card-'.$ssh_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-terminal"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">SSH</div>
     		        <div class="protocol-port">Port: '.strtoupper($row['ssh_port']).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$ssh_status_class.'">
     		        <i class="fas '.$ssh_status_icon.'"></i>
     		        <span>'.strtoupper($row['ssh_status']).'</span>
     		    </div>
     		</div>';
     		$ssh_status = $ssh;
     		    
     		     		//SLOWDNS STATUS - Modern Card Design
     		$slowdns_status_class = ($row['slowdns_status'] == 'active') ? 'success' : 'danger';
     		$slowdns_status_icon = ($row['slowdns_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$slowdns = '
     		<div class="protocol-status-card protocol-card-'.$slowdns_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-cloud"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">SlowDNS</div>
     		        <div class="protocol-port">Port: '.strtoupper($row['slowdns_port']).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$slowdns_status_class.'">
     		        <i class="fas '.$slowdns_status_icon.'"></i>
     		        <span>'.strtoupper($row['slowdns_status']).'</span>
     		    </div>
     		</div>';
     		$slowdns_status = $slowdns;
         		
         		//DROPBEAR STATUS - Modern Card Design
         		$dropbear_status_class = ($row['dropbear_status'] == 'active') ? 'success' : 'danger';
         		$dropbear_status_icon = ($row['dropbear_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
         		$dropbear = '
         		<div class="protocol-status-card protocol-card-'.$dropbear_status_class.'">
         		    <div class="protocol-icon">
         		        <i class="fas fa-lock"></i>
         		    </div>
         		    <div class="protocol-info">
         		        <div class="protocol-name">Dropbear</div>
         		        <div class="protocol-port">Port: '.strtoupper($row['dropbear_port']).'</div>
         		    </div>
         		    <div class="protocol-status status-'.$dropbear_status_class.'">
         		        <i class="fas '.$dropbear_status_icon.'"></i>
         		        <span>'.strtoupper($row['dropbear_status']).'</span>
         		    </div>
         		</div>';
         		$dropbear_status = $dropbear;
     		    $info = '<a href="http://'.$serverip.':5623/server.txt" class="btn btn-primary btn-block" target=blank_>SERVER INFO</a>';
     		}elseif($row['proto'] == 'openvpn'){
     		    $proto = 'openvpn';
     		    $online_ssh = 'NOT APPLICABLE';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'openssh'){
     		    $proto = 'openssh';
     		    $online_ssh = strtoupper($row['ssh_online']);
     		    
     		     		//SSH STATUS - Modern Card Design
     		$ssh_status_class = ($row['ssh_status'] == 'active') ? 'success' : 'danger';
     		$ssh_status_icon = ($row['ssh_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$ssh = '
     		<div class="protocol-status-card protocol-card-'.$ssh_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-terminal"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">SSH</div>
     		        <div class="protocol-port">Port: '.strtoupper($row['ssh_port']).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$ssh_status_class.'">
     		        <i class="fas '.$ssh_status_icon.'"></i>
     		        <span>'.strtoupper($row['ssh_status']).'</span>
     		    </div>
     		</div>';
     		$ssh_status = $ssh;
     		    
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'openconnect'){
     		    $proto = 'openconnect';
     		    $online_ssh = '';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'xray'){
     		    
     		     		//XRAY TLS STATUS - Modern Card Design
     		$xraytls_status_class = ($row['xray_status'] == 'active') ? 'success' : 'danger';
     		$xraytls_status_icon = ($row['xray_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$xray_tls_port = (!empty($row['xray_tls']) && $row['xray_tls'] != '0') ? $row['xray_tls'] : '8444';
     		$xraytls = '
     		<div class="protocol-status-card protocol-card-'.$xraytls_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-certificate"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">XRAY TLS</div>
     		        <div class="protocol-port">Port: '.strtoupper($xray_tls_port).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$xraytls_status_class.'">
     		        <i class="fas '.$xraytls_status_icon.'"></i>
     		        <span>'.strtoupper($row['xray_status']).'</span>
     		    </div>
     		</div>';
     		$xray_tls = $xraytls;
         		
         		//XRAY NTLS STATUS - Modern Card Design
         		$xrayntls_status_class = ($row['xray_status'] == 'active') ? 'success' : 'danger';
         		$xrayntls_status_icon = ($row['xray_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
         		$xray_ntls_port = (!empty($row['xray_ntls']) && $row['xray_ntls'] != '0') ? $row['xray_ntls'] : '8444';
         		$xrayntls = '
         		<div class="protocol-status-card protocol-card-'.$xrayntls_status_class.'">
         		    <div class="protocol-icon">
         		        <i class="fas fa-stream"></i>
         		    </div>
         		    <div class="protocol-info">
         		        <div class="protocol-name">XRAY Non-TLS</div>
         		        <div class="protocol-port">Port: '.strtoupper($xray_ntls_port).'</div>
         		    </div>
         		    <div class="protocol-status status-'.$xrayntls_status_class.'">
         		        <i class="fas '.$xrayntls_status_icon.'"></i>
         		        <span>'.strtoupper($row['xray_status']).'</span>
         		    </div>
         		</div>';
         		$xray_ntls = $xrayntls;
         		
         		$vmess_link = '<a href="https://'.$serverip.':81/'.$row['xray_vmess'].'.txt" class="btn btn-primary btn-block" target=blank_>VMESS DETAILS</a>';
         		$vless_link = '<a href="https://'.$serverip.':81/'.$row['xray_vless'].'.txt" class="btn btn-primary btn-block" target=blank_>VLESS DETAILS</a>';
         		$trojan_link = '<a href="https://'.$serverip.':81/'.$row['xray_trojan'].'.txt" class="btn btn-primary btn-block" target=blank_>TROJAN DETAILS</a>';
         		$ss_link = '<a href="https://'.$serverip.':81/'.$row['xray_ss'].'.txt" class="btn btn-primary btn-block" target=blank_>SHADOWSOCKS DETAILS</a>';
         		
     		    $proto = 'xray';
     		    $online_ssh = '';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'hysteria'){
     		    $proto = 'hysteria';
     		    $online_ssh = '';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'socksip'){
     		    $proto = 'socksip';
     		    $online_ssh = '';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'ssh'){
     		    $proto = 'ssh';
     		    $online_ssh = '';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    
     		    //SSH STATUS - Modern Card Design
     		    $ssh_status_class = ($row['ssh_status'] == 'active') ? 'success' : 'danger';
     		    $ssh_status_icon = ($row['ssh_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		    $ssh = '
     		    <div class="protocol-status-card protocol-card-'.$ssh_status_class.'">
     		        <div class="protocol-icon">
     		            <i class="fas fa-terminal"></i>
     		        </div>
     		        <div class="protocol-info">
     		            <div class="protocol-name">SSH</div>
     		            <div class="protocol-port">Port: '.strtoupper($row['ssh_port']).'</div>
     		        </div>
     		        <div class="protocol-status status-'.$ssh_status_class.'">
     		            <i class="fas '.$ssh_status_icon.'"></i>
     		            <span>'.strtoupper($row['ssh_status']).'</span>
     		        </div>
     		    </div>';
     		    $ssh_status = $ssh;
         		
         		//DROPBEAR STATUS - Modern Card Design
         		$dropbear_status_class = ($row['dropbear_status'] == 'active') ? 'success' : 'danger';
         		$dropbear_status_icon = ($row['dropbear_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
         		$dropbear = '
         		<div class="protocol-status-card protocol-card-'.$dropbear_status_class.'">
         		    <div class="protocol-icon">
         		        <i class="fas fa-key"></i>
         		    </div>
         		    <div class="protocol-info">
         		        <div class="protocol-name">Dropbear</div>
         		        <div class="protocol-port">Port: '.strtoupper($row['dropbear_port']).'</div>
         		    </div>
         		    <div class="protocol-status status-'.$dropbear_status_class.'">
         		        <i class="fas '.$dropbear_status_icon.'"></i>
         		        <span>'.strtoupper($row['dropbear_status']).'</span>
         		    </div>
         		</div>';
         		$dropbear_status = $dropbear;
     		    $info = '<a href="http://'.$serverip.':5623/server.txt" class="btn btn-primary btn-block" target=blank_>SERVER INFO</a>';
     		}elseif($row['proto'] == 'ubuntu_wireguard' || $row['proto'] == 'debian_wireguard'){
     		    // WireGuard Native UDP
     		    $proto = 'WireGuard UDP';
     		    $online_ssh = 'NOT APPLICABLE';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'ubuntu_wireguard_ws'){
     		    // WireGuard over WebSocket
     		    $proto = 'WireGuard WebSocket';
     		    $online_ssh = 'NOT APPLICABLE';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'ubuntu_wireguard_tls'){
     		    // WireGuard over TLS
     		    $proto = 'WireGuard TLS';
     		    $online_ssh = 'NOT APPLICABLE';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'ubuntu_wireguard_tcp'){
     		    // WireGuard over TCP
     		    $proto = 'WireGuard TCP';
     		    $online_ssh = 'NOT APPLICABLE';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'ubuntu_wireguard_multi' || $row['proto'] == 'debian_wireguard_multi'){
     		    // WireGuard Multi-Tunnel
     		    $proto = 'WireGuard Multi-Tunnel';
     		    $online_ssh = 'NOT APPLICABLE';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'wireguard_ultimate'){
     		    // WireGuard Ultimate 17 Protocols
     		    $proto = 'WireGuard Ultimate';
     		    $online_ssh = 'NOT APPLICABLE';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}elseif($row['proto'] == 'vpn_ultimate_all'){
     		    // iPhone VPN - All Protocols
     		    $proto = 'iPhone VPN (All Protocols)';
     		    $online_ssh = 'NOT APPLICABLE';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}else{
     		    $proto = 'unknown';
     		    $online_ssh = '<span class="text-danger">NOT APPLICABLE</span>';
     		    $xray_status = '';
     		    $slowdns_status = '';
     		    $ssh_status = '';
     		    $dropbear_status = '';
     		    $info = '';
     		}
     		
     		$server_service = strtoupper('service : '.$proto.' protocol');
     		$server_ip = strtoupper('ip address : '.$row['server_ip'].'');
     		$connected_ovpn = strtoupper($proto.' users : '.$row['online'].'');
     		$connected_hysteria = strtoupper('hysteria users : '.$row['hysteria_online'].'');
     		$connected_ssh = strtoupper('ssh users : '.$online_ssh.'');
     		$bandwidth = strtoupper('bandwidth : '.$row['bandwidth'].'');
     		$os = strtoupper('os : '.$row['os'].'');
     		$distro = strtoupper('distro : '.$row['distro'].'');
     		$cpu_model = strtoupper('cpu model : '.$row['cpu_model'].'');
     		$memory = strtoupper('memory : '.$row['memory'].'');
     		$disk = strtoupper('disk : '.$row['disk'].'');
     		$uptime = strtoupper('uptime : '.$row['uptime'].'');
     		
     		
     		//HYSTERIA STATUS - Modern Card Design
     		$status_class = ($row['hysteria_status'] == 'active') ? 'success' : 'danger';
     		$status_icon = ($row['hysteria_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$hysteria_udp = '
     		<div class="protocol-status-card protocol-card-'.$status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-bolt"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">Hysteria UDP</div>
     		        <div class="protocol-port">Port: '.strtoupper($row['hysteria_port']).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$status_class.'">
     		        <i class="fas '.$status_icon.'"></i>
     		        <span>'.strtoupper($row['hysteria_status']).'</span>
     		    </div>
     		</div>';
     		$hysteria_status = $hysteria_udp;
     		
     		//OVPN TCP STATUS - Modern Card Design
     		$tcp_status_class = ($row['tcp_status'] == 'active') ? 'success' : 'danger';
     		$tcp_status_icon = ($row['tcp_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$protocol_name = 'OVPN TCP';
     		if($row['proto'] == 'openconnect'){
     		    $protocol_name = 'OCSERV TCP';
     		}
     		$ovpntcp = '
     		<div class="protocol-status-card protocol-card-'.$tcp_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-exchange-alt"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">'.$protocol_name.'</div>
     		        <div class="protocol-port">Port: '.strtoupper($row['tcp']).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$tcp_status_class.'">
     		        <i class="fas '.$tcp_status_icon.'"></i>
     		        <span>'.strtoupper($row['tcp_status']).'</span>
     		    </div>
     		</div>';
     		$ovpntcp_status = $ovpntcp;
     		
     		//OVPN UDP STATUS - Modern Card Design
     		$udp_status_class = ($row['udp_status'] == 'active') ? 'success' : 'danger';
     		$udp_status_icon = ($row['udp_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$protocol_name_udp = 'OVPN UDP';
     		$udp_port = $row['udp'];
     		if($row['proto'] == 'openconnect'){
     		    $protocol_name_udp = 'OCSERV UDP';
     		    $udp_port = $row['tcp'];
     		}
     		$ovpnudp = '
     		<div class="protocol-status-card protocol-card-'.$udp_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-network-wired"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">'.$protocol_name_udp.'</div>
     		        <div class="protocol-port">Port: '.strtoupper($udp_port).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$udp_status_class.'">
     		        <i class="fas '.$udp_status_icon.'"></i>
     		        <span>'.strtoupper($row['udp_status']).'</span>
     		    </div>
     		</div>';
     		$ovpnudp_status = $ovpnudp;
     		
     		//OVPN TCP SSL STATUS - Modern Card Design
     		$ssl_status_class = ($row['ssl_status'] == 'active') ? 'success' : 'danger';
     		$ssl_status_icon = ($row['ssl_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$ssl_protocol_name = 'OVPN TCP SSL';
     		$ssl_port = $row['tcpssl'];
     		if($row['proto'] == 'openconnect'){
     		    $ssl_protocol_name = 'OCSERV TCP SSL';
     		}elseif($row['proto'] == 'ssh'){
     		    $ssl_protocol_name = 'SSH/SSL WS';
     		    $ssl_port = '443';
     		}
     		$ovpntcpssl = '
     		<div class="protocol-status-card protocol-card-'.$ssl_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-lock"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">'.$ssl_protocol_name.'</div>
     		        <div class="protocol-port">Port: '.strtoupper($ssl_port).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$ssl_status_class.'">
     		        <i class="fas '.$ssl_status_icon.'"></i>
     		        <span>'.strtoupper($row['ssl_status']).'</span>
     		    </div>
     		</div>';
     		$ovpntcpssl_status = $ovpntcpssl;
     		
     		//OVPN UDP SSL STATUS - Modern Card Design
     		$udpssl_status_class = ($row['ssl_status'] == 'active') ? 'success' : 'danger';
     		$udpssl_status_icon = ($row['ssl_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
     		$udpssl_protocol_name = 'OVPN UDP SSL';
     		$udpssl_port = $row['udpssl'];
     		if($row['proto'] == 'openconnect'){
     		    $udpssl_protocol_name = 'OCSERV UDP SSL';
     		    $udpssl_port = $row['tcpssl'];
     		}
     		$ovpnudpssl = '
     		<div class="protocol-status-card protocol-card-'.$udpssl_status_class.'">
     		    <div class="protocol-icon">
     		        <i class="fas fa-shield-alt"></i>
     		    </div>
     		    <div class="protocol-info">
     		        <div class="protocol-name">'.$udpssl_protocol_name.'</div>
     		        <div class="protocol-port">Port: '.strtoupper($udpssl_port).'</div>
     		    </div>
     		    <div class="protocol-status status-'.$udpssl_status_class.'">
     		        <i class="fas '.$udpssl_status_icon.'"></i>
     		        <span>'.strtoupper($row['ssl_status']).'</span>
     		    </div>
     		</div>';
     		$ovpnudpssl_status = $ovpnudpssl;
            
            //SQUID PROXY STATUS - Modern Card Design
            $squid_status_class = ($row['squid_status'] == 'active') ? 'success' : 'danger';
            $squid_status_icon = ($row['squid_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
            $squid = '
            <div class="protocol-status-card protocol-card-'.$squid_status_class.'">
                <div class="protocol-icon">
                    <i class="fas fa-globe"></i>
                </div>
                <div class="protocol-info">
                    <div class="protocol-name">Squid Proxy</div>
                    <div class="protocol-port">Port: '.strtoupper($row['squid']).'</div>
                </div>
                <div class="protocol-status status-'.$squid_status_class.'">
                    <i class="fas '.$squid_status_icon.'"></i>
                    <span>'.strtoupper($row['squid_status']).'</span>
                </div>
            </div>';
            $squid_status = $squid;
            
            //SOCKET PROXY STATUS - Modern Card Design
            $socket_status_class = ($row['socket_status'] == 'active') ? 'success' : 'danger';
            $socket_status_icon = ($row['socket_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
            $socks = '
            <div class="protocol-status-card protocol-card-'.$socket_status_class.'">
                <div class="protocol-icon">
                    <i class="fas fa-plug"></i>
                </div>
                <div class="protocol-info">
                    <div class="protocol-name">WebSocket Proxy</div>
                    <div class="protocol-port">Port: '.strtoupper($row['socket']).'</div>
                </div>
                <div class="protocol-status status-'.$socket_status_class.'">
                    <i class="fas '.$socket_status_icon.'"></i>
                    <span>'.strtoupper($row['socket_status']).'</span>
                </div>
            </div>';
            $socket_status = $socks;
            
            //SOCKSIP STATUS - Modern Card Design
            $socksip_status_class = ($row['socksip_status'] == 'active') ? 'success' : 'danger';
            $socksip_status_icon = ($row['socksip_status'] == 'active') ? 'fa-check-circle' : 'fa-times-circle';
            $socksip = '
            <div class="protocol-status-card protocol-card-'.$socksip_status_class.'">
                <div class="protocol-icon">
                    <i class="fas fa-project-diagram"></i>
                </div>
                <div class="protocol-info">
                    <div class="protocol-name">SocksIP</div>
                    <div class="protocol-port">Port: '.strtoupper($row['socksip_port']).'</div>
                </div>
                <div class="protocol-status status-'.$socksip_status_class.'">
                    <i class="fas '.$socksip_status_icon.'"></i>
                    <span>'.strtoupper($row['socksip_status']).'</span>
                </div>
            </div>';
            $socksip_status = $socksip;
     		
     		// Modern card-based statistics design
     		$values['proto'] = '
     		<div class="stats-info-card stats-card-primary">
     		    <div class="stats-info-icon">
     		        <i class="fas fa-network-wired"></i>
     		    </div>
     		    <div class="stats-info-content">
     		        <div class="stats-info-label">Service Protocol</div>
     		        <div class="stats-info-value">'.strtoupper($proto).'</div>
     		    </div>
     		</div>';
     		
     		$values['ipaddress'] = '
     		<div class="stats-info-card stats-card-info">
     		    <div class="stats-info-icon">
     		        <i class="fas fa-server"></i>
     		    </div>
     		    <div class="stats-info-content">
     		        <div class="stats-info-label">IP Address</div>
     		        <div class="stats-info-value">'.$row['server_ip'].'</div>
     		    </div>
     		</div>';
     		
     		if($row['proto'] == 'hysteria' || $row['proto'] == 'socksip' || $row['proto'] == 'ssh'){
     		    $values['total_connected'] = '';
     		}else{
     		    $values['total_connected'] = '<div class="form-group"><span class="form-control" tabindex="1" readonly><b>'.$connected_ovpn.'</b></span></div>';
     		}
     		
     		if($row['proto'] == 'xray' || $row['proto'] == 'socksip' || $row['proto'] == 'ssh'){
     		    $values['total_hysteria'] = '';
     		}else{
     		    $values['total_hysteria'] = '<div class="form-group"><span class="form-control" tabindex="1" readonly><b>'.$connected_hysteria.'</b></div>';
     		}
     		
     		if($row['proto'] == 'openvpn' || $row['proto'] == 'openconnect' || $row['proto'] == 'unknown'){
     		    $values['total_ssh'] = '';
     		    $values['ssh_status'] = '';
     		    $values['dropbear_status'] = '';
     		    $values['slowdns_status'] = '';
     		    $values['xray_status'] = '';
     		    $values['xray_tls'] = '';
     		    $values['xray_ntls'] = '';
     		    $values['svrinfo'] = '';
     		    $values['vmess_link'] = '';
     		    $values['vless_link'] = '';
     		    $values['trojan_link'] = '';
     		    $values['ss_link'] = '';
     		}elseif($row['proto'] == 'aio' || $row['protocol'] == '99'){
     		    $values['total_ssh'] = '<div class="form-group"><span class="form-control" tabindex="1" readonly><b>'.$connected_ssh.'</b></span></div>';
     		    $values['ssh_status'] = $ssh_status;
     		    $values['dropbear_status'] = $dropbear_status;
     		    $values['slowdns_status'] = $slowdns_status;
     		    $values['xray_status'] = $xray_status;
     		    $values['xray_tls'] = $xray_tls;
     		    $values['xray_ntls'] = $xray_ntls;
     		    $values['svrinfo'] = $info;
     		    $values['vmess_link'] = $vmess_link;
     		    $values['vless_link'] = $vless_link;
     		    $values['trojan_link'] = $trojan_link;
     		    $values['ss_link'] = $ss_link;
     		}elseif($row['proto'] == 'xray'){
     		    $values['total_ssh'] = '';
     		    $values['ssh_status'] = '';
     		    $values['dropbear_status'] = '';
     		    $values['slowdns_status'] = '';
     		    $values['xray_status'] = '';
     		    $values['xray_tls'] = $xray_tls;
     		    $values['xray_ntls'] = $xray_ntls;
     		    
     		    $values['svrinfo'] = '';
     		    $values['vmess_link'] = $vmess_link;
     		    $values['vless_link'] = $vless_link;
     		    $values['trojan_link'] = $trojan_link;
     		    $values['ss_link'] = $ss_link;
     		}elseif($row['proto'] == 'hysteria'){
     		    $values['total_ssh'] = '';
     		    $values['ssh_status'] = '';
     		    $values['dropbear_status'] = '';
     		    $values['slowdns_status'] = '';
     		    $values['xray_status'] = '';
     		    $values['xray_tls'] = '';
     		    $values['xray_ntls'] = '';
     		    
     		    $values['svrinfo'] = '';
     		    $values['vmess_link'] = '';
     		    $values['vless_link'] = '';
     		    $values['trojan_link'] = '';
     		    $values['ss_link'] = '';
     		}elseif($row['proto'] == 'socksip'){
     		    $values['total_ssh'] = '';
     		    $values['ssh_status'] = '';
     		    $values['dropbear_status'] = '';
     		    $values['slowdns_status'] = '';
     		    $values['xray_status'] = '';
     		    $values['xray_tls'] = '';
     		    $values['xray_ntls'] = '';
     		    
     		    $values['svrinfo'] = '';
     		    $values['vmess_link'] = '';
     		    $values['vless_link'] = '';
     		    $values['trojan_link'] = '';
     		    $values['ss_link'] = '';
     		}elseif($row['proto'] == 'ssh'){
     		    $values['total_ssh'] = '<div class="form-group"><span class="form-control" tabindex="1" readonly><b>'.$connected_ssh.'</b></span></div>';
     		    $values['ssh_status'] = $ssh_status;
     		    $values['dropbear_status'] = $dropbear_status;
     		    $values['slowdns_status'] = '';
     		    $values['xray_status'] = '';
     		    $values['xray_tls'] = '';
     		    $values['xray_ntls'] = '';
     		    $values['svrinfo'] = '';
     		    $values['vmess_link'] = '';
     		    $values['vless_link'] = '';
     		    $values['trojan_link'] = '';
     		    $values['ss_link'] = '';
     		}elseif($row['proto'] == 'WireGuard UDP' || $row['proto'] == 'WireGuard WebSocket' || $row['proto'] == 'WireGuard TLS' || $row['proto'] == 'WireGuard TCP' || $row['proto'] == 'WireGuard Multi-Tunnel' || $row['proto'] == 'WireGuard Ultimate'){
     		    // WireGuard protocols
     		    $values['total_ssh'] = '';
     		    $values['ssh_status'] = '';
     		    $values['dropbear_status'] = '';
     		    $values['slowdns_status'] = '';
     		    $values['xray_status'] = '';
     		    $values['xray_tls'] = '';
     		    $values['xray_ntls'] = '';
     		    $values['svrinfo'] = '';
     		    $values['vmess_link'] = '';
     		    $values['vless_link'] = '';
     		    $values['trojan_link'] = '';
     		    $values['ss_link'] = '';
     		}elseif($row['proto'] == 'iPhone VPN (All Protocols)'){
     		    // iPhone VPN - All Protocols
     		    $values['total_ssh'] = '';
     		    $values['ssh_status'] = '';
     		    $values['dropbear_status'] = '';
     		    $values['slowdns_status'] = '';
     		    $values['xray_status'] = '';
     		    $values['xray_tls'] = '';
     		    $values['xray_ntls'] = '';
     		    $values['svrinfo'] = '';
     		    $values['vmess_link'] = '';
     		    $values['vless_link'] = '';
     		    $values['trojan_link'] = '';
     		    $values['ss_link'] = '';
     		}
     		
     		$values['bandwidth'] = '
     		<div class="stats-info-card stats-card-success">
     		    <div class="stats-info-icon"><i class="fas fa-tachometer-alt"></i></div>
     		    <div class="stats-info-content">
     		        <div class="stats-info-label">Bandwidth</div>
     		        <div class="stats-info-value">'.$row['bandwidth'].'</div>
     		    </div>
     		</div>';
     		
     		$values['distro'] = '
     		<div class="stats-info-card stats-card-warning">
     		    <div class="stats-info-icon"><i class="fab fa-linux"></i></div>
     		    <div class="stats-info-content">
     		        <div class="stats-info-label">Distribution</div>
     		        <div class="stats-info-value">'.$row['distro'].'</div>
     		    </div>
     		</div>';
     		
     		$values['cpu_model'] = '
     		<div class="stats-info-card stats-card-danger">
     		    <div class="stats-info-icon"><i class="fas fa-microchip"></i></div>
     		    <div class="stats-info-content">
     		        <div class="stats-info-label">CPU Model</div>
     		        <div class="stats-info-value">'.$row['cpu_model'].'</div>
     		    </div>
     		</div>';
     		
     		$values['memory'] = '
     		<div class="stats-info-card stats-card-purple">
     		    <div class="stats-info-icon"><i class="fas fa-memory"></i></div>
     		    <div class="stats-info-content">
     		        <div class="stats-info-label">Memory</div>
     		        <div class="stats-info-value">'.$row['memory'].'</div>
     		    </div>
     		</div>';
     		
            $values['disk'] = '
            <div class="stats-info-card stats-card-info">
                <div class="stats-info-icon"><i class="fas fa-hdd"></i></div>
                <div class="stats-info-content">
                    <div class="stats-info-label">Disk Space</div>
                    <div class="stats-info-value">'.$row['disk'].'</div>
                </div>
            </div>';
            
            $values['uptime'] = '
            <div class="stats-info-card stats-card-success">
                <div class="stats-info-icon"><i class="fas fa-clock"></i></div>
                <div class="stats-info-content">
                    <div class="stats-info-label">Uptime</div>
                    <div class="stats-info-value">'.$row['uptime'].'</div>
                </div>
            </div>';
            
            if($row['proto'] == 'xray'){
                $values['tcp_status'] = '';
                $values['udp_status'] = '';
                $values['tcpssl'] = '';
                $values['udpssl'] = '';
                $values['httpstatus'] = '';
                $values['hysteria_status'] = '';
                $values['socksip_status'] = '';
                $values['squid3'] = $squid_status;
            }elseif($row['proto'] == 'socksip'){
                $values['tcp_status'] = '';
                $values['udp_status'] = '';
                $values['tcpssl'] = '';
                $values['udpssl'] = '';
                $values['httpstatus'] = '';
                $values['hysteria_status'] = '';
                $values['socksip_status'] = $socksip_status;
                $values['squid3'] = '';
            }elseif($row['proto'] == 'ssh'){
                $values['tcp_status'] = '';
                $values['udp_status'] = '';
                $values['tcpssl'] = $ovpntcpssl_status;
                $values['udpssl'] = '';
                $values['httpstatus'] = $socket_status;
                $values['hysteria_status'] = '';
                $values['socksip_status'] = '';
                $values['squid3'] = $squid_status;
            }elseif($row['proto'] == 'WireGuard UDP'){
                // WireGuard Native UDP - Port 51820
                $wg_udp_status = '
                <div class="protocol-status-card protocol-card-success">
                    <div class="protocol-icon"><i class="fas fa-shield-alt"></i></div>
                    <div class="protocol-info">
                        <div class="protocol-name">WireGuard UDP</div>
                        <div class="protocol-port">Port: 51820</div>
                    </div>
                    <div class="protocol-status status-success">
                        <i class="fas fa-check-circle"></i>
                        <span>ACTIVE</span>
                    </div>
                </div>';
                $values['tcp_status'] = '';
                $values['udp_status'] = $wg_udp_status;
                $values['tcpssl'] = '';
                $values['udpssl'] = '';
                $values['httpstatus'] = '';
                $values['hysteria_status'] = '';
                $values['socksip_status'] = '';
                $values['squid3'] = '';
            }elseif($row['proto'] == 'WireGuard WebSocket' || $row['proto'] == 'WireGuard TLS' || $row['proto'] == 'WireGuard TCP' || $row['proto'] == 'WireGuard Multi-Tunnel' || $row['proto'] == 'WireGuard Ultimate'){
                // WireGuard variants with multiple ports
                $wg_multi_status = '
                <div class="protocol-status-card protocol-card-success">
                    <div class="protocol-icon"><i class="fas fa-shield-alt"></i></div>
                    <div class="protocol-info">
                        <div class="protocol-name">'.$row['proto'].'</div>
                        <div class="protocol-port">Multiple Ports</div>
                    </div>
                    <div class="protocol-status status-success">
                        <i class="fas fa-check-circle"></i>
                        <span>ACTIVE</span>
                    </div>
                </div>';
                $values['tcp_status'] = $wg_multi_status;
                $values['udp_status'] = '';
                $values['tcpssl'] = '';
                $values['udpssl'] = '';
                $values['httpstatus'] = '';
                $values['hysteria_status'] = '';
                $values['socksip_status'] = '';
                $values['squid3'] = '';
            }elseif($row['proto'] == 'iPhone VPN (All Protocols)'){
                // iPhone VPN - All Protocols Display
                $iphone_protocols = '
                <div class="protocol-status-card protocol-card-success">
                    <div class="protocol-icon"><i class="fab fa-apple"></i></div>
                    <div class="protocol-info">
                        <div class="protocol-name">WireGuard</div>
                        <div class="protocol-port">Port: 51820/UDP</div>
                    </div>
                    <div class="protocol-status status-success">
                        <i class="fas fa-check-circle"></i>
                        <span>ACTIVE</span>
                    </div>
                </div>
                <div class="protocol-status-card protocol-card-success">
                    <div class="protocol-icon"><i class="fas fa-key"></i></div>
                    <div class="protocol-info">
                        <div class="protocol-name">IKEv2/IPSec</div>
                        <div class="protocol-port">Port: 500,4500/UDP</div>
                    </div>
                    <div class="protocol-status status-success">
                        <i class="fas fa-check-circle"></i>
                        <span>ACTIVE</span>
                    </div>
                </div>
                <div class="protocol-status-card protocol-card-success">
                    <div class="protocol-icon"><i class="fas fa-lock"></i></div>
                    <div class="protocol-info">
                        <div class="protocol-name">L2TP/IPSec</div>
                        <div class="protocol-port">Port: 1701/UDP</div>
                    </div>
                    <div class="protocol-status status-success">
                        <i class="fas fa-check-circle"></i>
                        <span>ACTIVE</span>
                    </div>
                </div>
                <div class="protocol-status-card protocol-card-success">
                    <div class="protocol-icon"><i class="fas fa-shield-alt"></i></div>
                    <div class="protocol-info">
                        <div class="protocol-name">Cisco IPSec</div>
                        <div class="protocol-port">Port: 500,4500/UDP</div>
                    </div>
                    <div class="protocol-status status-success">
                        <i class="fas fa-check-circle"></i>
                        <span>ACTIVE</span>
                    </div>
                </div>
                <div class="protocol-status-card protocol-card-success">
                    <div class="protocol-icon"><i class="fas fa-network-wired"></i></div>
                    <div class="protocol-info">
                        <div class="protocol-name">OpenVPN</div>
                        <div class="protocol-port">Port: 1194/UDP,TCP</div>
                    </div>
                    <div class="protocol-status status-success">
                        <i class="fas fa-check-circle"></i>
                        <span>ACTIVE</span>
                    </div>
                </div>';
                $values['tcp_status'] = $iphone_protocols;
                $values['udp_status'] = '';
                $values['tcpssl'] = '';
                $values['udpssl'] = '';
                $values['httpstatus'] = '';
                $values['hysteria_status'] = '';
                $values['socksip_status'] = '';
                $values['squid3'] = '';
            }else{
                $values['tcp_status'] = $ovpntcp_status;
                $values['udp_status'] = $ovpnudp_status;
                $values['tcpssl'] = $ovpntcpssl_status;
                $values['udpssl'] = $ovpnudpssl_status;
                
                if($row['proto'] == 'hysteria'){
                    $values['httpstatus'] = '';
                }else{
                    $values['httpstatus'] = $socket_status;
                }
                $values['socksip_status'] = '';
                $values['hysteria_status'] = $hysteria_status;
                $values['squid3'] = $squid_status;
            }
            
            $values['response'] = 1;
        
    }
    
    echo json_encode($values);
}

?>
