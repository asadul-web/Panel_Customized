#!/bin/bash
# VPN Server Online User Monitoring Script
# Reports online user counts to panel using /api/connected.php

# Load configuration
if [ -f /etc/.db-base ]; then
    source /etc/.db-base
elif [ -f /root/.db-base ]; then
    source /root/.db-base
elif [ -f /etc/openvpn/login/config.sh ]; then
    source /etc/openvpn/login/config.sh
else
    # Fallback - try to get from environment or use localhost
    PANEL_URL="${PANEL_URL:-http://localhost}"
fi

# Get server IP
SERVER_IP=$(curl -s https://api.ipify.org 2>/dev/null || wget -qO- https://api.ipify.org 2>/dev/null || hostname -I | awk '{print $1}')

# Count OpenVPN connections
count_openvpn() {
    local count=0
    
    # Check OpenVPN status files
    if [ -f /etc/openvpn/server/openvpn-status.log ]; then
        count=$(grep -c "^CLIENT_LIST" /etc/openvpn/server/openvpn-status.log 2>/dev/null || echo 0)
    elif [ -f /var/log/openvpn/status.log ]; then
        count=$(grep -c "^CLIENT_LIST" /var/log/openvpn/status.log 2>/dev/null || echo 0)
    elif [ -f /etc/openvpn/openvpn-status.log ]; then
        count=$(grep -c "^CLIENT_LIST" /etc/openvpn/openvpn-status.log 2>/dev/null || echo 0)
    fi
    
    # Alternative: count from process
    if [ "$count" -eq 0 ]; then
        count=$(ps aux | grep -c "openvpn.*client" 2>/dev/null || echo 0)
    fi
    
    echo $count
}

# Count SSH connections (excluding system users)
count_ssh() {
    local count=0
    
    # Count active SSH sessions (excluding root, azimaxus, and system users)
    count=$(who | grep -v "root\|azimaxus\|system" | wc -l 2>/dev/null || echo 0)
    
    # Alternative: count from MySQL if available
    if command -v mysql >/dev/null 2>&1 && [ -n "$HOST" ] && [ -n "$USER" ] && [ -n "$DBNAME" ]; then
        local db_count=$(mysql -u "$USER" -p"$PASS" -D "$DBNAME" -h "$HOST" -sN -e "SELECT COUNT(*) FROM users WHERE active_address != '' AND duration > 0 AND is_freeze = 0" 2>/dev/null || echo 0)
        if [ "$db_count" -gt "$count" ]; then
            count=$db_count
        fi
    fi
    
    echo $count
}

# Count Hysteria connections
count_hysteria() {
    local count=0
    
    # Check Hysteria status
    if systemctl is-active --quiet hysteria; then
        count=$(journalctl -u hysteria -n 100 --no-pager 2>/dev/null | grep -c "connection established" || echo 0)
    fi
    
    echo $count
}

# Count Xray connections
count_xray() {
    local count=0
    
    # Check Xray access log
    if [ -f /var/log/xray/access.log ]; then
        # Count unique IPs in last minute
        count=$(tail -n 1000 /var/log/xray/access.log 2>/dev/null | grep "accepted" | awk '{print $NF}' | sort -u | wc -l || echo 0)
    fi
    
    echo $count
}

# Main monitoring function
monitor_and_report() {
    # Get counts
    OPENVPN_COUNT=$(count_openvpn)
    SSH_COUNT=$(count_ssh)
    HYSTERIA_COUNT=$(count_hysteria)
    XRAY_COUNT=$(count_xray)
    
    # Total online (all protocols combined)
    TOTAL_ONLINE=$((OPENVPN_COUNT + SSH_COUNT + HYSTERIA_COUNT + XRAY_COUNT))
    
    # Log locally
    echo "$(date): OpenVPN=$OPENVPN_COUNT, SSH=$SSH_COUNT, Hysteria=$HYSTERIA_COUNT, Xray=$XRAY_COUNT, Total=$TOTAL_ONLINE" >> /var/log/monitor-online.log
    
    # Report to panel using /api/connected.php (simple API)
    if [ -n "$PANEL_URL" ] && [ -n "$SERVER_IP" ]; then
        # Use the simple connected.php API
        RESPONSE=$(curl -s "$PANEL_URL/api/connected.php?ip=$SERVER_IP&total=$TOTAL_ONLINE" 2>/dev/null)
        
        if [ "$RESPONSE" = "success" ]; then
            echo "$(date): Reported $TOTAL_ONLINE users to panel successfully" >> /var/log/monitor-online.log
        else
            echo "$(date): Failed to report to panel (Response: $RESPONSE)" >> /var/log/monitor-online.log
        fi
    else
        echo "$(date): PANEL_URL or SERVER_IP not configured" >> /var/log/monitor-online.log
    fi
}

# Run monitoring
monitor_and_report

# Keep log file size manageable (keep last 1000 lines)
if [ -f /var/log/monitor-online.log ]; then
    tail -n 1000 /var/log/monitor-online.log > /var/log/monitor-online.log.tmp
    mv /var/log/monitor-online.log.tmp /var/log/monitor-online.log
fi
