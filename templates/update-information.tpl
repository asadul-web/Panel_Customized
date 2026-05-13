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
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
<style>
.info-edit-content-display {
    min-height: 200px;
    padding: 0;
    margin-bottom: 0;
}

.info-edit-content-display h1, 
.info-edit-content-display h2, 
.info-edit-content-display h3,
.info-edit-content-display h4,
.info-edit-content-display h5,
.info-edit-content-display h6 {
    color: #495057;
    margin-bottom: 15px;
}

.info-edit-content-display p {
    line-height: 1.6;
    color: #6c757d;
    margin-bottom: 15px;
}

.info-edit-content-display ul, 
.info-edit-content-display ol {
    margin: 15px 0;
    padding-left: 30px;
}

.info-edit-content-display .alert {
    margin: 15px 0;
}

.info-edit-content-display blockquote {
    border-left: 4px solid #007bff;
    padding-left: 15px;
    margin: 20px 0;
    font-style: italic;
}

.info-edit-content-display table {
    width: 100%;
    margin: 15px 0;
}

.info-edit-content-display table th,
.info-edit-content-display table td {
    padding: 8px 12px;
    border: 1px solid #dee2e6;
}

.info-edit-content-display table th {
    background-color: #e9ecef;
    font-weight: bold;
}

.content-sync-status {
    font-size: 11px;
    color: #6c757d;
    margin-top: 15px;
    padding: 8px 12px;
    background: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 4px;
    display: block;
    text-align: center;
}

/* Support for Bengali and other Unicode text */
.info-edit-content-display {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif, 'Noto Sans Bengali', 'SolaimanLipi';
}

.info-edit-content-display h2,
.info-edit-content-display h3,
.info-edit-content-display h4 {
    font-weight: 600;
}

/* Emoji support */
.info-edit-content-display p,
.info-edit-content-display li {
    line-height: 1.8;
}
</style>
</head>
<body class="bg-image">
<a class="faz" href="#" onclick="return false;" type="button" data-theme-toggle><i id="xtoggle"></i></a>    
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

<div id="app">
<section class="section">
<div class="container mt-5">
<div class="card card-primary">
<div class="card-header">
<h4>Info Edit Content</h4>
<div class="card-header-action">
<button class="btn btn-primary" onclick="setTestContent()">
<i class="fas fa-sync"></i> Load Content
</button>
<button class="btn btn-warning ml-2" onclick="clearCache()">
<i class="fas fa-trash-alt"></i> Clear Cache
</button>
</div>
</div>
<div class="card-body">
<!-- HTML Editor Content Display -->
<div id="infoEditContent" class="info-edit-content-display">
    <div class="text-center text-muted">
        <i class="fas fa-spinner fa-spin"></i> Loading...
    </div>
</div>
</div>
</div>

<div class="form-group text-center mt-4">
    <a href="{$btn_link}" class="btn btn-icon icon-left"><i class="fas fa-undo"></i> Back to {$btn_value}</a>
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

<script data-cfasync="false" src="/cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script><script src="/dist/modules/jquery.min.js"></script>
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
<script src="/dist/modules/summernote/summernote-bs4.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom.js?v=2"></script>
<script src="/dist/js/custom-select.js"></script>
<script src="/dist/js/page/privacy-policy.js"></script>

{include file='js/page/custom_js.tpl'}
{include file='js/page/download_js.tpl'}

