<!DOCTYPE html>
<html class="no-js" lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>Reseller Signup — {$site_name}</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="{$base_url}dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="{$base_url}dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}

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

                    <div class="card card-primary">
                        <div class="card-header">
                            <h4>Become a Reseller</h4>
                        </div>

                        <div class="card-body">
                            <p class="text-muted">Join our reseller program and start earning by selling VPN accounts to your customers.</p>

                            <form method="POST" class="needs-validation reseller-signup-form" novalidate="">
                                <input type="hidden" name="submitted" value="reseller_signup">
                                <input type="hidden" name="_key" value="{$firenet_encrypt}">

                                <div class="form-group">
                                    <label for="business_name">Business/Company Name</label>
                                    <input id="business_name" type="text" class="form-control" name="business_name" tabindex="1" required autofocus>
                                    <div class="invalid-feedback">
                                        Please enter your business or company name
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="full_name">Full Name</label>
                                    <input id="full_name" type="text" class="form-control" name="full_name" tabindex="2" required>
                                    <div class="invalid-feedback">
                                        Please enter your full name
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="email">Email Address</label>
                                    <input id="email" type="email" class="form-control" name="email" tabindex="3" required>
                                    <div class="invalid-feedback">
                                        Please enter a valid email address
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input id="phone" type="tel" class="form-control" name="phone" tabindex="4" required>
                                    <div class="invalid-feedback">
                                        Please enter your phone number
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="country">Country</label>
                                    <select id="country" class="form-control" name="country" tabindex="5" required>
                                        <option value="">Select Country</option>
                                        <option value="US">United States</option>
                                        <option value="CA">Canada</option>
                                        <option value="GB">United Kingdom</option>
                                        <option value="AU">Australia</option>
                                        <option value="DE">Germany</option>
                                        <option value="FR">France</option>
                                        <option value="IT">Italy</option>
                                        <option value="ES">Spain</option>
                                        <option value="NL">Netherlands</option>
                                        <option value="SE">Sweden</option>
                                        <option value="NO">Norway</option>
                                        <option value="DK">Denmark</option>
                                        <option value="FI">Finland</option>
                                        <option value="JP">Japan</option>
                                        <option value="KR">South Korea</option>
                                        <option value="SG">Singapore</option>
                                        <option value="HK">Hong Kong</option>
                                        <option value="IN">India</option>
                                        <option value="PH">Philippines</option>
                                        <option value="TH">Thailand</option>
                                        <option value="MY">Malaysia</option>
                                        <option value="ID">Indonesia</option>
                                        <option value="VN">Vietnam</option>
                                        <option value="BD">Bangladesh</option>
                                        <option value="PK">Pakistan</option>
                                        <option value="LK">Sri Lanka</option>
                                        <option value="BR">Brazil</option>
                                        <option value="MX">Mexico</option>
                                        <option value="AR">Argentina</option>
                                        <option value="CL">Chile</option>
                                        <option value="CO">Colombia</option>
                                        <option value="PE">Peru</option>
                                        <option value="ZA">South Africa</option>
                                        <option value="EG">Egypt</option>
                                        <option value="NG">Nigeria</option>
                                        <option value="KE">Kenya</option>
                                        <option value="GH">Ghana</option>
                                        <option value="MA">Morocco</option>
                                        <option value="TN">Tunisia</option>
                                        <option value="DZ">Algeria</option>
                                        <option value="AE">UAE</option>
                                        <option value="SA">Saudi Arabia</option>
                                        <option value="QA">Qatar</option>
                                        <option value="KW">Kuwait</option>
                                        <option value="BH">Bahrain</option>
                                        <option value="OM">Oman</option>
                                        <option value="JO">Jordan</option>
                                        <option value="LB">Lebanon</option>
                                        <option value="TR">Turkey</option>
                                        <option value="RU">Russia</option>
                                        <option value="UA">Ukraine</option>
                                        <option value="PL">Poland</option>
                                        <option value="CZ">Czech Republic</option>
                                        <option value="HU">Hungary</option>
                                        <option value="RO">Romania</option>
                                        <option value="BG">Bulgaria</option>
                                        <option value="HR">Croatia</option>
                                        <option value="RS">Serbia</option>
                                        <option value="BA">Bosnia and Herzegovina</option>
                                        <option value="MK">North Macedonia</option>
                                        <option value="AL">Albania</option>
                                        <option value="ME">Montenegro</option>
                                        <option value="SI">Slovenia</option>
                                        <option value="SK">Slovakia</option>
                                        <option value="LT">Lithuania</option>
                                        <option value="LV">Latvia</option>
                                        <option value="EE">Estonia</option>
                                        <option value="BY">Belarus</option>
                                        <option value="MD">Moldova</option>
                                        <option value="GE">Georgia</option>
                                        <option value="AM">Armenia</option>
                                        <option value="AZ">Azerbaijan</option>
                                        <option value="KZ">Kazakhstan</option>
                                        <option value="UZ">Uzbekistan</option>
                                        <option value="KG">Kyrgyzstan</option>
                                        <option value="TJ">Tajikistan</option>
                                        <option value="TM">Turkmenistan</option>
                                        <option value="MN">Mongolia</option>
                                        <option value="CN">China</option>
                                        <option value="TW">Taiwan</option>
                                        <option value="Other">Other</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Please select your country
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="website">Website/Social Media (Optional)</label>
                                    <input id="website" type="url" class="form-control" name="website" tabindex="6" placeholder="https://example.com">
                                </div>

                                <div class="form-group">
                                    <label for="experience">Experience in VPN/Hosting Business</label>
                                    <select id="experience" class="form-control" name="experience" tabindex="7" required>
                                        <option value="">Select Experience Level</option>
                                        <option value="beginner">Beginner (0-1 years)</option>
                                        <option value="intermediate">Intermediate (1-3 years)</option>
                                        <option value="experienced">Experienced (3-5 years)</option>
                                        <option value="expert">Expert (5+ years)</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Please select your experience level
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="expected_sales">Expected Monthly Sales</label>
                                    <select id="expected_sales" class="form-control" name="expected_sales" tabindex="8" required>
                                        <option value="">Select Expected Sales</option>
                                        <option value="1-50">1-50 accounts</option>
                                        <option value="51-100">51-100 accounts</option>
                                        <option value="101-500">101-500 accounts</option>
                                        <option value="501-1000">501-1000 accounts</option>
                                        <option value="1000+">1000+ accounts</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Please select your expected monthly sales
                                    </div>
                                    <small class="form-text text-info">
                                        <i class="fas fa-info-circle"></i> This information helps us understand your business goals. Credits will be added manually by admin after approval.
                                    </small>
                                </div>

                                <div class="form-group">
                                    <label for="message">Why do you want to become a reseller?</label>
                                    <textarea id="message" class="form-control" name="message" rows="4" tabindex="9" required placeholder="Tell us about your business goals and why you want to join our reseller program..."></textarea>
                                    <div class="invalid-feedback">
                                        Please tell us why you want to become a reseller
                                    </div>
                                </div>

                                <hr>
                                <h6 class="text-primary"><i class="fas fa-user-cog"></i> Account Credentials</h6>
                                <p class="text-muted small">Choose your login credentials for the reseller panel (if approved).</p>

                                <div class="form-group">
                                    <label for="username">Preferred Username</label>
                                    <input id="username" type="text" class="form-control" name="username" tabindex="10" required minlength="4" maxlength="20" pattern="[a-zA-Z0-9_]+" placeholder="Enter your preferred username">
                                    <div class="invalid-feedback">
                                        Username must be 4-20 characters, letters, numbers and underscore only
                                    </div>
                                    <small class="form-text text-muted">This will be your login username for the reseller panel</small>
                                </div>

                                <div class="form-group">
                                    <label for="password">Password</label>
                                    <div class="input-group">
                                        <input id="password" type="password" class="form-control" name="password" tabindex="11" required minlength="6" placeholder="Enter a secure password">
                                        <div class="input-group-append">
                                            <div class="input-group-text" style="cursor: pointer;" onclick="togglePassword()">
                                                <span id="password-toggle-icon"><i class="fas fa-eye"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="invalid-feedback">
                                        Password must be at least 6 characters long
                                    </div>
                                    <small class="form-text text-muted">Minimum 6 characters, use a strong password</small>
                                </div>

                                <div class="form-group">
                                    <label for="confirm_password">Confirm Password</label>
                                    <input id="confirm_password" type="password" class="form-control" name="confirm_password" tabindex="12" required minlength="6" placeholder="Confirm your password">
                                    <div class="invalid-feedback">
                                        Passwords do not match
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" class="custom-control-input" tabindex="13" required id="agree" name="agree">
                                        <label class="custom-control-label" for="agree">I agree to the <a href="#" target="_blank">Terms and Conditions</a> and <a href="#" target="_blank">Privacy Policy</a></label>
                                        <div class="invalid-feedback">
                                            You must agree to our terms and conditions
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <button type="submit" class="btn btn-primary btn-lg btn-block" tabindex="14">
                                        Submit Application
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="mt-5 text-muted text-center">
                        Already have an account? <a href="/login">Sign In</a>
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
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}

