<script>
$(document).ready(function() {
    
    // Initialize clipboard
    var clipboard = new ClipboardJS('.btn-copy');
    
    clipboard.on('success', function(e) {
        Swal.fire({
            title: "Copied!",
            text: "API URL copied to clipboard",
            icon: "success",
            timer: 2000,
            showConfirmButton: false
        });
        e.clearSelection();
    });
    
    clipboard.on('error', function(e) {
        Swal.fire({
            title: "Error",
            text: "Failed to copy to clipboard",
            icon: "error",
            timer: 2000,
            showConfirmButton: false
        });
    });
    
    // Initialize DataTable
    $('#ads-view-table').DataTable({
        "ajax": {
            "url": "{$base_url}serverside/data/get_ads_view.php",
            "type": "GET",
            "dataSrc": "data"
        },
        "columns": [
            { "data": "app_name" },
            { "data": "package_name" },
            { 
                "data": "admob_app_id",
                "render": function(data, type, row) {
                    return '<small>' + data + '</small>';
                }
            },
            { 
                "data": "banner_ad_id",
                "render": function(data, type, row) {
                    return data ? '<small>' + data + '</small>' : '<span class="text-muted">Not set</span>';
                }
            },
            { 
                "data": "interstitial_ad_id",
                "render": function(data, type, row) {
                    return data ? '<small>' + data + '</small>' : '<span class="text-muted">Not set</span>';
                }
            },
            { 
                "data": "rewarded_ad_id",
                "render": function(data, type, row) {
                    return data ? '<small>' + data + '</small>' : '<span class="text-muted">Not set</span>';
                }
            },
            { 
                "data": "native_advanced_ad_id",
                "render": function(data, type, row) {
                    return data ? '<small>' + data + '</small>' : '<span class="text-muted">Not set</span>';
                }
            },
            { 
                "data": "app_open_ad_id",
                "render": function(data, type, row) {
                    return data ? '<small>' + data + '</small>' : '<span class="text-muted">Not set</span>';
                }
            },
            { 
                "data": "status",
                "render": function(data, type, row) {
                    var badgeClass = data === 'active' ? 'success' : (data === 'testing' ? 'warning' : 'danger');
                    return '<span class="badge badge-' + badgeClass + '">' + data.toUpperCase() + '</span>';
                }
            },
            { 
                "data": "api_url",
                "render": function(data, type, row) {
                    return '<div class="d-flex align-items-center api-url-cell">' +
                           '<span class="api-url-text mr-2 flex-grow-1">' + data + '</span>' +
                           '<button class="btn btn-xs btn-primary copy-api-url" data-url="' + data + '" title="Copy URL">' +
                           '<i class="fas fa-copy"></i></button>' +
                           '</div>';
                }
            },
            { 
                "data": null,
                "render": function(data, type, row) {
                    return '<button class="btn btn-sm btn-info test-api" data-url="' + row.api_url + '">Test API</button>';
                }
            }
        ],
        "responsive": true,
        "scrollX": true,
        "order": [[ 0, "asc" ]]
    });
    
    // Copy API URL
    $(document).on('click', '.copy-api-url', function() {
        var url = $(this).data('url');
        navigator.clipboard.writeText(url).then(function() {
            Swal.fire({
                title: "Copied!",
                text: "API URL copied to clipboard",
                icon: "success",
                timer: 2000,
                showConfirmButton: false
            });
        });
    });
    
    // Test API
    $(document).on('click', '.test-api', function() {
        var url = $(this).data('url');
        
        Swal.fire({
            title: 'Testing API...',
            text: 'Please wait while we test the API endpoint',
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });
        
        $.ajax({
            url: url,
            type: "GET",
            dataType: "JSON",
            success: function(data) {
                Swal.fire({
                    title: "API Test Result",
                    html: '<pre>' + JSON.stringify(data, null, 2) + '</pre>',
                    icon: "success",
                    customClass: {
                        confirmButton: 'btn-primary'
                    }
                });
            },
            error: function(jqXHR, textStatus, errorThrown) {
                Swal.fire({
                    title: "API Test Failed",
                    text: "Error: " + textStatus,
                    icon: "error",
                    customClass: {
                        confirmButton: 'btn-primary'
                    }
                });
            }
        });
    });
    
    // Load API doc examples
    function loadApiExamples() {
        // You can add more dynamic examples here
        }
    
    loadApiExamples();
    
});
</script>

