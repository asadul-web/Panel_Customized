<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — API Settings</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
</head>
<body>
<div id="app">
<div class="main-wrapper">
{include file='apps/sidenav.tpl'}
{include file='apps/topnav.tpl'}

<div class="main-content">
<section class="section">
<div class="section-header">
<h1><i class="fas fa-shield-alt text-primary"></i> API URL Encryption Settings</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item active"><a href="/dashboard">Dashboard</a></div>
<div class="breadcrumb-item">API Settings</div>
</div>
</div>

<div class="section-body">

{if $message}
<div class="alert alert-{$message_type} alert-dismissible fade show">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <i class="fas fa-{if $message_type == 'success'}check-circle{else}exclamation-triangle{/if}"></i>
    {$message}
</div>
{/if}

<div class="row">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-lock text-success"></i> Encrypted API URLs</h4>
                <div class="card-header-action">
                    <span class="badge badge-{if $config_status.valid}success{else}warning{/if}">
                        {if $config_status.valid}<i class="fas fa-check"></i> Configured{else}<i class="fas fa-exclamation"></i> Needs Setup{/if}
                    </span>
                </div>
            </div>
            <div class="card-body">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <strong>Security Notice:</strong> These API URLs are encrypted using AES-256-CBC and stored securely. 
                    They are never exposed to the frontend - only proxy URLs are visible to users.
                </div>
                
                <form method="POST" action="">
                    <input type="hidden" name="action" value="update_urls">
                    
                    <div class="form-group">
                        <label><i class="fas fa-key text-primary"></i> License API URL</label>
                        <input type="url" name="license_api_url" class="form-control" 
                               value="{$current_urls.license_api_url|escape:'html'}" 
                               placeholder="https://example.com/serverside/data/licenses_api.php">
                        <small class="text-muted">Remote license verification API endpoint</small>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-bullhorn text-warning"></i> Notice API URL</label>
                        <input type="url" name="notice_api_url" class="form-control" 
                               value="{$current_urls.notice_api_url|escape:'html'}" 
                               placeholder="https://example.com/serverside/data/notice_api.php">
                        <small class="text-muted">Remote notice management API endpoint</small>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-window-restore text-info"></i> Popup Notice API URL</label>
                        <input type="url" name="popup_notice_api_url" class="form-control" 
                               value="{$current_urls.popup_notice_api_url|escape:'html'}" 
                               placeholder="https://example.com/serverside/data/popup_notice_api.php">
                        <small class="text-muted">Remote popup notice API endpoint</small>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save"></i> Encrypt & Save URLs
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-undo text-warning"></i> Reset to Defaults</h4>
            </div>
            <div class="card-body">
                <form method="POST" action="" onsubmit="return confirm('Are you sure you want to reset all API URLs to defaults?');">
                    <input type="hidden" name="action" value="reset_defaults">
                    
                    <div class="form-group">
                        <label>Base URL for Default Endpoints</label>
                        <input type="url" name="base_url" class="form-control" 
                               value="https://ruzain.com" 
                               placeholder="https://example.com">
                        <small class="text-muted">All API endpoints will be generated from this base URL</small>
                    </div>
                    
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-undo"></i> Reset to Defaults
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-info-circle text-info"></i> How It Works</h4>
            </div>
            <div class="card-body">
                <h6><i class="fas fa-lock text-success"></i> Encryption</h6>
                <p class="text-muted">API URLs are encrypted using AES-256-CBC with HMAC verification. The encryption key is unique to your server installation.</p>
                
                <h6><i class="fas fa-exchange-alt text-primary"></i> Proxy System</h6>
                <p class="text-muted">Frontend JavaScript only sees local proxy URLs. The actual remote API URLs are decrypted server-side and never exposed to browsers.</p>
                
                <h6><i class="fas fa-shield-alt text-warning"></i> Security Benefits</h6>
                <ul class="text-muted">
                    <li>API URLs hidden from browser dev tools</li>
                    <li>Cannot be modified by users</li>
                    <li>Tamper detection via HMAC</li>
                    <li>Machine-specific encryption keys</li>
                </ul>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-link text-success"></i> Proxy URLs</h4>
            </div>
            <div class="card-body">
                <p class="text-muted mb-2">These are the safe URLs exposed to frontend:</p>
                
                <div class="mb-2">
                    <strong>License Proxy:</strong><br>
                    <code class="text-success">/serverside/data/licenses_proxy.php</code>
                </div>
                
                <div class="mb-2">
                    <strong>Notice Proxy:</strong><br>
                    <code class="text-success">/serverside/data/notice_proxy.php</code>
                </div>
                
                <div class="mb-2">
                    <strong>Popup Notice Proxy:</strong><br>
                    <code class="text-success">/serverside/data/popup_notice_proxy.php</code>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-check-circle text-success"></i> Config Status</h4>
            </div>
            <div class="card-body">
                <table class="table table-sm">
                    <tr>
                        <td>Configuration Valid</td>
                        <td class="text-right">
                            {if $config_status.valid}
                            <span class="badge badge-success"><i class="fas fa-check"></i> Yes</span>
                            {else}
                            <span class="badge badge-danger"><i class="fas fa-times"></i> No</span>
                            {/if}
                        </td>
                    </tr>
                    <tr>
                        <td>URLs Configured</td>
                        <td class="text-right">
                            <span class="badge badge-info">{$config_status.urls_count} / 3</span>
                        </td>
                    </tr>
                    {if $config_status.errors}
                    <tr>
                        <td colspan="2">
                            <div class="alert alert-warning mb-0 mt-2">
                                {foreach $config_status.errors as $error}
                                <small><i class="fas fa-exclamation-triangle"></i> {$error}</small><br>
                                {/foreach}
                            </div>
                        </td>
                    </tr>
                    {/if}
                </table>
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
<script src="/dist/sweetalert2/sweetalert2.all.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/js/scripts.js"></script>

{if $is_locked}
<script>
$(document).ready(function() {
    // Show password popup immediately
    showPasswordPopup();
    
    function showPasswordPopup() {
        Swal.fire({
            title: '<i class="fas fa-lock text-primary"></i> API Settings Access',
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
                    url: '/api-settings',
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
});
</script>
{/if}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
