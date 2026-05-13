<script>
// Real-time session tracking for view-user page
var sessionUpdateInterval;
var username = null;

function startRealtimeTracking(user) {
    username = user;
    updateSessionData();
    
    // Update every 5 seconds
    sessionUpdateInterval = setInterval(function() {
        updateSessionData();
    }, 5000);
}

function stopRealtimeTracking() {
    if (sessionUpdateInterval) {
        clearInterval(sessionUpdateInterval);
    }
}

function updateSessionData() {
    if (!username) return;
    
    $.ajax({
        url: '{$base_url}api/get_user_session.php',
        type: 'GET',
        data: { username: username },
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                // Update online status
                if (response.is_online) {
                    $('#user-online-status').html('<span class="badge badge-success"><i class="fas fa-circle"></i> Online</span>');
                } else {
                    $('#user-online-status').html('<span class="badge badge-secondary"><i class="fas fa-circle"></i> Offline</span>');
                }
                
                // Update remaining time
                if (response.remaining_time) {
                    $('#user-remaining-time').text(response.remaining_time.formatted);
                    
                    // Update individual time components if elements exist
                    if ($('#user-days').length) $('#user-days').text(response.remaining_time.days);
                    if ($('#user-hours').length) $('#user-hours').text(response.remaining_time.hours);
                    if ($('#user-minutes').length) $('#user-minutes').text(response.remaining_time.minutes);
                    if ($('#user-seconds').length) $('#user-seconds').text(response.remaining_time.seconds);
                } else {
                    $('#user-remaining-time').html('<span class="text-danger">Expired</span>');
                }
                
                // Update active address
                if (response.active_address && $('#user-active-address').length) {
                    $('#user-active-address').text(response.active_address);
                }
                
                // Update usage statistics
                if (response.usage_24h && $('#user-usage-24h').length) {
                    $('#user-usage-24h').text(response.usage_24h.connections + ' connections');
                }
                
                // Update last connection
                if (response.usage_24h && response.usage_24h.last_connection && $('#user-last-connection').length) {
                    $('#user-last-connection').text(response.usage_24h.last_connection);
                }
            }
        },
        error: function() {
            // Silent error handling
        }
    });
}

// Auto-start tracking when page loads
$(document).ready(function() {
    // Get username from page data attribute or hidden field
    var pageUsername = $('#user-data-username').val() || $('#user-data-username').data('username');
    if (pageUsername) {
        startRealtimeTracking(pageUsername);
    }
});

// Stop tracking when leaving page
$(window).on('beforeunload', function() {
    stopRealtimeTracking();
});
</script>
