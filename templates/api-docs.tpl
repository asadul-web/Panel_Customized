<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Decrypt URLs</title>
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
<h1><i class="fas fa-unlock text-primary"></i> Decrypt URLs</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item active"><a href="/dashboard">Dashboard</a></div>
<div class="breadcrumb-item">API Management</div>
<div class="breadcrumb-item">Decrypt URLs</div>
</div>
</div>

<div class="section-body">

{if $result && isset($result.error)}
<div class="alert alert-danger alert-dismissible fade show">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> {$result.error}
</div>
{/if}

{if $result && $result.success}
<div class="alert alert-success alert-dismissible fade show">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <i class="fas fa-check-circle"></i> <strong>Decryption Successful!</strong>
</div>

<div class="row">
    <div class="col-lg-12">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-key text-success"></i> Decrypted Result</h4>
                <div class="card-header-action">
                    <button type="button" class="btn btn-success btn-sm" onclick="copyDecrypted()">
                        <i class="fas fa-copy"></i> Copy Result
                    </button>
                </div>
            </div>
            <div class="card-body">
                {if $result.is_json}
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> This appears to be a complete configuration file with multiple URLs.
                </div>
                
                <h6>Decrypted URLs:</h6>
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>URL</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $result.urls as $key => $value}
                            {if strpos($key, '_url') !== false}
                            <tr>
                                <td><strong>{$key|replace:'_':' '|ucwords}</strong></td>
                                <td class="text-break">{$value}</td>
                            </tr>
                            {/if}
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                
                <h6 class="mt-4">Full JSON Structure:</h6>
                <textarea id="decrypted-result" class="form-control" rows="8" readonly style="font-family: monospace; font-size: 12px;">{$result.decrypted|escape}</textarea>
                
                {else}
                <h6>Decrypted Value:</h6>
                <textarea id="decrypted-result" class="form-control" rows="4" readonly style="font-family: monospace; font-size: 14px;">{$result.decrypted|escape}</textarea>
                {/if}
            </div>
        </div>
    </div>
</div>
{/if}

<div class="row">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-shield-alt text-primary"></i> Decrypt Encrypted URLs</h4>
            </div>
            <div class="card-body">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    Enter an encrypted string to decrypt it. This tool can decrypt both individual URLs and complete configuration files.
                </div>
                
                <form method="POST" action="">
                    <div class="form-group">
                        <label>🔒 Encrypted String</label>
                        <textarea name="encrypted" class="form-control" rows="6" required
                                  placeholder="Paste your encrypted string here..."
                                  style="font-family: monospace; font-size: 12px;">{if isset($post_data.encrypted)}{$post_data.encrypted}{/if}</textarea>
                        <small class="form-text text-muted">Paste the encrypted string from api_urls_encrypted.dat or individual encrypted URL</small>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fas fa-unlock"></i> Decrypt String
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
                    <h6><i class="fas fa-file-alt text-primary"></i> Single URL</h6>
                    <small>Decrypts individual encrypted URLs back to their original form</small>
                </div>
                <div class="mb-3">
                    <h6><i class="fas fa-file-code text-primary"></i> Config File</h6>
                    <small>Decrypts complete api_urls_encrypted.dat files and shows all URLs</small>
                </div>
                <div class="mb-3">
                    <h6><i class="fas fa-shield-alt text-success"></i> Security</h6>
                    <small>Uses AES-256-CBC decryption with machine-specific keys</small>
                </div>
                <div class="mb-0">
                    <h6><i class="fas fa-eye text-info"></i> View Only</h6>
                    <small>This tool only decrypts for viewing - it doesn't modify any files</small>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-lightbulb text-warning"></i> Tips</h4>
            </div>
            <div class="card-body">
                <ul class="list-unstyled mb-0">
                    <li class="mb-2"><i class="fas fa-check text-success"></i> Copy encrypted strings exactly as they appear</li>
                    <li class="mb-2"><i class="fas fa-check text-success"></i> Remove any extra spaces or line breaks</li>
                    <li class="mb-2"><i class="fas fa-check text-success"></i> Works with both old and new encryption formats</li>
                    <li class="mb-0"><i class="fas fa-check text-success"></i> Results can be copied to clipboard</li>
                </ul>
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
function copyDecrypted() {
    var text = document.getElementById('decrypted-result').value;
    navigator.clipboard.writeText(text).then(function() {
        Swal.fire({
            icon: 'success',
            title: 'Copied!',
            text: 'Decrypted result copied to clipboard!',
            timer: 2000
        });
    }).catch(function() {
        // Fallback for older browsers
        document.getElementById('decrypted-result').select();
        document.execCommand('copy');
        Swal.fire({
            icon: 'success',
            title: 'Copied!',
            text: 'Decrypted result copied to clipboard!',
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
        title: '<i class="fas fa-lock text-primary"></i> API Docs Access',
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
                url: '/api-docs',
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
