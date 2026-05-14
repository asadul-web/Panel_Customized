<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Email Subscribers</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/datatables.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}

<style>
/* Email Subscribers Bangla Font Support */
.subscriber-info .bangla-text, .table .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

.modal-body .subscriber-details .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

/* Mobile-responsive styling for email subscribers */

/* Statistics cards mobile improvements */
@media (max-width: 768px) {
    .card-statistic-2 {
        margin-bottom: 1rem;
    }
    
    .card-statistic-2 .card-wrap {
        padding: 15px;
    }
    
    .card-statistic-2 .card-header h4 {
        font-size: 14px;
        margin-bottom: 5px;
    }
    
    .card-statistic-2 .card-body {
        font-size: 18px;
        font-weight: bold;
    }
    
    .card-icon {
        width: 50px;
        height: 50px;
        line-height: 50px;
    }
    
    .card-icon i {
        font-size: 20px;
    }
}

/* Sidebar mobile improvements */
@media (max-width: 991px) {
    .col-lg-3 {
        margin-bottom: 20px;
    }
    
    .btn-block {
        margin-bottom: 8px;
    }
}

/* Table mobile enhancements */
@media (max-width: 768px) {
    .table-responsive {
        border: none;
        font-size: 13px;
    }
    
    .table th,
    .table td {
        padding: 0.5rem 0.3rem;
        vertical-align: middle;
    }
    
    .btn-group .btn {
        padding: 0.25rem 0.4rem;
        font-size: 0.8rem;
        margin-right: 2px;
    }
    
    .btn-group .btn i {
        font-size: 11px;
    }
    
    /* Compact table for mobile */
    .table th:first-child,
    .table td:first-child {
        width: 25px;
        padding: 0.5rem 0.2rem;
    }
    
    .table th:last-child,
    .table td:last-child {
        width: 100px;
        padding: 0.5rem 0.2rem;
    }
}

/* Extra small screens */
@media (max-width: 576px) {
    .card-header h4 {
        font-size: 16px;
    }
    
    .btn-group .btn {
        padding: 0.2rem 0.3rem;
        font-size: 0.75rem;
        margin-right: 1px;
    }
    
    .btn-group .btn i {
        font-size: 10px;
    }
    
    .table {
        font-size: 12px;
    }
}

/* Simple subscriber email display */
.subscriber-email-class {
    color: #007bff;
    text-decoration: none;
    font-weight: 500;
}

.subscriber-email-class:hover {
    color: #0056b3;
    text-decoration: underline;
}

/* Name badge styling */
.badge-secondary {
    background-color: #6c757d !important;
    color: white !important;
    border-radius: 12px;
    font-weight: 500;
}

.badge-light {
    background-color: #f8f9fa !important;
    color: #6c757d !important;
    border: 1px solid #dee2e6;
    border-radius: 12px;
}

/* Original template section-header styling */
.section-header {
    padding: 30px 0;
    margin-bottom: 30px;
}

.section-header h1 {
    font-size: 2.25rem;
    font-weight: 600;
    color: #34395e;
    margin-bottom: 5px;
}

.section-header-breadcrumb {
    margin-top: 10px;
}

.section-header-breadcrumb .breadcrumb-item {
    font-size: 14px;
    color: #6c757d;
}

.section-header-breadcrumb .breadcrumb-item.active {
    color: #34395e;
    font-weight: 500;
}
</style>

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
<h1><i class="fas fa-users"></i> Email Subscribers</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item active"><a href="dashboard">Dashboard</a></div>
<div class="breadcrumb-item">Email Subscribers</div>
</div>
</div>

<div class="section-body">

<!-- Statistics Cards - Dashboard Style -->
<div class="row mb-4">
<div class="col-lg-3 col-md-6 col-sm-6 col-12">
    <div class="card card-statistic-2 card-primary">
        <div class="card-icon shadow-primary bg-primary">
            <i class="fas fa-users"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Total Subscribers</h4>
            </div>
            <div class="card-body">
                {$stats.total_subscribers|default:0}
            </div>
        </div>
    </div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6 col-12">
    <div class="card card-statistic-2 card-success">
        <div class="card-icon shadow-success bg-success">
            <i class="fas fa-user-check"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Active Subscribers</h4>
            </div>
            <div class="card-body">
                {$stats.active_subscribers|default:0}
            </div>
        </div>
    </div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6 col-12">
    <div class="card card-statistic-2 card-warning">
        <div class="card-icon shadow-warning bg-warning">
            <i class="fas fa-user-times"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Unsubscribed</h4>
            </div>
            <div class="card-body">
                {$stats.unsubscribed|default:0}
            </div>
        </div>
    </div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6 col-12">
    <div class="card card-statistic-2 card-danger">
        <div class="card-icon shadow-danger bg-danger">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Bounced</h4>
            </div>
            <div class="card-body">
                {$stats.bounced|default:0}
            </div>
        </div>
    </div>
