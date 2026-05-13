<script>
// Stable modal system from view-user page
function normal_modalize(title, body) {
    $(".normal-modalize").modal({
        backdrop: 'static',
        keyboard: false  // to prevent closing with Esc button (if you want this too)
    })
    $(".normal-modalize").modal('show');
    $(".normal-modal-title").text(title);
    $(".normal-modal-error").html('');
    $(".normal-modal-html").html(body);
}

function normalMessage(type, title, message) {
    $(".normal-modal-body > .normal-modal-error").html('').append('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
}

$(document).ready(function() {
    
    // Initialize DataTable
    var subscribersTable = $('#subscribersTable').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "/serverside/data/get_email_subscribers.php",
            "type": "POST",
            "data": function(d) {
                d.status_filter = $('#statusFilter').val();
                d.source_filter = $('#sourceFilter').val();
                d.date_filter = $('#dateFilter').val();
            }
        },
        "columns": [
            { 
                "data": null,
                "orderable": false,
                "render": function(data, type, row) {
                    var rowId = row.id || row.DT_RowIndex || 0;
                    return '<input type="checkbox" class="subscriber-checkbox" value="' + rowId + '">';
                }
            },
            { 
                "data": "email",
                "render": function(data, type, row) {
                    if(type === 'display') {
                        // Use row index if id is not available
                        var rowId = row.id || row.DT_RowIndex || 0;
                        
                        // Simple email display without avatar, clickable email
                        return '<a class="subscriber-email-class" onclick="viewSubscriber(' + rowId + ')" style="color: #007bff; cursor: pointer;">' + (data || 'No Email') + '</a>';
                    }
                    return data || 'No Email';
                }
            },
            { 
                "data": "name",
                "render": function(data, type, row) {
                    if(type === 'display') {
                        if(data && data.trim() !== '') {
                            return '<span class="badge badge-secondary" style="font-size: 11px; padding: 4px 8px;">' + data + '</span>';
                        } else {
                            return '<span class="badge badge-light text-muted" style="font-size: 10px; padding: 3px 6px;">No Name</span>';
                        }
                    }
                    return data || 'No Name';
                }
            },
            { 
                "data": "status",
                "render": function(data, type, row) {
                    var badgeClass = '';
                    var icon = '';
                    switch(data) {
                        case 'active':
                            badgeClass = 'badge-success';
                            icon = '<i class="fa fa-check-circle"></i>';
                            break;
                        case 'unsubscribed':
                            badgeClass = 'badge-warning';
                            icon = '<i class="fa fa-times-circle"></i>';
                            break;
                        case 'bounced':
                            badgeClass = 'badge-danger';
                            icon = '<i class="fa fa-exclamation-circle"></i>';
                            break;
                        default:
                            badgeClass = 'badge-secondary';
                            icon = '<i class="fa fa-question-circle"></i>';
                    }
                    return '<span class="' + badgeClass + '">' + icon + ' ' + data.charAt(0).toUpperCase() + data.slice(1) + '</span>';
                }
            },
            { 
                "data": "source",
                "render": function(data, type, row) {
                    var icon = '';
                    switch(data) {
                        case 'manual':
                            icon = '<i class="fas fa-user-plus"></i>';
                            break;
                        case 'website':
                            icon = '<i class="fas fa-globe"></i>';
                            break;
                        case 'import':
                            icon = '<i class="fas fa-upload"></i>';
                            break;
                        case 'api':
                            icon = '<i class="fas fa-code"></i>';
                            break;
                        default:
                            icon = '<i class="fas fa-question"></i>';
                    }
                    return '<span class="badge badge-info">' + icon + ' ' + data.charAt(0).toUpperCase() + data.slice(1) + '</span>';
                }
            },
            { 
                "data": "subscribed_date",
                "render": function(data, type, row) {
                    return '<span class="badge badge-primary"><i class="far fa-calendar-alt"></i> ' + new Date(data).toLocaleDateString() + '</span>';
                }
            },
            { 
                "data": "last_email_sent",
                "render": function(data, type, row) {
                    if(data) {
                        return '<span class="badge badge-info"><i class="far fa-clock"></i> ' + new Date(data).toLocaleDateString() + '</span>';
                    } else {
                        return '<span class="badge badge-secondary"><i class="far fa-clock"></i> Never</span>';
                    }
                }
            },
            { 
                "data": "email_count",
                "render": function(data, type, row) {
                    return '<span class="badge badge-info"><i class="fas fa-envelope"></i> ' + data + '</span>';
                }
            },
            {
                "data": null,
                "orderable": false,
                "width": "150px",
                "render": function(data, type, row, meta) {
                    // Use row index if id is not available
                    var rowId = row.id || meta.row || 0;
                    
                    // Debug log for troubleshooting
                    var actions = '<div class="btn-group btn-group-md" role="group">';
                    actions += '<button type="button" class="btn btn-primary mr-1" onclick="viewSubscriber(' + rowId + ')" title="View Details"><i class="far fa-eye"></i></button>';
                    actions += '<button type="button" class="btn btn-primary mr-1" onclick="subscriber_option(' + rowId + ')" title="Options"><i class="fas fa-edit"></i></button>';
                    actions += '</div>';
                    
                    return actions;
                }
            }
        ],
        "order": [[ 5, "desc" ]], // Order by subscribed_date descending
        "pageLength": 25,
        "responsive": true,
        "language": {
            "processing": '<i class="fas fa-spinner fa-spin"></i> Loading subscribers...',
            "emptyTable": "No subscribers found",
            "zeroRecords": "No matching subscribers found"
        },
        "drawCallback": function(settings) {
            // Initialize tooltips for action buttons
            $('[title]').tooltip();
            
            // Debug: Log the data to see what's being returned
            }
    });
    
    // Filter handlers
    $('#statusFilter, #sourceFilter, #dateFilter').on('change', function() {
        subscribersTable.ajax.reload();
    });
    
    // Select all checkbox
    $('#selectAll').on('change', function() {
        $('.subscriber-checkbox').prop('checked', $(this).is(':checked'));
    });
    
    // Individual checkbox handler
    $(document).on('change', '.subscriber-checkbox', function() {
        var totalCheckboxes = $('.subscriber-checkbox').length;
        var checkedCheckboxes = $('.subscriber-checkbox:checked').length;
        
        if(checkedCheckboxes === totalCheckboxes) {
            $('#selectAll').prop('checked', true);
        } else {
            $('#selectAll').prop('checked', false);
        }
    });
    
    // Modal button event handlers (similar to view-user page)
    $(".normal-modalize").on("click", ".btn-modal-edit", function(e) {
        var subscriberId = $(this).data("id");
        editSubscriber(subscriberId);
        $(".normal-modalize").modal('hide');
    });
    
    $(".normal-modalize").on("click", ".btn-modal-unsubscribe", function(e) {
        var subscriberId = $(this).data("id");
        var email = $(this).data("email");
        unsubscribeSubscriber(subscriberId);
        $(".normal-modalize").modal('hide');
    });
    
    $(".normal-modalize").on("click", ".btn-modal-resubscribe", function(e) {
        var subscriberId = $(this).data("id");
        var email = $(this).data("email");
        resubscribeSubscriber(subscriberId);
        $(".normal-modalize").modal('hide');
    });
    
    $(".normal-modalize").on("click", ".btn-modal-reactivate", function(e) {
        var subscriberId = $(this).data("id");
        var email = $(this).data("email");
        reactivateSubscriber(subscriberId);
        $(".normal-modalize").modal('hide');
    });
    
    $(".normal-modalize").on("click", ".btn-modal-delete", function(e) {
        var subscriberId = $(this).data("id");
        var email = $(this).data("email");
        deleteSubscriber(subscriberId);
        $(".normal-modalize").modal('hide');
    });
    
});

