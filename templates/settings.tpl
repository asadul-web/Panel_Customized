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
<style>
/* Theme dropdown with color circles */
#theme option {
    padding-left: 25px;
    background-repeat: no-repeat;
    background-position: 8px center;
    background-size: 12px 12px;
    line-height: 1.5;
}

#theme option[value="default"] {
    background-image: radial-gradient(circle, #6777ef 6px, transparent 6px);
}

#theme option[value="light"] {
    background-image: radial-gradient(circle, #f8f9fa 5px, #ccc 5px, #ccc 6px, transparent 6px);
}

#theme option[value="dark"] {
    background-image: radial-gradient(circle, #191d21 6px, transparent 6px);
}

#theme option[value="red"] {
    background-image: radial-gradient(circle, #e53935 6px, transparent 6px);
}

#theme option[value="pink"] {
    background-image: radial-gradient(circle, #e83e8c 6px, transparent 6px);
}

#theme option[value="purple"] {
    background-image: radial-gradient(circle, #8360c3 6px, transparent 6px);
}

#theme option[value="blue"] {
    background-image: radial-gradient(circle, #039be5 6px, transparent 6px);
}

#theme option[value="cyan"] {
    background-image: radial-gradient(circle, #17a2b8 6px, transparent 6px);
}

#theme option[value="green"] {
    background-image: radial-gradient(circle, #47c363 6px, transparent 6px);
}

#theme option[value="yellow"] {
    background-image: radial-gradient(circle, #ffc107 6px, transparent 6px);
}

#theme option[value="orange"] {
    background-image: radial-gradient(circle, #fd7e14 6px, transparent 6px);
}

#theme option[value="navy"] {
    background-image: radial-gradient(circle, #001f3f 6px, transparent 6px);
}

#theme option[value="forest"] {
    background-image: radial-gradient(circle, #228B22 6px, transparent 6px);
}

#theme option[value="galaxy"] {
    background-image: radial-gradient(circle, #6f42c1 6px, transparent 6px);
}

#theme option[value="ocean"] {
    background-image: radial-gradient(circle, #006994 6px, transparent 6px);
}

#theme option[value="midnight"] {
    background-image: radial-gradient(circle, #191970 6px, transparent 6px);
}

#theme option[value="sunset"] {
    background-image: radial-gradient(circle, #ff6b35 6px, transparent 6px);
}

/* Make dropdown taller for better visibility */
#theme {
    padding: 8px 12px;
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
            <h1>Settings</h1>
            <div class="section-header-breadcrumb">
