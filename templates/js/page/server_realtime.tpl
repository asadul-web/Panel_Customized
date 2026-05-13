<script>
// Real-time server monitoring for server list page
var serverUpdateInterval;

function startServerRealtime() {
    updateServerOnline();
    
    // Update every 15 seconds
    serverUpdateInterval = setInterval(function() {
        updateServerOnline();
    }, 15000);
}

function stopServerRealtime() {
    if (serverUpdateInterval) {
        clearInterval(serverUpdateInterval);
    }
}

function updateServerOnline() {
    $.ajax({
        url: '{$base_url}api/get_online_users.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.success && response.servers) {
                response.servers.forEach(function(server) {
                    // Update online count in table
                    var serverRow = $('tr[data-server-ip="' + server.ip + '"]');
                    if (serverRow.length) {
                        // Update VPN online count
                        serverRow.find('.server-online-vpn').text(server.online);
                        
                        // Update Hysteria online count
                        serverRow.find('.server-online-hysteria').text(server.hysteria);
                        
                        // Update SSH online count
                        serverRow.find('.server-online-ssh').text(server.ssh);
                        
                        // Update total online count
                        serverRow.find('.server-online-total').text(server.total);
                        
                        // Update status indicator
                        if (server.total > 0) {
                            serverRow.find('.server-status-indicator')
                                .removeClass('badge-secondary')
                                .addClass('badge-success')
                                .html('<i class="fas fa-circle"></i> ' + server.total + ' Online');
                        } else {
                            serverRow.find('.server-status-indicator')
                                .removeClass('badge-success')
                                .addClass('badge-secondary')
                                .html('<i class="fas fa-circle"></i> Idle');
                        }
                    }
                });
                
                // Update last refresh time
                $('#last-refresh-time').text(new Date().toLocaleTimeString());
            }
        },
        error: function() {
            // Silent error handling
        }
    });
}

// Auto-start when server page loads
$(document).ready(function() {
    if ($('body').hasClass('server-page') || window.location.href.indexOf('server') > -1) {
        startServerRealtime();
    }
});

// Stop when leaving page
$(window).on('beforeunload', function() {
    stopServerRealtime();
});

// Manual refresh button
$(document).on('click', '#refresh-server-status', function() {
    updateServerOnline();
    $(this).html('<i class="fas fa-sync fa-spin"></i> Refreshing...');
    setTimeout(function() {
        $('#refresh-server-status').html('<i class="fas fa-sync"></i> Refresh');
    }, 1000);
});
</script>

<style>
.server-status-indicator {
    font-size: 0.875rem;
    padding: 0.25rem 0.5rem;
}

.server-online-count {
    font-weight: 600;
    color: #28a745;
}

#last-refresh-time {
    font-size: 0.75rem;
    color: #6c757d;
}
</style>
