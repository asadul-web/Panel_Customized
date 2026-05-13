<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>Reseller Settings - {$site_name}</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Hind+Siliguri:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="/dist/modules/bootstrap-social/bootstrap-social.css">
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}

<style>
/* Bangla Font Support */
.bangla-text, .hind-siliguri {
    font-family: 'Hind Siliguri', Arial, sans-serif !important;
    font-feature-settings: "liga" 1, "kern" 1;
    text-rendering: optimizeLegibility;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

/* Summernote editor content area Bangla support */
.note-editable {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.6;
    font-size: 14px;
}

/* Bangla text in email templates */
.note-editable p, .note-editable div, .note-editable span {
    font-family: 'Hind Siliguri', Arial, sans-serif;
}

/* Fix Summernote toolbar icons */
.note-editor .note-toolbar .note-btn i {
    font-family: "Font Awesome 5 Free", "Font Awesome 5 Pro", FontAwesome !important;
    font-weight: 900 !important;
    font-style: normal !important;
}

/* Ensure FontAwesome icons display properly */
.fas, .far, .fab, .fa {
    font-family: "Font Awesome 5 Free", "Font Awesome 5 Pro", FontAwesome !important;
    font-weight: 900 !important;
    font-style: normal !important;
    display: inline-block !important;
}

/* Fix Summernote specific icons */
.note-btn .fa-bold:before { content: "\f032"; }
.note-btn .fa-italic:before { content: "\f033"; }
.note-btn .fa-underline:before { content: "\f0cd"; }
.note-btn .fa-strikethrough:before { content: "\f0cc"; }
.note-btn .fa-list-ul:before { content: "\f0ca"; }
.note-btn .fa-list-ol:before { content: "\f0cb"; }
.note-btn .fa-align-left:before { content: "\f036"; }
.note-btn .fa-align-center:before { content: "\f037"; }
.note-btn .fa-align-right:before { content: "\f038"; }
.note-btn .fa-align-justify:before { content: "\f039"; }
.note-btn .fa-link:before { content: "\f0c1"; }
.note-btn .fa-picture-o:before { content: "\f03e"; }
.note-btn .fa-table:before { content: "\f0ce"; }
.note-btn .fa-code:before { content: "\f121"; }
.note-btn .fa-expand:before { content: "\f065"; }
.note-btn .fa-question:before { content: "\f128"; }

/* Custom placeholder button styling */
.note-btn-group .dropdown-toggle {
    background: #f8f9fa;
    border: 1px solid #dee2e6;
    color: #495057;
}

.note-btn-group .dropdown-toggle:hover {
    background: #e9ecef;
    border-color: #adb5bd;
}

.note-btn-group .fa-tags:before {
    content: "\f02c";
}

/* Bangla font button styling */
.bangla-font-btn {
    background: #28a745;
    color: white;
    border: 1px solid #28a745;
    font-family: 'Hind Siliguri', Arial, sans-serif;
    font-weight: 500;
}

.bangla-font-btn:hover {
    background: #218838;
    border-color: #1e7e34;
    color: white;
}

/* Ensure proper Bangla text display in all contexts */
.bangla-content {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    direction: ltr;
    unicode-bidi: embed;
    font-variant-ligatures: normal;
    font-feature-settings: "liga" 1, "kern" 1, "calt" 1;
}

/* Better line height for Bangla text */
.note-editable.bangla-mode {
    line-height: 1.8;
    font-size: 16px;
}

/* Form labels with Bangla support */
.form-control.bangla-input {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    font-size: 14px;
    line-height: 1.6;
}
</style>
</head>
<body>

<div class="main-wrapper">

{include file='apps/topnav.tpl'}
{include file='apps/sidenav.tpl'}

<div class="main-content">
    <section class="section">
        <div class="section-header">
            <h1>Reseller Settings</h1>
            <div class="section-header-breadcrumb">
                <div class="breadcrumb-item active"><a href="/dashboard">Dashboard</a></div>
                <div class="breadcrumb-item">Reseller Settings</div>
            </div>
        </div>

        <div class="section-body">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h4>Email Configuration</h4>
                        </div>
                        <div class="card-body">
                            <form class="reseller-settings-form">
                                <input type="hidden" name="submitted" value="reseller_settings">
                                <input type="hidden" name="_key" value="{$firenet_encrypt}">
                                
                                <div class="form-group row">
                                    <label class="col-sm-3 col-form-label">Email Notifications</label>
                                    <div class="col-sm-9">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="email_notifications" name="email_notifications" value="1" {if $settings.email_notifications == '1'}checked{/if}>
                                            <label class="custom-control-label" for="email_notifications">Enable email notifications for new applications</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label class="col-sm-3 col-form-label">Auto Approval</label>
                                    <div class="col-sm-9">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="auto_approval" name="auto_approval" value="1" {if $settings.auto_approval == '1'}checked{/if}>
                                            <label class="custom-control-label" for="auto_approval">Automatically approve reseller applications</label>
                                        </div>
                                        <small class="form-text text-muted">When enabled, new applications will be automatically approved and reseller accounts created.</small>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="admin_email" class="col-sm-3 col-form-label">Admin Email</label>
                                    <div class="col-sm-9">
                                        <input type="email" class="form-control" id="admin_email" name="admin_email" value="{$settings.admin_email|escape}" placeholder="admin@example.com">
                                        <small class="form-text text-muted">Email address to receive notifications about new applications</small>
                                    </div>
                                </div>

                                <hr>

                                <h5>SMTP Configuration</h5>
                                <p class="text-muted">Configure SMTP settings for sending emails. Leave disabled to use PHP's default mail() function.</p>

                                <div class="form-group row">
                                    <label class="col-sm-3 col-form-label">Enable SMTP</label>
                                    <div class="col-sm-9">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="smtp_enabled" name="smtp_enabled" value="1" {if $settings.smtp_enabled == '1'}checked{/if}>
                                            <label class="custom-control-label" for="smtp_enabled">Use SMTP for sending emails</label>
                                        </div>
                                    </div>
                                </div>

                                <div id="smtp-settings" style="{if $settings.smtp_enabled != '1'}display: none;{/if}">
                                    <div class="form-group row">
                                        <label for="smtp_host" class="col-sm-3 col-form-label">SMTP Host</label>
                                        <div class="col-sm-9">
                                            <input type="text" class="form-control" id="smtp_host" name="smtp_host" value="{$settings.smtp_host|escape}" placeholder="smtp.gmail.com">
                                            <small class="form-text text-muted">SMTP server hostname</small>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="smtp_port" class="col-sm-3 col-form-label">SMTP Port</label>
                                        <div class="col-sm-9">
                                            <input type="number" class="form-control" id="smtp_port" name="smtp_port" value="{$settings.smtp_port|escape}" placeholder="587">
                                            <small class="form-text text-muted">Common ports: 587 (TLS), 465 (SSL), 25 (unsecured)</small>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="smtp_security" class="col-sm-3 col-form-label">Security</label>
                                        <div class="col-sm-9">
                                            <select class="form-control" id="smtp_security" name="smtp_security">
                                                <option value="none" {if $settings.smtp_security == 'none'}selected{/if}>None</option>
                                                <option value="tls" {if $settings.smtp_security == 'tls'}selected{/if}>TLS</option>
                                                <option value="ssl" {if $settings.smtp_security == 'ssl'}selected{/if}>SSL</option>
                                            </select>
                                            <small class="form-text text-muted">Encryption method for SMTP connection</small>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="smtp_username" class="col-sm-3 col-form-label">SMTP Username</label>
                                        <div class="col-sm-9">
                                            <input type="text" class="form-control" id="smtp_username" name="smtp_username" value="{$settings.smtp_username|escape}" placeholder="your-email@gmail.com">
                                            <small class="form-text text-muted">SMTP authentication username</small>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="smtp_password" class="col-sm-3 col-form-label">SMTP Password</label>
                                        <div class="col-sm-9">
                                            <div class="input-group">
                                                <input type="password" class="form-control" id="smtp_password" name="smtp_password" value="{$settings.smtp_password|escape}" placeholder="Enter SMTP password">
                                                <div class="input-group-append">
                                                    <div class="input-group-text" style="cursor: pointer;" onclick="toggleSmtpPassword()">
                                                        <span id="smtp-password-toggle-icon"><i class="fas fa-eye"></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <small class="form-text text-muted">SMTP authentication password or app password</small>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="smtp_from_email" class="col-sm-3 col-form-label">From Email</label>
                                        <div class="col-sm-9">
                                            <input type="email" class="form-control" id="smtp_from_email" name="smtp_from_email" value="{$settings.smtp_from_email|escape}" placeholder="noreply@yourdomain.com">
                                            <small class="form-text text-muted">Email address to send emails from</small>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label for="smtp_from_name" class="col-sm-3 col-form-label">From Name</label>
                                        <div class="col-sm-9">
                                            <input type="text" class="form-control" id="smtp_from_name" name="smtp_from_name" value="{$settings.smtp_from_name|escape}" placeholder="VPN Panel">
                                            <small class="form-text text-muted">Display name for outgoing emails</small>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <div class="col-sm-9 offset-sm-3">
                                            <button type="button" class="btn btn-info" id="testSmtp">
                                                <i class="fas fa-paper-plane"></i> Test SMTP Connection
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <hr>

                                <h5>Email Templates</h5>

                                <div class="form-group row">
                                    <label for="welcome_email_subject" class="col-sm-3 col-form-label">Welcome Email Subject</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="welcome_email_subject" name="welcome_email_subject" value="{$settings.welcome_email_subject|escape}" placeholder="Welcome to Our Reseller Program">
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="welcome_email_body" class="col-sm-3 col-form-label">Welcome Email Body</label>
                                    <div class="col-sm-9">
                                        <textarea class="form-control summernote-editor" id="welcome_email_body" name="welcome_email_body" rows="8" placeholder="Dear {literal}{name}{/literal}...">{$settings.welcome_email_body}</textarea>
                                        <small class="form-text text-muted">
                                            Available placeholders: {literal}{name}, {username}, {password}, {reseller_url}{/literal}
                                        </small>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="approval_email_subject" class="col-sm-3 col-form-label">Approval Email Subject</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="approval_email_subject" name="approval_email_subject" value="{$settings.approval_email_subject|escape}" placeholder="Reseller Application Approved">
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="approval_email_body" class="col-sm-3 col-form-label">Approval Email Body</label>
                                    <div class="col-sm-9">
                                        <textarea class="form-control summernote-editor" id="approval_email_body" name="approval_email_body" rows="6" placeholder="Dear {literal}{name}{/literal}...">{$settings.approval_email_body}</textarea>
                                        <small class="form-text text-muted">
                                            Available placeholders: {literal}{name}, {business_name}{/literal}
                                        </small>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="rejection_email_subject" class="col-sm-3 col-form-label">Rejection Email Subject</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="rejection_email_subject" name="rejection_email_subject" value="{$settings.rejection_email_subject|escape}" placeholder="Reseller Application Update">
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="rejection_email_body" class="col-sm-3 col-form-label">Rejection Email Body</label>
                                    <div class="col-sm-9">
                                        <textarea class="form-control summernote-editor" id="rejection_email_body" name="rejection_email_body" rows="6" placeholder="Dear {literal}{name}{/literal}...">{$settings.rejection_email_body}</textarea>
                                        <small class="form-text text-muted">
                                            Available placeholders: {literal}{name}, {business_name}, {reason}{/literal}
                                        </small>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <div class="col-sm-9 offset-sm-3">
                                        <button type="submit" class="btn btn-primary">Save Settings</button>
                                        <button type="button" class="btn btn-secondary" id="resetDefaults">Reset to Defaults</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
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

<script src="/dist/modules/summernote/summernote-bs4.min.js"></script>
<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/reseller_settings_js.tpl'}


<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
