<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Popup Notice</title>
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
<h1>Popup Notice Manager</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Panel Management</div>
<div class="breadcrumb-item active">Popup Notice</div>
</div>
</div>

<div class="section-body">
<div class="row">
<div class="col-md-8">
<div class="card">
<div class="card-header">
<h2 class="section-title"><i class="fas fa-window-restore"></i> Popup Notice Configuration</h2>
</div>
<div class="card-body">
<form id="popupNoticeForm">
<div class="form-group">
<label>Title</label>
<input type="text" class="form-control" name="title" id="popupTitle" required>
</div>

<div class="form-group">
<label>Message</label>
<textarea class="form-control summernote" name="message" id="popupMessage"></textarea>
</div>

<div class="row">
<div class="col-md-3">
<div class="form-group">
<label>Active</label>
<select class="form-control" name="active" id="popupActive">
<option value="true">Yes</option>
<option value="false">No</option>
</select>
</div>
</div>
<div class="col-md-3">
<div class="form-group">
<label>Icon</label>
<select class="form-control" name="icon" id="popupIcon">
<option value="success">Success (✓)</option>
<option value="info">Info (ℹ)</option>
<option value="warning">Warning (⚠)</option>
<option value="error">Error (✗)</option>
</select>
</div>
</div>
<div class="col-md-3">
<div class="form-group">
<label>Show on Login</label>
<select class="form-control" name="show_on_login" id="showOnLogin">
<option value="true">Yes</option>
<option value="false">No</option>
</select>
</div>
</div>
<div class="col-md-3">
<div class="form-group">
<label>Show on Dashboard</label>
<select class="form-control" name="show_on_dashboard" id="showOnDashboard">
<option value="true">Yes</option>
<option value="false">No</option>
</select>
</div>
</div>
</div>

<button type="submit" class="btn btn-primary btn-lg btn-block" id="savePopupBtn">
<i class="fas fa-save"></i> Save Popup Notice
</button>
</form>

<hr>

<h5>Preview</h5>
<button type="button" class="btn btn-info" id="previewBtn">
<i class="fas fa-eye"></i> Preview Popup
</button>

<hr>

<h5>Current Status</h5>
<div id="popupStatus" class="alert alert-secondary">
Loading...
</div>
</div>
</div>
</div>
</div>

<div class="col-md-4">
<div class="card">
<div class="card-header">
<h2 class="section-title"><i class="fas fa-info-circle"></i> Popup Information</h2>
</div>
<div class="card-body">
<div class="alert alert-info mb-3">
<strong><i class="fas fa-lightbulb"></i> Info:</strong><br>
This popup appears as a SweetAlert dialog when users access the panel.
</div>
<h6>Display Options:</h6>
<ul class="list-unstyled">
<li><i class="fas fa-check text-success"></i> Auto-display on login</li>
<li><i class="fas fa-check text-success"></i> Dismissible by users</li>
<li><i class="fas fa-check text-success"></i> Customizable icon</li>
</ul>
<h6 class="mt-3">Icon Types:</h6>
<div class="mb-2">
<span class="badge badge-info">info</span>
<span class="badge badge-success">success</span>
<span class="badge badge-warning">warning</span>
<span class="badge badge-danger">error</span>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs4.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/js/scripts.js"></script>

<script>
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
    
    loadPopupNotice();
    
    $('#popupNoticeForm').on('submit', function(e) {
        e.preventDefault();
        
        var $btn = $('#savePopupBtn');
        $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...');
        
        var formData = {
            title: $('#popupTitle').val(),
            message: $('#popupMessage').summernote('code'),
            active: $('#popupActive').val() === 'true',
            icon: $('#popupIcon').val(),
            show_on_login: $('#showOnLogin').val() === 'true',
            show_on_dashboard: $('#showOnDashboard').val() === 'true'
        };
        
        $.ajax({
            url: '{$popup_notice_proxy}',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            dataType: 'json',
            success: function(response) {
                $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Save Popup Notice');
                
                if(response.response == 1) {
                    Swal.fire({
                        title: 'Success!',
                        text: 'Popup notice saved successfully',
                        icon: 'success',
                        timer: 2000,
                        showConfirmButton: false
                    });
                    setTimeout(function() {
                        loadPopupNotice();
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
                $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Save Popup Notice');
                
                Swal.fire({
                    title: 'Error!',
                    text: 'Failed to connect to API: ' + status,
                    icon: 'error'
                });
            }
        });
    });
    
    $('#previewBtn').on('click', function() {
        var title = $('#popupTitle').val();
        var message = $('#popupMessage').summernote('code');
        var icon = $('#popupIcon').val();
        
        var htmlContent = document.createElement("div");
        htmlContent.innerHTML = '<div class="swal-title" style="padding-bottom:10px; font-weight:bold; font-size:18px;">' + title + '</div>'
            + '<div style="padding-top:10px;">' + message + '</div>';
        
        Swal.fire({
            icon: icon,
            html: htmlContent,
            confirmButtonText: 'Confirm',
            showCloseButton: false,
            didOpen: function () {
                Swal.getConfirmButton().blur();
            },
            customClass: {
                confirmButton: 'swal2-confirm btn btn-primary swal2-styled'
            }
        });
    });
});

function loadPopupNotice() {
    $.ajax({
        url: '{$popup_notice_proxy}',
        type: 'GET',
        success: function(response) {
            if(response.response == 1) {
                var data = response.data;
                $('#popupTitle').val(data.title);
                $('#popupMessage').summernote('code', data.message);
                $('#popupMessage').summernote('enable'); // Enable editing
                $('#popupActive').val(data.active ? 'true' : 'false');
                $('#popupIcon').val(data.icon);
                $('#showOnLogin').val(data.show_on_login ? 'true' : 'false');
                $('#showOnDashboard').val(data.show_on_dashboard ? 'true' : 'false');
                
                var statusHtml = '<strong>Status:</strong> ' + (data.active ? '<span class="badge badge-success">Active</span>' : '<span class="badge badge-danger">Inactive</span>') + '<br>';
                statusHtml += '<strong>Icon:</strong> ' + data.icon + '<br>';
                statusHtml += '<strong>Show on Login:</strong> ' + (data.show_on_login ? 'Yes' : 'No') + '<br>';
                statusHtml += '<strong>Show on Dashboard:</strong> ' + (data.show_on_dashboard ? 'Yes' : 'No') + '<br>';
                statusHtml += '<strong>Last Updated:</strong> ' + new Date(data.updated_at * 1000).toLocaleString() + '<br>';
                statusHtml += '<strong>Updated By:</strong> ' + data.updated_by;
                $('#popupStatus').html(statusHtml);
            }
        }
    });
}
</script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>

