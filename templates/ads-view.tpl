<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Ads View</title>
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
.api-url-cell {
    min-width: 300px;
    max-width: 400px;
}

.api-url-text {
    font-family: 'Courier New', monospace;
    font-size: 0.75rem;
    color: #495057;
    word-break: break-all;
    line-height: 1.2;
}

.btn-xs {
    padding: 0.125rem 0.25rem;
    font-size: 0.7rem;
    line-height: 1.2;
    border-radius: 0.2rem;
}

#ads-view-table th:nth-child(10),
#ads-view-table td:nth-child(10) {
    min-width: 300px;
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
<h1>Ads View</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Panel</div>
<div class="breadcrumb-item">Ads Manager</div>
<div class="breadcrumb-item active">Ads View</div>
</div>
</div>
<div class="section-body">

<div class="row">
    <div class="col-12">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">API Endpoints</h2>
            </div>
            <div class="card-body">
                <div class="alert alert-success" role="alert" style="border: none; border-radius: 8px;">
                    <h6 class="alert-heading"><i class="fas fa-check-circle"></i> New RESTful API Format</h6>
                    <strong>Pattern:</strong> <code>http://{$smarty.server.HTTP_HOST}/api/ads/APP_NAME/config</code><br>
                    <strong>Example:</strong> <code>http://{$smarty.server.HTTP_HOST}/api/ads/ruzain/config</code><br>
                    <small class="text-white mt-1 d-block">Clean URLs without query parameters - following REST API standards</small>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="get_app_config_api">Get App Configuration API</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="get_app_config_api" value="http://{$smarty.server.HTTP_HOST}/api/ads/APP_NAME/config" readonly>
                                <div class="input-group-append">
                                    <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#get_app_config_api">Copy</button>
                                </div>
                            </div>
                            <small class="form-text text-muted">Replace APP_NAME with your app name</small>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="get_all_apps_api">Get All Apps API</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="get_all_apps_api" value="http://{$smarty.server.HTTP_HOST}/api/ads/apps" readonly>
                                <div class="input-group-append">
                                    <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#get_all_apps_api">Copy</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="update_revenue_api">Update Revenue API (POST)</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="update_revenue_api" value="http://{$smarty.server.HTTP_HOST}/api/ads/revenue" readonly>
                                <div class="input-group-append">
                                    <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#update_revenue_api">Copy</button>
                                </div>
                            </div>
                            <small class="form-text text-muted">POST: app_name, revenue_amount, ad_type</small>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="get_revenue_api">Get Revenue API</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="get_revenue_api" value="http://{$smarty.server.HTTP_HOST}/api/ads/APP_NAME/revenue" readonly>
                                <div class="input-group-append">
                                    <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#get_revenue_api">Copy</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-12">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">App Configurations List</h2>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="ads-view-table">
                        <thead>
                            <tr>
                                <th>App Name</th>
                                <th>Package Name</th>
                                <th>AdMob App ID</th>
                                <th>Banner ID</th>
                                <th>Interstitial ID</th>
                                <th>Rewarded ID</th>
                                <th>Native Advanced ID</th>
                                <th>App Open ID</th>
                                <th>Status</th>
                                <th>API URL</th>
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

<div class="row">
    <div class="col-12">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">API Response Examples</h2>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6>App Configuration Response:</h6>
                        <pre class="bg-light p-3"><code>{
  "response": 1,
  "app_name": "MyApp",
  "package_name": "com.example.myapp",
  "admob_app_id": "ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx",
  "banner_ad_id": "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx",
  "interstitial_ad_id": "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx",
  "rewarded_ad_id": "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx",
  "native_advanced_ad_id": "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx",
  "app_open_ad_id": "ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx",
  "status": "active"
}</code></pre>
                    </div>
                    <div class="col-md-6">
                        <h6>Revenue Response:</h6>
                        <pre class="bg-light p-3"><code>{
  "response": 1,
  "app_name": "MyApp",
  "total_revenue": "125.50",
  "today_revenue": "12.30",
  "this_month": "89.20",
  "currency": "USD",
  "last_updated": "2024-11-11 13:30:00"
}</code></pre>
                    </div>
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
{include file='js/page/ads_view_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
