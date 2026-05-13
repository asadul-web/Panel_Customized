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
	$serverip = $_GET['server_ip'];
	
	$sql = "SELECT * FROM server_list WHERE server_ip='$serverip' LIMIT 1";
    $qry = $db->sql_query("$sql") OR die();
	$row = $db->sql_fetchrow($qry);
	
	$server_protocol = $row['protocol'];
	$server_tcp = $row['port_tcp'];
	$server_udp = $row['port_udp'];
	
	// Hardcoded SSH credentials (no database dependency)
	$server_user = 'azimaxus';
	$server_pass = 'azim.0987Aa';
	$connection = ssh2_connect($serverip, 22);
	$authenticate = ssh2_auth_password($connection, $server_user, $server_pass);
	
	$valid = true;
	
	if(!$connection){
        $errormsg[] = '<li>Maybe your server is down or Wrong server information!</li>';
        $valid = false;
    }
        
    if(!$authenticate){
        $errormsg[] = '<li>Server authentication failed!</li>';
        $valid = false;
    }
    
	if($valid){
	    $freq = "$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )";
 		$cname = "$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )";
 		$_nf = "'{";
 		$nf = 'print $2" "$3" "$4" "$5';
 		$nf_ = "}'";
 		$up= "$(uptime -p|awk $_nf$nf$nf_)";
 		$uptime_= "$(uptime -p)";
 		$tram= "$( free -m | awk 'NR==2 {print $3}' )";
 		$tram2= "$( free -m | awk 'NR==2 {print $2}' )";
 		$diskused= "$( df -h / | awk 'NR==2 {print $3}' )";
 		$disktotal= "$( df -h / | awk 'NR==2 {print $2}' )";
 		$diskpercentage= "$( df -h / | awk 'NR==2 {print $5}' )";
        $status_text_stunnel4= '$(echo "$(systemctl show stunnel4.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
        if($server_protocol == "1" || $server_protocol == "2" || $server_protocol == "4" || $server_protocol == "5"){
            $status_text_squid3= '$(echo "$(systemctl show squid3.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
        }else{
            $status_text_squid3= '$(echo "$(systemctl show squid.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
        }
 		$distro="$(lsb_release -a | grep 'Description:' | cut -f2)";
 		$HTTPSTAT="$(pgrep -f socks)"; 
 		
 		if($server_protocol == "1" || $server_protocol == "4" || $server_protocol == "8" || $server_protocol == "11"){
 		    $proto = 'OPENVPN';
 		    $status_tcp = '$(echo "$(systemctl show openvpn@server2.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
 		    $status_udp = '$(echo "$(systemctl show openvpn@server.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
 		}elseif($server_protocol == "2" || $server_protocol == "5" || $server_protocol == "9" || $server_protocol == "12"){
 		    $proto = 'OPENCONNECT';
 		    $status_tcp = '$(echo "$(systemctl show ocserv.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
 		    $status_udp = '$(echo "$(systemctl show ocserv.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
 		}elseif($server_protocol == "15"){
 		    $proto = 'UDP SERVER';
 		    $status_tcp = 'NA';
 		    $status_udp = '$(echo "$(systemctl show hysteria-server.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
 		}elseif($server_protocol == "99"){
 		    $proto = 'ULTIMATE ALL';
 		    $status_tcp = '$(echo "$(systemctl show openvpn@server2.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
 		    $status_udp = '$(echo "$(systemctl show openvpn@server.service --no-page)" | grep "ActiveState=" | cut -f2 -d=)';
 		}else{
 		    
 		}
 		
 		$sqlx = "SELECT active_address FROM users WHERE active_address='$serverip'";
        $qryx = $db->sql_query("$sqlx") OR die();
	    $xserv_total = $db->sql_numrows($qryx);
	    
	    $stream = ssh2_exec($connection, '
                    ISP=$(timeout 3 curl -s ipinfo.io/org | cut -d " " -f 2-10 || echo "Unknown" )
                    COUNTRY=$(timeout 3 curl -s ipinfo.io/country || echo "Unknown" )
                    CITY=$(timeout 3 curl -s ipinfo.io/city || echo "Unknown" )
                    WKT=$(cat /etc/timezone 2>/dev/null || echo "Unknown" )
                    DISTRO='.$distro.';
                    IPVPS=$(timeout 3 curl -s ipinfo.io/ip || echo "'.$serverip.'" )
                    HTTPSTAT='.$HTTPSTAT.'
                	cname='.$cname.'
                	cores=$( awk -F: "/model name/ {core++} END {print core}" /proc/cpuinfo )
                	freq='.$freq.'
                	tram='.$tram.';
                	tram2='.$tram2.';
                	dskused='.$diskused.';
                	dsktotal='.$disktotal.';
                	dskpercent='.$diskpercentage.';
                	swap=$( free -m | awk "NR==3 {print $2}" )
                	up='.$up.';
                	stunnel4='.$status_text_stunnel4.';
                	squid3='.$status_text_squid3.';
                	stat_tcp='.$status_tcp.';
                	stat_udp='.$status_udp.';
                	rx_band=$(cat /sys/class/net/eth0/statistics/rx_bytes 2>/dev/null || cat /sys/class/net/ens*/statistics/rx_bytes 2>/dev/null || echo "0" );
                	tx_band=$(cat /sys/class/net/eth0/statistics/tx_bytes 2>/dev/null || cat /sys/class/net/ens*/statistics/tx_bytes 2>/dev/null || echo "0" );
                    
                    echo "|"
                	echo "CPU MODEL : $cname|"
                	echo "CPU CORES : $cores core/s|"
                	echo "CPU FREQUENCY : $freq MHz|"
                	echo "DISTRO : $DISTRO|"
                	echo "MEMORY : $tram MB / $tram2 MB|"
                	echo "UPTIME : $up|"
                	echo "TIMEZONE : $WKT|"
                	echo "ISP : $ISP|"
                	echo "LOCATION : $CITY, $COUNTRY|"
                	echo "$IPVPS|"
                	echo "$stunnel4|"
                	echo "$squid3|"
                	echo "HTTP STATUS: $HTTPSTAT|"
                	echo "$stat_tcp|"
                	echo "DISK : $dskused / $dsktotal ($dskpercent)|"
                	echo "$stat_udp|"
                	echo "$rx_band|"
                	echo "$tx_band|"');
                	
        if($stream){
            stream_set_blocking($stream, true);
     		$stream_out = ssh2_fetch_stream($stream, SSH2_STREAM_STDIO);
     		$csvReportString = stream_get_contents($stream_out);
     		    
     		$dataArr = explode('|',$csvReportString);
            for($i = 0; $i < count($dataArr); $i++){
                ${'var'.$i} = $dataArr[$i];
            }
            
            if($dataArr){
                $bandwidth = $var17 + $var18;
                $tot_bandwidth = $bandwidth / 1000000;
                
                if($server_protocol == "15"){
                    $socksstatus = 'NA';
                }else{
                    if($var13 == ''){
                        $socksstatus = 'inactive';
                    }else{
                        $socksstatus = 'active';
                    }
                }
                $values['cpu_model'] = $var1;
                $values['cpu_cores'] = $var2;
                $values['cpu_frequency'] = $var3;
                $values['distro'] = $var4;
                $values['memory'] = $var5;
                $values['uptime'] = strtoupper($var6);
                $values['disk'] = $var15;
                $values['bandwidth'] = 'BANDWIDTH : '.formatBytes($bandwidth).'';
                $values['os'] = 'OS : LINUX';
                $values['timezone'] = $var7;
                $values['isp'] = $var8;
                $values['proto'] = 'SERVICE : '.$proto.' PROTOCOL';
                $values['location'] = $var9;
                $values['ipaddress'] = 'IP : '.$serverip.'';
                if($server_protocol == "15"){
                    $values['tcpssl'] = 'TCP_SSL_PORT : 443 - NA';
                    $values['udpssl'] = 'UDP_SSL_PORT : 444 - NA';
                }else{
                    $values['tcpssl'] = 'TCP_SSL_PORT : 443 - '.strtoupper($var11).'';
                    $values['udpssl'] = 'UDP_SSL_PORT : 444 - '.strtoupper($var11).'';
                }
                $values['squid3'] = 'SQUID_PORT : 8080 - '.strtoupper($var12).'';;
                $values['httpstatus'] = 'SOCKET_PORT : 80 - '.strtoupper($socksstatus).'';
                $values['tcp_status'] = 'TCP_PORT : '.$server_tcp.' - '.strtoupper($var14).'';
                $values['udp_status'] = 'UDP_PORT : '.$server_udp.' - '.strtoupper($var16).'';
                $values['total_connected'] = 'USERS : '.$xserv_total.'';
                $values['response'] = 1;
     		}else{
     		    $error_message = 'Failed getting data!';
                $values['response'] = 2;
                $values['msg'] = $error_message;
     		}
        }else{
            $error_message = 'Failed getting data!';
            $values['response'] = 2;
            $values['msg'] = $error_message;
        }
	}else{
	    $values['response'] = 3;
        $errors = implode('',$errormsg);
        $values['errormsg'] = $errors;
	}
	echo json_encode($values);
}
?>
