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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote-bs4.css">
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
            <h1>Developer Settings</h1>
            <div class="section-header-breadcrumb">
<div class="breadcrumb-item">Developer</div>
<div class="breadcrumb-item active">Settings</div>
</div>
        </div>
        <div class="section-error">
            <div class="errors"></div>
        </div>
        <div class="section-body">
            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h2 class="section-title">General</h2>
                        </div>
                        <div class="card-body">
                            <form class="gensettings" accept-charset="UTF-8" autocomplete="off">
                                <input type="hidden" name="_key" id="_key_git" value="{$firenet_encrypt}">
                                <input type="hidden" name="submitted" id="submitted" value="git_settings">
                                <div class="form-group">
                                    <label for="github_username">Github Username</label>
                                    <input id="github_username" type="text" value="" class="form-control github_username" name="github_username" tabindex="1">
                                </div>
                                <div class="form-group">
                                    <label for="github_token">Github Token</label>
                                    <input id="github_token" type="text" value="" class="form-control github_token" name="github_token" tabindex="1">
                                </div>
                                <div class="form-group">
                                    <label for="github_repo">Github Repository Domain</label>
                                    <input id="github_repo" type="text" value="" class="form-control github_repo" name="github_repo" tabindex="1" placeholder="e.g., ruzain.com">
                                    <small class="form-text text-muted">Enter your domain name for GitHub logs (e.g., ruzain.com). Leave empty for auto-detection.</small>
                                </div>
                                <div class="form-group">
                                    <label for="base_api_url">Base API URL</label>
                                    <input id="base_api_url" type="text" value="{$base_url_full}" class="form-control base-api-url" name="base_api_url" tabindex="1" placeholder="http://localhost">
                                    <small class="form-text text-muted">Change this to update all API endpoints below</small>
                                </div>
                                <div class="card card-info">
                                    <div class="card-header">
                                        <h4><i class="fas fa-link"></i> API Endpoints (Auto-Updated)</h4>
                                    </div>
                                    <div class="card-body">
                                        <div class="form-group">
                                            <label>Notice API</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control api-endpoint" id="notice-api" value="{$api_endpoints.notice_link}" readonly>
                                                <div class="input-group-append">
                                                    <button class="btn btn-primary copy-btn" type="button" data-target="notice-api"><i class="fas fa-copy"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>Popup Notice API</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control api-endpoint" id="popup-api" value="{$api_endpoints.popup_notice}" readonly>
                                                <div class="input-group-append">
                                                    <button class="btn btn-primary copy-btn" type="button" data-target="popup-api"><i class="fas fa-copy"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>License API</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control api-endpoint" id="license-api" value="{$api_endpoints.license_api}" readonly>
                                                <div class="input-group-append">
                                                    <button class="btn btn-primary copy-btn" type="button" data-target="license-api"><i class="fas fa-copy"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>License Validation API</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control api-endpoint" id="validate-api" value="{$api_endpoints.validate_license}" readonly>
                                                <div class="input-group-append">
                                                    <button class="btn btn-primary copy-btn" type="button" data-target="validate-api"><i class="fas fa-copy"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>License Proxy API</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control api-endpoint" id="proxy-api" value="{$api_endpoints.licenses_proxy}" readonly>
                                                <div class="input-group-append">
                                                    <button class="btn btn-primary copy-btn" type="button" data-target="proxy-api"><i class="fas fa-copy"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="alert alert-success mt-3">
                                            <i class="fas fa-lock"></i> <strong>API URLs are Encrypted!</strong><br>
                                            <small>Remote API URLs are now encrypted and hidden. Only proxy URLs are shown here. 
                                            <a href="/api-settings" class="alert-link">Manage encrypted URLs →</a></small>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="license">License Key</label>
                                    <input id="license" type="text" value="" class="form-control license" name="license" tabindex="1" placeholder="Enter license key">
                                    <small class="form-text text-muted">Enter your panel license key to activate</small>
                                </div>
                                <div class="form-group">
                                    <button type="button" class="btn btn-success btn-activate-license"><i class="fas fa-check"></i> Activate License</button>
                                    <button type="button" class="btn btn-info btn-check-license"><i class="fas fa-sync"></i> Check Status</button>
                                </div>
                                <div id="licenseStatus" class="alert d-none"></div>
                                <div class="form-group">
                                    <label for="turnstile">Turnstile Key (Cloudflare)</label>
                                    <input id="turnstile" type="text" value="" class="form-control turnstile" name="turnstile" tabindex="1">
                                </div>
                                <div class="form-group">
                                    <label for="turnstilesecret">Turnstile Secret (Cloudflare)</label>
                                    <input id="turnstilesecret" type="text" value="" class="form-control turnstilesecret" name="turnstilesecret" tabindex="1">
                                </div>
                                <div class="form-group">
                                    <label for="whois">API Layer Key (Whois)</label>
                                    <input id="whois" type="text" value="" class="form-control whois" name="whois" tabindex="1">
                                    <small>Generate API key <a href="https://apilayer.com/marketplace/whois-api" target="_blank">HERE</a></small>
                                </div>
                                <div class="form-group" id="generalsettings">
                                    <button type="button" class="btn btn-primary btn-confirm-web" tabindex="4"> Confirm</button>
                                    <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                                    <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                <div class="card">
                    <div class="card-header">
                        <h2 class="section-title">Cloudflare Dns</h2>
                    </div>
                    <div class="card-body">
                        <form action="" class="dnsupdate" autocomplete="off">
                            <input type="hidden" name="_key" id="_key_dns" value="{$firenet_encrypt}">
                            <input type="hidden" name="submitted" id="submitted" value="dns_update">
                            <div class="form-group">
                                <label>Domain</label>
                                <input type="text" placeholder="Enter domain" value="" class="form-control dns_domain" name="dns_domain" tabindex="1">
                            </div>
                            <div class="form-group">
                                <label>Zone ID</label>
                                <input type="text" placeholder="Enter zone id" value="" class="form-control dns_zone" name="dns_zone" tabindex="1">
                            </div>
                            <div class="form-group">
                                <label>Global API</label>
                                <input type="text" placeholder="Enter global api" value="" class="form-control dns_global" name="dns_global" tabindex="1">
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="text" placeholder="Enter email address" value="" class="form-control dns_email" name="dns_email" tabindex="1">
                            </div>
                            <div class="form-group" id="dnssettings">
                                <button type="button" class="btn btn-primary btn-confirm-dns" tabindex="4"> Confirm</button>
                                <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                                <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h2 class="section-title">Database Backup</h2>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-primary" role="alert">
                            <h6 class="alert-heading"><i class="fas fa-book"></i> Note </h6>
                            <code>Backup Database</code> : Can backup full panel database manually or automatically.<br>
                            <code>Manual Backup</code> : Just click the Backup button.<br>
                            <code>Automatic Backup</code> : You need to add <span class="text-secondary"><u>/includes/cronjob/cronjob_backup.php</u></span> in hosting cronjobs.
                        </div>
                        <form action="" class="dbbak" autocomplete="off">
                            <input type="hidden" name="_key" id="_key_backup" value="{$firenet_encrypt}">
                            <input type="hidden" name="submitted" id="submitted" value="database_backup">
                            <div class="form-group">
                                <label>Recipient Email</label>
                                <input type="email" placeholder="Enter recipient email" value="" class="form-control recipient_email" name="recipient_email" tabindex="1">
                            </div>
                            <div class="form-group">
                                <label>CC Email (Optional)</label>
                                <input type="email" placeholder="Enter cc email" value="" class="form-control cc_email" name="cc_email" tabindex="1">
                            </div>
                            <div class="form-group" id="dbbakup">
                                <button type="button" class="btn btn-primary btn-confirm-db" tabindex="4"> Confirm</button>
                                <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                                <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                                <button type="button" class="btn btn-warning btn-confirm-manbak" onclick="manual_bak()" tabindex="4"> Backup</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                        <h2 class="section-title">Administrator</h2>
                    </div>
                <div class="card-body">
                    <form class="adminsettings" accept-charset="UTF-8" autocomplete="off">
                        <input type="hidden" name="_key" id="_key_admin" value="{$firenet_encrypt}">
                        <input type="hidden" name="submitted" id="submitted" value="edit_admin">
                        <div class="form-group">
                            <label for="admusername">Username</label>
                            <input id="admusername" type="text" value="" class="form-control admusername" name="admusername" tabindex="1">
                        </div>
                        <div class="form-group">
                            <label for="admpassword">Password</label>
                            <input id="admpassword" type="text" value="" class="form-control admpassword" name="admpassword" tabindex="1" placeholder="Enter new password to update">
                            <small class="form-text text-muted">If password field is empty, set a new password here</small>
                        </div>
                        <div class="form-group" id="admsettings">
                            <button type="button" class="btn btn-primary btn-confirm-adm" tabindex="4"> Confirm</button>
                            <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                            <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <h2 class="section-title">Clear Data</h2>
                </div>
                <div class="card-body">
                    <div class="alert alert-primary" role="alert">
                        <h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Warning </h6>
                        <p>This will <code>delete</code> all the database records.</p>
                    </div>
                    <form class="clrsettings" accept-charset="UTF-8" autocomplete="off">
                        <input type="hidden" name="_key" id="_key_clear" value="{$firenet_encrypt}">
                        <input type="hidden" name="submitted" id="submitted" value="reset_panel">
                        <div class="form-group">
                            <label for="usercounter">Users</label>
                            <input type="text" class="form-control usercounter" readonly="">
                        </div>
                        <div class="form-group">
                            <label for="resellercounter">Resellers</label>
                            <input type="text" class="form-control resellercounter" readonly="">
                        </div>
                        <div class="form-group" id="deletedata">
                            <button type="button" class="btn btn-primary btn-confirm-clr" tabindex="4"> Confirm</button>
                            <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                            <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <h2 class="section-title">Device Reset</h2>
                </div>
                <div class="card-body">
                    <div class="alert alert-primary" role="alert">
                        <h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Warning </h6>
                        <p>This will <code>clear</code> all user's device information.</p>
                    </div>
                    <form class="clrdevice" accept-charset="UTF-8" autocomplete="off">
                        <input type="hidden" name="_key" id="_key_devres" value="{$firenet_encrypt}">
                        <input type="hidden" name="submitted" id="submitted" value="reset_device">
                        <div class="form-group">
                            <label for="useractive">Active Users</label>
                            <input type="text" class="form-control useractive" readonly="">
                        </div>
                        <div class="form-group" id="deletedevice">
                            <button type="button" class="btn btn-primary btn-confirm-clrdevice" tabindex="4"> Confirm</button>
                            <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                            <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote-bs4.js"></script>
