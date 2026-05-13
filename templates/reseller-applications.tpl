<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Reseller Applications</title>
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
/* Reseller Applications Bangla Font Support */
.application-info .bangla-text, .table .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

.modal-body .application-details .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

.card-body .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

/* Dashboard-style Statistics Cards */
.card-body {
    transition: all 0.3s ease;
}

#total-applications, #approved-applications, #pending-applications, #rejected-applications {
    font-size: 1.5rem;
    font-weight: bold;
    min-height: 30px;
}

/* Optimize card animations */
.card-statistic-2 {
    opacity: 1;
    transform: translateY(0);
    transition: opacity 0.3s ease, transform 0.3s ease;
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
<h1>Reseller Applications</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Main</div>
<div class="breadcrumb-item active">Reseller Manage</div>
<div class="breadcrumb-item active">Applications</div>
</div>
</div>
<div class="section-body">
<!-- Statistics Cards Row -->
<div class="row">
<div class="col-lg-3 col-md-6 col-sm-6">
<div class="card card-statistic-2 card-primary">
<div class="card-icon shadow-primary bg-primary">
<i class="fas fa-file-alt"></i>
</div>
<div class="card-wrap">
<div class="card-header">
<h4>Total Applications</h4>
</div>
<div class="card-body" id="total-applications">
{$total_applications|default:0}
</div>
</div>
</div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6">
<div class="card card-statistic-2 card-success">
<div class="card-icon shadow-success bg-success">
<i class="fas fa-check-circle"></i>
</div>
<div class="card-wrap">
<div class="card-header">
<h4>Approved</h4>
</div>
<div class="card-body" id="approved-applications">
{$approved_applications|default:0}
</div>
</div>
</div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6">
<div class="card card-statistic-2 card-warning">
<div class="card-icon shadow-warning bg-warning">
<i class="fas fa-clock"></i>
</div>
<div class="card-wrap">
<div class="card-header">
<h4>Pending Review</h4>
</div>
<div class="card-body" id="pending-applications">
{$pending_applications|default:0}
</div>
</div>
</div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6">
<div class="card card-statistic-2 card-danger">
<div class="card-icon shadow-danger bg-danger">
<i class="fas fa-times-circle"></i>
</div>
<div class="card-wrap">
<div class="card-header">
<h4>Rejected</h4>
</div>
<div class="card-body" id="rejected-applications">
{$rejected_applications|default:0}
</div>
</div>
</div>
</div>
</div>

<!-- Applications Table Row -->
<div class="row">
<div class="col-12">
<div class="card card-primary">
<div class="card-header">
<h2 class="section-title currentuser">All Applications</h2>
</div>
<div class="card-body">
<div class="alert alert-primary" role="alert">
    <strong>RESELLER APPLICATIONS : </strong> Manage and review reseller applications.<br>
    <strong>STATUS MANAGEMENT : </strong> Approve, reject, or mark applications under review.
</div>
<table class="table table-striped table-listapplication" style="width: 100%">
<thead>
<tr>
<th>Business Name</th>
<th>Full Name</th>
<th>Email</th>
<th>Country</th>
<th>Status</th>
<th>Action</th>
</tr>
</thead>
</table>
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
<script src="/dist/bootstrap/assets/jqueryform/jquery.form.js"></script>
<script src="/dist/modules/summernote/summernote-bs4.min.js"></script>
<script src="/dist/modules/select2.full.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/notification_js.tpl'}
{include file='js/page/reseller_applications_js.tpl'}
{include file='js/page/search_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