<script>
$(document).ready(function() {
    // Function to load and display HTML editor content from Info Edit page
    function loadInfoEditContent() {
        try {
            // Get content from localStorage (same key used in site-info.tpl)
            var savedContent = localStorage.getItem('htmlEditorContent');
            var lastSaved = localStorage.getItem('lastSaved');
            
            
            if (savedContent && savedContent.trim() !== '') {
                // Display the content
                $('#infoEditContent').html(savedContent);
                
                // Add sync status
                var statusHtml = '<div class="content-sync-status">';
                statusHtml += '<i class="fas fa-sync-alt"></i> ';
                statusHtml += 'Synced from Info Edit page';
                if (lastSaved) {
                    statusHtml += ' | Last updated: ' + lastSaved;
                }
                statusHtml += '</div>';
                
                $('#infoEditContent').append(statusHtml);
                
            } else {
                // Auto-load content if none found
                setTestContent();
            }
        } catch (error) {
            console.error('❌ Error loading Info Edit content:', error);
            $('#infoEditContent').html(
                '<div class="alert alert-danger">' +
                '<i class="fas fa-exclamation-circle"></i> ' +
                'Error loading content from Info Edit page.' +
                '</div>'
            );
        }
    }
    
    // Function to set the exact content from Info Edit page
    window.setTestContent = function() {
        var testContent = `
            <h2 style="color: #6f42c1; font-weight: bold;">সাইট তথ্য-এ স্বাগতম</h2>
            <p><span style="color: #ff6b35;">🔥</span> <strong>STC Free – blazing speed!1</strong></p>
            
            <h3 style="color: #333; margin-top: 20px;">Features:</h3>
            <ul style="margin-left: 20px;">
                <li><strong>Mobily</strong> - 30 SR & 60 SR Packages !</li>
                <li><strong>Lebara</strong> - Sim Free</li>
                <li><strong>Salam SIM</strong> - Free</li>
                <li style="color: #28a745;"><strong>কোন প্রকার সার্ভার আপডেট নিয়ে ঝামেলা নাই</strong></li>
            </ul>
            
            <h3 style="color: #333; margin-top: 20px;">Updates:</h3>
            <div style="background-color: #17a2b8; color: white; padding: 15px; border-radius: 5px; margin: 10px 0;">
                <p style="margin: 0;"><span style="color: #28a745;">✅</span> <strong>No updates or issues.</strong></p>
                <ul style="margin: 10px 0 0 20px; color: white;">
                    <li>Text formatting (Update)</li>
                    <li>Lists and tables</li>
                </ul>
            </div>
        `;
        
        try {
            localStorage.setItem('htmlEditorContent', testContent);
            localStorage.setItem('lastSaved', new Date().toLocaleString());
            loadInfoEditContent();
        } catch (error) {
            console.error('❌ Error saving content:', error);
            alert('Error saving content to localStorage');
        }
    };
    
    // Function to clear localStorage and force refresh
    window.clearAndRefresh = function() {
        try {
            localStorage.removeItem('htmlEditorContent');
            localStorage.removeItem('lastSaved');
            loadInfoEditContent();
        } catch (error) {
            console.error('❌ Error clearing localStorage:', error);
        }
    };
    
    // Function to clear all cache (localStorage, sessionStorage, server cache, and browser cache)
    window.clearCache = function() {
        // Show confirmation dialog
        if (confirm('Are you sure you want to clear all cache? This will:\n\n• Clear localStorage content\n• Clear sessionStorage\n• Clear server-side cache\n• Clear browser cache\n• Force page refresh')) {
            try {
                
                // Clear localStorage
                var localStorageKeys = Object.keys(localStorage);
                localStorageKeys.forEach(function(key) {
                    localStorage.removeItem(key);
                });
                
                // Clear sessionStorage
                var sessionStorageKeys = Object.keys(sessionStorage);
                sessionStorageKeys.forEach(function(key) {
                    sessionStorage.removeItem(key);
                });
                
                // Clear any cached data in memory
                if (window.caches) {
                    caches.keys().then(function(names) {
                        names.forEach(function(name) {
                            caches.delete(name);
                        });
                    });
                }
                
                
                // Redirect to clear server-side cache
                window.location.href = window.location.pathname + '?clear_cache=1';
                
            } catch (error) {
                console.error('❌ Error clearing cache:', error);
                alert('❌ Error clearing cache: ' + error.message);
            }
        }
    };
    
    // Check if cache was cleared and show success message
    {if $cache_cleared}
    $(document).ready(function() {
        setTimeout(function() {
            alert('✅ Cache Cleared Successfully!\n\n• Server-side cache cleared\n• Smarty templates cleared\n• PHP opcache cleared\n• All cache files removed\n\nPage is now fresh and updated!');
        }, 1000);
    });
    {/if}
    
    // Load content on page load with slight delay
    setTimeout(function() {
        loadInfoEditContent();
    }, 500);
    
    // Listen for storage changes (when content is updated from Info Edit page)
    window.addEventListener('storage', function(e) {
        if (e.key === 'htmlEditorContent') {
            loadInfoEditContent();
        }
    });
    
    // Auto-reload content every 5 seconds for the first minute, then every 30 seconds
    var reloadCount = 0;
    var autoReloadInterval = setInterval(function() {
        reloadCount++;
        loadInfoEditContent();
        
        // After 12 attempts (1 minute), switch to 30-second intervals
        if (reloadCount >= 12) {
            clearInterval(autoReloadInterval);
            setInterval(function() {
                loadInfoEditContent();
            }, 30000);
        }
    }, 5000);
});
</script>


<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
