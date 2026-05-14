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
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/modules/select2.min.css">
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
<h1>Reseller</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Main</div>
<div class="breadcrumb-item active">Create</div>
<div class="breadcrumb-item active">Reseller</div>
</div>
</div>
<div class="section-error">
<div class="errors"></div>
</div>
<div class="section-body">
<div class="row">
<div class="col-md-6">
<div class="card card-primary">
<div class="card-header">
<h2 class="section-title">Create Reseller</h2>
</div>
<div class="card-body">
<form action="" class="addreseller" autocomplete="off">
<input type="hidden" name="submitted" name="submitted" value="add_reseller">
<input type="hidden" name="_key" id="_key_reseller" value="{$firenet_encrypt}">
{if $user_level_2=='reseller'}
<div class="form-group">
<label for="mycred">Your Credit Balance</label>
<input id="mycred" type="text" value="" class="form-control mycred" name="mycred" tabindex="1" readonly>
</div>
{/if}
<div class="form-group">
<label for="reseller_username">Username</label>
<input id="reseller_username" type="text" value="" class="form-control" name="username" tabindex="1">
</div>
<div class="form-group">
<label for="reseller_password">Password</label>
<input id="reseller_password" type="text" value="" class="form-control" name="password" tabindex="1">
</div>
<div class="form-group">
<label for="reseller_amount">Credits</label>
<input id="reseller_amount" type="number" value="0" min="0" class="form-control amount" name="amount" tabindex="1">
</div>
<div class="form-group">
<button type="submit" class="btn btn-primary btn-lg btn-block btn-addreseller" tabindex="4">
Create
</button>
</div>
</form>
</div>
</div>
</div>

<div class="col-md-6">
<div class="card card-primary">
<div class="card-header">
<h2 class="section-title">Transfer Credit</h2>
</div>
<div class="card-body">
<form action="" class="transfercredit" autocomplete="off">
<input type="hidden" name="submitted" name="submitted" value="transfer_credit">
<input type="hidden" name="_key" id="_key_transfer" value="{$firenet_encrypt}">
{if $user_level_2=='reseller'}
<div class="form-group">
<label for="transfer_mycred">Your Credit Balance</label>
<input id="transfer_mycred" type="text" value="" class="form-control mycred" name="mycred" tabindex="1" readonly>
</div>
{/if}
<div class="form-group">
<label for="transfer_username">Username</label>
<input id="transfer_username" type="text" value="" class="form-control transferusername" name="transferusername" tabindex="1">
</div>
<div class="form-group">
<label for="transfer_amount">Credits</label>
<input id="transfer_amount" type="number" value="0" min="0" class="form-control transferamount" name="transferamount" tabindex="1">
</div>
 <div class="form-group">
<div class="custom-control custom-checkbox">
<input type="checkbox" class="custom-control-input" id="authorized" name="transferauthorized">
<label class="custom-control-label" for="authorized">I authorized this transfer</label>
</div>
</div>
<div class="form-group">
<button type="submit" class="btn btn-primary btn-lg btn-block btn-transfercredit" tabindex="4">
Transfer
</button>
</div>
</form>
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
{include file='js/page/addreseller_js.tpl'}
{include file='js/page/search_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