// Refresh subscribers table
function refreshSubscribers() {
    $('#subscribersTable').DataTable().ajax.reload();
    Swal.fire({
        title: 'Refreshed!',
        text: 'Subscriber data has been refreshed',
        icon: 'success',
        timer: 1500,
        showConfirmButton: false
    });
}


// Clear filters
function clearFilters() {
    $('#statusFilter').val('');
    $('#sourceFilter').val('');
    $('#dateFilter').val('');
    $('#subscribersTable').DataTable().ajax.reload();
}

// Add subscriber
function addSubscriber() {
    var formData = {
        email: $('#subscriberEmail').val().trim(),
        name: $('#subscriberName').val().trim(),
        tags: $('#subscriberTags').val().trim(),
        source: $('#subscriberSource').val()
    };
    
    if(!formData.email) {
        Swal.fire('Error', 'Email address is required', 'error');
        return;
    }
    
    $.ajax({
        url: '/serverside/forms/add_email_subscriber.php',
        type: 'POST',
        data: formData,
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire('Success', response.msg, 'success');
                $('#addSubscriberModal').modal('hide');
                $('#addSubscriberForm')[0].reset();
                $('#subscribersTable').DataTable().ajax.reload();
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to add subscriber', 'error');
        }
    });
}

// Import subscribers
function importSubscribers() {
    var formData = new FormData();
    var csvFile = $('#csvFile')[0].files[0];
    
    if(!csvFile) {
        Swal.fire('Error', 'Please select a CSV file', 'error');
        return;
    }
    
    formData.append('csv_file', csvFile);
    formData.append('skip_duplicates', $('#skipDuplicates').is(':checked') ? '1' : '0');
    
    $.ajax({
        url: '/serverside/forms/import_email_subscribers.php',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire('Success', response.msg, 'success');
                $('#importSubscribersModal').modal('hide');
                $('#importSubscribersForm')[0].reset();
                $('#subscribersTable').DataTable().ajax.reload();
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to import subscribers', 'error');
        }
    });
}

