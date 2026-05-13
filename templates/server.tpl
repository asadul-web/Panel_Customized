<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — {$site_description}</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/timeago.js/4.0.2/timeago.min.js" integrity="sha512-SVDh1zH5N9ChofSlNAK43lcNS7lWze6DTVx1JCXH1Tmno+0/1jMpdbR8YDgDUfcUrPp1xyE53G42GFrcM0CMVg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<link rel="stylesheet" href="/dist/modules/bootstrap-social/bootstrap-social.css">
<link rel="stylesheet" href="/dist/modules/datatables/datatables.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/Select-1.2.4/css/select.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/Select-1.2.4/css/select.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/select2.min.css">
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
<style>
/* Ultra Compact Form Styling */
.add-server .form-group {
    margin-bottom: 8px !important;
}

.add-server label {
    font-size: 11px !important;
    font-weight: 400 !important;
    margin-bottom: 3px !important;
    color: #4a5568 !important;
}

.add-server .form-control {
    height: 32px !important;
    padding: 5px 8px !important;
    font-size: 12px !important;
    border-radius: 4px !important;
}

.add-server .btn-add-server {
    height: 36px !important;
    padding: 7px 12px !important;
    font-size: 12px !important;
    font-weight: 600 !important;
    margin-top: 6px !important;
}

.add-server h6 {
    margin: 0 !important;
    font-size: 14px !important;
    font-weight: 600 !important;
}

.add-server > div:first-child {
    margin-bottom: 12px !important;
}

/* Reduce card padding */
.add-server {
    padding: 12px !important;
}

/* Override card-body padding for Add Server card - AGGRESSIVE */
.section-body .col-md-3 .card .card-body {
    padding: 12px !important;
}

.section-body .col-md-3 .card {
    margin-bottom: 15px !important;
}

/* Force compact spacing on all elements inside the card */
.col-md-3 .card-body > * {
    margin-bottom: 8px !important;
}

.col-md-3 .card-body > *:last-child {
    margin-bottom: 0 !important;
}

/* Clean Server Type Selector - Ultra Compact */
.select2-container--default .select2-selection--single {
    border: 1px solid #e2e8f0;
    border-radius: 4px;
    height: 32px;
    background: #ffffff;
}

.select2-container--default .select2-selection--single:hover {
    border-color: #6777ef;
}

.select2-container--default.select2-container--focus .select2-selection--single {
    border-color: #6777ef;
    box-shadow: 0 0 0 2px rgba(103, 119, 239, 0.1);
}

.select2-container--default .select2-selection--single .select2-selection__rendered {
    line-height: 30px;
    color: #374151;
    font-weight: 400;
    padding-left: 8px;
    padding-right: 26px;
    font-size: 12px;
}

.select2-container--default .select2-selection--single .select2-selection__arrow {
    height: 30px;
    right: 5px;
}

.select2-dropdown {
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    margin-top: 2px;
}

.select2-results__options {
    max-height: 250px;
    padding: 2px;
}

.select2-container--default .select2-results__option {
    padding: 8px 12px;
    font-size: 15px;
    border-radius: 3px;
    margin-bottom: 0;
    color: #374151;
    line-height: 1.6;
}

.select2-container--default .select2-results__option i,
.select2-container--default .select2-results__option .fas,
.select2-container--default .select2-results__option .far {
    font-size: 16px;
    margin-right: 8px;
}

.select2-container--default .select2-results__option--highlighted {
    background: #f0f4ff;
    color: #4f46e5;
}

.select2-container--default .select2-results__option[aria-selected=true] {
    background: #6777ef;
    color: #ffffff;
}

.select2-container--default .select2-results__option[aria-selected=true] i {
    color: #ffffff !important;
}

/* Professional Protocol Status Card Design - Panel v9 Style */
.protocol-status-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
    padding: 1rem 1.25rem;
    margin-bottom: 0.75rem;
    border-radius: 10px;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    border: 2px solid transparent;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

.protocol-status-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    width: 4px;
    background: var(--protocol-color);
    transition: width 0.3s ease;
}