</div>
</div>

<!-- Subscribers Management -->
<div class="row">
<div class="col-lg-3 col-md-12">
<div class="card card-primary">
<div class="card-header">
<h4><i class="fas fa-filter"></i> Filters & Actions</h4>
</div>
<div class="card-body">

<div class="form-group">
<label>Status Filter</label>
<select class="form-control filter-status" id="statusFilter">
<option value="">All Status</option>
<option value="active">✅ Active</option>
<option value="unsubscribed">⚠️ Unsubscribed</option>
<option value="bounced">❌ Bounced</option>
</select>
</div>

<div class="form-group">
<label>Source Filter</label>
<select class="form-control filter-source" id="sourceFilter">
<option value="">All Sources</option>
<option value="manual">👤 Manual</option>
<option value="website">🌐 Website</option>
<option value="import">📤 Import</option>
<option value="api">💻 API</option>
<option value="reseller_application">🏢 Reseller Application</option>
</select>
</div>

<div class="form-group">
<label>Date Filter</label>
<input type="date" class="form-control" id="dateFilter" placeholder="Filter by date">
</div>

<div class="form-group">
<button class="btn btn-secondary btn-block" onclick="clearFilters()">
<i class="fas fa-times"></i> Clear All Filters
</button>
</div>

<hr>

<div class="form-group">
<label>Quick Actions</label>
<div class="d-grid gap-2">
<button class="btn btn-primary btn-block" data-toggle="modal" data-target="#addSubscriberModal">
<i class="fas fa-plus"></i> Add Subscriber
</button>
<button class="btn btn-success btn-block mt-2" data-toggle="modal" data-target="#importSubscribersModal">
<i class="fas fa-upload"></i> Import CSV
</button>
<button class="btn btn-info btn-block mt-2" onclick="exportSubscribers()">
<i class="fas fa-download"></i> Export CSV
</button>
<button class="btn btn-warning btn-block mt-2" onclick="syncResellerEmails()">
<i class="fas fa-sync"></i> Sync Reseller Emails
</button>
</div>
</div>

</div>
</div>
</div>
<div class="col-lg-9 col-md-12">
<div class="card card-primary">
<div class="card-header">
<h4><i class="fas fa-users"></i> Manage Subscribers</h4>
<div class="card-header-action">
<button class="btn btn-primary btn-sm" onclick="refreshSubscribers()">
<i class="fas fa-sync-alt"></i> Refresh
</button>
</div>
</div>
<div class="card-body">


<!-- Subscribers Table -->
<div class="table-responsive">
<table class="table table-striped" id="subscribersTable">
<thead>
<tr>
<th><input type="checkbox" id="selectAll"></th>
<th>Email</th>
<th>Name</th>
<th>Status</th>
<th>Source</th>
<th>Subscribed Date</th>
<th>Last Email</th>
<th>Count</th>
<th>Action</th>
</tr>
</thead>
<tbody>
<!-- Data loaded via AJAX -->
</tbody>
</table>
</div>

<!-- Bulk Actions -->
<div class="row mt-3">
<div class="col-md-6">
<div class="form-group">
<label>Bulk Actions:</label>
<div class="input-group">
<select class="form-control" id="bulkAction">
<option value="">Select Action</option>
<option value="activate">Activate Selected</option>
<option value="unsubscribe">Unsubscribe Selected</option>
<option value="delete">Delete Selected</option>
<option value="export">Export Selected</option>
</select>
<div class="input-group-append">
<button class="btn btn-primary" onclick="executeBulkAction()">Apply</button>
</div>
</div>
</div>
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

