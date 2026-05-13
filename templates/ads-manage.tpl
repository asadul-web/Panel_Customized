<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Ads Manager</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/dist/modules/bootstrap-social/bootstrap-social.css">
<link href="https://cdn.datatables.net/v/bs4/dt-1.13.6/b-2.4.2/r-2.5.0/sr-1.3.0/datatables.min.css" rel="stylesheet">

<link rel="stylesheet" href="/dist/modules/select2.min.css">
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
<style>
.compact-form .form-control-sm {
    font-size: 0.8rem;
    padding: 0.25rem 0.5rem;
    height: calc(1.5em + 0.5rem + 2px);
}

.compact-form label.small {
    font-size: 0.75rem;
    margin-bottom: 0.25rem;
    color: #495057;
}

.compact-form .form-group {
    margin-bottom: 0.75rem;
}

.compact-form .form-text {
    margin-top: 0.1rem;
    font-size: 0.7rem !important;
}

.compact-form .btn-sm {
    padding: 0.375rem 0.75rem;
    font-size: 0.8rem;
    line-height: 1.4;
}

.compact-form input::placeholder {
    font-size: 0.75rem;
    color: #6c757d;
}

.compact-form select.form-control-sm {
    font-size: 0.8rem;
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
<h1>Ads Manager</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Panel</div>
<div class="breadcrumb-item active">Ads</div>
</div>
</div>
<div class="section-body">

<div class="row">
    <div class="col-12">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">Create New App Ad Configuration</h2>
            </div>
            <div class="card-body">
                <form id="ads-form" class="ads-form compact-form">
                    <input type="hidden" name="_key" value="{$firenet_encrypt}">
                    <input type="hidden" name="submitted" value="1">
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group mb-2">
                                <label for="app_name" class="small font-weight-bold">App Name</label>
                                <input type="text" class="form-control form-control-sm" id="app_name" name="app_name" placeholder="Enter app name" required>
                                <small class="form-text text-muted" style="font-size: 0.7rem;">Used in URL generation</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group mb-2">
                                <label for="app_package" class="small font-weight-bold">Package Name</label>
                                <input type="text" class="form-control form-control-sm" id="app_package" name="app_package" placeholder="com.example.app" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group mb-2">
                                <label for="app_status" class="small font-weight-bold">App Status</label>
                                <select class="form-control form-control-sm" id="app_status" name="app_status">
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                    <option value="testing">Testing</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group mb-2">
                                <label for="admob_app_id" class="small font-weight-bold">AdMob App ID</label>
                                <input type="text" class="form-control form-control-sm" id="admob_app_id" name="admob_app_id" placeholder="ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group mb-2">
                                <label for="banner_ad_id" class="small font-weight-bold">Banner Ad Unit ID</label>
                                <input type="text" class="form-control form-control-sm" id="banner_ad_id" name="banner_ad_id" placeholder="ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group mb-2">
                                <label for="interstitial_ad_id" class="small font-weight-bold">Interstitial Ad Unit ID</label>
                                <input type="text" class="form-control form-control-sm" id="interstitial_ad_id" name="interstitial_ad_id" placeholder="ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group mb-2">
                                <label for="rewarded_ad_id" class="small font-weight-bold">Rewarded Ad Unit ID</label>
                                <input type="text" class="form-control form-control-sm" id="rewarded_ad_id" name="rewarded_ad_id" placeholder="ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group mb-2">
                                <label for="native_advanced_ad_id" class="small font-weight-bold">Native Advanced Ad Unit ID</label>
                                <input type="text" class="form-control form-control-sm" id="native_advanced_ad_id" name="native_advanced_ad_id" placeholder="ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group mb-2">
                                <label for="app_open_ad_id" class="small font-weight-bold">App Open Ad Unit ID</label>
                                <input type="text" class="form-control form-control-sm" id="app_open_ad_id" name="app_open_ad_id" placeholder="ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx">
                            </div>
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <div class="form-group mb-2 w-100">
                                <button type="button" class="btn btn-primary btn-sm btn-confirm-ads w-100" tabindex="4">Create App Configuration</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row d-none" id="cancel-row">
                        <div class="col-md-12">
                            <div class="form-group mb-2 text-center">
                                <button type="button" class="btn btn-secondary btn-sm btn-cancel-ads" tabindex="5">Cancel</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-12">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">Existing App Configurations</h2>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="ads-table">
                        <thead>
                            <tr>
                                <th>App Name</th>
                                <th>Package</th>
                                <th>Generated URL</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Data will be loaded via AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</div>
</section>
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
<script src="https://cdn.datatables.net/v/bs4/dt-1.13.6/b-2.4.2/r-2.5.0/sl-1.7.0/datatables.min.js"></script>
<script src="/dist/modules/select2.full.min.js"></script>
<script src="/dist/modules/jquery-ui/jquery-ui.min.js"></script>
<script src="/dist/bootstrap/assets/jqueryform/jquery.form.js"></script>
<script src="/dist/modules/summernote/summernote-bs4.min.js"></script>
<script src="/dist/modules/select2.full.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/ads_manage_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
