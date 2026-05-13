<script>
function normal_modalize(title, body)
	{
	    $(".normal-modalize").modal({
            backdrop: 'static',
            keyboard: false  // to prevent closing with Esc button (if you want this too)
        })
        $(".normal-modalize").modal('show');
		$(".normal-modal-title").text(title);
		$(".normal-modal-error").html('');
		$(".normal-modal-html").html(body);
	}

$(document).ready(function() {
	// Check if ClipboardJS is available
	if (typeof ClipboardJS !== 'undefined') {
		var clippy = new ClipboardJS('.btn-copy');
		clippy.on('success', function(e) {
	    $('.normal-modalize').modal('hide');
		Swal.fire({
            title: "Details copied successfuly!",
            icon: "success",
            allowOutsideClick: false,
            allowEscapeKey: false,
            confirmButtonText: "Confirm",
            didOpen: function () {
                Swal.getConfirmButton().blur()
            },
            customClass: {
                confirmButton: 'swal2-confirm btn btn-primary swal2-styled'
            }
        }); e.clearSelection();
		}); 
	}
	var token = $("#app").data("token");
	
	if (typeof ClipboardJS !== 'undefined') {
		var kiffy = new ClipboardJS('.btn-xcopy');
	$.fn.modal.Constructor.prototype._enforceFocus = function() {};
	kiffy.on('success', function(e) {
	    $('.normal-modalize').modal('hide');
		Swal.fire({
            title: "Link copied successfuly!",
            icon: "success",
            allowOutsideClick: false,
            allowEscapeKey: false,
            confirmButtonText: "Confirm",
            didOpen: function () {
                Swal.getConfirmButton().blur()
            },
            customClass: {
                confirmButton: 'swal2-confirm btn btn-primary swal2-styled'
            }
        }); e.clearSelection();
		}); 
	}
	var token = $("#xxapp").data("token");
	
	$(".btn-logout").click(function(e) {
		e.preventDefault(); // Prevent default link behavior
		
		Swal.fire({
          text: "Are you sure you want to logout?",
          allowOutsideClick: false,
          allowEscapeKey: false,
          imageUrl: "{$site_logo}",
          imageWidth: 150,
          imageHeight: 150,
          imageAlt: "Custom image",
          showCancelButton: true,
          confirmButtonText: `Confirm`,
          didOpen: function () {
            Swal.getConfirmButton().blur()
          },
          customClass: {
                confirmButton: 'swal2-confirm btn btn-primary swal2-styled',
                cancelButton: 'swal2-confirm btn btn-danger swal2-styled'
            }
        }).then((doLogout) => {
			if (doLogout.isConfirmed) {
				window.location.href = "{$base_url}logout";
			}
		});
		
		return false;
	})
	
    $('.btn-genuine').click(function () {
        normal_modalize('Made with \u2764️ by Vollam','Thank you for choosing my vpn panel and for supporting me.')
    })
})

        $(document).on('click', '.upload-field', function(){
            var file = $(this).parent().parent().find('.input-file');
            file.trigger('click');
        });

        $(document).on('change', '.input-file', function(){
            $(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
        });
        
        $(document).on('click', '.upload-field2', function(){
            var file2 = $(this).parent().parent().parent().find('.input-file2');
            file2.trigger('click');
        });

        $(document).on('change', '.input-file2', function(){
            $(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
        });
        
$(window).on('load', function() {
   $("#loading").hide();
   
   // Initialize Bangla font detection and application
   initializeBanglaFontSupport();
});

// Bangla Font Auto-Detection and Application
function initializeBanglaFontSupport() {
    // Function to detect Bangla text
    function containsBanglaText(text) {
        // Bengali Unicode range: U+0980–U+09FF
        var banglaRegex = /[\u0980-\u09FF]/;
        return banglaRegex.test(text);
    }
    
    // Function to apply Bangla font to elements
    function applyBanglaFont(element) {
        $(element).addClass('bangla-text');
        $(element).css({
            'font-family': "'Hind Siliguri', Arial, sans-serif",
            'line-height': '1.7'
        });
    }
    
    // Auto-detect and apply Bangla font to text content
    function autoDetectBanglaText() {
        // Check common text elements
        var textElements = $('p, span, div, td, th, h1, h2, h3, h4, h5, h6, label, .card-title, .card-text, .modal-title, .modal-body, .alert');
        
        textElements.each(function() {
            var text = $(this).text();
            if (containsBanglaText(text)) {
                applyBanglaFont(this);
            }
        });
        
        // Check input fields and textareas
        $('input[type="text"], textarea, .form-control').each(function() {
            var text = $(this).val();
            if (containsBanglaText(text)) {
                applyBanglaFont(this);
            }
        });
    }
    
    // Run auto-detection on page load
    autoDetectBanglaText();
    
    // Monitor for dynamic content changes
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                mutation.addedNodes.forEach(function(node) {
                    if (node.nodeType === 1) { // Element node
                        var $node = $(node);
                        if (containsBanglaText($node.text())) {
                            applyBanglaFont(node);
                        }
                        // Check child elements
                        $node.find('*').each(function() {
                            if (containsBanglaText($(this).text())) {
                                applyBanglaFont(this);
                            }
                        });
                    }
                });
            }
        });
    });
    
    // Start observing
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
    
    // Monitor input changes
    $(document).on('input keyup paste', 'input, textarea', function() {
        var text = $(this).val();
        if (containsBanglaText(text)) {
            applyBanglaFont(this);
        }
    });
}

