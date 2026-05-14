<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — {$site_description}</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<!-- Preconnect to external domains for faster loading -->
<link rel="preconnect" href="https://cdnjs.cloudflare.com" crossorigin>
<link rel="preconnect" href="https://cdn.datatables.net" crossorigin>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="dns-prefetch" href="https://fonts.gstatic.com">

<!-- Critical CSS loaded immediately -->
<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">

<!-- Non-critical CSS deferred -->
<link rel="preload" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" as="style" onload="this.onload=null;this.rel='stylesheet'" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous">
<link rel="preload" href="https://cdn.datatables.net/v/bs4/dt-1.13.6/b-2.4.2/r-2.5.0/sr-1.3.0/datatables.min.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<link rel="preload" href="/dist/sweetalert2/sweetalert2.min.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/v/bs4/dt-1.13.6/b-2.4.2/r-2.5.0/sr-1.3.0/datatables.min.css">
    <link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
</noscript>
{include file='css/custom_css.tpl'}
<style>
/* License Status Badge Flash Animation */
@keyframes flash-active {
    0%, 100% { 
        transform: scale(1); 
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        opacity: 1;
    }
    50% { 
        transform: scale(1.1); 
        box-shadow: 0 0 15px rgba(40, 167, 69, 0.6);
        opacity: 0.9;
    }
}

.placeholder-loading {
    height: 30px;
    opacity: 0.7;
}

.card-body {
    transition: all 0.3s ease;
}

.stats-reseller, .stats-user, .stats-online, .stats-server {
    font-size: 1.5rem;
    font-weight: bold;
    min-height: 30px;
}

/* Optimize loading animations */
.spinner-border-sm {
    width: 1rem;
    height: 1rem;
}

/* Preload critical elements */
.card-statistic-2 {
    opacity: 1;
    transform: translateY(0);
    transition: opacity 0.3s ease, transform 0.3s ease;
}

/* Simple Header Styling */
.section-header {
    padding: 15px 0;
    margin-bottom: 20px;
}

/* Top 5 Statistics Cards using original template design */
.top5-loading {
    padding: 20px;
    text-align: center;
}

.top5-content .list-group-item {
    border: none;
    border-bottom: 1px solid #f0f0f0;
    padding: 12px 15px;
    transition: background-color 0.2s ease;
}

.top5-content .list-group-item:hover {
    background-color: #f8f9fa;
}

.top5-content .list-group-item:last-child {
    border-bottom: none;
}

.top5-content .badge {
    font-size: 0.75em;
    padding: 4px 8px;
}

.top5-content h6 {
    font-size: 0.9em;
    font-weight: 600;
    margin-bottom: 2px;
}

.top5-content small {
    font-size: 0.75em;
}
</style>
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
<h1>Dashboard</h1>
<div class="section-header-breadcrumb">
    <div class="breadcrumb-item active">Main</div>
    <div class="breadcrumb-item">Dashboard</div>
</div>
</div>

<div class="section-body">
{$mainte}

{if $user_id_2=='1' || $user_level_2=='superadmin' || $user_level_2=='developer' }


<!--div class="fetch-update alert alert-primary alert-dismissible fade">
<div class="alert-body">
<button class="close" data-dismiss="alert">
<span>&times;</span>
</button>
<i class="fas fa-star-half-alt"></i> What's new on version <code><span class="panel-version"></span></code> :
<ul class="panel-update-list"></ul>
</div>
</div-->
{/if}
{if $user_level_2=='reseller' }

<div class="hero">
<div class="hero-inner">
<h2>Welcome, {$user_name_2}!</h2>
<p class="lead">Thank you for choosing {$site_name} as your vpn service provider. We will keep you up to date.</p>
<div class="mt-4">
<a href="add-user" class="btn btn-outline-white btn-lg btn-icon icon-left"><i class="far fa-user"></i> Create Account</a>
</div>
</div>
</div>
{/if}

<div class="row">

{if $user_id_2=='1' || $user_level_2=='superadmin' || $user_level_2=='developer' || $user_level_2 == 'reseller' }
<div class="col-lg-3 col-md-6 col-sm-6">
    <div class="card card-statistic-2 card-success">
        <div class="card-icon shadow-success bg-success">
            <i class="fas fa-user-tie"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Reseller</h4>
            </div>
        <div class="card-body stats-reseller">
            <div class="placeholder-loading">
                <div class="spinner-border spinner-border-sm text-success" role="status">
                    <span class="sr-only">Loading...</span>
                </div>
            </div>
        </div>
        </div>
    </div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6">
    <div class="card card-statistic-2 card-info">
        <div class="card-icon shadow-info bg-info">
            <i class="fas fa-users"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Users</h4>
            </div>
            <div class="card-body stats-user">
                <div class="placeholder-loading">
                    <div class="spinner-border spinner-border-sm text-info" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6">
    <div class="card card-statistic-2 card-warning">
        <div class="card-icon shadow-warning bg-warning">
            <i class="fas fa-signal"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Online</h4>
            </div>
            <div class="card-body stats-online">
                <div class="placeholder-loading">
                    <div class="spinner-border spinner-border-sm text-warning" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{if $user_id_2=='1' || $user_level_2=='superadmin' || $user_level_2=='developer' }

