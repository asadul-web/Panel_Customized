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
<h1>Profile Settings</h1>

<div class="section-header-breadcrumb">
    <div class="breadcrumb-item">Main</div>
    <div class="breadcrumb-item active">Profile</div>
</div>

</div>

<div class="section-body">
            <h2 class="section-title">Hi, <span class="profile-name">-</span>!</h2>
            <p>
              Change information about yourself on this page.
            </p>

            <div class="row mt-sm-4">
              <div class="col-12 col-md-12 col-lg-5">
                <div class="card profile-widget">
                  <div class="profile-widget-header">
                    <div class="profilepic profile-widget-picture" id="ppcture">
                      {$avatar3}
                      <div class="profilepic__content" onclick="avatarchange()">
                        <span class="profilepic__icon"><i class="fas fa-camera"></i></span>
                        <span class="profilepic__text">Update Avatar</span>
                      </div>
                    </div>
                    <div class="profile-widget-items">
                      <div class="profile-widget-item">
                        <div class="profile-widget-item-label">Credit</div>
                        <div class="profile-widget-item-value profile-credit">-</div>
                      </div>
                      <div class="profile-widget-item">
                        <div class="profile-widget-item-label">User</div>
                        <div class="profile-widget-item-value profile-user">-</div>
                      </div>
                      <div class="profile-widget-item">
                        <div class="profile-widget-item-label">Reseller</div>
                        <div class="profile-widget-item-value profile-reseller">-</div>
                      </div>
                    </div>
                  </div>
                  <div class="profile-widget-description">
                    <div class="profile-widget-name"><span class="profile-name-2"></span> <div class="text-muted d-inline font-weight-normal"></div></div>
                    <span class="profile-bio-2"></span>
                  </div>
                  <div class="card-footer">
                    <btn type="button" class="btn btn-primary mr-1 mb-2" onclick="changepassword()">
                      <i class="fa fa-edit"></i> Password
                    </btn>
                    <btn type="button" class="btn btn-primary mr-1 mb-2 d-none" onclick="emailchange()">
                      <i class="fa fa-edit"></i> Email
                    </btn>
                  </div>
                </div>
              </div>
              <div class="col-12 col-md-12 col-lg-7">
                <div class="card">
                  <form class="profileupdate" accept-charset="UTF-8" autocomplete="off">
                    <div class="card-header">
                      <h4>Edit Profile</h4>
                    </div>
                    <div class="card-body">
                        <div class="section-error">
                            <div class="errors"></div>
                        </div>
                        <input type="hidden" name="_key" id="_key" value="{$firenet_encrypt}">
                        <input type="hidden" name="submitted" id="submitted" value="updateprofile">
                        <div class="row">
                          <div class="form-group col-md-6 col-12">
                            <label>First Name</label>
                            <input type="text" class="form-control data-firstname" name="firstname">
                          </div>
                          <div class="form-group col-md-6 col-12">
                            <label>Last Name</label>
                            <input type="text" class="form-control data-lastname" name="lastname">
                          </div>
                        </div>
                        <div class="row">
                          <div class="form-group col-md-6 col-12">
                            <label>Email</label>
                            <div class="input-group">
                                <input type="email" class="form-control data-email" name="email">
                                <div class="input-group-append">
                                  <div class="input-group-text verified-img">
                                    <i class="iyot"></i>
                                  </div>
                                </div>
                                <div class="" id="statemail">
                                    <span class="ver-msg"></span>
                                </div>
                            </div>
                          </div>
                          <div class="form-group col-md-6 col-12">
                            <label>Phone</label>
                            <input type="tel" class="form-control data-phone" name="phone">
                          </div>
                        </div>
                        <div class="row">
                          <div class="form-group col-12">
                            <label>Bio</label>
                            <textarea class="form-control summernote-simple data-bio" id="bio" name="bio"></textarea>
                          </div>
                        </div>
                        <div class="row">
                          <div class="form-group mb-0 col-12">
                            <div class="custom-control custom-checkbox">
                              <input type="checkbox" name="2fa" class="custom-control-input data-2fa" id="2fa">
                              <label class="custom-control-label" for="2fa">Two-factor authentication (2FA)</label>
                              <div class="text-muted form-text">
                                You will required to provide security code (OTP) everytime you login.<br> Make sure to provide working email address in your account.
                              </div>
                            </div>
                          </div>
                        </div>
                    </div>
                    <div class="card-footer">
                      <div class="form-group" id="profileupdate">
                        <button type="button" class="btn btn-primary btn-confirm-submit" tabindex="4"> Confirm</button>
                        <button type="submit" class="btn btn-success btn-confirm-auth d-none" tabindex="4"> Authorize</button>
                        <button type="button" class="btn btn-confirm-cancel btn-danger d-none" tabindex="4">Cancel</button>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
          
</section>
</div>
</div>
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
{include file='js/page/profile_js.tpl'}
{include file='js/page/search_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>