<!-- Add Subscriber Modal -->
<div class="modal fade" id="addSubscriberModal" tabindex="-1" role="dialog">
<div class="modal-dialog" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Add New Subscriber</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<form id="addSubscriberForm">
<div class="form-group">
<label for="subscriberEmail">Email Address *</label>
<input type="email" class="form-control" id="subscriberEmail" name="email" required>
</div>
<div class="form-group">
<label for="subscriberName">Name</label>
<input type="text" class="form-control" id="subscriberName" name="name">
</div>
<div class="form-group">
<label for="subscriberTags">Tags</label>
<input type="text" class="form-control" id="subscriberTags" name="tags" placeholder="customer, vip, newsletter">
<small class="form-text text-muted">Separate tags with commas</small>
</div>
<div class="form-group">
<label for="subscriberSource">Source</label>
<select class="form-control" id="subscriberSource" name="source">
<option value="manual">Manual</option>
<option value="website">Website</option>
<option value="import">Import</option>
<option value="api">API</option>
</select>
</div>
</form>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
<button type="button" class="btn btn-primary" onclick="addSubscriber()">Add Subscriber</button>
</div>
</div>
</div>
</div>

<!-- Edit Subscriber Modal -->
<div class="modal fade" id="editSubscriberModal" tabindex="-1" role="dialog">
<div class="modal-dialog" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Edit Subscriber</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<form id="editSubscriberForm">
<input type="hidden" id="editSubscriberId" name="subscriber_id">
<div class="form-group">
<label for="editSubscriberEmail">Email Address *</label>
<input type="email" class="form-control" id="editSubscriberEmail" name="email" required>
</div>
<div class="form-group">
<label for="editSubscriberName">Name</label>
<input type="text" class="form-control" id="editSubscriberName" name="name">
</div>
<div class="form-group">
<label for="editSubscriberTags">Tags</label>
<input type="text" class="form-control" id="editSubscriberTags" name="tags" placeholder="customer, vip, newsletter">
<small class="form-text text-muted">Separate tags with commas</small>
</div>
<div class="form-group">
<label for="editSubscriberSource">Source</label>
<select class="form-control" id="editSubscriberSource" name="source">
<option value="manual">Manual</option>
<option value="website">Website</option>
<option value="import">Import</option>
<option value="api">API</option>
</select>
</div>
<div class="form-group">
<label for="editSubscriberStatus">Status</label>
<select class="form-control" id="editSubscriberStatus" name="status">
<option value="active">Active</option>
<option value="unsubscribed">Unsubscribed</option>
<option value="bounced">Bounced</option>
</select>
</div>
</form>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
<button type="button" class="btn btn-primary" onclick="updateSubscriber()">Update Subscriber</button>
</div>
</div>
</div>
</div>

<!-- Import Subscribers Modal -->
<div class="modal fade" id="importSubscribersModal" tabindex="-1" role="dialog">
<div class="modal-dialog modal-lg" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Import Subscribers from CSV</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<form id="importSubscribersForm" enctype="multipart/form-data">
<div class="form-group">
<label for="csvFile">CSV File *</label>
<input type="file" class="form-control-file" id="csvFile" name="csv_file" accept=".csv" required>
<small class="form-text text-muted">
CSV should have columns: email, name (optional), tags (optional)
</small>
</div>
<div class="form-group">
<label>CSV Format Example:</label>
<pre class="bg-light p-2">email,name,tags
john@example.com,John Doe,customer,vip
jane@example.com,Jane Smith,newsletter</pre>
</div>
<div class="form-group">
<div class="custom-control custom-checkbox">
<input type="checkbox" class="custom-control-input" id="skipDuplicates" name="skip_duplicates" checked>
<label class="custom-control-label" for="skipDuplicates">Skip duplicate emails</label>
</div>
</div>
</form>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
<button type="button" class="btn btn-primary" onclick="importSubscribers()">Import</button>
</div>
</div>
</div>
</div>

<!-- Normal Modal for View Details (same as view-user page) -->
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

<script src="/dist/modules/jquery.min.js"></script>
<script src="/dist/modules/popper.js"></script>
<script src="/dist/modules/tooltip.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="/dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script src="/dist/modules/moment.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/modules/datatables/datatables.min.js"></script>
<script src="/dist/modules/datatables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script src="/dist/sweetalert2/sweetalert2.min.js"></script>

{include file='js/page/email_subscribers_js.tpl'}

<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom.js?v=2"></script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
