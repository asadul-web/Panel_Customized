<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Notice API</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs4.min.css">
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
<h1>Notice API Management</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Panel Management</div>
<div class="breadcrumb-item active">Notice API</div>
</div>
</div>

<div class="section-body">
<div class="row">
<div class="col-md-8">
<div class="card">
<div class="card-header">
<h2 class="section-title"><i class="fas fa-bell"></i> Notice API Manager</h2>
</div>
<div class="card-body">
<form id="noticeForm">
<div class="form-group">
<label>Title</label>
<input type="text" class="form-control" name="title" id="noticeTitle" required>
</div>

<div class="form-group">
<label>Message</label>
<textarea class="form-control summernote" name="message" id="noticeMessage"></textarea>
</div>

<div class="row">
<div class="col-md-4">
<div class="form-group">
<label>Active</label>
<select class="form-control" name="active" id="noticeActive">
<option value="true">Yes</option>
<option value="false">No</option>
</select>
</div>
</div>
<div class="col-md-4">
<div class="form-group">
<label>Severity</label>
<select class="form-control" name="severity" id="noticeSeverity">
<option value="info">Info</option>
<option value="warning">Warning</option>
<option value="danger">Danger</option>
</select>
</div>
</div>
<div class="col-md-4">
<div class="form-group">
<label>&nbsp;</label>
<button type="submit" class="btn btn-primary btn-block" id="saveNoticeBtn">
<i class="fas fa-save"></i> Save Notice
</button>
</div>
</div>
</div>
</form>

<hr>

<h5>Current Status</h5>
<div id="noticeStatus" class="alert alert-secondary">
Loading...
</div>
</div>
</div>
</div>
</div>

<div class="col-md-4">
<div class="card">
<div class="card-header">
<h2 class="section-title"><i class="fas fa-info-circle"></i> API Information</h2>
</div>
<div class="card-body">
<div class="alert alert-success mb-3">
<strong>API Endpoint:</strong><br>
<code style="word-break: break-all;">{$notice_api_proxy}</code>
<small class="text-muted d-block mt-1"><i class="fas fa-lock"></i> Actual API URL is encrypted</small>
</div>
<h6>Methods:</h6>
<ul class="list-unstyled">
<li><span class="badge badge-primary">GET</span> Retrieve notice</li>
<li><span class="badge badge-success">POST</span> Update notice</li>
</ul>
<h6 class="mt-3">Response Format:</h6>
<pre class="bg-dark text-white p-2" style="font-size: 11px;">{literal}{
  "response": 1,
  "msg": "Success",
  "data": {...}
}{/literal}</pre>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs4.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/js/scripts.js"></script>

<script>
// Cache buster - v2.0 - Direct API endpoint
var NOTICE_API_URL = '/notice-api-direct.php?v=' + Date.now();

$(document).ready(function() {
    // Hide loading animation
    $('#loading').fadeOut();
    
    // Initialize Summernote
    $('.summernote').summernote({
        height: 200,
        focus: false,
        airMode: false,
        disableDragAndDrop: false,
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ],
        callbacks: {
            onInit: function() {
                // Ensure editor is editable on init
                $('.summernote').summernote('enable');
            }
        }
    });
    
    loadNotice();
    
    $('#noticeForm').on('submit', function(e) {
        e.preventDefault();
        
        var $btn = $('#saveNoticeBtn');
        $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...');
        
        var formData = {
            title: $('#noticeTitle').val(),
            message: $('#noticeMessage').summernote('code'),
            active: $('#noticeActive').val() === 'true',
            severity: $('#noticeSeverity').val()
        };
        
        console.log('Saving to:', '/notice-api-direct.php');
        console.log('Data:', formData);
        
        $.ajax({
            url: '{$notice_api_proxy}',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            dataType: 'json',
            success: function(response) {
                console.log('Save response:', response);
                $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Save Notice');
                
                if(response.response == 1) {
                    Swal.fire({
                        title: 'Success!',
                        text: 'Notice saved successfully',
                        icon: 'success',
                        timer: 2000,
                        showConfirmButton: false
                    });
                    setTimeout(function() {
                        loadNotice();
                    }, 500);
                } else {
                    Swal.fire({
                        title: 'Error!',
                        text: response.msg || 'Failed to save',
                        icon: 'error'
                    });
                }
            },
            error: function(xhr, status, error) {
                console.error('Save error:', status, error, xhr.responseText);
                $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Save Notice');
                
                Swal.fire({
                    title: 'Error!',
                    text: 'API Error: ' + status + ' - Check browser console (F12) for details',
                    icon: 'error'
                });
            }
        });
    });
});

function loadNotice() {
    $.ajax({
        url: '{$notice_api_proxy}',
        type: 'GET',
        success: function(response) {
            console.log('Load response:', response);
            if(response.response == 1) {
                var data = response.data;
                $('#noticeTitle').val(data.title);
                $('#noticeMessage').summernote('code', data.message);
                $('#noticeMessage').summernote('enable'); // Enable editing
                $('#noticeActive').val(data.active ? 'true' : 'false');
                $('#noticeSeverity').val(data.severity);
                
                var statusHtml = '<strong>Status:</strong> ' + (data.billing.status || 'ok') + '<br>';
                statusHtml += '<strong>Days Remaining:</strong> ' + (data.billing.days_remaining || 'N/A');
                $('#noticeStatus').html(statusHtml);
            }
        },
        error: function(xhr, status, error) {
            console.error('Load error:', status, error, xhr.responseText);
        }
    });
}

{if $is_locked}
// Show password popup immediately
showPasswordPopup();

function showPasswordPopup() {
    Swal.fire({
        title: '<i class="fas fa-lock text-primary"></i> Notice API Access',
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
                url: '/notice-api',
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

