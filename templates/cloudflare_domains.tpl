<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Cloudflare Domains</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/dist/modules/datatables/datatables.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
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
<h1>Cloudflare Domains</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Panel</div>
<div class="breadcrumb-item active">Cloudflare Dns</div>
</div>
</div>
<div class="section-body">
<div class="row">
<div class="col-md-4">
<div class="card card-primary">
<div class="card-header">
<h2 class="section-title">Add Cloudflare Domain</h2>
</div>
<div class="card-body">
<div class="section-error">
<div class="errors"></div>
</div>
<form action="" class="add-cloudflare-domain" autocomplete="off">
<input type="hidden" name="submitted" value="add_cloudflare_domain">
<input type="hidden" name="_key" id="_key" value="{$firenet_encrypt}">

<div class="form-group">
<label for="domain">Domain</label>
<input id="domain" type="text" class="form-control" name="domain" placeholder="ruzain.com" required="">
</div>

<div class="form-group">
<label for="zone_id">Zone ID</label>
<input id="zone_id" type="text" class="form-control" name="zone_id" placeholder="37052f49b5af0e0017031ebb9c3e2175" required="">
</div>

<div class="form-group">
<label for="global_api">Global API</label>
<input id="global_api" type="text" class="form-control" name="global_api" placeholder="f5fa5ee453016f970a164377dfb3d954b661" required="">
</div>

<div class="form-group">
<label for="email">Email Address</label>
<input id="email" type="email" class="form-control" name="email" placeholder="azimaxcom@gmail.com" required="">
</div>

<div class="form-group">
<button type="submit" class="btn btn-primary btn-add-cf-domain">Confirm</button>
<button type="button" class="btn btn-danger btn-reset-cf">Reset</button>
</div>
</form>
</div>
</div>
</div>

<div class="col-md-8">
<div class="card card-primary">
<div class="card-header">
<h2 class="section-title">Cloudflare Domains List</h2>
</div>
<div class="card-body">
<div class="table-responsive">
<table class="table table-cloudflare-domains" style="width: 100%">
<thead>
<tr>
<th>Domain</th>
<th>Zone ID</th>
<th>Email</th>
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
</div>
</section>
</div>

<script src="/dist/modules/jquery.min.js"></script>
<script src="/dist/modules/popper.js"></script>
<script src="/dist/modules/tooltip.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="/dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script src="/dist/modules/moment.min.js"></script>
<script src="/dist/sweetalert2/sweetalert2.min.js"></script>
<script src="/dist/js/stisla.js"></script>

<script src="/dist/modules/datatables/datatables.min.js"></script>
<script src="/dist/modules/datatables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script src="/dist/bootstrap/assets/jqueryform/jquery.form.js"></script>

<script src="/dist/js/scripts.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/notification_js.tpl'}
{include file='js/page/cloudflare_domains_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