// Global function to manually apply Bangla font
window.applyBanglaFontToElement = function(selector) {
    $(selector).addClass('bangla-text').css({
        'font-family': "'Hind Siliguri', Arial, sans-serif",
        'line-height': '1.7'
    });
};

// Global function to toggle Bangla font for an element
window.toggleBanglaFont = function(selector) {
    var $element = $(selector);
    if ($element.hasClass('bangla-text')) {
        $element.removeClass('bangla-text').css({
            'font-family': '',
            'line-height': ''
        });
    } else {
        $element.addClass('bangla-text').css({
            'font-family': "'Hind Siliguri', Arial, sans-serif",
            'line-height': '1.7'
        });
    }
};

/**
* Utility function to calculate the current theme setting.
* Look for a local storage value.
* Fall back to system setting.
* Fall back to light mode.
*/
function calculateSettingAsThemeString({ localStorageTheme, systemSettingDark }) {
  if (localStorageTheme !== null) {
    return localStorageTheme;
  }

  if (systemSettingDark.matches) {
    return "dark";
  }

  return "light";
}

/**
* Utility function to update the button text and aria-label.
*/
function updateButton({ buttonEl, isDark }) {
  const newCta = isDark ? "fa fa-sun" : "fa fa-moon";
  // use an aria-label if you are omitting text on the button
  // and using a sun/moon icon, for example
  $('#xtoggle').attr("class",newCta);
}

/**
* Utility function to update the theme setting on the html tag
*/
function updateThemeOnHtmlEl({ theme }) {
  document.querySelector("html").setAttribute("data-theme", theme);
}


/**
* On page load:
*/

/**
* 1. Grab what we need from the DOM and system settings on page load
*/
const button = document.querySelector("[data-theme-toggle]");
const localStorageTheme = localStorage.getItem("theme");
const systemSettingDark = window.matchMedia("(prefers-color-scheme: dark)");

/**
* 2. Work out the current site settings
*/
let currentThemeSetting = calculateSettingAsThemeString({ localStorageTheme, systemSettingDark });

/**
* 3. Update the theme setting and button text accoridng to current settings
*/
updateButton({ buttonEl: button, isDark: currentThemeSetting === "dark" });
updateThemeOnHtmlEl({ theme: currentThemeSetting });

/**
* 4. Add an event listener to toggle the theme
*/
button.addEventListener("click", (event) => {
  const newTheme = currentThemeSetting === "dark" ? "light" : "dark";

  localStorage.setItem("theme", newTheme);
  updateButton({ buttonEl: button, isDark: newTheme === "dark" });
  updateThemeOnHtmlEl({ theme: newTheme });

  currentThemeSetting = newTheme;
}); 

// Global variable to track dismissed notices for current page load
window.dismissedNotices = window.dismissedNotices || [];

// Global flag to track if notice has been rendered
window.noticeRendered = window.noticeRendered || false;

// Unicode-safe base64 encoding function
function unicodeSafeHash(str) {
  try {
    // Use a simple hash instead of btoa to avoid Unicode issues
    var hash = 0;
    for (var i = 0; i < str.length; i++) {
      var char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash; // Convert to 32bit integer
    }
    return Math.abs(hash).toString(36);
  } catch(e) {
    return 'notice_' + Date.now();
  }
}