<script src="/dist/modules/select2.full.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/notification_js.tpl'}
{include file='js/page/search_js.tpl'}
{include file='js/page/developer_js.tpl'}

<script>
$(document).ready(function() {
    // Auto-update API endpoints when base URL changes
    $('.base-api-url').on('input', function() {
        var baseUrl = $(this).val().trim();
        if (baseUrl) {
            // Remove trailing slash
            baseUrl = baseUrl.replace(/\/$/, '');
            
            // Update all API endpoints
            $('#notice-api').val(baseUrl + '/serverside/data/notice_api.php');
            $('#popup-api').val(baseUrl + '/serverside/data/popup_notice_api.php');
            $('#license-api').val(baseUrl + '/serverside/data/licenses_api.php');
            $('#validate-api').val(baseUrl + '/serverside/data/validate_license.php');
            $('#proxy-api').val(baseUrl + '/serverside/data/licenses_proxy.php');
        }
    });
    
    // Copy button functionality
    $('.copy-btn').on('click', function() {
        var targetId = $(this).data('target');
        var input = $('#' + targetId);
        
        // Select and copy
        input.select();
        document.execCommand('copy');
        
        // Show feedback
        var btn = $(this);
        var originalHtml = btn.html();
        btn.html('<i class="fas fa-check"></i>');
        btn.removeClass('btn-primary').addClass('btn-success');
        
        setTimeout(function() {
            btn.html(originalHtml);
            btn.removeClass('btn-success').addClass('btn-primary');
        }, 1500);
    });
    
    // Check license status on page load
    checkLicenseStatus();
    
    // Auto-refresh license status every 60 seconds to show updates
    setInterval(function() {
        checkLicenseStatus();
    }, 60000); // 60 seconds
    
    // Activate license button
    $('.btn-activate-license').on('click', function() {
        var licenseKey = $('#license').val().trim();
        if (!licenseKey) {
            Swal.fire('Error', 'Please enter a license key', 'error');
            return;
        }
        
        Swal.fire({
            title: 'Activate License?',
            text: 'License Key: ' + licenseKey,
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Yes, activate it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '/serverside/data/validate_license.php',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ license_key: licenseKey }),
                    success: function(response) {
                        if (response.response == 1) {
                            Swal.fire('Success!', response.msg, 'success').then(() => {
                                checkLicenseStatus();
                            });
                        } else {
                            Swal.fire('Error', response.msg || 'Failed to activate license', 'error');
                        }
                    },
                    error: function(xhr) {
                        var msg = 'Failed to connect to API';
                        try {
                            var response = JSON.parse(xhr.responseText);
                            msg = response.msg || msg;
                        } catch(e) {}
                        Swal.fire('Error', msg, 'error');
                    }
                });
            }
        });
    });
    
    // Check license status button
    $('.btn-check-license').on('click', function() {
        checkLicenseStatus();
    });
});

