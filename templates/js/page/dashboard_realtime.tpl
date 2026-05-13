<script>
// Real-time dashboard updates for online users
var dashboardUpdateInterval;

function startDashboardRealtime() {
    updateDashboardOnline();
    
    // Update every 10 seconds
    dashboardUpdateInterval = setInterval(function() {
        updateDashboardOnline();
    }, 10000);
}

function stopDashboardRealtime() {
    if (dashboardUpdateInterval) {
        clearInterval(dashboardUpdateInterval);
    }
}

function updateDashboardOnline() {
    $.ajax({
        url: '{$base_url}api/get_online_users.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                // Update total online count
                if ($('#dashboard-online-count').length) {
                    $('#dashboard-online-count').text(response.grand_total);
                }
                
                // Update individual protocol counts
                if ($('#dashboard-online-vpn').length) {
                    $('#dashboard-online-vpn').text(response.total_online);
                }
                if ($('#dashboard-online-hysteria').length) {
                    $('#dashboard-online-hysteria').text(response.total_hysteria);
                }
                if ($('#dashboard-online-ssh').length) {
                    $('#dashboard-online-ssh').text(response.total_ssh);
                }
                
                // Update server list if element exists
                if ($('#dashboard-server-list').length && response.servers) {
                    var serverHtml = '';
                    response.servers.forEach(function(server) {
                        if (server.status == '1') {
                            var statusClass = server.total > 0 ? 'success' : 'secondary';
                            serverHtml += '<div class="server-item">';
                            serverHtml += '<span class="server-name">' + server.name + '</span>';
                            serverHtml += '<span class="badge badge-' + statusClass + '">' + server.total + ' online</span>';
                            serverHtml += '</div>';
                        }
                    });
                    $('#dashboard-server-list').html(serverHtml);
                }
                
                // Add pulsing animation to online indicator
                if (response.grand_total > 0) {
                    $('#dashboard-online-indicator').addClass('pulse-animation');
                } else {
                    $('#dashboard-online-indicator').removeClass('pulse-animation');
                }
            }
        },
        error: function() {
            // Silent error handling
        }
    });
}

// Auto-start when dashboard loads
$(document).ready(function() {
    if ($('body').hasClass('dashboard-page') || window.location.href.indexOf('dashboard') > -1) {
        startDashboardRealtime();
    }
});

// Stop when leaving page
$(window).on('beforeunload', function() {
    stopDashboardRealtime();
});
</script>

<style>
.pulse-animation {
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% {
        opacity: 1;
    }
    50% {
        opacity: 0.6;
    }
    100% {
        opacity: 1;
    }
}

.server-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
    border-bottom: 1px solid #eee;
}

.server-item:last-child {
    border-bottom: none;
}

.server-name {
    font-weight: 500;
}
</style>
