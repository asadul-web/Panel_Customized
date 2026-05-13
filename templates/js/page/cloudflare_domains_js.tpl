<script type="text/javascript">
$(document).ready(function(){
    
    // Reset form
    $('.btn-reset-cf').click(function(){
        $('.add-cloudflare-domain')[0].reset();
    });
    
    // Add Cloudflare Domain
    $('.add-cloudflare-domain').ajaxForm({
        url: '/serverside/forms/add_cloudflare_domain.php',
        type: 'POST',
        beforeSubmit: function(){
            $('.btn-add-cf-domain').html('<i class="fa fa-spinner fa-spin"></i> Processing...').attr('disabled', true);
        },
        success: function(data){
            if(data.response == 1){
                Swal.fire({
                    title: 'Success!',
                    text: data.msg,
                    icon: 'success',
                    showConfirmButton: false,
                    timer: 2000
                });
                $('.add-cloudflare-domain')[0].reset();
                table.api().ajax.reload();
            }else if(data.response == 2){
                Swal.fire({
                    title: 'Error!',
                    text: data.msg,
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            }else if(data.response == 3){
                $('.errors').html('<div class="alert alert-danger alert-dismissible fade show"><div class="alert-body"><button class="close" data-dismiss="alert"><span>×</span></button>'+data.errormsg+'</div></div>');
            }
            $('.btn-add-cf-domain').html('Confirm').attr('disabled', false);
        },
        error: function(){
            Swal.fire({
                title: 'Error!',
                text: 'Something went wrong!',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            $('.btn-add-cf-domain').html('Confirm').attr('disabled', false);
        },
        dataType: 'json'
    });
    
    // DataTable for Cloudflare Domains
    var table = $('.table-cloudflare-domains').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "ajax": {
            "url": "/cloudflare-domains-serverside",
            "type": "POST"
        },
        responsive: true,
        "order": [[ 0, "desc" ]],
        "language": {                
            "infoFiltered": ""
        },
        columnDefs: [
            {
                orderable: false,
                targets: [4],
            },
        ],
    });
    
    // Delete Cloudflare Domain
    $(document).on('click', '.btn-delete-cf-domain', function(){
        var domain_id = $(this).data('id');
        var domain_name = $(this).data('domain');
        
        Swal.fire({
            title: 'Are you sure?',
            text: 'Delete domain: ' + domain_name + '?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '/serverside/forms/delete_cloudflare_domain.php',
                    type: 'POST',
                    data: {
                        domain_id: domain_id
                    },
                    dataType: 'json',
                    success: function(data){
                        if(data.response == 1){
                            Swal.fire({
                                title: 'Deleted!',
                                text: data.msg,
                                icon: 'success',
                                showConfirmButton: false,
                                timer: 2000
                            });
                            table.api().ajax.reload();
                        }else{
                            Swal.fire({
                                title: 'Error!',
                                text: data.msg,
                                icon: 'error',
                                confirmButtonText: 'OK'
                            });
                        }
                    }
                });
            }
        });
    });
    
    // Toggle Active Status
    $(document).on('click', '.btn-toggle-cf-status', function(){
        var domain_id = $(this).data('id');
        var current_status = $(this).data('status');
        
        $.ajax({
            url: '/serverside/forms/toggle_cloudflare_domain.php',
            type: 'POST',
            data: {
                submitted: 'toggle_cf_status',
                domain_id: domain_id,
                current_status: current_status,
                _key: $('#_key').val()
            },
            dataType: 'json',
            success: function(data){
                if(data.response == 1){
                    Swal.fire({
                        title: 'Success!',
                        text: data.msg,
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 2000
                    });
                    table.api().ajax.reload();
                }else{
                    Swal.fire({
                        title: 'Error!',
                        text: data.msg,
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            }
        });
    });
});
</script>
