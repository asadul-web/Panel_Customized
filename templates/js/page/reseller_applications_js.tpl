<script>
function normal_modalize(title, body)
	{
	    $(".normal-modalize").modal({
            backdrop: 'static',
            keyboard: false  // to prevent closing with Esc button (if you want this too)
        })
        $(".normal-modalize").modal('show');
		$(".normal-modal-title").text(title);
		$(".normal-modal-error").html('');
		$(".normal-modal-html").html(body);
	}

function normalMessage(type,title,message)
	{
		$(".normal-modal-body > .normal-modal-error").html('').append('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
	}

function view_info(u) {
	$.ajax({
        url: "{$base_url}serverside/data/get_reseller_application_info.php",
        data: "aid="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            var template_html =  `<div class="form-group"><label for="business_name">Business Name</label><input class="form-control" id="business_name" type="text" value="`+(data.business_name || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="full_name">Full Name</label><input class="form-control" id="full_name" type="text" value="`+(data.full_name || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="email">Email</label><input class="form-control" id="email" type="text" value="`+(data.email || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="username">Requested Username</label><input class="form-control" id="username" type="text" value="`+(data.username || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="password">Requested Password</label><div class="input-group"><input class="form-control" id="password" type="password" value="`+(data.password || 'Not available')+`" readonly><div class="input-group-append"><button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility()"><i class="fas fa-eye" id="password-eye"></i></button></div></div></div>
				<div class="form-group mt-3"><label for="phone">Phone</label><input class="form-control" id="phone" type="text" value="`+(data.phone || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="country">Country</label><input class="form-control" id="country" type="text" value="`+(data.country || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="website">Website</label><input class="form-control" id="website" type="text" value="`+(data.website || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="experience">Experience</label><input class="form-control" id="experience" type="text" value="`+(data.experience || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="expected_sales">Expected Monthly Sales</label><input class="form-control" id="expected_sales" type="text" value="`+(data.expected_sales || 'Not provided')+`" readonly></div>
				<div class="form-group mt-3"><label for="message">Message</label><textarea class="form-control" id="message" rows="3" readonly>`+(data.message || 'No message provided')+`</textarea></div>
				<div class="form-group mt-3"><label for="status">Status</label><input class="form-control" id="status" type="text" value="`+(data.status || 'Pending')+`" readonly></div>
				<div class="form-group mt-3"><label for="applied_date">Applied Date</label><input class="form-control" id="applied_date" type="text" value="`+(data.applied_date || 'Not available')+`" readonly></div>`;
			normal_modalize('Application Details', template_html);
        },
        error: function (jqXHR, textStatus, errorThrown)
        {
            Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });
        }
    });
}

function application_option(u) {
	$.ajax({
        url: "{$base_url}serverside/data/get_reseller_application_options.php",
        data: "aid="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            var template_html = '<div class="form-group">';
            template_html += '<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-view" tabindex="4" data-id="'+u+'">View Details</button>';

            if(data.status == 'pending') {
                template_html += '<button type="submit" class="btn btn-success btn-lg btn-block btn-modal-approve" data-id="'+u+'" tabindex="4">Approve Application</button>';
                template_html += '<button type="submit" class="btn btn-warning btn-lg btn-block btn-modal-review" data-id="'+u+'" tabindex="4">Mark Under Review</button>';
                template_html += '<button type="submit" class="btn btn-danger btn-lg btn-block btn-modal-reject" data-id="'+u+'" tabindex="4">Reject Application</button>';
            } else if(data.status == 'under_review') {
                template_html += '<button type="submit" class="btn btn-success btn-lg btn-block btn-modal-approve" data-id="'+u+'" tabindex="4">Approve Application</button>';
                template_html += '<button type="submit" class="btn btn-danger btn-lg btn-block btn-modal-reject" data-id="'+u+'" tabindex="4">Reject Application</button>';
            }

            template_html += '</div>';
            normal_modalize('Application Actions', template_html);
        },
        error: function (jqXHR, textStatus, errorThrown)
        {
            Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });
        }
    });
}

$(document).ready(function() {
    // Initialize DataTable
    var applicationsTable = $('.table-listapplication').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "{$base_url}serverside/data/get_reseller_applications.php",
            "type": "POST",
            "data": function(d) {
                d.table_type = $('#tabletype').val();
            }
        },
        "columns": [
            { "data": "business_name" },
            { "data": "full_name" },
            { "data": "email" },
            { "data": "country" },
            {
                "data": "status",
                "render": function(data, type, row) {
                    var badgeClass = '';
                    switch(data) {
                        case 'pending':
                            badgeClass = 'badge-warning';
                            break;
                        case 'under_review':
                            badgeClass = 'badge-info';
                            break;
                        case 'approved':
                            badgeClass = 'badge-success';
                            break;
                        case 'rejected':
                            badgeClass = 'badge-danger';
                            break;
                        default:
                            badgeClass = 'badge-secondary';
                    }
                    return '<span class="badge ' + badgeClass + '">' + data.replace('_', ' ').toUpperCase() + '</span>';
                }
            },
            {
                "data": null,
                "orderable": false,
                "render": function(data, type, row) {
                    return '<div class="btn-group btn-group-sm" role="group">' +
                           '<button type="button" class="btn btn-primary" onclick="view_info(' + row.id + ')" title="View Details"><i class="fas fa-eye"></i></button>' +
                           '<button type="button" class="btn btn-primary" onclick="application_option(' + row.id + ')" title="Options"><i class="fas fa-edit"></i></button>' +
                           '</div>';
                }
            }
        ],
        "order": [[ 0, "asc" ]],
        "pageLength": 25,
        "responsive": true
    });


    // Table type selector change event
    $('#tabletype').on('change', function() {
        var selectedType = $(this).val();
        var currentText = '';

        switch(selectedType) {
            case 'all':
                currentText = 'All Applications';
                break;
            case 'pending':
                currentText = 'Pending Applications';
                break;
            case 'under_review':
                currentText = 'Under Review Applications';
                break;
            case 'approved':
                currentText = 'Approved Applications';
                break;
            case 'rejected':
                currentText = 'Rejected Applications';
                break;
        }

        $('.currentloaded').val(currentText);
        $('.currentuser').text(currentText);
        applicationsTable.ajax.reload();
    });

    // Modal button events
    $(".normal-modalize").on("click", ".btn-modal-view", function(e) {
        var applicationId = $(this).data("id");
        view_info(applicationId);
    });

    $(".normal-modalize").on("click", ".btn-modal-approve", function(e) {
        var applicationId = $(this).data("id");
        approveApplication(applicationId);
        $(".normal-modalize").modal('hide');
    });

    $(".normal-modalize").on("click", ".btn-modal-review", function(e) {
        var applicationId = $(this).data("id");
        updateApplicationStatus(applicationId, 'under_review');
        $(".normal-modalize").modal('hide');
    });

    $(".normal-modalize").on("click", ".btn-modal-reject", function(e) {
        var applicationId = $(this).data("id");
        rejectApplication(applicationId);
        $(".normal-modalize").modal('hide');
    });

    // Load application counts
    loadApplicationCounts();
});

function approveApplication(applicationId) {
    Swal.fire({
        title: 'Approve Application?',
        text: 'This will approve the reseller application',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Approve',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#28a745'
    }).then(function(result) {
        if(result.isConfirmed) {
            updateApplicationStatus(applicationId, 'approved');
        }
    });
}

function rejectApplication(applicationId) {
    Swal.fire({
        title: 'Reject Application?',
        input: 'textarea',
        inputLabel: 'Reason for rejection',
        inputPlaceholder: 'Please provide a reason for rejecting this application...',
        inputAttributes: {
            'aria-label': 'Reason for rejection'
        },
        showCancelButton: true,
        confirmButtonText: 'Reject',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#dc3545',
        inputValidator: (value) => {
            if (!value) {
                return 'You need to provide a reason for rejection!'
            }
        }
    }).then(function(result) {
        if(result.isConfirmed) {
            updateApplicationStatus(applicationId, 'rejected', result.value);
        }
    });
}

function updateApplicationStatus(applicationId, status, reason) {
    $.ajax({
        url: "{$base_url}serverside/forms/update_reseller_application_status.php",
        type: "POST",
        data: {
            application_id: applicationId,
            status: status,
            reason: reason || ''
        },
        dataType: "JSON",
        success: function(response) {
            if(response.response == 1) {
                if(status == 'approved' && response.msg.includes('username:')) {
                    Swal.fire({
                        title: 'Application Approved!',
                        html: response.msg,
                        icon: 'success',
                        width: 600,
                        timer: 10000,
                        timerProgressBar: true
                    });
                } else {
                    Swal.fire('Success', response.msg, 'success');
                }
                $('.table-listapplication').DataTable().ajax.reload();
                loadApplicationCounts();
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to update application status', 'error');
        }
    });
}

function loadApplicationCounts() {
    $.ajax({
        url: "{$base_url}serverside/data/get_reseller_application_counts.php",
        type: "GET",
        dataType: "JSON",
        success: function(data) {
            $('.Pending').val(data.pending || 0);
            $('.Approved').val(data.approved || 0);
            $('.Total').val(data.total || 0);
        }
    });
}

function togglePasswordVisibility() {
    var passwordField = document.getElementById('password');
    var eyeIcon = document.getElementById('password-eye');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        eyeIcon.className = 'fas fa-eye-slash';
    } else {
        passwordField.type = 'password';
        eyeIcon.className = 'fas fa-eye';
    }
}
</script>
