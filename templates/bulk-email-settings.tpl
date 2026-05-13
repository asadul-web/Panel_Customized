<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Bulk Email Settings</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
</head>

<body>
<div id="app">
<div class="main-wrapper main-wrapper-1">
<div class="navbar-bg"></div>
{include file='apps/topnav.tpl'}
{include file='apps/sidenav.tpl'}

<div class="main-content">
<section class="section">
<div class="section-header">
<h1><i class="fas fa-cogs"></i> Bulk Email Settings</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item active"><a href="dashboard">Dashboard</a></div>
<div class="breadcrumb-item">Bulk Email Settings</div>
</div>
</div>

<div class="section-body">
<div class="row">
<div class="col-12">
<div class="card">
<div class="card-header">
<h4>Bulk Email Configuration</h4>
</div>
<div class="card-body">
<form id="bulkEmailSettingsForm">
<div class="row">
<div class="col-md-6">
<div class="form-group">
<label class="custom-switch">
<input type="checkbox" name="bulk_email_enabled" class="custom-switch-input" {if $settings.bulk_email_enabled == '1'}checked{/if}>
<span class="custom-switch-indicator"></span>
<span class="custom-switch-description">Enable Bulk Email System</span>
</label>
<small class="form-text text-muted">Enable or disable the bulk email functionality</small>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label class="custom-switch">
<input type="checkbox" name="email_tracking_enabled" class="custom-switch-input" {if $settings.email_tracking_enabled == '1'}checked{/if}>
<span class="custom-switch-indicator"></span>
<span class="custom-switch-description">Enable Email Tracking</span>
</label>
<small class="form-text text-muted">Track email opens and clicks</small>
</div>
</div>
</div>

<div class="row">
<div class="col-md-6">
<div class="form-group">
<label for="bulk_email_per_batch">Emails per Batch</label>
<input type="number" class="form-control" id="bulk_email_per_batch" name="bulk_email_per_batch" value="{$settings.bulk_email_per_batch|default:50}" min="1" max="500">
<small class="form-text text-muted">Number of emails to send in each batch</small>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label for="bulk_email_delay">Delay Between Batches (seconds)</label>
<input type="number" class="form-control" id="bulk_email_delay" name="bulk_email_delay" value="{$settings.bulk_email_delay|default:5}" min="1" max="60">
<small class="form-text text-muted">Delay between sending batches to avoid spam filters</small>
</div>
</div>
</div>

<div class="row">
<div class="col-md-6">
<div class="form-group">
<label for="bulk_email_from_name">Default From Name</label>
<input type="text" class="form-control" id="bulk_email_from_name" name="bulk_email_from_name" value="{$settings.bulk_email_from_name|default:'VPN Panel'}">
<small class="form-text text-muted">Default sender name for bulk emails</small>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label for="bulk_email_reply_to">Reply-To Email (Optional)</label>
<input type="email" class="form-control" id="bulk_email_reply_to" name="bulk_email_reply_to" value="{$settings.bulk_email_reply_to|default:''}">
<small class="form-text text-muted">Email address for replies (leave empty to use SMTP from email)</small>
</div>
</div>
</div>

<div class="form-group">
<button type="submit" class="btn btn-primary">
<i class="fas fa-save"></i> Save Settings
</button>
<button type="button" class="btn btn-secondary" onclick="resetSettings()">
<i class="fas fa-undo"></i> Reset to Defaults
</button>
</div>
</form>
</div>
</div>
</div>
</div>

<!-- SMTP Settings Info -->
<div class="row">
<div class="col-12">
<div class="card">
<div class="card-header">
<h4>SMTP Configuration</h4>
</div>
<div class="card-body">
<div class="alert alert-info">
<i class="fas fa-info-circle"></i>
<strong>SMTP Settings</strong> - Bulk emails use the same SMTP configuration as the reseller system.
<br>To configure SMTP settings, go to <a href="/reseller-settings">Reseller Settings</a>.
</div>

<div class="row">
<div class="col-md-6">
<h6>Current SMTP Status:</h6>
<div id="smtpStatus">
<i class="fas fa-spinner fa-spin"></i> Checking SMTP configuration...
</div>
</div>
<div class="col-md-6">
<h6>Quick Actions:</h6>
<a href="/reseller-settings" class="btn btn-info btn-sm">
<i class="fas fa-cog"></i> Configure SMTP
</a>
<button class="btn btn-success btn-sm" onclick="testSMTP()">
<i class="fas fa-paper-plane"></i> Test SMTP
</button>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</section>
</div>

</div>
</div>

<script src="/dist/modules/jquery.min.js"></script>
<script src="/dist/modules/popper.js"></script>
<script src="/dist/modules/tooltip.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="/dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script src="/dist/modules/moment.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/sweetalert2/sweetalert2.min.js"></script>

<script>
$(document).ready(function() {
    checkSMTPStatus();
    
    $('#bulkEmailSettingsForm').on('submit', function(e) {
        e.preventDefault();
        saveSettings();
    });
});

function saveSettings() {
    var formData = {
        bulk_email_enabled: $('input[name="bulk_email_enabled"]').is(':checked') ? '1' : '0',
        email_tracking_enabled: $('input[name="email_tracking_enabled"]').is(':checked') ? '1' : '0',
        bulk_email_per_batch: $('#bulk_email_per_batch').val(),
        bulk_email_delay: $('#bulk_email_delay').val(),
        bulk_email_from_name: $('#bulk_email_from_name').val(),
        bulk_email_reply_to: $('#bulk_email_reply_to').val()
    };
    
    $.ajax({
        url: '/serverside/forms/save_bulk_email_settings.php',
        type: 'POST',
        data: formData,
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire('Success', response.msg, 'success');
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to save settings', 'error');
        }
    });
}

function resetSettings() {
    Swal.fire({
        title: 'Reset to Defaults?',
        text: 'This will reset all bulk email settings to their default values',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, Reset',
        cancelButtonText: 'Cancel'
    }).then(function(result) {
        if(result.isConfirmed) {
            // Reset form to defaults
            $('input[name="bulk_email_enabled"]').prop('checked', true);
            $('input[name="email_tracking_enabled"]').prop('checked', true);
            $('#bulk_email_per_batch').val('50');
            $('#bulk_email_delay').val('5');
            $('#bulk_email_from_name').val('VPN Panel');
            $('#bulk_email_reply_to').val('');
            
            Swal.fire('Reset', 'Settings have been reset to defaults. Click Save to apply.', 'info');
        }
    });
}

function checkSMTPStatus() {
    $('#smtpStatus').html('<i class="fas fa-spinner fa-spin"></i> Checking SMTP configuration...');
    
    // For now, show a placeholder status
    setTimeout(function() {
        $('#smtpStatus').html(`
            <div class="alert alert-warning alert-sm mb-0">
                <i class="fas fa-exclamation-triangle"></i>
                SMTP status check is being developed. Please test SMTP manually.
            </div>
        `);
    }, 1000);
}

function testSMTP() {
    Swal.fire({
        title: 'Test SMTP',
        text: 'This will redirect you to the SMTP test page in the reseller settings.',
        icon: 'info',
        showCancelButton: true,
        confirmButtonText: 'Go to SMTP Test',
        cancelButtonText: 'Cancel'
    }).then(function(result) {
        if(result.isConfirmed) {
            window.location.href = '/reseller-settings';
        }
    });
}
</script>

<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom.js?v=2"></script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