<script>
// Password toggle function
function togglePassword() {
    var passwordField = document.getElementById('password');
    var toggleIcon = document.getElementById('password-toggle-icon');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        toggleIcon.innerHTML = '<i class="fas fa-eye-slash"></i>';
    } else {
        passwordField.type = 'password';
        toggleIcon.innerHTML = '<i class="fas fa-eye"></i>';
    }
}

$(document).ready(function() {
    // Password confirmation validation
    $('#confirm_password').on('keyup', function() {
        var password = $('#password').val();
        var confirmPassword = $(this).val();

        if (password !== confirmPassword) {
            $(this).addClass('is-invalid');
            $(this).removeClass('is-valid');
        } else {
            $(this).removeClass('is-invalid');
            $(this).addClass('is-valid');
        }
    });

    // Username validation
    $('#username').on('keyup', function() {
        var username = $(this).val();
        var pattern = /^[a-zA-Z0-9_]+$/;

        if (username.length >= 4 && username.length <= 20 && pattern.test(username)) {
            $(this).removeClass('is-invalid');
            $(this).addClass('is-valid');
        } else {
            $(this).addClass('is-invalid');
            $(this).removeClass('is-valid');
        }
    });

    $('.reseller-signup-form').on('submit', function(e) {
        e.preventDefault();

        // Validate passwords match
        var password = $('#password').val();
        var confirmPassword = $('#confirm_password').val();

        if (password !== confirmPassword) {
            Swal.fire({
                title: 'Password Mismatch!',
                text: 'Password and confirm password do not match.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            return false;
        }

        var form = $(this);
        var formData = form.serialize();

        // Show loading
        var submitBtn = form.find('button[type="submit"]');
        var originalText = submitBtn.html();
        submitBtn.html('<i class="fas fa-spinner fa-spin"></i> Processing...').prop('disabled', true);

        $.ajax({
            url: '/serverside/forms/reseller_signup.php',
            type: 'POST',
            data: formData,
            dataType: 'json',
            success: function(response) {
                if (response.response == 1) {
                    Swal.fire({
                        title: 'Application Submitted!',
                        html: response.msg,
                        icon: 'success',
                        confirmButtonText: 'OK',
                        allowOutsideClick: false
                    }).then(function() {
                        window.location.href = '/';
                    });
                } else if (response.response == 2) {
                    Swal.fire({
                        title: 'Error!',
                        html: response.msg,
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                } else if (response.response == 3) {
                    Swal.fire({
                        title: 'Validation Error!',
                        html: response.errormsg,
                        icon: 'warning',
                        confirmButtonText: 'OK'
                    });
                }
            },
            error: function() {
                Swal.fire({
                    title: 'Error!',
                    text: 'Something went wrong. Please try again.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            },
            complete: function() {
                submitBtn.html(originalText).prop('disabled', false);
            }
        });
    });
});
</script>


<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
