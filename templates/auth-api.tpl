<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Encrypt All URLs</title>
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
<h1><i class="fas fa-lock text-primary"></i> Encrypt All URLs Together</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item active"><a href="/dashboard">Dashboard</a></div>
<div class="breadcrumb-item">API Management</div>
<div class="breadcrumb-item">Encrypt URLs</div>
</div>
</div>

<div class="section-body">

{if $result && !$result.success}
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

{if $result && $result.success}
<div class="alert alert-success alert-dismissible fade show">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <i class="fas fa-check-circle"></i> <strong>All URLs Encrypted Successfully!</strong>
    <p class="mb-0 mt-2">Copy the encrypted string below and paste it into <code>api_urls_encrypted.dat</code></p>
</div>

<div class="row">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-key text-success"></i> Final Encrypted String</h4>
                <div class="card-header-action">
                    <button type="button" class="btn btn-success btn-sm" onclick="copyToClipboard()">
                        <i class="fas fa-copy"></i> Copy to Clipboard
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <textarea id="final-encrypted" class="form-control" rows="8" readonly style="font-family: monospace; font-size: 11px; word-break: break-all;">{$result.final_encrypted}</textarea>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-info-circle text-info"></i> Original URLs</h4>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <small class="text-muted">🔑 License API:</small>
                    <div class="text-break" style="font-size: 12px;">{$result.urls.license_api_url}</div>
                </div>
                <div class="mb-3">
                    <small class="text-muted">📢 Notice API:</small>
                    <div class="text-break" style="font-size: 12px;">{$result.urls.notice_api_url}</div>
                </div>
                <div class="mb-0">
                    <small class="text-muted">🪟 Popup Notice API:</small>
                    <div class="text-break" style="font-size: 12px;">{$result.urls.popup_notice_api_url}</div>
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
                <h4><i class="fas fa-shield-alt text-primary"></i> Encrypt API URLs</h4>
            </div>
            <div class="card-body">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    This tool creates a <strong>single encrypted string</strong> that contains all 3 API URLs. 
                    The output is the same format as <code>api_urls_encrypted.dat</code> file.
                </div>
                
                <form method="POST" action="">
                    <div class="form-group">
                        <label>🔑 License API URL</label>
                        <input type="url" name="license_api_url" class="form-control" required
                               value="{$post_data.license_api_url|default:$current_urls.license_api_url}"
                               placeholder="https://ruzain.com/serverside/data/licenses_api.php">
                        <small class="form-text text-muted">Remote license verification endpoint</small>
                    </div>
                    
                    <div class="form-group">
                        <label>📢 Notice API URL</label>
                        <input type="url" name="notice_api_url" class="form-control" required
                               value="{$post_data.notice_api_url|default:$current_urls.notice_api_url}"
                               placeholder="https://ruzain.com/serverside/data/notice_api.php">
                        <small class="form-text text-muted">Remote notice management endpoint</small>
                    </div>
                    
                    <div class="form-group">
                        <label>🪟 Popup Notice API URL</label>
                        <input type="url" name="popup_notice_api_url" class="form-control" required
                               value="{$post_data.popup_notice_api_url|default:$current_urls.popup_notice_api_url}"
                               placeholder="https://ruzain.com/serverside/data/popup_notice_api.php">
                        <small class="form-text text-muted">Remote popup notice endpoint</small>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fas fa-lock"></i> Encrypt All URLs Together
                    </button>
                </form>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-question-circle text-warning"></i> How It Works</h4>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <h6><i class="fas fa-step-forward text-primary"></i> Step 1</h6>
                    <small>Each URL is encrypted individually using AES-256-CBC</small>
                </div>
                <div class="mb-3">
                    <h6><i class="fas fa-step-forward text-primary"></i> Step 2</h6>
                    <small>All encrypted URLs are combined into a JSON structure</small>
                </div>
                <div class="mb-3">
                    <h6><i class="fas fa-step-forward text-primary"></i> Step 3</h6>
                    <small>The entire JSON is encrypted again (double encryption)</small>
                </div>
                <div class="mb-0">
                    <h6><i class="fas fa-check text-success"></i> Result</h6>
                    <small>One secure string containing all API URLs</small>
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
function copyToClipboard() {
    var text = document.getElementById('final-encrypted').value;
    navigator.clipboard.writeText(text).then(function() {
        Swal.fire({
            icon: 'success',
            title: 'Copied!',
            text: 'Encrypted string copied to clipboard!\n\nPaste it into api_urls_encrypted.dat',
            timer: 3000
        });
    }).catch(function() {
        // Fallback for older browsers
        document.getElementById('final-encrypted').select();
        document.execCommand('copy');
        Swal.fire({
            icon: 'success',
            title: 'Copied!',
            text: 'Encrypted string copied to clipboard!',
            timer: 2000
        });
    });
}

{if $is_locked}
// Show password popup immediately
console.log('Page is locked - showing password popup');
showPasswordPopup();

function showPasswordPopup() {
    Swal.fire({
        title: '<i class="fas fa-lock text-primary"></i> Auth API Access',
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
                url: '/auth-api',
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
