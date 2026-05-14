<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Save URLs</title>
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
<h1><i class="fas fa-save text-primary"></i> Save & Encrypt URLs</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item active"><a href="/dashboard">Dashboard</a></div>
<div class="breadcrumb-item">API Management</div>
<div class="breadcrumb-item">Save URLs</div>
</div>
</div>

<div class="section-body">

{if $result && !$result.success && isset($result.errors)}
<div class="alert alert-danger alert-dismissible fade show">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <i class="fas fa-exclamation-triangle"></i> <strong>Validation Errors:</strong>
    <ul class="mb-0 mt-2">
        {foreach $result.errors as $error}
        <li>{$error}</li>
        {/foreach}
    </ul>
</div>
{/if}

{if $result && !$result.success && isset($result.message)}
<div class="alert alert-danger alert-dismissible fade show">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> {$result.message}
</div>
{/if}

{if $result && $result.success}
<div class="alert alert-success alert-dismissible fade show">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <i class="fas fa-check-circle"></i> <strong>Success!</strong> {$result.message}
</div>

<div class="row">
    <div class="col-lg-12">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-key text-success"></i> Encrypted URLs (Individual)</h4>
                <div class="card-header-action">
                    <small class="text-muted">These are the individual encrypted URLs</small>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>Original URL</th>
                                <th>Encrypted Value</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>🔑 License API</strong></td>
                                <td class="text-break" style="max-width: 200px;">{$result.urls.license_api_url}</td>
                                <td class="text-break" style="font-family: monospace; font-size: 11px; max-width: 300px;">{$result.encrypted.license_api_url}</td>
                                <td><button class="btn btn-sm btn-outline-primary" onclick="copyText('{$result.encrypted.license_api_url}')"><i class="fas fa-copy"></i></button></td>
                            </tr>
                            <tr>
                                <td><strong>📢 Notice API</strong></td>
                                <td class="text-break" style="max-width: 200px;">{$result.urls.notice_api_url}</td>
                                <td class="text-break" style="font-family: monospace; font-size: 11px; max-width: 300px;">{$result.encrypted.notice_api_url}</td>
                                <td><button class="btn btn-sm btn-outline-primary" onclick="copyText('{$result.encrypted.notice_api_url}')"><i class="fas fa-copy"></i></button></td>
                            </tr>
                            <tr>
                                <td><strong>🪟 Popup Notice API</strong></td>
                                <td class="text-break" style="max-width: 200px;">{$result.urls.popup_notice_api_url}</td>
                                <td class="text-break" style="font-family: monospace; font-size: 11px; max-width: 300px;">{$result.encrypted.popup_notice_api_url}</td>
                                <td><button class="btn btn-sm btn-outline-primary" onclick="copyText('{$result.encrypted.popup_notice_api_url}')"><i class="fas fa-copy"></i></button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
{/if}

<div class="row">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-shield-alt text-primary"></i> Save & Encrypt API URLs</h4>
            </div>
            <div class="card-body">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    This tool encrypts and saves all API URLs to the configuration file. Leave fields empty to keep current values.
                </div>
                
                <form method="POST" action="">
                    <div class="form-group">
                        <label>🔑 License API URL</label>
                        <input type="url" name="license_api_url" class="form-control"
                               value="{$post_data.license_api_url|default:$current_urls.license_api_url}"
                               placeholder="https://ruzain.com/serverside/data/licenses_api.php">
                        <small class="form-text text-muted">Remote license verification endpoint</small>
                    </div>
                    
                    <div class="form-group">
                        <label>📢 Notice API URL</label>
                        <input type="url" name="notice_api_url" class="form-control"
                               value="{$post_data.notice_api_url|default:$current_urls.notice_api_url}"
                               placeholder="https://ruzain.com/serverside/data/notice_api.php">
                        <small class="form-text text-muted">Remote notice management endpoint</small>
                    </div>
                    
                    <div class="form-group">
                        <label>🪟 Popup Notice API URL</label>
                        <input type="url" name="popup_notice_api_url" class="form-control"
                               value="{$post_data.popup_notice_api_url|default:$current_urls.popup_notice_api_url}"
                               placeholder="https://ruzain.com/serverside/data/popup_notice_api.php">
                        <small class="form-text text-muted">Remote popup notice endpoint</small>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fas fa-save"></i> Save & Encrypt URLs
                    </button>
                </form>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-eye text-info"></i> Current URLs</h4>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <small class="text-muted">🔑 License API:</small>
                    <div class="text-break" style="font-size: 12px;">{$current_urls.license_api_url|default:'Not set'}</div>
                </div>
                <div class="mb-3">
                    <small class="text-muted">📢 Notice API:</small>
                    <div class="text-break" style="font-size: 12px;">{$current_urls.notice_api_url|default:'Not set'}</div>
                </div>
                <div class="mb-0">
                    <small class="text-muted">🪟 Popup Notice API:</small>
                    <div class="text-break" style="font-size: 12px;">{$current_urls.popup_notice_api_url|default:'Not set'}</div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-question-circle text-warning"></i> How It Works</h4>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <h6><i class="fas fa-step-forward text-primary"></i> Step 1</h6>
                    <small>URLs are validated for proper format</small>
                </div>
                <div class="mb-3">
                    <h6><i class="fas fa-step-forward text-primary"></i> Step 2</h6>
                    <small>Each URL is encrypted using AES-256-CBC</small>
                </div>
                <div class="mb-3">
                    <h6><i class="fas fa-step-forward text-primary"></i> Step 3</h6>
                    <small>Encrypted URLs are saved to configuration file</small>
                </div>
                <div class="mb-0">
                    <h6><i class="fas fa-check text-success"></i> Result</h6>
                    <small>Panel will use the new URLs immediately</small>
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
<script src="/dist/sweetalert2/sweetalert2.all.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/js/scripts.js"></script>

<script>
function copyText(text) {
    navigator.clipboard.writeText(text).then(function() {
        Swal.fire({
            icon: 'success',
            title: 'Copied!',
            text: 'Encrypted URL copied to clipboard!',
            timer: 2000
        });
    }).catch(function() {
        // Fallback for older browsers
        var textArea = document.createElement("textarea");
        textArea.value = text;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
        Swal.fire({
            icon: 'success',
            title: 'Copied!',
            text: 'Encrypted URL copied to clipboard!',
            timer: 2000
        });
    });
}

{if $is_locked}
// Show password popup immediately
showPasswordPopup();

function showPasswordPopup() {
    Swal.fire({
        title: '<i class="fas fa-lock text-primary"></i> API Logs Access',
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
                url: '/api-logs',
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