// Export subscribers
function exportSubscribers() {
    window.location.href = '/serverside/forms/export_email_subscribers.php';
}

// Subscriber options (similar to user_option in view-user page)
function subscriber_option(id) {
    $.ajax({
        url: '/serverside/data/get_subscriber_options.php',
        type: 'POST',
        data: { subscriber_id: id },
        dataType: 'json',
        cache: false,
        success: function(response) {
            if(response.response == 1) {
                var subscriber = response.subscriber;
                var template_html = '<div class="form-group">';
                template_html += '<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-edit" tabindex="4" data-id="' + id + '">Edit Subscriber</button>';
                
                if(subscriber.status == 'active') {
                    template_html += '<button type="submit" class="btn btn-warning btn-lg btn-block btn-modal-unsubscribe" data-id="' + id + '" data-email="' + subscriber.email + '" tabindex="4">Unsubscribe</button>';
                } else if(subscriber.status == 'unsubscribed') {
                    template_html += '<button type="submit" class="btn btn-success btn-lg btn-block btn-modal-resubscribe" data-id="' + id + '" data-email="' + subscriber.email + '" tabindex="4">Resubscribe</button>';
                } else if(subscriber.status == 'bounced') {
                    template_html += '<button type="submit" class="btn btn-info btn-lg btn-block btn-modal-reactivate" data-id="' + id + '" data-email="' + subscriber.email + '" tabindex="4">Reactivate</button>';
                }
                
                template_html += '<button type="submit" class="btn btn-danger btn-lg btn-block btn-modal-delete" tabindex="4" data-id="' + id + '" data-email="' + subscriber.email + '">Delete Subscriber</button>';
                template_html += '</div>';
                
                normal_modalize('Subscriber Actions', template_html);
            } else {
                Swal.fire('Error', response.msg || 'Failed to load subscriber options', 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to load subscriber options', 'error');
        }
    });
}

// View subscriber details (matching view_info from view-user page)
function viewSubscriber(id) {
    $.ajax({
        url: '/serverside/data/get_subscriber_details.php',
        type: 'POST',
        data: { subscriber_id: id },
        dataType: 'json',
        cache: false,
        success: function(response) {
            if(response.response == 1) {
                var subscriber = response.subscriber;
                var template_html = '<div class="form-group"><label for="email">Email Address</label><input class="form-control" type="text" value="' + subscriber.email + '" readonly></div>';
                template_html += '<div class="form-group mt-3"><label for="name">Full Name</label><input class="form-control" type="text" value="' + (subscriber.name || 'Not provided') + '" readonly></div>';
                template_html += '<div class="form-group mt-3"><label for="status">Status</label><input class="form-control" type="text" value="' + subscriber.status.toUpperCase() + '" readonly></div>';
                template_html += '<div class="form-group mt-3"><label for="source">Source</label><input class="form-control" type="text" value="' + subscriber.source + '" readonly></div>';
                template_html += '<div class="form-group mt-3"><label for="subscribed">Subscribed Date</label><input class="form-control" type="text" value="' + new Date(subscriber.subscribed_date).toLocaleString() + '" readonly></div>';
                template_html += '<div class="form-group mt-3"><label for="emails">Emails Sent</label><input class="form-control" type="text" value="' + subscriber.email_count + '" readonly></div>';
                if(subscriber.last_email_sent) {
                    template_html += '<div class="form-group mt-3"><label for="last_email">Last Email Sent</label><input class="form-control" type="text" value="' + new Date(subscriber.last_email_sent).toLocaleString() + '" readonly></div>';
                }
                if(subscriber.tags) {
                    template_html += '<div class="form-group mt-3"><label for="tags">Tags</label><input class="form-control" type="text" value="' + subscriber.tags + '" readonly></div>';
                }
                
                normal_modalize('Subscriber Details', template_html);
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to load subscriber details', 'error');
        }
    });
}

// Edit subscriber (simplified)
function editSubscriber(id) {
    $.ajax({
        url: '/serverside/data/get_subscriber_details.php',
        type: 'POST',
        data: { subscriber_id: id },
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                var subscriber = response.subscriber;
                $('#editSubscriberId').val(subscriber.id);
                $('#editSubscriberEmail').val(subscriber.email);
                $('#editSubscriberName').val(subscriber.name || '');
                $('#editSubscriberTags').val(subscriber.tags || '');
                $('#editSubscriberSource').val(subscriber.source);
                $('#editSubscriberStatus').val(subscriber.status);
                $('#editSubscriberModal').modal('show');
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to load subscriber details', 'error');
        }
    });
}

// Update subscriber
function updateSubscriber() {
    var formData = {
        subscriber_id: $('#editSubscriberId').val(),
        email: $('#editSubscriberEmail').val().trim(),
        name: $('#editSubscriberName').val().trim(),
        tags: $('#editSubscriberTags').val().trim(),
        source: $('#editSubscriberSource').val(),
        status: $('#editSubscriberStatus').val()
    };
    
    if(!formData.email) {
        Swal.fire('Error', 'Email address is required', 'error');
        return;
    }
    
    $.ajax({
        url: '/serverside/forms/update_email_subscriber.php',
        type: 'POST',
        data: formData,
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire('Success', response.msg, 'success');
                $('#editSubscriberModal').modal('hide');
                $('#subscribersTable').DataTable().ajax.reload();
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to update subscriber', 'error');
        }
    });
}

// Status update functions (consolidated)
function unsubscribeSubscriber(id) {
    updateSubscriberStatus(id, 'unsubscribed');
}

function resubscribeSubscriber(id) {
    updateSubscriberStatus(id, 'active');
}

function reactivateSubscriber(id) {
    updateSubscriberStatus(id, 'active');
}

// Delete subscriber
function deleteSubscriber(id) {
    Swal.fire({
        title: 'Delete Subscriber?',
        text: 'This action cannot be undone',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, Delete',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#d33'
    }).then(function(result) {
        if(result.isConfirmed) {
            $.ajax({
                url: '/serverside/forms/delete_email_subscriber.php',
                type: 'POST',
                data: { subscriber_id: id },
                dataType: 'json',
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire('Deleted', response.msg, 'success');
                        $('#subscribersTable').DataTable().ajax.reload();
                    } else {
                        Swal.fire('Error', response.msg, 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to delete subscriber', 'error');
                }
            });
        }
    });
}


// Update subscriber status
function updateSubscriberStatus(id, status) {
    $.ajax({
        url: '/serverside/forms/update_subscriber_status.php',
        type: 'POST',
        data: { 
            subscriber_id: id,
            status: status
        },
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire('Success', response.msg, 'success');
                $('#subscribersTable').DataTable().ajax.reload();
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to update subscriber status', 'error');
        }
    });
}

