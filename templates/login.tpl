<!DOCTYPE html>
<html class="no-js" lang="en" data-theme="dark">
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
:root {
    --login-bg: #04060e;
    --login-bg-soft: rgba(15, 23, 42, 0.85);
    --login-card: rgba(10, 18, 35, 0.95);
    --login-border: rgba(255, 255, 255, 0.08);
    --login-border-strong: rgba(99, 102, 241, 0.25);
    --login-text: #e2e8f0;
    --login-muted: #94a3b8;
    --login-accent: #7c3aed;
    --login-accent-soft: #4f46e5;
}
html, body {
    min-height: 100% !important;
    background: radial-gradient(circle at 20% 20%, rgba(99, 102, 241, 0.18), transparent 28%) !important;
    background-image: radial-gradient(circle at 80% 10%, rgba(16, 185, 129, 0.14), transparent 22%), radial-gradient(circle at 10% 90%, rgba(59, 130, 246, 0.12), transparent 18%), linear-gradient(180deg, #04060e 0%, #070c16 56%, #0d1629 100%) !important;
    color: var(--login-text) !important;
}
body.login-body {
    overflow-x: hidden !important;
}
.login-page {
    min-height: calc(100vh - 140px) !important;
    display: grid !important;
    align-items: center !important;
    padding: 3rem 0 !important;
}
.login-grid {
    display: grid !important;
    grid-template-columns: 1fr 0.95fr !important;
    gap: 2rem !important;
}
.login-brand {
    display: inline-flex !important;
    align-items: center !important;
    gap: 0.85rem !important;
    margin-bottom: 1.75rem !important;
}
.login-brand img {
    border-radius: 50% !important;
    box-shadow: 0 18px 45px rgba(124, 58, 237, 0.18) !important;
}
.login-brand__title {
    font-size: 1rem !important;
    font-weight: 700 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.24em !important;
    color: #c7d2fe !important;
}
.login-hero {
    background: rgba(15, 23, 42, 0.74) !important;
    border: 1px solid rgba(255, 255, 255, 0.06) !important;
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.3) !important;
    border-radius: 30px !important;
    padding: 2.5rem 2.5rem 2.5rem 2.5rem !important;
    display: flex !important;
    flex-direction: column !important;
    justify-content: center !important;
    min-height: 100% !important;
}
.login-hero h1 {
    font-size: 2.8rem !important;
    line-height: 1.02 !important;
    margin-bottom: 1rem !important;
    color: white !important;
}
.login-hero p {
    font-size: 1rem !important;
    color: var(--login-muted) !important;
    max-width: 34rem !important;
    margin-bottom: 1.75rem !important;
}
.login-hero .login-highlights {
    display: grid !important;
    gap: 1rem !important;
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
}
.login-hero .highlight {
    background: rgba(255, 255, 255, 0.04) !important;
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
    border-radius: 20px !important;
    padding: 1rem 1.15rem !important;
    color: var(--login-text) !important;
    display: flex !important;
    align-items: center !important;
    gap: 0.75rem !important;
    font-weight: 500 !important;
}
.login-hero .highlight i {
    width: 2.4rem !important;
    height: 2.4rem !important;
    display: grid !important;
    place-items: center !important;
    border-radius: 14px !important;
    background: rgba(124, 58, 237, 0.16) !important;
    color: #dbeafe !important;
}
.login-frame {
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
}
.login-card {
    background: var(--login-card) !important;
    border: 1px solid var(--login-border) !important;
    border-radius: 30px !important;
    box-shadow: 0 40px 90px rgba(3, 7, 24, 0.45) !important;
    overflow: hidden !important;
}
.login-card .card-body {
    padding: 2.7rem !important;
}
.login-card-header {
    font-size: 1.65rem !important;
    font-weight: 700 !important;
    color: white !important;
    margin-bottom: 0.65rem !important;
}
.login-card-description {
    color: var(--login-muted) !important;
    margin-bottom: 1.75rem !important;
    line-height: 1.8 !important;
}
.form-group label {
    color: #cbd5e1 !important;
    font-weight: 600 !important;
    margin-bottom: 0.55rem !important;
}
.form-control {
    background: rgba(255, 255, 255, 0.04) !important;
    border: 1px solid rgba(255, 255, 255, 0.12) !important;
    color: #f8fafc !important;
    border-radius: 16px !important;
    height: 58px !important;
    transition: all 0.3s ease !important;
}
.form-control:focus {
    background: rgba(255, 255, 255, 0.08) !important;
    border-color: rgba(124, 58, 237, 0.55) !important;
    box-shadow: 0 0 0 0.2rem rgba(124, 58, 237, 0.18) !important;
    color: white !important;
}
.input-group-text {
    background: rgba(255, 255, 255, 0.05) !important;
    border: 1px solid rgba(255, 255, 255, 0.12) !important;
    color: #a5b4fc !important;
    border-radius: 0 16px 16px 0 !important;
}
.btn-submit {
    border-radius: 16px !important;
    background: linear-gradient(135deg, var(--login-accent), var(--login-accent-soft)) !important;
    border: none !important;
    color: white !important;
    padding: 0.95rem 1.15rem !important;
    font-size: 1rem !important;
    font-weight: 600 !important;
    box-shadow: 0 18px 45px rgba(124, 58, 237, 0.25) !important;
    transition: transform 0.25s ease, box-shadow 0.25s ease !important;
}
.btn-submit:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 24px 58px rgba(124, 58, 237, 0.28) !important;
}
.btn-progress::after {
    content: '' !important;
    position: absolute !important;
    inset: 0 !important;
    border-radius: 16px !important;
    background: linear-gradient(90deg, rgba(255,255,255,0.05), rgba(255,255,255,0.12), rgba(255,255,255,0.05)) !important;
    animation: login-button-loading 1.1s infinite linear !important;
}
@keyframes login-button-loading {
    0% { transform: translateX(-100%) !important; }
    100% { transform: translateX(100%) !important; }
}
.login-links {
    display: grid !important;
    gap: 0.9rem !important;
    margin-top: 1.4rem !important;
}
.login-links a {
    color: #f8fafc !important;
    background: rgba(255, 255, 255, 0.04) !important;
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
    border-radius: 16px !important;
    padding: 0.95rem 1.25rem !important;
    display: inline-flex !important;
    justify-content: center !important;
    align-items: center !important;
    gap: 0.75rem !important;
    font-weight: 600 !important;
    transition: all 0.25s ease !important;
}
.login-links a:hover {
    transform: translateY(-1px) !important;
    background: rgba(124, 58, 237, 0.16) !important;
    border-color: rgba(124, 58, 237, 0.22) !important;
}
.reseller-card {
    background: linear-gradient(135deg, rgba(124, 58, 237, 0.18), rgba(59, 130, 246, 0.12)) !important;
    border: 1px solid rgba(124, 58, 237, 0.24) !important;
    border-radius: 22px !important;
    padding: 1.35rem 1.35rem !important;
    box-shadow: 0 28px 65px rgba(4, 6, 14, 0.28) !important;
}
.reseller-card .alert-heading {
    color: #eef2ff !important;
    font-weight: 700 !important;
    margin-bottom: 0.85rem !important;
}
.reseller-card p {
    color: #dbeafe !important;
    margin-bottom: 1rem !important;
    line-height: 1.7 !important;
}
.reseller-card .btn-light {
    background: linear-gradient(135deg, var(--login-accent), #5b21b6) !important;
    border: none !important;
    border-radius: 14px !important;
    color: white !important;
    font-weight: 600 !important;
    padding: 0.8rem 1.2rem !important;
    box-shadow: 0 16px 35px rgba(124, 58, 237, 0.2) !important;
}
.reseller-card .btn-light:hover {
    transform: translateY(-1px) !important;
}
.footer .simple-footer {
    color: var(--login-muted) !important;
    padding: 1.25rem 0 1rem !important;
    text-align: center !important;
}
.footer .text-muted a {
    color: var(--login-accent) !important;
}
@media (max-width: 992px) {
    .login-grid { grid-template-columns: 1fr !important; }
    .login-hero { min-height: auto !important; }
}
@media (max-width: 576px) {
    .login-page { padding: 2rem 0 1rem !important; }
    .login-card .card-body { padding: 2rem 1.5rem !important; }
    .login-hero { padding: 1.8rem 1.5rem !important; border-radius: 24px !important; }
    .login-hero h1 { font-size: 2.2rem !important; }
}
</style>

</head>
<body class="login-body">
<a class="faz" href="#" onclick="return false;" type="button" data-theme-toggle><i id="xtoggle"></i></a>
<div id="app">
<section class="section login-page">
<div class="container">
<div class="login-grid">
<div class="login-hero">
    <div class="login-brand">
        <img src="{$site_logo}" alt="logo">
        <div class="login-brand__title">{$site_name}</div>
    </div>
    <h1>Secure VPN dashboard access</h1>
    <p>Login to the panel securely and manage servers, users, and connection analytics from one premium console.</p>
    <div class="login-highlights">
        <div class="highlight"><i class="fas fa-shield-alt"></i>Enterprise-grade security</div>
        <div class="highlight"><i class="fas fa-server"></i>Server & user controls</div>
        <div class="highlight"><i class="fas fa-rocket"></i>Fast, modern workflow</div>
        <div class="highlight"><i class="fas fa-chart-line"></i>Realtime activity insights</div>
    </div>
</div>
<div class="login-frame">
<div class="login-card card">
<div class="card-body">
    <div class="login-card-header">Welcome back</div>
    <p class="login-card-description">Use your existing VPN login credentials to continue. The form below submits normally to the panel authentication endpoint.</p>
    {$mainte}
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
        <div class="login-links">
            <a href="download" class="btn btn-icon icon-left"><i class="fas fa-download"></i>Application List</a>
            <a href="update" class="btn btn-icon icon-left btn-primary"><i class="fas fa-edit"></i>Update Information</a>
        </div>
        <div class="form-group mt-4 text-center">
            <div class="alert alert-primary reseller-card" role="alert">
                <h6 class="alert-heading"><i class="fas fa-handshake"></i>Become a Reseller</h6>
                <p class="mb-2">Join our reseller program and start earning by selling VPN accounts to your customers.</p>
                <a href="reseller-signup" class="btn btn-light btn-sm">
                    <i class="fas fa-user-plus"></i>Apply Now
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
