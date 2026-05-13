<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Ads Revenue</title>
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
<h1>Ads Revenue</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Panel</div>
<div class="breadcrumb-item">Ads Manager</div>
<div class="breadcrumb-item active">Revenue</div>
</div>
</div>
<div class="section-body">

<div class="row">
    <div class="col-lg-3 col-md-6 col-sm-6">
        <div class="card card-statistic-2 card-success">
            <div class="card-icon shadow-success bg-success">
                <i class="fas fa-dollar-sign"></i>
            </div>
            <div class="card-wrap">
                <div class="card-header">
                    <h4>Total Revenue</h4>
                </div>
                <div class="card-body total-revenue">$0.00</div>
            </div>
        </div>
    </div>
    
    <div class="col-lg-3 col-md-6 col-sm-6">
        <div class="card card-statistic-2 card-primary">
            <div class="card-icon shadow-primary bg-primary">
                <i class="fas fa-calendar-day"></i>
            </div>
            <div class="card-wrap">
                <div class="card-header">
                    <h4>Today</h4>
                </div>
                <div class="card-body today-revenue">$0.00</div>
            </div>
        </div>
    </div>
    
    <div class="col-lg-3 col-md-6 col-sm-6">
        <div class="card card-statistic-2 card-warning">
            <div class="card-icon shadow-warning bg-warning">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <div class="card-wrap">
                <div class="card-header">
                    <h4>This Month</h4>
                </div>
                <div class="card-body month-revenue">$0.00</div>
            </div>
        </div>
    </div>
    
    <div class="col-lg-3 col-md-6 col-sm-6">
        <div class="card card-statistic-2 card-info">
            <div class="card-icon shadow-info bg-info">
                <i class="fas fa-mobile-alt"></i>
            </div>
            <div class="card-wrap">
                <div class="card-header">
                    <h4>Active Apps</h4>
                </div>
                <div class="card-body active-apps">0</div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-12">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">Revenue by App</h2>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="revenue-table">
                        <thead>
                            <tr>
                                <th>App Name</th>
                                <th>Package</th>
                                <th>Status</th>
                                <th>Total Revenue</th>
                                <th>Today</th>
                                <th>This Month</th>
                                <th>Last Updated</th>
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
    <div class="col-md-6">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">Revenue Chart</h2>
            </div>
            <div class="card-body">
                <canvas id="revenue-chart"></canvas>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">Top Performing Apps</h2>
            </div>
            <div class="card-body">
                <div class="top-apps-list">
                    <!-- Top apps will be loaded here -->
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-12">
        <div class="card card-primary">
            <div class="card-header">
                <h2 class="section-title">Revenue History</h2>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-3">
                        <select class="form-control" id="filter-app">
                            <option value="">All Apps</option>
                            <!-- Options will be loaded via AJAX -->
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-control" id="filter-period">
                            <option value="7">Last 7 Days</option>
                            <option value="30">Last 30 Days</option>
                            <option value="90">Last 90 Days</option>
                            <option value="365">Last Year</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button class="btn btn-primary" id="apply-filter">Apply Filter</button>
                    </div>
                    <div class="col-md-3">
                        <div class="btn-group w-100">
                            <button class="btn btn-warning" id="clean-history" title="Clean old revenue history data">
                                <i class="fas fa-broom"></i> Clean History
                            </button>
                            <button class="btn btn-outline-warning dropdown-toggle dropdown-toggle-split" data-toggle="dropdown">
                                <span class="sr-only">Toggle Dropdown</span>
                            </button>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#" id="clean-30-days">Clean data older than 30 days</a>
                                <a class="dropdown-item" href="#" id="clean-90-days">Clean data older than 90 days</a>
                                <a class="dropdown-item" href="#" id="clean-1-year">Clean data older than 1 year</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item text-danger" href="#" id="clean-all-history">Clean all history</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-striped" id="revenue-history-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>App Name</th>
                                <th>Ad Type</th>
                                <th>Revenue</th>
                                <th>Impressions</th>
                                <th>Clicks</th>
                                <th>CTR</th>
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
{include file='js/page/ads_revenue_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