function renderNoticeBanner(n){
  try{
    if(!n || !n.message || !n.active){ return; }
    
    // Prevent multiple renders - only render once per page load
    if(window.noticeRendered){ return; }
    
    // NEVER show on login page
    var currentPage = window.location.pathname;
    var isLogin = currentPage.includes('login') || currentPage.includes('p=login');
    if(isLogin){ return; } // Exit immediately if on login page
    
    // Only show on dashboard page
    var isDashboard = currentPage === '/' || currentPage === '/dashboard' || currentPage.includes('dashboard');
    if(!isDashboard){ return; }
    
    // Check if user has dismissed this notice in current page load (Unicode-safe)
    var noticeId = 'notice_' + unicodeSafeHash((n.title||'') + '|' + (n.message||''));
    if(window.dismissedNotices.includes(noticeId)){ return; }
    
    var sev = String(n.severity||'info').toLowerCase();
    // Force green color (alert-success) regardless of severity
    var cls = 'alert-success';
    var b = n.billing || {};
    var extra = b.status ? (' • Status: ' + b.status) : '';
    var due = b.next_due ? (' • Due: ' + b.next_due) : '';
    var html = '<div class="alert '+cls+' alert-dismissible" role="alert" style="margin-bottom:12px; position:relative;" data-notice-id="'+noticeId+'">'
      + '<button type="button" class="close" data-dismiss="alert" aria-label="Close" onclick="dismissNotice(\''+noticeId+'\')" style="position:absolute; top:10px; right:15px; font-size:24px; font-weight:700; line-height:1; color:#155724; opacity:0.8; background:none; border:none; cursor:pointer;">'
      + '<span aria-hidden="true">&times;</span></button>'
      + '<strong><i class="fas fa-bullhorn"></i> ' + (n.title||'Panel News Update') + '</strong> — ' + n.message + extra + due
      + '</div>';
    var $target = $('.section-body').first();
    if($target.length===0){ $target = $('.main-content').first(); }
    if($target.length===0){ $target = $('body'); }
    
    // Check if this exact notice already exists on the page
    var existingNotice = $('[data-notice-id="'+noticeId+'"]');
    if(existingNotice.length > 0){
      return; // Notice already displayed, don't add duplicate
    }
    
    // Add the notice
    $target.prepend(html);
    
    // Mark as rendered to prevent duplicates
    window.noticeRendered = true;
  }catch(e){ console.warn('renderNoticeBanner error', e); }
}

// Function to temporarily hide notice (until page refresh)
function dismissNotice(noticeId){
  // Add to dismissed notices array for current page load
  if(!window.dismissedNotices.includes(noticeId)){
    window.dismissedNotices.push(noticeId);
  }
  $('[data-notice-id="'+noticeId+'"]').fadeOut(300, function(){
    $(this).remove();
  });
  // Reset render flag in case user wants to see notices again
  window.noticeRendered = false;
}

async function fetchPopupNotice(){
  try {
    // Only show for ADMIN users (administrator, superadmin) - NOT reseller or developer
    var userLevel = '{$user_level_2|default:""}';
    var userId = '{$user_id_2|default:""}';
    var isAdmin = (userId === '1' || userLevel === 'superadmin' || userLevel === 'administrator');
    
    if(!isAdmin){
      return; // Exit if not admin (reseller/developer will not see notices)
    }
    
    // Use local proxy only (actual API URL is encrypted and hidden)
    var urls = [
      '{$popup_notice_proxy}'
    ];
    
    var j = null;
    for (var i = 0; i < urls.length; i++) {
      try {
        var r = await fetch(urls[i], { 
          method: 'GET',
          mode: i === 0 ? 'same-origin' : 'cors',
          headers: {
            'Content-Type': 'application/json'
          },
          cache: 'no-cache'
        });
        
        if (r.ok) {
          j = await r.json();
          break;
        }
      } catch (err) {
        // Silent fallback to next URL
        continue;
      }
    }
    
    if (!j) {
      return;
    }
    
    if(j && j.response === 1 && j.data){ 
      var data = j.data;
      
      if(!data || !data.message || !data.active){ 
        return; 
      }
      
      // Only show on dashboard page
      var currentPage = window.location.pathname;
      var isDashboard = currentPage === '/' || currentPage === '/dashboard' || currentPage.includes('dashboard');
      
      // Check if should show on dashboard
      if(!data.show_on_dashboard) {
        return;
      }
      
      // Only show if on dashboard page
      if(!isDashboard){ 
        return; 
      }
      
      // Wait for SweetAlert to be ready
      setTimeout(function(){
        if(typeof Swal !== 'undefined'){
          var htmlContent = document.createElement("div");
          htmlContent.innerHTML = '<div class="swal-title" style="padding-bottom:10px; font-weight:bold; font-size:18px;">' + (data.title||'Important Notice') + '</div>'
            + '<div style="padding-top:10px;">' + data.message + '</div>';
          
          Swal.fire({
            icon: data.icon || 'info',
            html: htmlContent,
            confirmButtonText: 'Confirm',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            didOpen: function () {
              Swal.getConfirmButton().blur();
            },
            customClass: {
              confirmButton: 'swal2-confirm btn btn-primary swal2-styled'
            }
          });
        }
      }, 500);
    }
  } catch(e){ 
    // Silently fail
  }
}

