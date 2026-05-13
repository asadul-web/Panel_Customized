<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — API Key Manager</title>
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
        <h1><i class="fas fa-key"></i> API Key Manager</h1>
        <div class="section-header-breadcrumb">
            <div class="breadcrumb-item active"><a href="/dashboard">Dashboard</a></div>
            <div class="breadcrumb-item">API Key Manager</div>
        </div>
    </div>

    <div class="section-body">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h4>Android App API Key</h4>
                    </div>
                    <div class="card-body">
                        
                        {if $message}
                            <div class="alert alert-{if $message_type == 'success'}success{else}danger{/if} alert-dismissible show fade">
                                <div class="alert-body">
                                    <button class="close" data-dismiss="alert">
                                        <span>&times;</span>
                                    </button>
                                    {$message}
                                </div>
                            </div>
                        {/if}
                        
                        {if !$column_exists}
                            <div class="alert alert-warning">
                                <div class="alert-title">Database Setup Required</div>
                                The <code>api_key</code> column doesn't exist in the users table. Please run this SQL command first:
                                <br><br>
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <code>ALTER TABLE users ADD COLUMN api_key VARCHAR(64) DEFAULT NULL;</code>
                                        <button class="btn btn-sm btn-primary float-right" onclick="copyToClipboard('ALTER TABLE users ADD COLUMN api_key VARCHAR(64) DEFAULT NULL;')">
                                            <i class="fas fa-copy"></i> Copy SQL
                                        </button>
                                    </div>
                                </div>
                            </div>
                        {else}
                            
                            {if $current_api_key}
                                <div class="alert alert-success">
                                    <div class="alert-title"><i class="fas fa-check-circle"></i> Your API Key</div>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="apiKeyDisplay" value="{$current_api_key}" readonly>
                                            <div class="input-group-append">
                                                <button class="btn btn-primary" type="button" onclick="copyApiKey()">
                                                    <i class="fas fa-copy"></i> Copy
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle"></i> Keep this key secret. Use it in your Android app to authenticate API requests.
                                    </small>
                                </div>
                                
                                <div class="card bg-light mb-3">
                                    <div class="card-body">
                                        <h6><i class="fas fa-shield-alt"></i> Security Options</h6>
                                        <form method="POST" onsubmit="return confirm('This will invalidate your old API key. Continue?');">
                                            <input type="hidden" name="action" value="regenerate">
                                            <button type="submit" class="btn btn-warning">
                                                <i class="fas fa-sync"></i> Regenerate API Key
                                            </button>
                                            <small class="text-muted d-block mt-2">
                                                Generate a new key if you think your current key has been compromised.
                                            </small>
                                        </form>
                                    </div>
                                </div>
                            {else}
                                <div class="alert alert-info">
                                    <div class="alert-title"><i class="fas fa-info-circle"></i> No API Key Found</div>
                                    You don't have an API key yet. Generate one to start using the Android API.
                                </div>
                                
                                <form method="POST">
                                    <input type="hidden" name="action" value="generate">
                                    <button type="submit" class="btn btn-success btn-lg">
                                        <i class="fas fa-plus-circle"></i> Generate API Key
                                    </button>
                                </form>
                            {/if}
                            
                            <hr>
                            
                            <div class="card">
                                <div class="card-header">
                                    <h4><i class="fas fa-book"></i> API Documentation</h4>
                                </div>
                                <div class="card-body">
                                    <h6>Available Endpoints:</h6>
                                    <ul>
                                        <li><strong>Create Trial User</strong> - Create temporary trial accounts</li>
                                        <li><strong>Create Normal/Bulk User</strong> - Create premium accounts (1-12 months)</li>
                                        <li><strong>Renew User</strong> - Extend existing subscriptions</li>
                                        <li><strong>Check User Status</strong> - Get account details and expiry info</li>
                                    </ul>
                                    
                                    <h6 class="mt-3">API Endpoint:</h6>
                                    <div class="input-group mb-3">
                                        <input type="text" class="form-control" id="apiEndpoint" value="{$smarty.server.REQUEST_SCHEME}://{$smarty.server.HTTP_HOST}/api/android_user_api.php" readonly>
                                        <div class="input-group-append">
                                            <button class="btn btn-primary" type="button" onclick="copyEndpoint()">
                                                <i class="fas fa-copy"></i> Copy
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <h6>Example Request (Create Trial User):</h6>
                                    <pre class="bg-dark text-white p-3 rounded"><code>{literal}curl -X POST {/literal}{$smarty.server.REQUEST_SCHEME}://{$smarty.server.HTTP_HOST}/api/android_user_api.php{literal} \
  -H "Content-Type: application/json" \
  -d '{
    "action": "create_trial",
    "api_key": "{/literal}{if $current_api_key}{$current_api_key}{else}YOUR_API_KEY{/if}{literal}",
    "username": "testuser123",
    "password": "pass12345"
  }'{/literal}</code></pre>
                                    
                                    <a href="/api/ANDROID_API_DOCUMENTATION.md" target="_blank" class="btn btn-info">
                                        <i class="fas fa-file-alt"></i> View Full Documentation
                                    </a>
                                </div>
                            </div>
                            
                        {/if}
                        
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
<script src="/dist/modules/moment.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/sweetalert2/sweetalert2.all.min.js"></script>
<script src="/dist/js/scripts.js"></script>
{include file='js/page/custom_js.tpl'}

<script>
function copyApiKey() {
    var copyText = document.getElementById("apiKeyDisplay");
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    document.execCommand("copy");
    
    Swal.fire({
        icon: 'success',
        title: 'Copied!',
        text: 'API key copied to clipboard',
        timer: 2000,
        showConfirmButton: false
    });
}

function copyEndpoint() {
    var copyText = document.getElementById("apiEndpoint");
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    document.execCommand("copy");
    
    Swal.fire({
        icon: 'success',
        title: 'Copied!',
        text: 'API endpoint copied to clipboard',
        timer: 2000,
        showConfirmButton: false
    });
}

function copyToClipboard(text) {
    var temp = document.createElement("textarea");
    document.body.appendChild(temp);
    temp.value = text;
    temp.select();
    document.execCommand("copy");
    document.body.removeChild(temp);
    
    Swal.fire({
        icon: 'success',
        title: 'Copied!',
        text: 'SQL command copied to clipboard',
        timer: 2000,
        showConfirmButton: false
    });
}
</script>


<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
