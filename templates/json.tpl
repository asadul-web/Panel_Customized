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
<h1>Json Management</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Panel</div>
<div class="breadcrumb-item active">Json</div>
</div>
</div>
<div class="section-body">
<div class="row">
<div class="col-md-4">
<div class="card card-primary">
<div class="card-header">
<h2 class="section-title">Create Json</h2>
</div>
<div class="card-body">
<div class="test"></div>
<div class="section-error">
<div class="errors"></div>
</div>
<form action="" class="add-json" autocomplete="off">
<input type="hidden" name="submitted" name="submitted" value="add_json">
<input type="hidden" name="_key" id="_key" value="{$firenet_encrypt}">
<div class="form-group">
<label for="name">Name</label>
<input id="name" type="text" class="form-control" name="name" tabindex="1" required="">
</div>
<div class="form-group">
<label for="jsontype">Type</label>
<select id="jsontype" class="form-control select2" name="type" data-minimum-results-for-search="-1">
<option value="1" selected>OPENVPN</option>
<option value="2">OPENCONNECT</option>
<option value="3">OPENSSH</option>
<option value="4">ALL-IN-ONE</option>
<option value="5">CONFIG</option>
<option value="6">NOTICE</option>
</select>
</div>
<div class="form-group">
<label for="forjsonconfig">Config</label>
<div id="json">
<textarea id="forjsonconfig" class="form-control" rows="15" style="min-width: 100%;height: 100%" name="json"></textarea>
</div>
</div>
<div class="form-group">
<button type="submit" class="btn btn-primary btn-add-json">Create</button>
<button type="button" class="btn btn-danger btn-reset">Reset</button>
</div>
</form>
</div>
</div>
</div>
<div class="col-md-8">
<div class="card card-primary">
<div class="card-header">
<h2 class="section-title">Json List</h2>
</div>
<div class="card-body">
<div class="table-responsive">
<table class="table table-listjson" style="width: 100%">
<thead>
<tr>
<th>Name</th>
<th>Type</th>
<th>Encryption</th>
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
<script src="/dist/modules/jquery-ui/jquery-ui.min.js"></script>
<script src="/dist/bootstrap/assets/jqueryform/jquery.form.js"></script>
<script src="/dist/modules/summernote/summernote-bs4.min.js"></script>
<script src="/dist/modules/select2.full.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/notification_js.tpl'}
{include file='js/page/json_js.tpl'}
{include file='js/page/search_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>

</body>
</html>