function checkLicenseStatus() {
    $.ajax({
        url: '/serverside/data/validate_license.php',
        type: 'GET',
        success: function(response) {
            var $status = $('#licenseStatus');
            $status.removeClass('d-none alert-success alert-warning alert-danger alert-info');
            
            if (response.status === 'no_license') {
                $status.addClass('alert-warning').html('<strong><i class="fas fa-exclamation-triangle"></i> No License:</strong> No license key activated. Please activate a license to use the panel.');
            } else if (response.status === 'valid') {
                var data = response.data;
                $status.addClass('alert-success').html(
                    '<strong><i class="fas fa-check-circle"></i> License Active</strong><br>' +
                    '<strong>Key:</strong> <code>' + data.key + '</code><br>' +
                    '<strong>Domain:</strong> ' + (data.domain || 'Not assigned') + '<br>' +
                    '<strong>Expires:</strong> ' + data.expiry_date + '<br>' +
                    '<strong>Days Remaining:</strong> <span class="badge badge-success">' + data.days_remaining + ' days</span>'
                );
                $('#license').val(data.key);
            } else if (response.status === 'expired') {
                var data = response.data;
                $status.addClass('alert-danger').html(
                    '<strong><i class="fas fa-times-circle"></i> License Expired</strong><br>' +
                    '<strong>Key:</strong> <code>' + data.key + '</code><br>' +
                    '<strong>Expired On:</strong> ' + data.expiry_date + '<br>' +
                    '<strong>Status:</strong> <span class="badge badge-danger">Expired</span><br>' +
                    'Please renew your license to continue using the panel.'
                );
                $('#license').val(data.key);
            } else if (response.status === 'blocked' || response.status === 'invalid') {
                var data = response.data;
                var html = '<strong><i class="fas fa-ban"></i> License Blocked</strong><br>' + response.message;
                
                // Show license details even if blocked
                if (data && data.key) {
                    html += '<br><br><strong>Key:</strong> <code>' + data.key + '</code>';
                    if (data.domain) {
                        html += '<br><strong>Domain:</strong> ' + data.domain;
                    }
                    if (data.expiry_date) {
                        html += '<br><strong>Expires:</strong> ' + data.expiry_date;
                    }
                    if (data.status) {
                        html += '<br><strong>Status:</strong> <span class="badge badge-danger">' + data.status + '</span>';
                    }
                }
                
                $status.addClass('alert-danger').html(html);
                if (data && data.key) {
                    $('#license').val(data.key);
                }
            }
        },
        error: function() {
            $('#licenseStatus').removeClass('d-none').addClass('alert-danger').html('<strong>Error:</strong> Failed to check license status');
        }
    });
}
</script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
