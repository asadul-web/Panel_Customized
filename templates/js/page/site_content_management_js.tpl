<script>
$(document).ready(function() {
    
    // Content Management Functions for Site Info
    $('#saveContentBtn').click(function() {
        var formData = $('#contentManagementForm').serialize();
        
        $.ajax({
            url: '/serverside/forms/update_site_content.php',
            type: 'POST',
            data: formData,
            dataType: 'json',
            beforeSend: function() {
                $('#saveContentBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...');
            },
            success: function(response) {
                if(response.response == 1) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: response.msg,
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function() {
                        location.reload();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error!',
                        text: response.msg
                    });
                }
            },
            error: function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: 'An error occurred while saving content.'
                });
            },
            complete: function() {
                $('#saveContentBtn').prop('disabled', false).html('<i class="fas fa-save"></i> Save Content');
            }
        });
    });
    
    // Edit content button click
    $('.edit-content').click(function() {
        var id = $(this).data('id');
        var name = $(this).data('name');
        var content = $(this).data('content');
        var type = $(this).data('type');
        var order = $(this).data('order');
        var active = $(this).data('active');
        
        $('#content_id').val(id);
        $('#section_name').val(name);
        $('#section_content').val(content);
        $('#section_type').val(type);
        $('#section_order').val(order);
        $('#is_active').prop('checked', active == 1);
    });
    
    // Slider Management Functions
    $('#saveSliderBtn').click(function() {
        var formData = $('#sliderManagementForm').serialize();
        
        $.ajax({
            url: '/serverside/forms/update_site_slider.php',
            type: 'POST',
            data: formData,
            dataType: 'json',
            beforeSend: function() {
                $('#saveSliderBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...');
            },
            success: function(response) {
                if(response.response == 1) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: response.msg,
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function() {
                        location.reload();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error!',
                        text: response.msg
                    });
                }
            },
            error: function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: 'An error occurred while saving slider content.'
                });
            },
            complete: function() {
                $('#saveSliderBtn').prop('disabled', false).html('<i class="fas fa-save"></i> Save Slider');
            }
        });
    });
    
    // Edit slider button click
    $('.edit-slider').click(function() {
        var id = $(this).data('id');
        var content = $(this).data('content');
        var order = $(this).data('order');
        var active = $(this).data('active');
        
        $('#slider_id').val(id);
        $('#text_content').val(content);
        $('#display_order').val(order);
        $('#slider_is_active').prop('checked', active == 1);
    });
    
    // Clear forms when modals are closed
    $('#contentManagementModal').on('hidden.bs.modal', function() {
        $('#contentManagementForm')[0].reset();
        $('#content_id').val('');
    });
    
    $('#sliderManagementModal').on('hidden.bs.modal', function() {
        $('#sliderManagementForm')[0].reset();
        $('#slider_id').val('');
    });
    
});
</script>
