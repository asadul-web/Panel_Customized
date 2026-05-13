<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — License Required</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
</head>

<body>
<div id="app">
<section class="section">
<div class="container mt-5">
<div class="row">
<div class="col-12 col-sm-8 offset-sm-2 col-md-6 offset-md-3 col-lg-6 offset-lg-3 col-xl-4 offset-xl-4">
<div class="card card-danger">
<div class="card-header">
<h4><i class="fas fa-exclamation-triangle"></i> License Required</h4>
</div>
<div class="card-body">
<div class="text-center mb-4">
<i class="fas fa-key fa-5x text-danger"></i>
</div>
<div class="alert alert-danger">
<strong>Panel Access Blocked!</strong><br>
{if $no_license}
No license key activated. The admin panel cannot be used without a valid license.
{else}
{$license_status.message}
{/if}
</div>

{if $no_license}
<div class="alert alert-warning">
<i class="fas fa-exclamation-triangle"></i> <strong>No License Activated</strong><br>
This panel requires a valid license key to function. Please contact the developer to activate a license.
</div>
{else}
{if $license_status.data}
<div class="mb-3">
<strong>License Key:</strong> <code>{$license_status.data.key}</code><br>
<strong>Status:</strong> <span class="badge badge-danger">{if $license_status.data.is_expired}Expired{else}Blocked{/if}</span><br>
<strong>Expiry Date:</strong> {$license_status.data.expiry_date}<br>
{if $license_status.data.is_expired}
<strong>Expired:</strong> <span class="text-danger">{$license_status.data.days_remaining * -1} days ago</span>
{/if}
</div>
{/if}
{/if}

<div class="alert alert-info">
<i class="fas fa-info-circle"></i> <strong>What to do:</strong><br>
• Contact your developer to renew the license<br>
• Or activate a valid license key
</div>

<a href="/logout" class="btn btn-danger btn-block">
<i class="fas fa-sign-out-alt"></i> Logout
</a>
</div>
</div>
</div>
</div>
</div>
</section>
</div>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