<div class="breadcrumb-item">Panel</div>
<div class="breadcrumb-item active">Settings</div>
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
                    <h2 class="section-title">General</h2>
                    </div>
                        <div class="card-body">
                            <form class="websettings" accept-charset="UTF-8" autocomplete="off">
                                <input type="hidden" name="_key" id="_key_web" value="{$firenet_encrypt}">
                                <input type="hidden" name="notetitle" id="notetitle" value="{$site_note}">
                                <input type="hidden" name="submitted" id="submitted" value="web_settings">
                                <div class="form-group">
                                    <label for="title">Title</label>
                                    <input id="title" type="text" value="" class="form-control title" name="title" tabindex="1">
                                </div>
                                <div class="form-group">
                                    <label for="description">Description</label>
                                    <input id="description" type="text" value="" class="form-control description" name="description" tabindex="1">
                                </div>
                                <div class="form-group">
                                    <label for="owner">Owner</label>
                                    <input id="owner" type="text" value="" class="form-control owner" name="owner" tabindex="1">
                                </div>
                                <div class="form-group">
                                    <label for="images">Logo (Allowed Extension: gif, jpeg, jpg, png), 2MB</label>
                                    <input type="file" id="images" name="images[]" class="input-file">
                                    <div class="input-group">
                                        <input type="text" class="form-control" disabled placeholder="Upload Logo" tabindex="1">
                                        <div class="input-group-append">
                                            <button class="btn btn-primary upload-field" type="button"><i class="fa fa-search"></i> Browse</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="logoshow">Logo Show</label>
                                    <select class="form-control" name="logoshow" id="logoshow" data-minimum-results-for-search="-1">
                                        <option class="logoshow" value="" disabled selected></option>
                                        <option value="1">On</option>
                                        <option value="0">Off</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="maintenance">Maintenance</label>
                                    <select class="form-control" name="maintenance" id="maintenance" data-minimum-results-for-search="-1">
                                        <option class="maintenance" value="" disabled selected></option>
                                        <option value="1">On</option>
                                        <option value="0">Off</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="theme">Theme</label>
                                    <select class="form-control select2" name="theme" id="theme" data-minimum-results-for-search="-1">
                                        <option class="theme" value="" disabled selected></option>
                                        <option value="default">Default</option>
                                        <option value="cyan">Cyan</option>
                                        <option value="dark">Dark</option>
                                        <option value="green">Green</option>
                                        <option value="orange">Orange</option>
                                        <option value="pink">Pink</option>
                                        <option value="red">Red</option>
                                        <option value="yellow">Yellow</option>
                                        <option value="blue">Blue</option>
                                        <option value="purple">Purple</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="note">Login Note</label>
                                    <textarea id="note" class="summernote" name="note"></textarea>
                                </div>
                                <div class="form-group" id="websettings">
                                    <button type="button" class="btn btn-primary btn-confirm-web" tabindex="4"> Confirm</button>
                                    <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                                    <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                
                <div class="card card-primary">
                <div class="card-header">
                <h2 class="section-title">User</h2>
                </div>
                    <div class="card-body">
                        <form action="" class="usersettings" autocomplete="off">
                            <input type="hidden" name="_key" id="_key_user" value="{$firenet_encrypt}">
                            <input type="hidden" name="submitted" id="submitted" value="user_settings">
                            <div class="form-group">
                                <label for="prefix">Prefix</label>
                                <select class="form-control select2" name="prefix" id="prefix" data-minimum-results-for-search="-1">
                                    <option class="prefix" value="" disabled selected></option>
                                    <option value="1">On</option>
                                    <option value="0">Off</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="uprefix">Username Prefix</label>
                                <input id="uprefix" type="text" value="" class="form-control uprefix" name="uprefix" tabindex="1">
                            </div>
                            <div class="form-group">
                                <label for="trialdur">Trial Duration</label>
                                <select class="form-control select2" id="trialdur" name="trialdur" data-minimum-results-for-search="-1">
                                    <option class="trialdur" value="" disabled selected></option>
                                    <option value="1">1 Hour</option>
                                    <option value="2">2 Hours</option>
                                    <option value="3">24 Hours</option>
                                    <option value="4">30 Minutes</option>
                                    <option value="5">3 Days</option>
                                    <option value="6">5 Days</option>
                                </select>
                            </div>
                            <div class="form-group" id="usersettings">
                                <button type="button" class="btn btn-primary btn-confirm-user" tabindex="4"> Confirm</button>
                                <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                                <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="card card-primary">
                <div class="card-header">
                <h2 class="section-title">VPN</h2>
                </div>
                    <div class="card-body">
                        <div class="alert alert-primary" role="alert">
                            <h6 class="alert-heading"><i class="fas fa-book"></i> Note </h6>
                            <code>Max Vpn Sessions</code> : Limit max vpn session per account.<br>
                            <code>Reset All Vpn Sessions</code> : Reset all vpn sessions, this won't logout already logged in users.
                            Restart all your vpn servers after doing this. It will reset Online user counter too.<br>
                        </div>
                        <form class="vpnsettings" accept-charset="UTF-8" autocomplete="off">
                            <input type="hidden" name="_key" id="_key_vpn" value="{$firenet_encrypt}">
                            <input type="hidden" name="submitted" id="submitted" value="vpn_session">
                            <div class="form-group">
                                <label for="sessions">Max Vpn Sessions</label>
                                <input id="sessions" type="number" value="" min="2" class="form-control sessions" name="sessions" tabindex="1">
                            </div>
                            <div class="form-group">
                                <label for="resetvpnsessions">Reset Vpn Sessions</label>
                                <select class="form-control select2" name="resetvpnsessions" data-minimum-results-for-search="-1">
                                    <option value="0">No</option>
                                    <option value="1">Yes</option>
                                </select>
                            </div>
                            <div class="form-group" id="vpnsettings">
                                <button type="button" class="btn btn-primary btn-confirm-session" tabindex="4"> Confirm</button>
                                <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                                <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
            <div class="card card-primary">
            <div class="card-header">
            <h2 class="section-title">Bandwidth Limit</h2>
            </div>
                <div class="card-body">
                    <form class="bandwidthsettings" accept-charset="UTF-8" autocomplete="off">
                        <input type="hidden" name="_key" id="_key_bandwidth" value="{$firenet_encrypt}">
                        <input type="hidden" name="submitted" id="submitted" value="bandwidth_limit">
                        
                        <div class="form-group">
                            <label for="xray_limit">Xray Limit</label>
                            <select class="form-control select2" name="xray_limit" id="xray_limit" data-minimum-results-for-search="-1">
                                <option value="" disabled selected></option>
                                <option value="enabled">Enabled</option>
                                <option value="disabled">Disabled</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <div class="alert alert-primary mb-3" style="border: none; border-radius: 8px;">
                                <strong>Result in Bytes: <span id="result-bytes">0</span></strong>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="bandwidth_value">Enter Value:</label>
                                    <input id="bandwidth_value" type="number" value="" min="0" step="0.1" class="form-control bandwidth_value" name="bandwidth_value" tabindex="1" placeholder="e.g. 1.5">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="bandwidth_unit">Select Unit:</label>
                                    <select class="form-control select2" name="bandwidth_unit" id="bandwidth_unit" data-minimum-results-for-search="-1">
                                        <option value="" disabled selected></option>
                                        <option value="bytes">Bytes</option>
                                        <option value="kb">KB</option>
                                        <option value="mb">MB</option>
                                        <option value="gb">GB</option>
                                        <option value="tb">TB</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        
                        <div class="form-group" id="bandwidthsettings">
                            <button type="button" class="btn btn-primary btn-confirm-bandwidth" tabindex="4">Confirm</button>
                            <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4">Authorize</button>
                            <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="card card-primary">
            <div class="card-header">
            <h2 class="section-title">Trial</h2>
            </div>
                <div class="card-body">
                    <div class="alert alert-primary" role="alert">
                        <h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Warning </h6>
                        <p>This will <code>delete</code> all the trial accounts created.</p>
                    </div>
                    <form class="trialsettings" accept-charset="UTF-8" autocomplete="off">
                        <input type="hidden" name="_key" id="_key_trial" value="{$firenet_encrypt}">
                        <input type="hidden" name="submitted" id="submitted" value="trial_reset">
                        <div class="form-group">
                            <input type="text" class="form-control trialcounter" readonly="">
                        </div>
                        <div class="form-group" id="trialsettings">
                            <button type="button" class="btn btn-primary btn-confirm-trial" tabindex="4"> Confirm</button>
                            <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                            <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="card card-primary">
            <div class="card-header">
            <h2 class="section-title">Device Reset</h2>
            </div>
                <div class="card-body">
                    <div class="alert alert-danger" role="alert">
                        <h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Warning </h6>
                        <p>This will <code>RESET</code> all devices in all vpn accounts</p>
                    </div>
                    <form class="clrdevice" accept-charset="UTF-8" autocomplete="off">
                        <input type="hidden" name="_key" id="_key_device" value="{$firenet_encrypt}">
                        <input type="hidden" name="submitted" id="submitted" value="reset_device">
                        <div class="form-group" id="deletedevice">
                            <button type="button" class="btn btn-primary btn-confirm-clrdevice" tabindex="4"> Confirm</button>
                            <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                            <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="card card-primary">
            <div class="card-header">
            <h2 class="section-title">Expired Delete</h2>
            </div>
                <div class="card-body">
                    <div class="alert alert-danger" role="alert">
                        <h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Warning </h6>
                        <p>This will <code>DELETE</code> all expired accounts.</p>
                        <p>This will <code>NOT</code> reflect in deleted logs.</p>
                    </div>
                    <form class="deletexpired" accept-charset="UTF-8" autocomplete="off">
                        <input type="hidden" name="_key" id="_key_expired" value="{$firenet_encrypt}">
                        <input type="hidden" name="submitted" id="submitted" value="delete_expired">
                        <div class="form-group" id="delete_xpired">
                            <button type="button" class="btn btn-primary btn-confirm-delxpired" tabindex="4"> Confirm</button>
                            <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                            <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Panel API Section -->
            <div class="card card-primary">
                <div class="card-header">
                    <h2 class="section-title">Panel API</h2>
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label for="universal_auth_api">Universal Authentication API</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="universal_auth_api" value="http://{$smarty.server.HTTP_HOST}/api/files/auth?username=USERNAME&password=PASSWORD" readonly>
                            <div class="input-group-append">
                                <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#universal_auth_api" >Copy</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="expire_api">Expire API</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="expire_api" value="http://{$smarty.server.HTTP_HOST}/api/files/expire?username=USERNAME" readonly>
                            <div class="input-group-append">
                                <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#expire_api" >Copy</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="device_api">Device API</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="device_api" value="http://{$smarty.server.HTTP_HOST}/api/files/device?username=USERNAMEHERE" readonly>
                            <div class="input-group-append">
                                <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#device_api" >Copy</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="json_get_api">JSON Update API (GET)</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="json_get_api" value="http://{$smarty.server.HTTP_HOST}/api/files/app?json=xxxxxxxxxxxxx" readonly>
                            <div class="input-group-append">
                                <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#json_get_api" >Copy</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="json_post_api">JSON Update API (POST)</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="json_post_api" value="http://{$smarty.server.HTTP_HOST}/api/files/update | FORM: hash=HASHVALUE, json=JSONVALUE" readonly>
                            <div class="input-group-append">
                                <button class="btn btn-primary btn-copy" type="button" data-clipboard-target="#json_post_api" >Copy</button>
                            </div>
                        </div>
                    </div>
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
{include file='js/page/settings_js.tpl'}
{include file='js/page/search_js.tpl'}



<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>