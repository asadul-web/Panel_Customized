<script>
$(document).ready(function() {
    
    // Initialize DataTable
    $('#ads-table').DataTable({
        "ajax": {
            "url": "{$base_url}serverside/data/get_ads_manage.php",
            "type": "GET",
            "dataSrc": "data"
        },
        "columns": [
            { "data": "app_name" },
            { "data": "package_name" },
            { 
                "data": "generated_url",
                "render": function(data, type, row) {
                    return '<a href="' + data + '" target="_blank" class="btn btn-sm btn-primary">View URL</a>';
                }
            },
            { 
                "data": "status",
                "render": function(data, type, row) {
                    var badgeClass = data === 'active' ? 'success' : (data === 'testing' ? 'warning' : 'danger');
                    return '<span class="badge badge-' + badgeClass + '">' + data.toUpperCase() + '</span>';
                }
            },
            { "data": "created_date" },
            { 
                "data": null,
                "render": function(data, type, row) {
                    return '<button class="btn btn-sm btn-warning edit-app" data-id="' + row.id + '">Edit</button> ' +
                           '<button class="btn btn-sm btn-danger delete-app" data-id="' + row.id + '">Delete</button>';
                }
            }
        ],
        "responsive": true,
        "order": [[ 4, "desc" ]]
    });
    
    // Form submission
    $('.btn-confirm-ads').click(function() {
        $(this).addClass('d-none');
        $('#cancel-row').removeClass('d-none');
        
        var $form = $('.ads-form');
        var isEdit = $form.attr('data-action') === 'edit';
        var submitUrl = isEdit ? "{$base_url}serverside/forms/ads_update.php" : "{$base_url}serverside/forms/ads_manage.php";
        
        $form.ajaxForm({
            type: "POST",
            url: submitUrl,
            data: $form.serialize(),
            dataType: "JSON",
            cache: false,
            beforeSend: function() {
                $('.btn-cancel-ads').addClass("btn-progress");
            },
            success: function(data) {
                if(data.response == 1) {
                    Swal.fire({
                        title: "Success",
                        html: data.msg,
                        icon: "success",
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        didOpen: function () {
                            Swal.getConfirmButton().blur();
                        }
                    }).then(() => {
                        // Reset form and reload table
                        $('.ads-form')[0].reset();
                        $('.ads-form').removeAttr('data-action');
                        $('.btn-confirm-ads').text('Create App Configuration');
                        $('#edit_app_id').remove();
                        $('#ads-table').DataTable().ajax.reload();
                    });
                } else {
                    Swal.fire({
                        title: "Failed",
                        html: data.msg,
                        icon: "error",
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        didOpen: function () {
                            Swal.getConfirmButton().blur();
                        }
                    });
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                Swal.fire({
                    title: "Error",
                    icon: "error",
                    html: "Failed to submit form.",
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    customClass: {
                        confirmButton: 'btn-primary'
                    }
                });
            },
            complete: function() {
                $('.btn-cancel-ads').removeClass("btn-progress");
                $('.btn-confirm-ads').removeClass('d-none');
                $('#cancel-row').addClass('d-none');
            }
        });
        
        $form.submit();
    });
    
    // Cancel button
    $('.btn-cancel-ads').click(function() {
        $('#cancel-row').addClass('d-none');
        $('.btn-confirm-ads').removeClass('d-none');
        $('.ads-form')[0].reset();
        $('.ads-form').removeAttr('data-action');
        $('.btn-confirm-ads').text('Create App Configuration');
        $('#edit_app_id').remove();
    });
    
    // Edit app
    $(document).on('click', '.edit-app', function() {
        var appId = $(this).data('id');
        
        // Get app data
        $.ajax({
            url: "{$base_url}serverside/data/get_app_data.php",
            type: "GET",
            data: { app_id: appId },
            dataType: "JSON",
            success: function(data) {
                if(data.response == 1) {
                    // Populate form with existing data
                    $('#app_name').val(data.data.app_name);
                    $('#app_package').val(data.data.package_name);
                    $('#admob_app_id').val(data.data.admob_app_id);
                    $('#banner_ad_id').val(data.data.banner_ad_id);
                    $('#interstitial_ad_id').val(data.data.interstitial_ad_id);
                    $('#rewarded_ad_id').val(data.data.rewarded_ad_id);
                    $('#native_advanced_ad_id').val(data.data.native_advanced_ad_id);
                    $('#app_open_ad_id').val(data.data.app_open_ad_id);
                    $('#app_status').val(data.data.status);
                    
                    // Add hidden field for app ID
                    if($('#edit_app_id').length === 0) {
                        $('.ads-form').append('<input type="hidden" id="edit_app_id" name="app_id" value="">');
                    }
                    $('#edit_app_id').val(data.data.id);
                    
                    // Change form action and button text
                    $('.ads-form').attr('data-action', 'edit');
                    $('.btn-confirm-ads').text('Update App Configuration');
                    
                    // Scroll to form
                    $('html, body').animate({
                        scrollTop: $('.ads-form').offset().top - 100
                    }, 500);
                    
                } else {
                    Swal.fire('Error!', data.msg, 'error');
                }
            }
        });
    });
    
    // Delete app
    $(document).on('click', '.delete-app', function() {
        var appId = $(this).data('id');
        
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: "{$base_url}serverside/forms/ads_delete.php",
                    type: "POST",
                    data: {
                        app_id: appId,
                        _key: "{$firenet_encrypt}"
                    },
                    dataType: "JSON",
                    success: function(data) {
                        if(data.response == 1) {
                            Swal.fire('Deleted!', data.msg, 'success').then(() => {
                                $('#ads-table').DataTable().ajax.reload();
                            });
                        } else {
                            Swal.fire('Error!', data.msg, 'error');
                        }
                    }
                });
            }
        });
    });
    
    // Generate URL preview
    $('#app_name').on('input', function() {
        var appName = $(this).val().toLowerCase().replace(/[^a-z0-9]/g, '');
        if(appName) {
            var generatedUrl = window.location.origin + '/api/ads/' + appName + '/config';
            // You can show this preview somewhere if needed
        }
    });
    
});
</script>