<div class="col-lg-3 col-md-6 col-sm-6">
    <div class="card card-statistic-2 card-danger">
        <div class="card-icon shadow-danger bg-danger">
            <i class="fas fa-server"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Servers</h4>
            </div>
            <div class="card-body stats-server">
                <div class="placeholder-loading">
                    <div class="spinner-border spinner-border-sm text-danger" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{/if}

{if $user_level_2=='reseller' }

<div class="col-lg-3 col-md-6 col-sm-6">
    <div class="card card-statistic-2 card-danger">
        <div class="card-icon shadow-danger bg-danger">
            <i class="fas fa-user-clock"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Expired Users</h4>
            </div>
            <div class="card-body stats-expired-users">
                <div class="placeholder-loading">
                    <div class="spinner-border spinner-border-sm text-danger" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{/if}
</div>



<div class="row">

{* License Status Card - ONLY show to admin accounts (NOT reseller or developer) *}
{if isset($show_license_info) && $show_license_info && ($user_id_2=='1' || $user_level_2=='superadmin' || $user_level_2=='administrator')}
<div class="col-lg-3 col-md-6 col-sm-6">
    <div class="card card-statistic-2 card-{if $license_info.valid}success{elseif $license_info.data.is_expired}danger{else}warning{/if}">
        <div class="card-wrap">
            <div class="card-header" style="display: flex; align-items: center; justify-content: space-between;">
                <h4 style="margin: 0;">License Status</h4>
                <span class="badge badge-{if $license_info.valid}success{elseif $license_info.data.is_expired}danger{else}warning{/if}" style="font-size: 10px; {if $license_info.valid}animation: flash-active 2s infinite;{/if}">
                    {if $license_info.valid}ACTIVE{elseif $license_info.data.is_expired}EXPIRED{else}BLOCKED{/if}
                </span>
            </div>
            <div class="card-body">
                {if isset($license_info) && $license_info.data}
                    <div style="text-align: center; margin-bottom: 20px;">
                        <div style="font-size: 36px; font-weight: bold; color: {if $license_info.data.days_remaining > 30}#28a745{elseif $license_info.data.days_remaining > 7}#ffc107{else}#dc3545{/if}; line-height: 1;">
                            {if $license_info.data.days_remaining > 0}{$license_info.data.days_remaining}{else}0{/if}
                        </div>
                        <div style="font-size: 12px; color: #6c757d; margin-top: 4px;">
                            {if $license_info.data.days_remaining == 1}day remaining{else}days remaining{/if}
                        </div>
                    </div>
                    
                    <div style="background: linear-gradient(135deg, {if $license_info.valid}#e8f5e8{elseif $license_info.data.is_expired}#ffeaea{else}#fff8e1{/if} 0%, {if $license_info.valid}#f0f9f0{elseif $license_info.data.is_expired}#fff5f5{else}#fffbf0{/if} 100%); border-radius: 8px; padding: 12px; margin-bottom: 15px;">
                        <div style="text-align: center; margin-bottom: 8px;">
                            <span style="font-family: monospace; font-size: 12px; color: #495057; font-weight: 600;">••••-••••-{$license_info.data.key|substr:-8}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <small style="color: #6c757d; font-weight: 500;">Expires On</small>
                            <span style="font-size: 11px; color: #495057; font-weight: 600;">{$license_info.data.expiry_date|date_format:"%B %d, %Y"}</span>
                        </div>
                    </div>
                    
                    <div style="width: 100%; height: 8px; background: #e9ecef; border-radius: 4px; overflow: hidden;">
                        <div style="height: 100%; background: linear-gradient(90deg, {if $license_info.data.days_remaining > 30}#28a745{elseif $license_info.data.days_remaining > 7}#ffc107{else}#dc3545{/if} 0%, {if $license_info.data.days_remaining > 30}#20c997{elseif $license_info.data.days_remaining > 7}#fd7e14{else}#fd7e14{/if} 100%); width: {if $license_info.data.days_remaining > 365}100{else}{math equation="round(x/365*100)" x=$license_info.data.days_remaining}{/if}%; transition: width 0.3s ease;"></div>
                    </div>
                {else}
                    <div class="text-center" style="padding: 20px 0;">
                        <div style="font-size: 36px; font-weight: bold; color: #6c757d; line-height: 1;">--</div>
                        <div style="font-size: 12px; color: #6c757d; margin-top: 4px;">No License Activated</div>
                        <div style="margin-top: 15px; padding: 10px; background: #f8f9fa; border-radius: 6px;">
                            <small style="color: #6c757d;">Contact your administrator to activate a license</small>
                        </div>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>
{/if}

