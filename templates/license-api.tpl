<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — License API</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
</head>

<body>

<div class="center" id="loading">
    <div class='building-blocks'>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
    </div>
</div>

<div class="main-wrapper">
{include file='apps/topnav.tpl'}
{include file='apps/sidenav.tpl'}

<div class="main-content">
<section class="section">
<div class="section-header">
<h1>License API Management</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">API Management</div>
<div class="breadcrumb-item active">License API</div>
</div>
</div>

<div class="section-body">
<div class="row">
<div class="col-md-12">
<div class="card">
<div class="card-header">
<h2 class="section-title"><i class="fas fa-key"></i> License API Manager</h2>
</div>
<div class="card-body">
<div class="alert alert-info">
<strong><i class="fas fa-info-circle"></i> API Endpoint:</strong> 
<code>http://localhost/serverside/data/licenses_api.php</code>
</div>

<h5>Create License</h5>
<form id="createLicenseForm">
<div class="row">
<div class="col-md-3">
<div class="form-group">
<label>Count</label>
<input type="number" class="form-control" name="count" min="1" max="50" value="1" required>
</div>
</div>
<div class="col-md-3">
<div class="form-group">
<label>Prefix</label>
<input type="text" class="form-control" name="prefix" value="LIC" required>
</div>
</div>
<div class="col-md-3">
<div class="form-group">
<label>Validity (Days)</label>
<select class="form-control" name="duration">
<option value="30" selected>30 Days (Default)</option>
<option value="30">1 Month</option>
<option value="90">3 Months</option>
<option value="180">6 Months</option>
<option value="365">1 Year</option>
</select>
</div>
</div>
<div class="col-md-3">
<div class="form-group">
<label>&nbsp;</label>
<button type="submit" class="btn btn-primary btn-block"><i class="fas fa-plus"></i> Generate</button>
</div>
</div>
</div>
</form>

<hr>

<h5>License List</h5>
<div class="table-responsive">
<table class="table table-striped" id="licenseTable">
<thead>
<tr>
<th>License Key</th>
<th>Status</th>
<th>Domain</th>
<th>Expires</th>
<th>Created</th>
<th>Actions</th>
</tr>
</thead>
<tbody id="licenseList">
<tr>
<td colspan="6" class="text-center">Loading...</td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
</div>
</div>
</div>
</section>
</div>

</div>

<script src="/dist/modules/jquery.min.js"></script>
<script src="/dist/modules/popper.js"></script>
<script src="/dist/modules/tooltip.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="/dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script src="/dist/sweetalert2/sweetalert2.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/js/scripts.js"></script>

<script>
$(document).ready(function() {
    // Hide loading animation
    $('#loading').fadeOut();
    
    loadLicenses();
    
    $('#createLicenseForm').on('submit', function(e) {
        e.preventDefault();
        var formData = {
            action: 'create',
            count: parseInt($('input[name="count"]').val()),
            prefix: $('input[name="prefix"]').val(),
            duration: parseInt($('select[name="duration"]').val())
        };
        
        $.ajax({
            url: '/serverside/data/licenses_api.php',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(response) {
                if(response.response == 1) {
                    Swal.fire('Success', 'License created', 'success');
                    loadLicenses();
                    $('#createLicenseForm')[0].reset();
                } else {
                    Swal.fire('Error', response.msg || 'Failed', 'error');
                }
            },
            error: function() {
                Swal.fire('Error', 'Failed to connect to API', 'error');
            }
        });
    });
});

function loadLicenses() {
    $.ajax({
        url: '/serverside/data/licenses_api.php',
        type: 'GET',
        success: function(response) {
            if(response.response == 1) {
                var html = '';
                if(response.data.length === 0) {
                    html = '<tr><td colspan="6" class="text-center">No licenses</td></tr>';
                } else {
                    response.data.forEach(function(license) {
                        var now = Math.floor(Date.now() / 1000);
                        var isExpired = license.expires_at && license.expires_at < now;
                        var statusBadge = isExpired 
                            ? '<span class="badge badge-danger">Expired</span>'
                            : (license.status === 'active' 
                                ? '<span class="badge badge-success">Active</span>' 
                                : '<span class="badge badge-secondary">Disabled</span>');
                        var createdDate = new Date(license.created_at * 1000).toLocaleDateString();
                        var expiryDate = license.expires_at ? new Date(license.expires_at * 1000).toLocaleDateString() : '-';
                        var domain = license.domain || '<span class="text-muted">Not assigned</span>';
                        html += '<tr>';
                        html += '<td><code>' + license.key + '</code></td>';
                        html += '<td>' + statusBadge + '</td>';
                        html += '<td>' + domain + '</td>';
                        html += '<td>' + expiryDate + '</td>';
                        html += '<td>' + createdDate + '</td>';
                        html += '<td>';
                        html += '<button class="btn btn-sm btn-info" onclick="renewLicense(\'' + license.key + '\')" title="Renew"><i class="fas fa-sync"></i></button> ';
                        html += '<button class="btn btn-sm btn-warning" onclick="assignDomain(\'' + license.key + '\', \'' + (license.domain || '') + '\')" title="Assign Domain"><i class="fas fa-globe"></i></button> ';
                        if (license.status === 'active') {
                            html += '<button class="btn btn-sm btn-secondary" onclick="blockLicense(\'' + license.key + '\')" title="Block"><i class="fas fa-ban"></i></button> ';
                        } else {
                            html += '<button class="btn btn-sm btn-success" onclick="unblockLicense(\'' + license.key + '\')" title="Unblock"><i class="fas fa-check-circle"></i></button> ';
                        }
                        html += '<button class="btn btn-sm btn-danger" onclick="deleteLicense(\'' + license.key + '\')" title="Delete"><i class="fas fa-trash"></i></button>';
                        html += '</td>';
                        html += '</tr>';
                    });
                }
                $('#licenseList').html(html);
            }
        }
    });
}

