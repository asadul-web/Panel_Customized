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

<link rel="stylesheet" href="/dist/modules/bootstrap-social/bootstrap-social.css">
<link rel="stylesheet" href="/dist/modules/datatables/datatables.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/Select-1.2.4/css/select.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="{$base_url}dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="{$base_url}dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
<style>
    .hehe{
        color: #ffff;
         background-image: -webkit-linear-gradient(30deg, #f35626, #feab3a);
         -webkit-background-clip: text;
         -webkit-text-fill-color: transparent;
         -webkit-animation: hue 10s infinite linear;
    }
    @-webkit-keyframes hue{
        from{
            -webkit-filter: hue-rotate(0deg);
        }
        to{
            -webkit-filter: hue-rotate(-360deg);
        }
</style>
</head>
<body>
<a class="faz" href="#" onclick="return false;" type="button" data-theme-toggle><i id="xtoggle"></i></a>
<div id="app">
<section class="section">
<div class="container mt-5">
<div class="row">
<div class="col-12 col-sm-8 offset-sm-2 col-md-6 offset-md-3 col-lg-6 offset-lg-3 col-xl-4 offset-xl-4">
<div class="login-brand">
<img src="{$site_logo}" alt="logo" width="120">
</div>
{$mainte}
<div class="card card-primary">
<div class="card-body">

    <form method="post" class="confirmation" autocomplete="off">
        <div class="errors"></div>
    
        <input type="hidden" id="submitted" name="submitted" value="confirmation" />
        <input type="hidden" id="code" name="code" value="{$code}" />
        <input type="hidden" id="category" name="category" value="{$login_encrypt}" />
        <input type="hidden" name="_key" id="_key" value="{$firenet_encrypt}">
        <div class="form-group text-center">
            <label>For security reason, we've sent a Confirmation Code to your registered email address.</label>
            <label>Kindly check your inbox or spam folder and provide the Confirmation Code to continue with this login.</label>
            <label>Confirmation Code will expire in 10 minutes.</label>
        </div>
        <hr>
        <div class="form-group text-center">
            <label for="user_name">Confimation Code</label>
            <input type="text" class="form-control" name="otp" id="otp" tabindex="1" autofocus>
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-outline-primary btn-lg btn-block btn-submit" tabindex="4">Submit</button>
        </div>
        <div class="form-group text-center">
            <label>Did'nt receive a code?</label><br>
            <label>{$otpduration}</label>
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
<span class="hehe">{$site_name}</span><br>
<span class="text-muted">Copyright &copy; <script>document.write(new Date().getFullYear())</script> - <a href="/privacy-policy" target="_blank">Privacy Policy</a></span>
</div>
</footer>
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

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom.js?v=2"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/confirmation_js.tpl'}


<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>