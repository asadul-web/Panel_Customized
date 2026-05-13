<script>
$(document).ready(function() {
    
    // Initialize revenue chart
    var revenueChart;
    
    // Load revenue statistics
    function loadRevenueStats() {
        $.ajax({
            url: "{$base_url}serverside/data/get_revenue_stats.php",
            type: "GET",
            dataType: "JSON",
            success: function(data) {
                if(data.response == 1) {
                    $('.total-revenue').text('$' + data.total_revenue);
                    $('.today-revenue').text('$' + data.today_revenue);
                    $('.month-revenue').text('$' + data.month_revenue);
                    $('.active-apps').text(data.active_apps);
                    
                    // Update chart
                    updateRevenueChart(data.chart_data);
                    
                    // Update top apps
                    updateTopApps(data.top_apps);
                }
            }
        });
    }
    
    // Initialize DataTable for revenue by app
    $('#revenue-table').DataTable({
        "ajax": {
            "url": "{$base_url}serverside/data/get_revenue_by_app.php",
            "type": "GET",
            "dataSrc": "data"
        },
        "columns": [
            { "data": "app_name" },
            { "data": "package_name" },
            { 
                "data": "status",
                "render": function(data, type, row) {
                    var badgeClass = data === 'active' ? 'success' : (data === 'testing' ? 'warning' : 'danger');
                    return '<span class="badge badge-' + badgeClass + '">' + data.toUpperCase() + '</span>';
                }
            },
            { 
                "data": "total_revenue",
                "render": function(data, type, row) {
                    return '$' + parseFloat(data).toFixed(2);
                }
            },
            { 
                "data": "today_revenue",
                "render": function(data, type, row) {
                    return '$' + parseFloat(data).toFixed(2);
                }
            },
            { 
                "data": "month_revenue",
                "render": function(data, type, row) {
                    return '$' + parseFloat(data).toFixed(2);
                }
            },
            { "data": "last_updated" },
            { 
                "data": null,
                "render": function(data, type, row) {
                    return '<button class="btn btn-sm btn-info view-details" data-app="' + row.app_name + '">Details</button>';
                }
            }
        ],
        "responsive": true,
        "order": [[ 3, "desc" ]]
    });
    
    // Initialize DataTable for revenue history
    $('#revenue-history-table').DataTable({
        "ajax": {
            "url": "{$base_url}serverside/data/get_revenue_history.php",
            "type": "GET",
            "dataSrc": "data"
        },
        "columns": [
            { "data": "date" },
            { "data": "app_name" },
            { "data": "ad_type" },
            { 
                "data": "revenue",
                "render": function(data, type, row) {
                    return '$' + parseFloat(data).toFixed(2);
                }
            },
            { "data": "impressions" },
            { "data": "clicks" },
            { 
                "data": "ctr",
                "render": function(data, type, row) {
                    return parseFloat(data).toFixed(2) + '%';
                }
            }
        ],
        "responsive": true,
        "order": [[ 0, "desc" ]]
    });
    
    // Update revenue chart
    function updateRevenueChart(chartData) {
        var ctx = document.getElementById('revenue-chart').getContext('2d');
        
        if (revenueChart) {
            revenueChart.destroy();
        }
        
        revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: chartData.labels,
                datasets: [{
                    label: 'Revenue ($)',
                    data: chartData.data,
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value, index, values) {
                                return '$' + value;
                            }
                        }
                    }
                }
            }
        });
    }
    
    // Update top apps list
    function updateTopApps(topApps) {
        var html = '';
        topApps.forEach(function(app, index) {
            var rankClass = index === 0 ? 'success' : (index === 1 ? 'warning' : 'info');
            html += '<div class="d-flex justify-content-between align-items-center mb-3">' +
                    '<div>' +
                    '<span class="badge badge-' + rankClass + '">#' + (index + 1) + '</span> ' +
                    '<strong>' + app.app_name + '</strong>' +
                    '<br><small class="text-muted">' + app.package_name + '</small>' +
                    '</div>' +
                    '<div class="text-right">' +
                    '<strong>$' + parseFloat(app.revenue).toFixed(2) + '</strong>' +
                    '</div>' +
                    '</div>';
        });
        $('.top-apps-list').html(html);
    }
    
    // Apply filter
    $('#apply-filter').click(function() {
        var app = $('#filter-app').val();
        var period = $('#filter-period').val();
        
        $('#revenue-history-table').DataTable().ajax.url(
            "{$base_url}serverside/data/get_revenue_history.php?app=" + app + "&period=" + period
        ).load();
    });
    
    // View app details
    $(document).on('click', '.view-details', function() {
        var appName = $(this).data('app');
        
        $.ajax({
            url: "{$base_url}serverside/data/get_app_revenue_details.php",
            type: "GET",
            data: { app_name: appName },
            dataType: "JSON",
            success: function(data) {
                if(data.response == 1) {
                    var html = '<div class="row">' +
                               '<div class="col-md-6">' +
                               '<h6>Revenue Breakdown</h6>' +
                               '<ul class="list-unstyled">' +
                               '<li>Banner Ads: $' + data.banner_revenue + '</li>' +
                               '<li>Interstitial Ads: $' + data.interstitial_revenue + '</li>' +
                               '<li>Rewarded Ads: $' + data.rewarded_revenue + '</li>' +
                               '<li>Native Advanced Ads: $' + data.native_advanced_revenue + '</li>' +
                               '<li>App Open Ads: $' + data.app_open_revenue + '</li>' +
                               '</ul>' +
                               '</div>' +
                               '<div class="col-md-6">' +
                               '<h6>Performance Metrics</h6>' +
                               '<ul class="list-unstyled">' +
                               '<li>Total Impressions: ' + data.total_impressions + '</li>' +
                               '<li>Total Clicks: ' + data.total_clicks + '</li>' +
                               '<li>Average CTR: ' + data.average_ctr + '%</li>' +
                               '</ul>' +
                               '</div>' +
                               '</div>';
                    
                    Swal.fire({
                        title: appName + ' - Revenue Details',
                        html: html,
                        icon: "info",
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        width: '600px'
                    });
                }
            }
        });
    });
    
    // Load app options for filter
    function loadAppOptions() {
        $.ajax({
            url: "{$base_url}serverside/data/get_app_list.php",
            type: "GET",
            dataType: "JSON",
            success: function(data) {
                if(data.response == 1) {
                    var options = '<option value="">All Apps</option>';
                    data.apps.forEach(function(app) {
                        options += '<option value="' + app.app_name + '">' + app.app_name + '</option>';
                    });
                    $('#filter-app').html(options);
                }
            }
        });
    }
    
    // Clean history functionality
    function cleanRevenueHistory(action, description) {
        var appFilter = $('#filter-app').val();
        
        Swal.fire({
            title: 'Clean Revenue History',
            html: 'Are you sure you want to clean <strong>' + description + '</strong>?' + 
                  (appFilter ? '<br><small>This will only affect data for: <strong>' + appFilter + '</strong></small>' : 
                   '<br><small class="text-danger">This will affect data for ALL apps</small>'),
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#f39c12',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, clean it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: "{$base_url}serverside/forms/clean_revenue_history.php",
                    type: "POST",
                    data: {
                        action: action,
                        app_name: appFilter,
                        _key: "{$firenet_encrypt}"
                    },
                    dataType: "JSON",
                    beforeSend: function() {
                        Swal.fire({
                            title: 'Cleaning...',
                            text: 'Please wait while we clean the revenue history',
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });
                    },
                    success: function(data) {
                        if(data.response == 1) {
                            Swal.fire({
                                title: 'Success!',
                                html: data.msg,
                                icon: 'success',
                                confirmButtonColor: '#28a745'
                            }).then(() => {
                                // Refresh all data
                                loadRevenueStats();
                                $('#revenue-table').DataTable().ajax.reload();
                                $('#revenue-history-table').DataTable().ajax.reload();
                            });
                        } else {
                            Swal.fire({
                                title: 'Error!',
                                text: data.msg,
                                icon: 'error',
                                confirmButtonColor: '#dc3545'
                            });
                        }
                    },
                    error: function() {
                        Swal.fire({
                            title: 'Error!',
                            text: 'Failed to clean revenue history. Please try again.',
                            icon: 'error',
                            confirmButtonColor: '#dc3545'
                        });
                    }
                });
            }
        });
    }
    
    // Clean history button handlers
    $('#clean-history').click(function() {
        cleanRevenueHistory('clean_90_days', 'data older than 90 days');
    });
    
    $('#clean-30-days').click(function(e) {
        e.preventDefault();
        cleanRevenueHistory('clean_30_days', 'data older than 30 days');
    });
    
    $('#clean-90-days').click(function(e) {
        e.preventDefault();
        cleanRevenueHistory('clean_90_days', 'data older than 90 days');
    });
    
    $('#clean-1-year').click(function(e) {
        e.preventDefault();
        cleanRevenueHistory('clean_1_year', 'data older than 1 year');
    });
    
    $('#clean-all-history').click(function(e) {
        e.preventDefault();
        cleanRevenueHistory('clean_all', 'ALL revenue history data');
    });
    
    // Initialize page
    loadRevenueStats();
    loadAppOptions();
    
    // Auto refresh every 5 minutes
    setInterval(function() {
        loadRevenueStats();
        $('#revenue-table').DataTable().ajax.reload(null, false);
    }, 300000);
    
});
</script>