function renewLicense(key) {
    Swal.fire({
        title: 'Renew License',
        text: 'Select renewal duration',
        icon: 'question',
        input: 'select',
        inputOptions: {
            '30': '1 Month (30 days)',
            '90': '3 Months (90 days)',
            '180': '6 Months (180 days)',
            '365': '1 Year (365 days)'
        },
        inputPlaceholder: 'Select duration',
        showCancelButton: true,
        confirmButtonText: 'Renew',
        cancelButtonText: 'Cancel',
        inputValidator: (value) => {
            if (!value) {
                return 'You need to select a duration!';
            }
        }
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/serverside/data/licenses_api.php',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ 
                    action: 'renew', 
                    key: key,
                    duration: parseInt(result.value)
                }),
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire('Renewed!', response.msg || 'License renewed successfully', 'success');
                        loadLicenses();
                    } else {
                        Swal.fire('Error', response.msg || 'Failed to renew', 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to connect to API', 'error');
                }
            });
        }
    });
}

function assignDomain(key, currentDomain) {
    Swal.fire({
        title: 'Assign Domain',
        text: 'Enter domain name for this license',
        icon: 'question',
        input: 'text',
        inputValue: currentDomain,
        inputPlaceholder: 'example.com',
        showCancelButton: true,
        confirmButtonText: 'Assign',
        cancelButtonText: 'Cancel',
        inputValidator: (value) => {
            if (!value) {
                return 'Domain cannot be empty!';
            }
        }
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/serverside/data/licenses_api.php',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ 
                    action: 'update', 
                    key: key,
                    domain: result.value
                }),
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire('Success!', 'Domain assigned successfully', 'success');
                        loadLicenses();
                    } else {
                        Swal.fire('Error', response.msg || 'Failed to assign domain', 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to connect to API', 'error');
                }
            });
        }
    });
}

function blockLicense(key) {
    Swal.fire({
        title: 'Block License?',
        text: 'This will prevent the license from being used. License: ' + key,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, block it!',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#6c757d',
        cancelButtonColor: '#3085d6'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/serverside/data/licenses_api.php',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ action: 'update', key: key, status: 'disabled' }),
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire('Blocked!', 'License has been blocked', 'success');
                        loadLicenses();
                    } else {
                        Swal.fire('Error', response.msg || 'Failed to block', 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to connect to API', 'error');
                }
            });
        }
    });
}

function unblockLicense(key) {
    Swal.fire({
        title: 'Unblock License?',
        text: 'This will allow the license to be used again. License: ' + key,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, unblock it!',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#28a745',
        cancelButtonColor: '#3085d6'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/serverside/data/licenses_api.php',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ action: 'update', key: key, status: 'active' }),
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire('Unblocked!', 'License has been unblocked', 'success');
                        loadLicenses();
                    } else {
                        Swal.fire('Error', response.msg || 'Failed to unblock', 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to connect to API', 'error');
                }
            });
        }
    });
}

function deleteLicense(key) {
    Swal.fire({
        title: 'Delete License?',
        text: 'License: ' + key,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, delete it!',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/serverside/data/licenses_api.php',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ action: 'delete', key: key }),
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire('Deleted!', 'License has been deleted', 'success');
                        loadLicenses();
                    } else {
                        Swal.fire('Error', response.msg || 'Failed to delete', 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to connect to API', 'error');
                }
            });
        }
    });
}

{if $is_locked}
// Show password popup immediately
showPasswordPopup();

function showPasswordPopup() {
    Swal.fire({
        title: '<i class="fas fa-lock text-primary"></i> License API Access',
        html: '<p class="text-muted mb-3">This page is password protected</p>',
        input: 'password',
        inputPlaceholder: 'Enter password',
        inputAttributes: {
            autocapitalize: 'off',
            autocorrect: 'off'
        },
        showCancelButton: true,
        cancelButtonText: '<i class="fas fa-arrow-left"></i> Back to Dashboard',
        confirmButtonText: '<i class="fas fa-unlock"></i> Unlock',
        allowOutsideClick: false,
        allowEscapeKey: false,
        customClass: {
            confirmButton: 'btn btn-primary',
            cancelButton: 'btn btn-secondary'
        },
        preConfirm: (password) => {
            if (!password) {
                Swal.showValidationMessage('Please enter a password');
                return false;
            }
            
            return $.ajax({
                url: '/license-api',
                type: 'POST',
                data: { verify_password: password },
                dataType: 'json'
            }).then(response => {
                if (!response.success) {
                    throw new Error(response.message || 'Incorrect password');
                }
                return response;
            }).catch(error => {
                Swal.showValidationMessage(error.message || 'Incorrect password!');
            });
        }
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                icon: 'success',
                title: 'Access Granted!',
                text: 'Reloading page...',
                timer: 1000,
                showConfirmButton: false
            }).then(() => {
                window.location.reload();
            });
        } else {
            window.location.href = '/dashboard';
        }
    });
}
{/if}
</script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