async function fetchNoticeBanner(){
  try {
    // Only show for ADMIN users (administrator, superadmin) - NOT reseller or developer
    var userLevel = '{$user_level_2|default:""}';
    var userId = '{$user_id_2|default:""}';
    var isAdmin = (userId === '1' || userLevel === 'superadmin' || userLevel === 'administrator');
    
    if(!isAdmin){
      return; // Exit if not admin (reseller/developer will not see banner notices)
    }
    
    var url = "{$notice_api_proxy}";
    if(!url){ return; }
    var r = await fetch(url, { credentials: 'same-origin' });
    var j = await r.json();
    if(j && j.response === 1 && j.data){ 
      renderNoticeBanner(j.data); // Show banner
    }
  } catch(e){ console.warn('Notice fetch failed', e); }
}

// Check license status and show popup if blocked or expired (ADMIN ONLY)
function checkLicenseStatusPopup() {
  {if isset($show_license_info) && $show_license_info && isset($license_check) && $license_check.data}
  // Only show to admin accounts (not reseller or developer)
  var licenseData = {
    isValid: {if $license_check.valid}true{else}false{/if},
    isExpired: {if $license_check.data.is_expired}true{else}false{/if},
    status: '{$license_check.data.status}',
    expiryDate: '{$license_check.data.expiry_date}',
    daysRemaining: {$license_check.data.days_remaining}
  };
  
  setTimeout(function() {
    if (typeof Swal !== 'undefined') {
      // Check if already shown today
      var today = new Date().toDateString();
      var lastShown = localStorage.getItem('license_reminder_shown');
      
      if (licenseData.status === 'disabled') {
        // License Blocked - Always show
        Swal.fire({
          icon: 'error',
          title: '<strong style="color: #dc3545;">🔒 License Blocked</strong>',
          html: '<div style="text-align: center; padding: 20px;">' +
                '<p style="margin-bottom: 20px; font-size: 16px;">Your license key has been <strong>blocked</strong> and can no longer be used.</p>' +
                '<p style="margin-bottom: 20px; font-size: 15px;">To restore full access and continue using all features, please contact our support team.</p>' +
                '<p style="color: #6c757d; font-size: 14px;">We\'re here to help you! 😊</p>' +
                '</div>',
          showCancelButton: false,
          confirmButtonText: '<i class="fab fa-whatsapp" style="font-size: 20px; margin-right: 10px;"></i> WhatsApp',
          confirmButtonColor: '#25D366',
          allowOutsideClick: false,
          allowEscapeKey: false,
          width: '450px',
          buttonsStyling: true
        }).then((result) => {
          if (result.isConfirmed) {
            window.open('https://wa.me/8801874654595?text=Hello!%20My%20license%20is%20blocked.%20I%20need%20help%20to%20unblock%20it.%20Thank%20you!', '_blank');
          }
        });
      } else if (licenseData.isExpired) {
        // License Expired - Always show
        Swal.fire({
          icon: 'warning',
          title: '<strong style="color: #ffc107;">⏰ License Expired</strong>',
          html: '<div style="text-align: center; padding: 20px;">' +
                '<p style="margin-bottom: 20px; font-size: 16px;">Your license key has reached its <strong>expiry date</strong> (' + licenseData.expiryDate + ').</p>' +
                '<p style="margin-bottom: 20px; font-size: 15px;">To restore full access and continue using all features, please contact our support team to renew.</p>' +
                '<p style="color: #6c757d; font-size: 14px;">We\'re ready to assist you! 😊</p>' +
                '</div>',
          showCancelButton: false,
          confirmButtonText: '<i class="fab fa-whatsapp" style="font-size: 20px; margin-right: 10px;"></i> WhatsApp',
          confirmButtonColor: '#25D366',
          allowOutsideClick: false,
          allowEscapeKey: false,
          width: '450px',
          buttonsStyling: true
        }).then((result) => {
          if (result.isConfirmed) {
            window.open('https://wa.me/8801874654595?text=Hello!%20My%20license%20has%20expired.%20I%20would%20like%20to%20renew%20it.%20Thank%20you!', '_blank');
          }
        });
      } else if (licenseData.isValid && licenseData.daysRemaining <= 5 && licenseData.daysRemaining > 0) {
        // License expiring soon (5 days or less) - Show once per day ONLY to admin
        if (lastShown !== today) {
          Swal.fire({
            icon: 'warning',
            title: '<strong style="color: #ffc107;">⚠️ License Expiring Soon</strong>',
            html: '<div style="text-align: center; padding: 20px;">' +
                  '<p style="margin-bottom: 20px; font-size: 18px;">Your license will expire in <strong style="color: #dc3545; font-size: 24px;">' + licenseData.daysRemaining + ' day' + (licenseData.daysRemaining > 1 ? 's' : '') + '</strong></p>' +
                  '<p style="margin-bottom: 15px; font-size: 16px;">Expiry Date: <strong>' + licenseData.expiryDate + '</strong></p>' +
                  '<p style="margin-bottom: 20px; font-size: 15px;">Please <strong>renew your license</strong> before it expires to avoid service interruption.</p>' +
                  '<p style="color: #6c757d; font-size: 14px;">Renew now to ensure uninterrupted access to all features. 🔐</p>' +
                  '</div>',
            showCancelButton: true,
            showDenyButton: true,
            confirmButtonText: '<i class="fas fa-sync"></i> Renew Now',
            denyButtonText: '<i class="fab fa-whatsapp"></i> WhatsApp Support',
            cancelButtonText: '<i class="fas fa-times"></i> Remind Me Tomorrow',
            confirmButtonColor: '#17a2b8',
            denyButtonColor: '#25D366',
            cancelButtonColor: '#6c757d',
            allowOutsideClick: true,
            allowEscapeKey: true,
            width: '500px',
            customClass: {
              popup: 'license-alert-popup',
              confirmButton: 'btn-lg',
              denyButton: 'btn-lg',
              cancelButton: 'btn-lg'
            }
          }).then((result) => {
            if (result.isConfirmed) {
              window.location.href = '/license-api';
            } else if (result.isDenied) {
              window.open('https://wa.me/8801874654595?text=Hello,%20I%20need%20help%20renewing%20my%20license.%20It%20expires%20in%20' + licenseData.daysRemaining + '%20days.%20Thank%20you!', '_blank');
            }
            // Mark as shown today - will show again tomorrow
            localStorage.setItem('license_reminder_shown', today);
          });
        }
      }
    }
  }, 800);
  {/if}
}

document.addEventListener('DOMContentLoaded', function(){
  // Only run on dashboard page for admin users
  var currentPage = window.location.pathname;
  var isDashboard = currentPage === '/' || currentPage === '/dashboard' || currentPage.includes('dashboard');
  var isLogin = currentPage.includes('login') || currentPage === '/login';
  
  // Don't run on login page
  if (!isLogin && isDashboard) {
    fetchPopupNotice();  // Fetch popup notice (admin dashboard only)
    // fetchNoticeBanner(); // Fetch banner notice (admin dashboard only) - DISABLED
  }
  
  if (!isLogin) {
    checkLicenseStatusPopup(); // Check license status (all pages except login)
  }
});

// Turnstile callback function
window.onloadTurnstileCallback = function() {
  // Turnstile loaded successfully
};
</script>
<script src="https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onloadTurnstileCallback" defer></script>