.protocol-status-card:hover {
    transform: translateX(3px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
    border-color: var(--protocol-color);
}

.protocol-status-card:hover::before { width: 6px; }

.protocol-card-success { --protocol-color: #28a745; }
.protocol-card-danger { --protocol-color: #dc3545; }
.protocol-card-warning { --protocol-color: #ffc107; }

.protocol-icon {
    width: 50px;
    height: 50px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, var(--protocol-color), var(--protocol-color));
    flex-shrink: 0;
}

.protocol-icon i {
    font-size: 1.5rem;
    color: #ffffff !important;
}

.protocol-info { flex: 1; min-width: 0; }

.protocol-name {
    font-size: 0.95rem;
    font-weight: 700;
    color: #2d3748;
    margin-bottom: 0.25rem;
    text-transform: uppercase;
    letter-spacing: 0.3px;
}

.protocol-port {
    font-size: 0.8rem;
    font-weight: 600;
    color: #6c757d;
    text-transform: uppercase;
}

.protocol-status {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.4rem 0.9rem;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    flex-shrink: 0;
}

.protocol-status.status-success {
    background: linear-gradient(135deg, rgba(40, 167, 69, 0.15), rgba(32, 201, 151, 0.15));
    color: #28a745;
    border: 1.5px solid rgba(40, 167, 69, 0.3);
}

.protocol-status.status-danger {
    background: linear-gradient(135deg, rgba(220, 53, 69, 0.15), rgba(231, 76, 60, 0.15));
    color: #dc3545;
    border: 1.5px solid rgba(220, 53, 69, 0.3);
}

.protocol-status i { font-size: 0.9rem; }

@keyframes protocolPulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.7; }
}

.protocol-status.status-success i {
    animation: protocolPulse 2s ease-in-out infinite;
}

/* XRAY Configuration Card Design */
.xray-config-card {
    margin-bottom: 1.5rem;
    padding: 1.5rem;
    border-radius: 12px;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    border: 2px solid #e9ecef;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;
}

.xray-config-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
    border-color: #6777ef;
}

.xray-config-header {
    font-size: 1.1rem;
    font-weight: 700;
    color: #2d3748;
    margin-bottom: 1rem;
    padding-bottom: 0.75rem;
    border-bottom: 2px solid #e9ecef;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.xray-config-header i {
    color: #6777ef;
    font-size: 1.2rem;
}

.xray-config-url {
    background: #f8f9fa;
    padding: 1rem;
    border-radius: 8px;
    margin-bottom: 1rem;
    border: 1px solid #e9ecef;
    word-break: break-all;
}

.xray-config-url code {
    font-size: 0.9rem;
    color: #495057;
    font-family: 'Courier New', monospace;
    background: transparent;
    padding: 0;
}

.xray-config-card .btn {
    font-weight: 600;
    padding: 0.75rem 1.5rem;
    border-radius: 8px;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    font-size: 0.9rem;
}

.xray-config-card .btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.xray-config-card .btn i {
    margin-right: 0.5rem;
}

/* Professional Server Statistics Modal Design - Panel v9 Style */
.stats-info-card {
    display: flex;
    align-items: center;
    gap: 1.25rem;
    padding: 1.25rem;
    margin-bottom: 1rem;
    border-radius: 12px;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    border: none;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

.stats-info-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 4px;
    height: 100%;
    background: linear-gradient(180deg, var(--card-color-start), var(--card-color-end));
    transition: width 0.3s ease;
}

