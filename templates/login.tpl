<!DOCTYPE html>
<html class="no-js" lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — {$site_description}</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="{$base_url}dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="{$base_url}dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}

<style>
/* Reseller Card Theme Integration */
.reseller-card.alert-primary {
    background: var(--primary, #6777ef) !important;
    background: linear-gradient(135deg, var(--primary, #6777ef), rgba(103, 119, 239, 0.8)) !important;
    border-color: var(--primary, #6777ef) !important;
    color: white !important;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(103, 119, 239, 0.3);
    transition: all 0.3s ease;
}

.reseller-card.alert-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(103, 119, 239, 0.4);
}

.reseller-card .alert-heading {
    color: white !important;
    font-weight: 600;
    margin-bottom: 10px;
}

.reseller-card p {
    color: rgba(255, 255, 255, 0.9) !important;
    margin-bottom: 15px;
}

.reseller-card .btn-light {
    background: #28a745 !important;
    background: linear-gradient(135deg, #28a745, #20c997) !important;
    color: white !important;
    border: none !important;
    font-weight: 600 !important;
    padding: 8px 20px !important;
    border-radius: 6px !important;
    transition: all 0.3s ease !important;
    box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
}

.reseller-card .btn-light:hover {
    background: #218838 !important;
    background: linear-gradient(135deg, #218838, #17a2b8) !important;
    color: white !important;
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
}
</style>

</head>
<body class="bg-image">
<a class="faz" href="#" onclick="return false;" type="button" data-theme-toggle><i id="xtoggle"></i></a>
<div id="app">
<section class="section">
<div class="container mt-5">
<div class="row">
<div class="col-12 col-sm-8 offset-sm-2 col-md-6 offset-md-3 col-lg-6 offset-lg-3 col-xl-4 offset-xl-4">
<div class="login-brand">
<img src="{$site_logo}" alt="logo" width="120" height="120">
</div>
{$mainte}

<div class="card card-primary">
<div class="card-body">

    {* FIXED: render HTML in login note *}
    <div class="mb-3 text-center">
        {$login_note nofilter}
    </div>

    <form method="post" class="authenticate" autocomplete="off">
        <div class="errors"></div>
    
        <input type="hidden" id="submitted" name="submitted" value="login_account" />
        <input type="hidden" id="code" name="code" value="{$code}" />
        <input type="hidden" id="category" name="category" value="{$login_encrypt}" />
        <input type="hidden" name="_key" id="_key" value="{$firenet_encrypt}">
        <div class="form-group">
            <label for="user_name">Username</label>
            <input type="text" class="form-control" name="user_name" id="user_name" value="{$user_name}" tabindex="1" autofocus>
        </div>
        <div class="form-group">
            <label for="user_pass">Password</label>
            
            <div class="input-group colorpickerinput">
            <input type="password" class="form-control" name="user_pass" id="user_pass" tabindex="1" autofocus>
                <div class="input-group-append">
                    <div class="input-group-text text-primary" style="cursor: pointer;">
                        <span class="password-toggle-icon"><i class="fas fa-eye"></i></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary btn-lg btn-block btn-submit" tabindex="4">Login</button>
        </div>
        <hr>
        <div class="form-group text-center">
            <a href="download" class="btn btn-icon icon-left"><i class="fas fa-download"></i> Application List</a>
        </div>
        <div class="form-group text-center">
            <a href="update" class="btn btn-icon icon-left btn-primary"><i class="fas fa-edit"></i> Update Information</a>
        </div>
        <hr>
        <div class="form-group text-center">
            <div class="alert alert-primary reseller-card" role="alert">
                <h6 class="alert-heading"><i class="fas fa-handshake"></i> Become a Reseller</h6>
                <p class="mb-2">Join our reseller program and start earning by selling VPN accounts to your customers.</p>
                <a href="reseller-signup" class="btn btn-light btn-sm">
                    <i class="fas fa-user-plus"></i> Apply Now
                </a>
            </div>
        </div>
    </form>

</div>
</div>
</div>
</div>
</div>
</section>
<footer class="footer">
<div class="simple-footer">
<span class="animate-charcter">{$site_name}</span><br>
<span class="text-muted">Copyright &copy; <script>document.write(new Date().getFullYear())</script> - <a href="/privacy-policy" target="_blank">Privacy Policy</a></span>
</div>
</footer>
</div>

{* MODALS *}
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
<script src="/dist/sweetalert2/sweetalert2.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/bootstrap/assets/jqueryform/jquery.form.js"></script>
<script src="/dist/js/scripts.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/login_js.tpl'}


<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
