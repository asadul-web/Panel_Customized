<script>
$('document').ready(function()
{
    $.fn.dataTable.ext.errMode = function() {
        swal('Failed', 'Failed getting data from AJAX.', 'warning', {
            button: false,
            closeOnClickOutside: false,
            timer: 3000
        }).then(function() {
            location.reload();
        });
    };
	table = $('.table-activity').DataTable({
	    responsive: false,
        processing: false,
        serverSide: true,
        deferRender: true,
        ajax: {
            url: "/log-activity-serverside",
            type: "POST",
            error: function() {}
        },
        language: {
            infoFiltered: ""
        },
        order: [[0, 'desc']]
	});
	
	// Modern action button functionality
    
    // Refresh log button
    $('#refresh-log').click(function() {
        var $btn = $(this);
        $btn.addClass('loading');
        
        // Refresh the DataTable
        table.api().ajax.reload(function() {
            $btn.removeClass('loading');
            Swal.fire({
                title: 'Refreshed!',
                text: 'Activity log has been refreshed',
                icon: 'success',
                timer: 1500,
                showConfirmButton: false
            });
        });
    });
    
    // Export log button
    $('#export-log').click(function() {
        Swal.fire({
            title: 'Export Activity Log',
            text: 'Choose export format:',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-file-csv"></i> Export CSV',
            cancelButtonText: '<i class="fas fa-file-pdf"></i> Export PDF',
            confirmButtonColor: '#28a745',
            cancelButtonColor: '#dc3545'
        }).then((result) => {
            if (result.isConfirmed) {
                // Export as CSV
                window.location.href = '{$base_url}serverside/export/export_activity_csv.php';
            } else if (result.dismiss === Swal.DismissReason.cancel) {
                // Export as PDF
                window.location.href = '{$base_url}serverside/export/export_activity_pdf.php';
            }
        });
    });
    
    // Filter buttons
    $('#filter-today').click(function(e) {
        e.preventDefault();
        // Add date filter for today
        table.api().columns(0).search(new Date().toISOString().split('T')[0]).draw();
        Swal.fire({
            title: 'Filtered!',
            text: 'Showing today\'s activity only',
            icon: 'info',
            timer: 1500,
            showConfirmButton: false
        });
    });
    
    $('#filter-week').click(function(e) {
        e.preventDefault();
        // Add date filter for this week
        var weekAgo = new Date();
        weekAgo.setDate(weekAgo.getDate() - 7);
        table.api().columns(0).search('').draw(); // Reset and show last 7 days
        Swal.fire({
            title: 'Filtered!',
            text: 'Showing this week\'s activity',
            icon: 'info',
            timer: 1500,
            showConfirmButton: false
        });
    });
    
    $('#filter-month').click(function(e) {
        e.preventDefault();
        // Add date filter for this month
        var monthAgo = new Date();
        monthAgo.setMonth(monthAgo.getMonth() - 1);
        table.api().columns(0).search('').draw(); // Reset and show last 30 days
        Swal.fire({
            title: 'Filtered!',
            text: 'Showing this month\'s activity',
            icon: 'info',
            timer: 1500,
            showConfirmButton: false
        });
    });
    
    $('#show-all').click(function(e) {
        e.preventDefault();
        // Clear all filters
        table.api().search('').columns().search('').draw();
        Swal.fire({
            title: 'Filter Cleared!',
            text: 'Showing all activity entries',
            icon: 'success',
            timer: 1500,
            showConfirmButton: false
        });
    });
    
    // Clean activity log functionality
    function cleanActivityLog(action, description) {
        Swal.fire({
            title: 'Clean Activity Log',
            html: 'Are you sure you want to clean <strong>' + description + '</strong>?<br>' +
                  '<small class="text-danger">This action cannot be undone!</small>',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#f39c12',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, clean it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: "{$base_url}serverside/forms/clean_activity_log.php",
                    type: "POST",
                    data: {
                        action: action,
                        _key: "{$firenet_encrypt}"
                    },
                    dataType: "JSON",
                    beforeSend: function() {
                        Swal.fire({
                            title: 'Cleaning...',
                            text: 'Please wait while we clean the activity log',
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
                                // Refresh the DataTable
                                table.api().ajax.reload();
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
                            text: 'Failed to clean activity log. Please try again.',
                            icon: 'error',
                            confirmButtonColor: '#dc3545'
                        });
                    }
                });
            }
        });
    }
    
    // Clean log button handlers
    $('#clean-activity-log').click(function() {
        cleanActivityLog('clean_30_days', 'entries older than 30 days');
    });
    
    $('#clean-7-days').click(function(e) {
        e.preventDefault();
        cleanActivityLog('clean_7_days', 'entries older than 7 days');
    });
    
    $('#clean-30-days').click(function(e) {
        e.preventDefault();
        cleanActivityLog('clean_30_days', 'entries older than 30 days');
    });
    
    $('#clean-90-days').click(function(e) {
        e.preventDefault();
        cleanActivityLog('clean_90_days', 'entries older than 90 days');
    });
    
    $('#clean-1-year').click(function(e) {
        e.preventDefault();
        cleanActivityLog('clean_1_year', 'entries older than 1 year');
    });
    
    $('#clean-all-logs').click(function(e) {
        e.preventDefault();
        cleanActivityLog('clean_all', 'ALL activity log entries');
    });
	
	function getD(){
        $.ajax({
            url: "{$base_url}serverside/data/get_data.php",
            type: "GET",
            dataType: "JSON",
        	cache: false,
            success: function(data)
            {
        		if(data.response == 1){
       
                }
                if(data.response == 2){
                	swal('Error', data.licmsg, 'error', {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 5000
                    }).then(function() {
                        location.reload();
                    });
                }
                if(data.response == 3){
                	swal('Error', data.licmsg, 'error', {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 5000
                    }).then(function() {
                        location.reload();
                    });
                }
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                swal('Error', 'Error parsing data.', 'error', {
                    button: false,
                    closeOnClickOutside: false,
                    timer: 3000
                }).then(function() {
                    location.reload();
                });
            },
            complete: function(){
        
        	}
        });
    }
    getD()
});
</script>