.stats-info-card:hover {
    transform: translateX(5px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}

.stats-info-card:hover::before {
    width: 6px;
}

.stats-card-primary { --card-color-start: #6777ef; --card-color-end: #4f5bd5; }
.stats-card-info { --card-color-start: #17a2b8; --card-color-end: #3498db; }
.stats-card-success { --card-color-start: #28a745; --card-color-end: #20c997; }
.stats-card-warning { --card-color-start: #ffc107; --card-color-end: #ff9800; }
.stats-card-danger { --card-color-start: #dc3545; --card-color-end: #e74c3c; }
.stats-card-purple { --card-color-start: #9b59b6; --card-color-end: #8e44ad; }

.stats-info-icon {
    width: 60px;
    height: 60px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, var(--card-color-start), var(--card-color-end));
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
    flex-shrink: 0;
    position: relative;
    overflow: hidden;
}

.stats-info-icon::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.3), transparent);
    transform: rotate(45deg);
    animation: shimmer 3s infinite;
}

@keyframes shimmer {
    0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
    100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
}

.stats-info-icon i {
    font-size: 1.75rem;
    color: #ffffff;
    z-index: 1;
    position: relative;
}

.stats-info-content { flex: 1; min-width: 0; }
.stats-info-label {
    font-size: 0.8rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #6c757d;
    margin-bottom: 0.35rem;
}

.stats-info-value {
    font-size: 1.1rem;
    font-weight: 700;
    color: #2d3748;
    word-break: break-word;
}

/* Modal Enhancement - Full Height */
.modal-dialog {
    max-width: 500px;
    margin: 1rem auto;
}

.modal-content {
    min-height: calc(100vh - 2rem);
    max-height: calc(100vh - 2rem);
    display: flex;
    flex-direction: column;
}

.modal-body {
    flex: 1;
    overflow-y: auto;
    padding: 1.5rem;
}

.modal-header {
    flex-shrink: 0;
    background: linear-gradient(135deg, #6777ef 0%, #4f5bd5 100%);
    color: #ffffff;
    border: none;
    padding: 1rem 1.5rem;
}

.modal-header .modal-title {
    color: #ffffff;
    font-weight: 700;
}

.modal-header .close {
    color: #ffffff;
    opacity: 0.8;
    text-shadow: none;
}

.modal-header .close:hover {
    opacity: 1;
}

.modal-body::-webkit-scrollbar { width: 8px; }
.modal-body::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 10px; }
.modal-body::-webkit-scrollbar-thumb { background: linear-gradient(180deg, #6777ef, #4f5bd5); border-radius: 10px; }
.modal-body::-webkit-scrollbar-thumb:hover { background: linear-gradient(180deg, #4f5bd5, #3d4ab8); }

/* Stats Grid Layout */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 1rem;
}

/* Form Control Stats Style */
.modal-html .form-group { margin-bottom: 0.75rem; }

.modal-html .form-control[readonly] {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem 1.25rem;
    border-radius: 10px;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    border: none;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

.modal-html .form-control[readonly]::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    width: 4px;
    background: linear-gradient(180deg, #6777ef, #4f5bd5);
    transition: width 0.3s ease;
}

.modal-html .form-control[readonly]:hover {
    transform: translateX(3px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
}

.modal-html .form-control[readonly]:hover::before { width: 6px; }

.modal-html .form-control[readonly] b {
    font-size: 0.85rem;
    font-weight: 700;
    color: #2d3748;
    text-transform: uppercase;
    letter-spacing: 0.3px;
}

.modal-html .form-control[readonly] .text-success {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.4rem 0.9rem;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    background: linear-gradient(135deg, rgba(40, 167, 69, 0.15), rgba(32, 201, 151, 0.15));
    color: #28a745 !important;
    border: 1.5px solid rgba(40, 167, 69, 0.3);
}

.modal-html .form-control[readonly] .text-danger {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.4rem 0.9rem;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    background: linear-gradient(135deg, rgba(220, 53, 69, 0.15), rgba(231, 76, 60, 0.15));
    color: #dc3545 !important;
    border: 1.5px solid rgba(220, 53, 69, 0.3);
}

.modal-html .btn-primary {
    background: linear-gradient(135deg, #6777ef 0%, #4f5bd5 100%);
    border: none;
    border-radius: 10px;
    padding: 12px 24px;
    font-weight: 600;
    margin-top: 1rem;
    box-shadow: 0 4px 15px rgba(103, 119, 239, 0.3);
    transition: all 0.3s ease;
}

.modal-html .btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(103, 119, 239, 0.4);
}

@media (max-width: 768px) {
    .modal-html .form-control[readonly] { padding: 0.875rem 1rem; gap: 0.75rem; }
    .modal-html .form-control[readonly] b { font-size: 0.75rem; }
}

/* Make modal with more comfortable height */
.modal-header {
    background-color: #f8f9fa !important;
    background-image: none !important;
    background: #f8f9fa !important;
    color: #495057 !important;
    border-bottom: 1px solid #dee2e6 !important;
    padding: 12px 15px !important;
    min-height: auto !important;
}

.modal-title {
    color: #495057 !important;
    font-size: 1rem !important;
    margin: 0 !important;
    line-height: 1.4 !important;
}

.modal-header .close {
    color: #495057 !important;
    opacity: 0.5 !important;
    font-size: 1.2rem !important;
    padding: 0 !important;
    margin: 0 !important;
}

.modal-header .close:hover {
    color: #000 !important;
    opacity: 0.75 !important;
}

.modal-body {
    padding: 15px !important;
    min-height: auto !important;
}

.modal-body p {
    margin-bottom: 12px !important;
    font-size: 0.9rem !important;
    line-height: 1.4 !important;
}

.modal-body .form-group {
    margin-bottom: 12px !important;
}

.modal-body .btn {
    padding: 8px 16px !important;
    font-size: 0.9rem !important;
    min-height: auto !important;
}

.modal-content {
    min-height: auto !important;
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
<h1>Server Management</h1>
</div>
<div class="section-body">
<div class="row">
<div class="col-md-3">
<div class="card">
<div class="card-body">
<div class="section-error">
<div class="errors"></div>
</div>
<div class="alert alert-warning text-center add-server-alert d-none" role="alert">
<i class="fas fa-exclamation-triangle"></i>
<br>
<strong>SERVER INSTALLER IS UNDER MAINTENANCE<br>please try again later. </strong>
</div>

<div class="alert alert-info add-server-message d-none" role="alert">
<div class="add-server-content"> <i class="fas fa-exclamation-triangle"></i> 
<strong>You selected <code>V2RAY</code> installer, make sure you have a v2ray supported app.</strong>
</div>
</div>

<div class="alert alert-success add-ultimate-message d-none" role="alert">
<div class="add-ultimate-content">
<i class="fas fa-rocket"></i> 
<strong>Ubuntu Ultimate - All Protocols Installer</strong>
<button class="btn btn-sm btn-primary copy-all-ports float-right" style="margin-top: -5px;" title="Click to copy all protocol info">
<i class="fas fa-copy"></i> Copy All Info
</button>
<br>
<small>This installer includes:</small>
<div id="ultimate-protocols-info" style="margin-top: 10px; font-size: 12px;">
<strong>VPN Protocols:</strong><br>
• OpenVPN - TCP:1194 | UDP:110 | SSL:443<br>
• Hysteria 2 - UDP:36712<br>
• TUIC - UDP:36713<br>
• Xray REALITY - TLS:443 | NTLS:80<br>
• NaiveProxy - HTTPS:443<br>
• Brook - TCP/UDP:9999<br>
• SlowDNS - DNS:53 | NS:5300<br>
• Squid Proxy - HTTP:8080 | SOCKS:3128<br>
• Stunnel - SSL:444,777<br>
• SSH Tunnel - SSH:22 | Dropbear:109,143<br>
<br>
<strong>Optimizations:</strong><br>
✅ BBR TCP Congestion Control<br>
✅ High-Speed Network Tuning<br>
✅ Fast Authentication Sync<br>
✅ Automatic Service Monitoring
</div>
</div>
</div>

<form action="" class="add-server d-none" autocomplete="off">
<input type="hidden" name="submitted" name="submitted" value="add_server">
<input type="hidden" name="_key" id="_key" value="{$firenet_encrypt}">

<!-- Add Server Header with Purple Accent -->
<div style="margin-bottom: 12px;">
<span style="display: block; width: 35px; height: 3px; background: linear-gradient(135deg, #6777ef 0%, #764ba2 100%); border-radius: 2px; margin-bottom: 6px;"></span>
<h6 style="margin: 0; font-weight: 600; font-size: 14px; color: #34395e;">Add Server</h6>
</div>

<!-- Hidden fields with default values -->
<input id="serveruser" type="hidden" name="serveruser" value="root">
<input id="servertcp" type="hidden" name="servercustomtcp" value="1194">
<input id="serverudp" type="hidden" name="servercustomudp" value="110">
<input id="serverssl" type="hidden" name="servercustomssl" value="443">
<input id="serverport" type="hidden" name="serverport" value="22">
<input id="serverauthstr" type="hidden" name="serverauthstr" value="vollam">
<input id="serverobfs" type="hidden" name="serverobfs" value="vollam">

<!-- Visible fields only -->
<div class="form-group">
<label for="servername">Server Name</label>
<input id="servername" type="text" class="form-control servername" name="servername" tabindex="1" required="">
</div>

<div class="form-group">
<label for="serverip">Server Host/Ip</label>
<input id="serverip" type="text" class="form-control serverip" name="serverip" tabindex="1" required="">
</div>

<div class="form-group">
<label for="serverpass">Server Password</label>
<input id="serverpass" type="text" class="form-control serverpass" name="serverpass" tabindex="1" required="">
</div>

<div class="form-group">
<label for="hysteriatype">Hysteria Type</label>
<select class="form-control" id="hysteriatype" name="hysteriatype">
<option value="1" class="text-primary" selected>DEFAULT V1</option>
<option value="2" class="text-primary">ZIVPN V1</option>
</select>
</div>

<div class="form-group">
  <label for="servertype">Server Type</label>
  <select class="form-control select2-server-type" id="servertype" name="servertype">
    <option value="8" data-os="debian">OpenVPN HTTP</option>
    <option value="11" selected data-os="debian">OpenVPN WS</option>
    <option value="13" data-os="debian">AIO WS</option>
    <option value="42" data-os="debian">Hysteria UDP</option>
    <option value="62" data-os="debian">Hysteria Free</option>
    <option value="31" data-os="debian">XRAY</option>
    <option value="81" data-os="debian">SSH WS</option>
    <option value="99" data-os="ubuntu">Ultimate All</option>
    <option value="1" data-os="ubuntu">OpenVPN HTTP</option>
    <option value="4" data-os="ubuntu">OpenVPN WS</option>
    <option value="5" data-os="ubuntu">AIO WS</option>
    <option value="7" data-os="ubuntu">XRAY</option>
    <option value="91" data-os="ubuntu">SSH WS</option>
    <option value="41" data-os="ubuntu">Hysteria UDP</option>
    <option value="51" data-os="ubuntu">SocksIP UDP</option>
  </select>
</div>

<div class="form-group">
<button type="submit" class="btn btn-primary btn-block btn-add-server" tabindex="4">Install</button>
</div>
</form>
</div>
</div>
<div class="card">
<div class="card-body">
<a href="https://dexter-repo.online/confi_cert.zip" target="_blank" class="btn btn-primary btn-block">OVPN Config</a>
<!--a href="https://drive.google.com/uc?export=download&id=1CQY_uuH9lTLNCEhVVnSjZdkMfD_ne8Gh" target="_blank" class="btn btn-primary btn-block">OVPN Config (Debian)</a-->
</div>
</div>
</div>
<div class="col-md-9">
<div class="card">
<div class="card-body">
<!-- Server List Header with Purple Accent -->
<div style="margin-bottom: 15px;">
<span style="display: block; width: 40px; height: 4px; background: linear-gradient(135deg, #6777ef 0%, #764ba2 100%); border-radius: 2px; margin-bottom: 8px;"></span>
<h6 style="margin: 0; font-weight: 600; font-size: 15px; color: #34395e;">Server List</h6>
</div>
<div class="alert alert-danger" role="alert">
<strong>SERVER STATUS INDICATOR</strong>
<ul>
<li><code>ACTIVE</code> - <small>ALL SERVICE GOOD, TOTAL USER WILL SHOW SOMETIME LET THE SERVER DO HIS WORK AND WAIT.</small></li>
<li><code>INACTIVE</code> - <small>SOME SERVICE IS NOT GOOD, RESTART THE SERVER.</small></li>
<li><code>OFFLINE</code> - <small>VPS PROVIDER SHUTDOWN THE SERVER OR DELETED OR DISABLED IT, GET A NEW SERVER.</small></li>
</ul> 
</div>
<div class="table-responsive">
<table class="table table-listserver" style="width: 100%">
<thead>
<tr>
<th>    
<div class="custom-checkbox custom-control">
<input type="checkbox" class="custom-control-input checkbox-parent" id="checkbox-all">
<label for="checkbox-all" class="custom-control-label">&nbsp;</label>
</div>
</th>
<th>Name</th>
<th>Service</th>
<th>Status</th>
<th>Location</th>
<th>Action</th>
</tr>
</thead>
</table>
</div>
</div>
</div>
</div>
</div>
<button class="btn btn-primary btn-circle btn-sm float-right btn-multi-delete d-none"><i class="fa fa-trash" aria-hidden="true" style="font-size: 20px; padding-top: 5px"></i></button>
</div>
</section>
</div>

<div class="modal fade modalize" role="dialog" aria-labelledby="smallmodal">
<div class="modal-dialog modal-sm" role="document">
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
<script src="/dist/modules/datatables/datatables.min.js"></script>
<script src="/dist/modules/datatables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script src="/dist/modules/datatables/Select-1.2.4/js/dataTables.select.min.js"></script>
<script src="/dist/modules/select2.full.min.js"></script>
<script src="/dist/modules/jquery-ui/jquery-ui.min.js"></script>

<script src="/dist/bootstrap/assets/jqueryform/jquery.form.js"></script>
<script src="/dist/modules/summernote/summernote-bs4.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/notification_js.tpl'}
{include file='js/page/server_js.tpl'}
{include file='js/page/search_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>

<script>
// Force clear cache and reload Select2
$(document).ready(function() {
    setTimeout(function() {
        $('#servertype').select2('destroy');
        $('#servertype').select2({
            templateResult: formatServerType,
            templateSelection: formatServerType,
            escapeMarkup: function(m) { return m; }
        });
    }, 500);
});
</script>
</body>
</html>