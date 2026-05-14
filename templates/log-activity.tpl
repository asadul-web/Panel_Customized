<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — {$site_description}</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/dist/modules/bootstrap-social/bootstrap-social.css">
<link rel="stylesheet" href="/dist/modules/datatables/datatables.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/Select-1.2.4/css/select.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/select2.min.css">
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
<style>
.btn-modern {
    border-radius: 8px;
    font-weight: 500;
    padding: 8px 16px;
    transition: all 0.3s ease;
    border: none;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    margin-right: 8px;
}

.btn-modern:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.btn-modern:active {
    transform: translateY(0);
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.btn-modern i {
    margin-right: 6px;
}

.btn-group .btn-modern:last-child {
    margin-right: 0;
}

.dropdown-menu {
    border-radius: 8px;
    border: none;
    box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    padding: 8px 0;
}

.dropdown-item {
    padding: 10px 20px;
    transition: all 0.2s ease;
    border-radius: 0;
}

.dropdown-item:hover {
    background: linear-gradient(45deg, #f8f9fa, #e9ecef);
    transform: translateX(4px);
}

.dropdown-item i {
    margin-right: 10px;
    width: 16px;
    text-align: center;
}

.card-header-action .btn-group {
    display: flex;
    align-items: center;
}

/* Keep original table styling */

/* Loading animation for refresh button */
.btn-modern.loading i {
    animation: spin 1s linear infinite;
}

@keyframes spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
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
<h1>Activity Log</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Main</div>
<div class="breadcrumb-item active">Logs</div>
<div class="breadcrumb-item active">Activity Log</div>
</div>
</div>
<div class="section-body">
<div class="row">
<div class="col-12">
<div class="card card-primary">
<div class="card-header">
<h2 class="section-title">Activity Log</h2>
<div class="card-header-action">
    {* Action buttons - ONLY show to admin accounts (NOT reseller or developer) *}
    {if $user_level_2=='administrator' || $user_level_2=='superadmin' || $user_id_2=='1'}
    <div class="btn-group">
        <button class="btn btn-primary btn-modern" id="refresh-log" title="Refresh activity log">
            <i class="fas fa-sync-alt"></i> Refresh
        </button>
        <button class="btn btn-info btn-modern" id="export-log" title="Export activity log">
            <i class="fas fa-download"></i> Export
        </button>
        <button class="btn btn-warning btn-modern" id="clean-activity-log" title="Clean old activity log entries">
            <i class="fas fa-broom"></i> Clean Log
        </button>
        <button class="btn btn-secondary btn-modern dropdown-toggle" data-toggle="dropdown" title="More options">
            <i class="fas fa-ellipsis-v"></i>
        </button>
        <div class="dropdown-menu dropdown-menu-right">
            <a class="dropdown-item" href="#" id="filter-today">
                <i class="fas fa-calendar-day text-primary"></i> Show Today's Activity
            </a>
            <a class="dropdown-item" href="#" id="filter-week">
                <i class="fas fa-calendar-week text-info"></i> Show This Week
            </a>
            <a class="dropdown-item" href="#" id="filter-month">
                <i class="fas fa-calendar-alt text-success"></i> Show This Month
            </a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="#" id="show-all">
                <i class="fas fa-list text-secondary"></i> Show All Entries
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Clean Options</h6>
            <a class="dropdown-item" href="#" id="clean-7-days">
                <i class="fas fa-calendar-day text-warning"></i> Clean entries older than 7 days
            </a>
            <a class="dropdown-item" href="#" id="clean-30-days">
                <i class="fas fa-calendar-week text-warning"></i> Clean entries older than 30 days
            </a>
            <a class="dropdown-item" href="#" id="clean-90-days">
                <i class="fas fa-calendar-alt text-warning"></i> Clean entries older than 90 days
            </a>
            <a class="dropdown-item" href="#" id="clean-1-year">
                <i class="fas fa-calendar text-warning"></i> Clean entries older than 1 year
            </a>
            <a class="dropdown-item text-danger" href="#" id="clean-all-logs">
                <i class="fas fa-trash text-danger"></i> Clean all activity logs
            </a>
        </div>
    </div>
    {/if}
</div>
</div>
<div class="card-body">
<div class="table-responsive">
<table class="table table-striped table-activity" width="100%">
<thead>
<tr>
<th>Date</th>
<th>Action</th>
<th>Ip</th>
<th>Device OS</th>
<th>Device Client</th>
</tr>
</thead>
</table>
</div>
</div>
</div>
</div>
</div>
</div>
</section>
</div>

<div class="modal fade normal-modalize" role="dialog" aria-labelledby="smallmodal">
<div class="modal-dialog modal-md normal-modal-dialog" role="document">
<div class="modal-content normal-modal-content">
<div class="modal-header normal-modal-header">
<h5 class="modal-title normal-modal-title"></h5>
<button type="button" class="close" data-dismiss="modal">&times;</button>
</div>
<div class="modal-body normal-modal-body">
<div class="modal-error normal-modal-error"></div>
<div class="modal-html normal-modal-html"></div>
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
<script src="/dist/modules/popper.js"></script>
<script src="/dist/modules/tooltip.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="/dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script src="/dist/modules/moment.min.js"></script>
<script src="/dist/sweetalert2/sweetalert2.min.js"></script>
<script src="/dist/modules/time.js"></script>
<script src="/dist/js/stisla.js"></script>

<script src="/dist/modules/chart.min.js"></script>
<script src="/dist/modules/datatables/datatables.min.js"></script>
<script src="/dist/modules/datatables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script src="/dist/modules/datatables/Select-1.2.4/js/dataTables.select.min.js"></script>
<script src="/dist/modules/select2.full.min.js"></script>
<script src="/dist/modules/jquery-ui/jquery-ui.min.js"></script>
<script src="/dist/modules/summernote/summernote-bs4.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/notification_js.tpl'}
{include file='js/page/logactivity_js.tpl'}
{include file='js/page/search_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