// Execute bulk action
function executeBulkAction() {
    var action = $('#bulkAction').val();
    var selectedIds = [];
    
    $('.subscriber-checkbox:checked').each(function() {
        selectedIds.push($(this).val());
    });
    
    if(!action) {
        Swal.fire('Error', 'Please select an action', 'error');
        return;
    }
    
    if(selectedIds.length === 0) {
        Swal.fire('Error', 'Please select at least one subscriber', 'error');
        return;
    }
    
    var actionText = action.charAt(0).toUpperCase() + action.slice(1);
    
    Swal.fire({
        title: actionText + ' Selected Subscribers?',
        text: 'This will affect ' + selectedIds.length + ' subscribers',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, ' + actionText,
        cancelButtonText: 'Cancel'
    }).then(function(result) {
        if(result.isConfirmed) {
            $.ajax({
                url: '/serverside/forms/bulk_subscriber_action.php',
                type: 'POST',
                data: { 
                    action: action,
                    subscriber_ids: selectedIds
                },
                dataType: 'json',
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire('Success', response.msg, 'success');
                        $('#subscribersTable').DataTable().ajax.reload();
                        $('#selectAll').prop('checked', false);
                        $('#bulkAction').val('');
                    } else {
                        Swal.fire('Error', response.msg, 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to execute bulk action', 'error');
                }
            });
        }
    });
}

// Sync reseller emails to subscribers
function syncResellerEmails() {
    Swal.fire({
        title: 'Sync Reseller Emails?',
        text: 'This will add all reseller application emails to the subscribers list',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Sync Now',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#ffc107'
    }).then(function(result) {
        if(result.isConfirmed) {
            // Show loading
            Swal.fire({
                title: 'Syncing...',
                text: 'Please wait while we sync reseller emails',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            $.ajax({
                url: '/serverside/forms/sync_reseller_emails.php',
                type: 'POST',
                dataType: 'json',
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire({
                            title: 'Sync Complete!',
                            html: response.msg + '<br><br><strong>Synced:</strong> ' + response.synced_count + ' emails<br><strong>Errors:</strong> ' + response.error_count,
                            icon: 'success',
                            confirmButtonText: 'OK'
                        });
                        // Refresh the table and stats
                        $('#subscribersTable').DataTable().ajax.reload();
                        location.reload(); // Reload to update statistics
                    } else {
                        Swal.fire('Error', response.msg, 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to sync reseller emails', 'error');
                }
            });
        }
    });
}
</script>