{* Profile Card - Show ONLY to reseller, developer, and regular users (NOT admin) *}
{if $user_level_2=='reseller' || $user_level_2=='developer' || (!isset($show_license_info) || !$show_license_info)}
<div class="col-lg-3 col-md-6 col-sm-6">
    <div class="card card-info">
    <div class="card-header">
    <h4><i class="fas fa-user-circle"></i> Profile</h4>
    </div>
    <div class="card-body">
    <ul class="list-unstyled user-progress list-unstyled-border list-unstyled-noborder">
    <li class="media">
    {$avatar2}
    <div class="media-body">
    <div class="media-title text-uppercase profile-username"></div>
    <div class="text-job text-muted">Username</div>
    </div>
    </li>
    <li class="media">
    {$avatar6}
    <div class="media-body">
    <div class="media-title text-uppercase profile-upline"></div>
    <div class="text-job text-muted">Upline</div>
    </div>
    </li>
    <li class="media">
    <img alt="image" class="mr-3 rounded-circle" width="50" src="/dist/img/dashboard/credits.png">
    <div class="media-body">
    <div class="media-title text-uppercase profile-credits"></div>
    <div class="text-job text-muted">Credits</div>
    </div>
    </li>
    </ul>
    </div>
    </div>
</div>
{/if}

<div class="col-lg-3 col-md-6 col-sm-6">
    <div class="card card-primary">
    <div class="card-header">
    <h4>Users</h4>
    </div>
    <div class="card-body">
    <canvas id="userchart"></canvas>
    </div>
    </div>
</div>

<div class="col-lg-6 col-md-6 col-sm-6">
        <div class="card card-primary">
            <div class="card-header">
            <h2 class="section-title">Recent Activities</h2>
            </div>
            <div class="card-body">
<table class="table table-sm table-activity">
<thead>
<tr>
    <th scope="col">Time</th>
    <th scope="col">Device</th>
    <th scope="col">Action</th>
</tr>
</thead>
<tbody>
</tbody>
</table>
</div>
<div class="card-body">
                <ul class="list-unstyled list-unstyled-border stats-activity">

                </ul>
                <div class="text-center pt-1 pb-1">
                    <a href="log-activity" class="btn btn-primary">
                        View All
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
{/if}
</div>
</div>
</section>
</div>

</div>

<div class="modal fade modalize" role="dialog" aria-labelledby="smallmodal">
<div class="modal-dialog modal-md" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title"></h5>
<button type="button" class="close" data-dismiss="modal">&times;</button>
</div>
<div class="modal-body">
<div class="modal-error"></div>
<div class="modal-html"></div>
</div>
</div>
</div>
</div>

<div class="modal fade search-modalize" role="dialog" aria-labelledby="smallmodal">
<div class="modal-dialog modal-md search-modal-dialog" role="document">
<div class="modal-content search-modal-content">
<div class="modal-header search-modal-header">
<h5 class="modal-title search-modal-title"></h5>
<button type="button" class="close" data-dismiss="modal">&times;</button>
</div>
<div class="modal-body search-modal-body">
<div class="modal-error search-modal-error"></div>
<div class="modal-html search-modal-html"></div>
</div>
</div>
</div>
</div>

<script src="/dist/modules/jquery.min.js"></script>
<script>
// Fallback to CDN if local jQuery fails
if (typeof jQuery === 'undefined') {
    document.write('<script src="https://code.jquery.com/jquery-3.6.0.min.js"><\/script>');
}
</script>
<!-- Critical scripts loaded immediately -->
<script src="/dist/modules/popper.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/js/lazy-load.js"></script>

<!-- Non-critical scripts deferred for faster page load -->
<script defer src="/dist/modules/tooltip.js"></script>
<script defer src="/dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script defer src="/dist/modules/moment.min.js"></script>
<script defer src="/dist/sweetalert2/sweetalert2.min.js"></script>
<script defer src="/dist/modules/time.js"></script>
<script defer src="/dist/modules/chart.min.js"></script>
<script defer src="https://cdn.datatables.net/v/bs4/dt-1.13.6/b-2.4.2/r-2.5.0/sl-1.7.0/datatables.min.js"></script>
<script defer src="https://cdn.jsdelivr.net/npm/clipboard@2.0.11/dist/clipboard.min.js"></script>
<script defer src="/dist/js/scripts.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/dashboard_js.tpl'}
{include file='js/page/notification_js.tpl'}
{include file='js/page/search_js.tpl'}

<!-- Vanilla JS Logout Handler (Fallback) -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Find all logout buttons
    const logoutButtons = document.querySelectorAll('.btn-logout');
    logoutButtons.forEach(function(button) {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            // Check if SweetAlert2 is available
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    text: "Are you sure you want to logout?",
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    imageUrl: "{$site_logo}",
                    imageWidth: 150,
                    imageHeight: 150,
                    imageAlt: "Custom image",
                    showCancelButton: true,
                    confirmButtonText: "Confirm",
                    didOpen: function () {
                        Swal.getConfirmButton().blur()
                    },
                    customClass: {
                        confirmButton: 'swal2-confirm btn btn-primary swal2-styled',
                        cancelButton: 'swal2-confirm btn btn-danger swal2-styled'
                    }
                }).then(function(result) {
                    if (result.isConfirmed) {
                        window.location.href = "{$base_url}logout";
                    }
                });
            } else {
                if (confirm('Are you sure you want to logout?')) {
                    window.location.href = "{$base_url}logout";
                }
            }
        });
    });
});


</script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>

</body>
</html>

