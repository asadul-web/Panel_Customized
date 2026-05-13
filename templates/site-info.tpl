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
/* Info Edit Page Styles */
.content-display-area {
    min-height: 400px;
    background: #f8f9fa;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
}

.content-display-area h1, .content-display-area h2, .content-display-area h3 {
    color: #495057;
    margin-bottom: 15px;
}

.content-display-area p {
    line-height: 1.6;
    color: #6c757d;
}

.content-display-area ul, .content-display-area ol {
    margin: 15px 0;
    padding-left: 30px;
}

.content-display-area .alert {
    margin: 15px 0;
}

/* Editor Section Styles */
.editor-section {
    background: white;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
}

.note-editor {
    border: 1px solid #dee2e6 !important;
    border-radius: 6px !important;
}

.note-toolbar {
    background: #f8f9fa !important;
    border-bottom: 1px solid #dee2e6 !important;
}

.note-editable {
    min-height: 300px !important;
    background: white !important;
}

/* Action Buttons */
.action-buttons {
    margin-top: 15px;
}

.action-buttons .btn {
    margin-right: 10px;
    margin-bottom: 5px;
}

/* Content Stats */
.content-stats {
    background: #e9ecef;
    border-radius: 6px;
    padding: 15px;
    margin-bottom: 20px;
}

.stat-item {
    text-align: center;
    padding: 10px;
}

.stat-number {
    font-size: 24px;
    font-weight: bold;
    color: #495057;
}

.stat-label {
    font-size: 12px;
    color: #6c757d;
    text-transform: uppercase;
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
<h1>Info Edit</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Main</div>
<div class="breadcrumb-item">Content</div>
<div class="breadcrumb-item active">Info Edit</div>
</div>
</div>
<div class="section-body">
<div class="row">
<div class="col-md-12">
<div class="card card-primary">
<div class="card-header">
<h4>Info Edit Management</h4>
<div class="card-header-action">
<button class="btn btn-primary" id="toggleEditor">
<i class="fas fa-edit"></i> Edit Content
</button>
</div>
</div>
<div class="card-body">
<div class="alert alert-primary" role="alert">
    <strong>SITE CONTENT : </strong> Manage and edit your Info Edit content with rich text editor.<br>
    <strong>AUTO-SYNC : </strong> Content changes are automatically synchronized across all pages.
</div>

<!-- Content Display Area -->
<div id="contentDisplay" class="content-display-area">
    <h2>Welcome to Info Edit</h2>
    <p>This is your main content area. Click "Edit Content" above to modify this content with the rich text editor.</p>

    <h3>Features:</h3>
    <ul>
        <li><strong>Rich Text Editing</strong> - Format your text with HTML using Summernote editor</li>
        <li><strong>Easy to Use</strong> - Professional WYSIWYG interface</li>
        <li><strong>Flexible Content</strong> - Add any HTML content you need</li>
        <li><strong>Auto-Save</strong> - Content is automatically saved to localStorage</li>
        <li><strong>Cross-Page Sync</strong> - Changes appear on other pages instantly</li>
    </ul>

    <h3>Sample Content:</h3>
    <div class="alert alert-info">
        <h5><i class="fas fa-info-circle"></i> What you can add:</h5>
        <ul>
            <li>Text formatting (bold, italic, underline, colors)</li>
            <li>Lists and tables</li>
            <li>Links and images</li>
            <li>Custom styling with CSS classes</li>
            <li>Code blocks and quotes</li>
        </ul>
    </div>

    <p><em>Click "Edit Content" above to start customizing this page content!</em></p>
</div>

<!-- Content Statistics -->
<div class="content-stats">
    <div class="row">
        <div class="col-md-3">
            <div class="stat-item">
                <div class="stat-number" id="wordCount">0</div>
                <div class="stat-label">Words</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-item">
                <div class="stat-number" id="charCount">0</div>
                <div class="stat-label">Characters</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-item">
                <div class="stat-number" id="lastSaved">Never</div>
                <div class="stat-label">Last Saved</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-item">
                <div class="stat-number" id="contentStatus">Ready</div>
                <div class="stat-label">Status</div>
            </div>
        </div>
    </div>
</div>

<!-- Editor Section (Hidden by default) -->
<div id="editorSection" class="editor-section" style="display: none;">
    <h5><i class="fas fa-edit"></i> Edit Site Content</h5>
    <form class="siteinformation" accept-charset="UTF-8" autocomplete="off">
        <div class="form-group">
            <label for="htmlEditor">Content Editor</label>
            <textarea id="htmlEditor" name="htmlEditor"></textarea>
        </div>
        <div class="action-buttons">
            <button type="button" class="btn btn-success btn-save-content">
                <i class="fas fa-save"></i> Save Content
            </button>
            <button type="button" class="btn btn-info btn-preview">
                <i class="fas fa-eye"></i> Preview
            </button>
            <button type="button" class="btn btn-secondary btn-cancel-edit">
                <i class="fas fa-times"></i> Cancel
            </button>
            <button type="button" class="btn btn-warning btn-clear">
                <i class="fas fa-trash"></i> Clear All
            </button>
            <button type="button" class="btn btn-primary btn-export">
                <i class="fas fa-download"></i> Export HTML
            </button>
            <button type="button" class="btn btn-dark btn-import">
                <i class="fas fa-upload"></i> Import HTML
            </button>
            <button type="button" class="btn btn-warning btn-test-content">
                <i class="fas fa-flask"></i> Test Content
            </button>
            <button type="button" class="btn btn-info btn-quick-save">
                <i class="fas fa-bolt"></i> Quick Save
            </button>
        </div>
        
        <!-- HTML Templates Section -->
        <div class="mt-4">
            <h6><i class="fas fa-code"></i> HTML Templates</h6>
            <div class="btn-group-vertical w-100" role="group">
                <button type="button" class="btn btn-outline-primary btn-sm mb-2" onclick="insertTemplate('basic')">
                    <i class="fas fa-file-alt"></i> Basic Page Template
                </button>
                <button type="button" class="btn btn-outline-success btn-sm mb-2" onclick="insertTemplate('features')">
                    <i class="fas fa-list"></i> Features List Template
                </button>
                <button type="button" class="btn btn-outline-info btn-sm mb-2" onclick="insertTemplate('pricing')">
                    <i class="fas fa-tags"></i> Pricing Table Template
                </button>
                <button type="button" class="btn btn-outline-warning btn-sm mb-2" onclick="insertTemplate('updates')">
                    <i class="fas fa-bell"></i> Updates/News Template
                </button>
                <button type="button" class="btn btn-outline-danger btn-sm mb-2" onclick="insertTemplate('contact')">
                    <i class="fas fa-envelope"></i> Contact Info Template
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm mb-2" onclick="insertTemplate('telecom')">
                    <i class="fas fa-mobile-alt"></i> Telecom Services Template
                </button>
                <button type="button" class="btn btn-outline-dark btn-sm mb-2" onclick="insertTemplate('services')">
                    <i class="fas fa-cogs"></i> Services Grid Template
                </button>
                <button type="button" class="btn btn-outline-primary btn-sm mb-2" onclick="insertTemplate('team')">
                    <i class="fas fa-users"></i> Team/About Template
                </button>
                <button type="button" class="btn btn-outline-success btn-sm mb-2" onclick="insertTemplate('testimonials')">
                    <i class="fas fa-quote-left"></i> Testimonials Template
                </button>
                <button type="button" class="btn btn-outline-info btn-sm mb-2" onclick="insertTemplate('faq')">
                    <i class="fas fa-question-circle"></i> FAQ Template
                </button>
                <button type="button" class="btn btn-outline-warning btn-sm mb-2" onclick="insertTemplate('stats')">
                    <i class="fas fa-chart-bar"></i> Statistics Template
                </button>
                <button type="button" class="btn btn-outline-danger btn-sm mb-2" onclick="insertTemplate('hero')">
                    <i class="fas fa-star"></i> Hero Section Template
                </button>
            </div>
            
            <!-- Bengali VPN Templates Section -->
            <h6 class="mt-3"><i class="fas fa-shield-alt"></i> Bengali VPN Templates</h6>
            <div class="btn-group-vertical w-100" role="group">
                <button type="button" class="btn btn-outline-primary btn-sm mb-2" onclick="insertTemplate('vpn_bangla_welcome')">
                    <i class="fas fa-home"></i> VPN স্বাগতম পেজ
                </button>
                <button type="button" class="btn btn-outline-success btn-sm mb-2" onclick="insertTemplate('vpn_bangla_packages')">
                    <i class="fas fa-box"></i> VPN প্যাকেজ তালিকা
                </button>
                <button type="button" class="btn btn-outline-info btn-sm mb-2" onclick="insertTemplate('vpn_bangla_features')">
                    <i class="fas fa-list-check"></i> VPN ফিচার সমূহ
                </button>
                <button type="button" class="btn btn-outline-warning btn-sm mb-2" onclick="insertTemplate('vpn_bangla_setup')">
                    <i class="fas fa-cog"></i> VPN সেটআপ গাইড
                </button>
                <button type="button" class="btn btn-outline-danger btn-sm mb-2" onclick="insertTemplate('vpn_bangla_support')">
                    <i class="fas fa-headset"></i> VPN সাপোর্ট তথ্য
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm mb-2" onclick="insertTemplate('vpn_bangla_pricing')">
                    <i class="fas fa-money-bill"></i> VPN মূল্য তালিকা
                </button>
            </div>
            
            <!-- Multiple Template Functions -->
            <h6 class="mt-3"><i class="fas fa-layer-group"></i> Multiple Templates</h6>
            <div class="btn-group-vertical w-100" role="group">
                <button type="button" class="btn btn-outline-primary btn-sm mb-2" onclick="insertMultipleTemplates(['vpn_bangla_welcome', 'vpn_bangla_packages', 'vpn_bangla_features'])">
                    <i class="fas fa-plus-circle"></i> Complete VPN Page (Bengali)
                </button>
                <button type="button" class="btn btn-outline-success btn-sm mb-2" onclick="insertMultipleTemplates(['basic', 'features', 'pricing'])">
                    <i class="fas fa-plus-circle"></i> Business Package (English)
                </button>
                <button type="button" class="btn btn-outline-info btn-sm mb-2" onclick="insertMultipleTemplates(['hero', 'services', 'testimonials', 'contact'])">
                    <i class="fas fa-plus-circle"></i> Full Website Template
                </button>
                <button type="button" class="btn btn-outline-warning btn-sm mb-2" onclick="clearAndInsertMultiple(['vpn_bangla_welcome', 'vpn_bangla_setup', 'vpn_bangla_support'])">
                    <i class="fas fa-refresh"></i> VPN Help Center (Bengali)
                </button>
            </div>
        </div>
    </form>
</div>

</div>
</div>
</div>
</div>
</div>
</section>
</div>

</div>

<!-- Import HTML Modal -->
<div class="modal fade" id="importModal" tabindex="-1" role="dialog">
<div class="modal-dialog modal-lg" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">
<i class="fas fa-upload"></i> Import HTML Content
</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<div class="form-group">
<label for="importTextarea">Paste HTML Content:</label>
<textarea class="form-control" id="importTextarea" rows="10" placeholder="Paste your HTML content here..."></textarea>
</div>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
<button type="button" class="btn btn-primary" id="importConfirm">Import</button>
</div>
</div>
</div>
</div>

<!-- Export HTML Modal -->
<div class="modal fade" id="exportModal" tabindex="-1" role="dialog">
<div class="modal-dialog modal-lg" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">
<i class="fas fa-download"></i> Export HTML Content
</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<div class="form-group">
<label for="exportTextarea">HTML Content:</label>
<textarea class="form-control" id="exportTextarea" rows="10" readonly></textarea>
</div>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
<button type="button" class="btn btn-primary" id="copyToClipboard">Copy to Clipboard</button>
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

<script>
$(document).ready(function() {
    var editorInitialized = false;
    
    // Check if button exists
    if ($('#toggleEditor').length) {
        $('#toggleEditor').on('click', function(e) {
            e.preventDefault();
        });
    }
    
    // Initialize Summernote HTML Editor
    function initializeEditor() {
        if (!editorInitialized) {
            $('#htmlEditor').summernote({
                height: 400,
                minHeight: null,
                maxHeight: null,
                focus: false,
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'italic', 'underline', 'clear']],
                    ['fontname', ['fontname']],
                    ['fontsize', ['fontsize']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link', 'picture', 'video']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ],
                callbacks: {
                    onChange: function(contents, $editable) {
                        updateContentStats(contents);
                    }
                }
            });
            editorInitialized = true;
        }
    }
    
    // Update content statistics
    function updateContentStats(content) {
        var text = $('<div>').html(content).text();
        var wordCount = text.trim() ? text.trim().split(/\s+/).length : 0;
        var charCount = text.length;
        
        $('#wordCount').text(wordCount);
        $('#charCount').text(charCount);
        $('#contentStatus').text('Modified');
    }
    
    // Toggle Editor Button - Use event delegation for dynamic ID changes
    $(document).on('click', '#toggleEditor', function() {
        initializeEditor();
        
        // Get current content from display area
        var currentContent = $('#contentDisplay').html();
        $('#htmlEditor').summernote('code', currentContent);
        
        // Show editor section
        $('#editorSection').slideDown();
        $('#contentDisplay').hide();
        
        // Update button text
        $(this).html('<i class="fas fa-eye"></i> View Content');
        $(this).attr('id', 'viewContent');
        
        // Update stats
        updateContentStats(currentContent);
        
    });
    
    // View Content Button (when in edit mode)
    $(document).on('click', '#viewContent', function() {
        // Hide editor section
        $('#editorSection').slideUp();
        $('#contentDisplay').show();
        
        // Update button text
        $(this).html('<i class="fas fa-edit"></i> Edit Content');
        $(this).attr('id', 'toggleEditor');
    });
    
    // Save Content Button
    $('.btn-save-content').click(function() {
        var htmlContent = $('#htmlEditor').summernote('code');
        
        // Update the display area
        $('#contentDisplay').html(htmlContent);
        
        // Store in localStorage with error handling
        try {
            localStorage.setItem('htmlEditorContent', htmlContent);
            localStorage.setItem('lastSaved', new Date().toLocaleString());
            
            // Trigger storage event for other tabs/pages
            window.dispatchEvent(new StorageEvent('storage', {
                key: 'htmlEditorContent',
                newValue: htmlContent,
                storageArea: localStorage
            }));
            
        } catch (error) {
            console.error('❌ Error saving to localStorage:', error);
        }
        
        // Update stats
        $('#lastSaved').text(new Date().toLocaleString());
        $('#contentStatus').text('Saved');
        
        // Hide editor and show content
        $('#editorSection').slideUp();
        $('#contentDisplay').show();
        
        // Update button text
        $('#viewContent').html('<i class="fas fa-edit"></i> Edit Content');
        $('#viewContent').attr('id', 'toggleEditor');
        
        // Show success message
        Swal.fire({
            icon: 'success',
            title: 'Content Saved!',
            text: 'Your content has been saved and updated.',
            timer: 2000,
            showConfirmButton: false
        });
    });
    
    // Preview Button
    $('.btn-preview').click(function() {
        var htmlContent = $('#htmlEditor').summernote('code');
        
        Swal.fire({
            title: 'Content Preview',
            html: htmlContent,
            width: '80%',
            showCloseButton: true,
            showConfirmButton: false,
            customClass: {
                popup: 'preview-popup'
            }
        });
    });
    
    // Cancel Edit Button
    $('.btn-cancel-edit').click(function() {
        // Hide editor section
        $('#editorSection').slideUp();
        $('#contentDisplay').show();
        
        // Update button text
        $('#viewContent').html('<i class="fas fa-edit"></i> Edit Content');
        $('#viewContent').attr('id', 'toggleEditor');
        
        $('#contentStatus').text('Ready');
    });
    
    // Clear Button
    $('.btn-clear').click(function() {
        Swal.fire({
            title: 'Are you sure?',
            text: "This will clear all your content!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Yes, clear it!'
        }).then((result) => {
            if (result.isConfirmed) {
                $('#htmlEditor').summernote('code', '');
                $('#contentDisplay').html('<p><em>Content cleared. Click "Edit Content" to add new content.</em></p>');
                localStorage.removeItem('htmlEditorContent');
                
                // Update stats
                $('#wordCount').text('0');
                $('#charCount').text('0');
                $('#contentStatus').text('Cleared');
                
                Swal.fire(
                    'Cleared!',
                    'Your content has been cleared.',
                    'success'
                );
            }
        });
    });
    
    // Export Button
    $('.btn-export').click(function() {
        var htmlContent = $('#htmlEditor').summernote('code');
        $('#exportTextarea').val(htmlContent);
        $('#exportModal').modal('show');
    });
    
    // Import Button
    $('.btn-import').click(function() {
        $('#importModal').modal('show');
    });
    
    // Import Confirm
    $('#importConfirm').click(function() {
        var importedContent = $('#importTextarea').val();
        if (importedContent.trim()) {
            $('#htmlEditor').summernote('code', importedContent);
            updateContentStats(importedContent);
            $('#importModal').modal('hide');
            $('#importTextarea').val('');
            
            Swal.fire({
                icon: 'success',
                title: 'Content Imported!',
                text: 'HTML content has been imported successfully.',
                timer: 2000,
                showConfirmButton: false
            });
        }
    });
    
    // Copy to Clipboard
    $('#copyToClipboard').click(function() {
        var content = $('#exportTextarea').val();
        navigator.clipboard.writeText(content).then(function() {
            Swal.fire({
                icon: 'success',
                title: 'Copied!',
                text: 'Content copied to clipboard.',
                timer: 1500,
                showConfirmButton: false
            });
        });
    });
    
    // Test Content Button - Create sample content for testing
    $('.btn-test-content').click(function() {
        var testContent = 
            '<h2>🚀 Test Content from Info Edit</h2>' +
            '<p>This is <strong>sample content</strong> created from the Info Edit page HTML editor.</p>' +
            '<div class="alert alert-success">' +
                '<h5><i class="fas fa-check-circle"></i> Success!</h5>' +
                '<p>If you can see this content on the Update page, the synchronization is working perfectly!</p>' +
            '</div>' +
            '<ul>' +
                '<li>✅ HTML formatting preserved</li>' +
                '<li>✅ Real-time synchronization</li>' +
                '<li>✅ Cross-page content display</li>' +
            '</ul>' +
            '<p><em>Created at: ' + new Date().toLocaleString() + '</em></p>';
        
        // Initialize editor if not already done
        initializeEditor();
        
        // Set content in editor
        $('#htmlEditor').summernote('code', testContent);
        
        // Save the content directly
        try {
            localStorage.setItem('htmlEditorContent', testContent);
            localStorage.setItem('lastSaved', new Date().toLocaleString());
            
            // Update display
            $('#contentDisplay').html(testContent);
            
            // Update stats
            updateContentStats(testContent);
            $('#lastSaved').text(new Date().toLocaleString());
            $('#contentStatus').text('Saved');
            
            // Trigger storage event
            window.dispatchEvent(new StorageEvent('storage', {
                key: 'htmlEditorContent',
                newValue: testContent,
                storageArea: localStorage
            }));
            
            
            // Show success message
            Swal.fire({
                icon: 'success',
                title: 'Test Content Created!',
                text: 'Content saved and should appear on Update page.',
                timer: 2000,
                showConfirmButton: false
            });
            
        } catch (error) {
            console.error('❌ Error saving test content:', error);
        }
    });
    
    // Quick Save Button - Direct localStorage save without editor
    $('.btn-quick-save').click(function() {
        var quickContent = '<h1>Quick Save Test</h1><p>This is a simple test to verify localStorage is working. Time: ' + new Date().toLocaleString() + '</p>';
        
        try {
            localStorage.setItem('htmlEditorContent', quickContent);
            localStorage.setItem('lastSaved', new Date().toLocaleString());
            
            // Update display
            $('#contentDisplay').html(quickContent);
            
            // Trigger storage event
            window.dispatchEvent(new StorageEvent('storage', {
                key: 'htmlEditorContent',
                newValue: quickContent,
                storageArea: localStorage
            }));
            
            
            Swal.fire({
                icon: 'success',
                title: 'Quick Save!',
                text: 'Simple content saved to localStorage.',
                timer: 1500,
                showConfirmButton: false
            });
            
        } catch (error) {
            console.error('❌ Quick save failed:', error);
        }
    });
    
    // Load saved content from localStorage on page load
    function loadSavedContent() {
        try {
            var savedContent = localStorage.getItem('htmlEditorContent');
            var lastSaved = localStorage.getItem('lastSaved');
            
            
            if (savedContent && savedContent.trim() !== '') {
                $('#contentDisplay').html(savedContent);
                updateContentStats(savedContent);
                
                if (lastSaved) {
                    $('#lastSaved').text(lastSaved);
                    $('#contentStatus').text('Loaded');
                }
            } else {
            }
        } catch (error) {
            console.error('❌ Error loading saved content:', error);
        }
    }
    
    // Load content on page load
    loadSavedContent();
    
    // Auto-create test content if none exists (for testing)
    setTimeout(function() {
        var existingContent = localStorage.getItem('htmlEditorContent');
        if (!existingContent || existingContent.trim() === '') {
            
            var defaultContent = '<h2>🚀 Welcome to Info Edit</h2><p>This content is automatically synced to the <strong>Update page</strong>.</p><div class="alert alert-success"><h5>✅ Synchronization Active</h5><p>Any changes made here will appear on the Update page instantly!</p></div><p><em>Last updated: ' + new Date().toLocaleString() + '</em></p>';
            
            try {
                localStorage.setItem('htmlEditorContent', defaultContent);
                localStorage.setItem('lastSaved', new Date().toLocaleString());
                
                // Update display
                $('#contentDisplay').html(defaultContent);
                updateContentStats(defaultContent);
                $('#lastSaved').text(new Date().toLocaleString());
                $('#contentStatus').text('Auto-Created');
                
                // Trigger storage event
                window.dispatchEvent(new StorageEvent('storage', {
                    key: 'htmlEditorContent',
                    newValue: defaultContent,
                    storageArea: localStorage
                }));
                
                
            } catch (error) {
                console.error('❌ Error creating default content:', error);
            }
        }
    }, 1000);
    
    // Listen for storage changes (when content is updated from other pages)
    window.addEventListener('storage', function(e) {
        if (e.key === 'htmlEditorContent') {
            loadSavedContent();
        }
    });
    
    // HTML Template Insertion Functions
    window.insertTemplate = function(templateType) {
        var templates = {
            'basic': `
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">সাইট তথ্য-এ স্বাগতম</h2>
                    </div>
                    <div class="card-body">
                        <p>Welcome to our platform. This is a basic page template with essential information.</p>
                        
                        <h4>About Us</h4>
                        <p>We provide reliable and fast services to our customers across the region.</p>
                        
                        <h4>Our Mission</h4>
                        <p>To deliver exceptional service quality and customer satisfaction.</p>
                    </div>
                </div>
            `,
            
            'features': `
                <div class="card card-success">
                    <div class="card-header">
                        <h2 class="card-title">🚀 Platform Features</h2>
                    </div>
                    <div class="card-body">
                        <h4>Key Features:</h4>
                        <ul>
                            <li><strong>High Speed</strong> - Lightning fast performance</li>
                            <li><strong>Reliable</strong> - 99.9% uptime guarantee</li>
                            <li><strong>Secure</strong> - Enterprise-grade security</li>
                            <li><strong>24/7 Support</strong> - Round-the-clock assistance</li>
                        </ul>
                        
                        <div class="alert alert-success">
                            <h5>✅ Why Choose Us?</h5>
                            <p class="mb-0">We offer the best combination of speed, reliability, and customer service in the industry.</p>
                        </div>
                    </div>
                </div>
            `,
            
            'pricing': `
                <div class="card card-primary">
                    <div class="card-header">
                        <h2 class="card-title">💰 Pricing Plans</h2>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card card-outline-primary">
                                    <div class="card-header">
                                        <h4 class="card-title">Basic Plan</h4>
                                    </div>
                                    <div class="card-body">
                                        <h3 class="text-primary">$10/month</h3>
                                        <ul>
                                            <li>Basic features</li>
                                            <li>Email support</li>
                                            <li>1GB storage</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card card-outline-success">
                                    <div class="card-header">
                                        <h4 class="card-title">Premium Plan</h4>
                                    </div>
                                    <div class="card-body">
                                        <h3 class="text-success">$25/month</h3>
                                        <ul>
                                            <li>All features</li>
                                            <li>Priority support</li>
                                            <li>10GB storage</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'updates': `
                <div class="card card-warning">
                    <div class="card-header">
                        <h2 class="card-title">📢 Latest Updates</h2>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <h5>✅ System Updates</h5>
                            <ul class="mb-0">
                                <li>Performance improvements implemented</li>
                                <li>New features added to dashboard</li>
                                <li>Security patches applied</li>
                            </ul>
                        </div>
                        
                        <h4>Recent News:</h4>
                        <ul>
                            <li><strong>New Server Location</strong> - Added servers in Asia-Pacific region</li>
                            <li><strong>Mobile App Update</strong> - Version 2.0 now available</li>
                            <li><strong>Customer Portal</strong> - Enhanced user interface launched</li>
                        </ul>
                    </div>
                </div>
            `,
            
            'contact': `
                <div class="card card-danger">
                    <div class="card-header">
                        <h2 class="card-title">📞 Contact Information</h2>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-light">
                            <h4>Get in Touch</h4>
                            <div class="row">
                                <div class="col-md-4">
                                    <h5><i class="fas fa-envelope"></i> Email</h5>
                                    <p>support@example.com</p>
                                </div>
                                <div class="col-md-4">
                                    <h5><i class="fas fa-phone"></i> Phone</h5>
                                    <p>+1 (555) 123-4567</p>
                                </div>
                                <div class="col-md-4">
                                    <h5><i class="fas fa-clock"></i> Hours</h5>
                                    <p>24/7 Support Available</p>
                                </div>
                            </div>
                        </div>
                        
                        <h4>Support Channels:</h4>
                        <ul>
                            <li>Live Chat (Available 24/7)</li>
                            <li>Email Support</li>
                            <li>Phone Support</li>
                            <li>Knowledge Base</li>
                        </ul>
                    </div>
                </div>
            `,
            
            'telecom': `
                <div class="card card-secondary">
                    <div class="card-header">
                        <h2 class="card-title">📱 Telecom Services</h2>
                    </div>
                    <div class="card-body">
                        <p><span class="text-warning">🔥</span> <strong>Premium Network Services</strong></p>
                        
                        <h4>Available Packages:</h4>
                        <ul>
                            <li><strong>Mobily</strong> - 30 SR & 60 SR Packages</li>
                            <li><strong>Lebara</strong> - SIM Free Options</li>
                            <li><strong>Salam SIM</strong> - Free Activation</li>
                            <li><strong>STC</strong> - High-speed data plans</li>
                        </ul>
                        
                        <p class="text-success"><strong>কোন প্রকার সার্ভার আপডেট নিয়ে ঝামেলা নাই</strong></p>
                        
                        <div class="alert alert-info">
                            <h5>✅ Service Status</h5>
                            <ul class="mb-0">
                                <li>All networks operational</li>
                                <li>No service interruptions</li>
                                <li>24/7 monitoring active</li>
                            </ul>
                        </div>
                        
                        <h4>Benefits:</h4>
                        <ul>
                            <li>Fast activation</li>
                            <li>Competitive pricing</li>
                            <li>Reliable network coverage</li>
                            <li>Customer support in multiple languages</li>
                        </ul>
                    </div>
                </div>
            `,
            
            'services': `
                <div class="card card-dark">
                    <div class="card-header">
                        <h2 class="card-title">🔧 Our Services</h2>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="card card-outline-primary">
                                    <div class="card-body text-center">
                                        <i class="fas fa-server fa-3x text-primary mb-3"></i>
                                        <h5>Web Hosting</h5>
                                        <p>Reliable and fast web hosting solutions</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="card card-outline-success">
                                    <div class="card-body text-center">
                                        <i class="fas fa-shield-alt fa-3x text-success mb-3"></i>
                                        <h5>Security</h5>
                                        <p>Advanced security and protection services</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="card card-outline-info">
                                    <div class="card-body text-center">
                                        <i class="fas fa-headset fa-3x text-info mb-3"></i>
                                        <h5>Support</h5>
                                        <p>24/7 customer support and assistance</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'team': `
                <div class="card card-primary">
                    <div class="card-header">
                        <h2 class="card-title">👥 Our Team</h2>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 text-center mb-4">
                                <div class="card">
                                    <div class="card-body">
                                        <i class="fas fa-user-circle fa-4x text-primary mb-3"></i>
                                        <h5>John Doe</h5>
                                        <p class="text-muted">CEO & Founder</p>
                                        <p>Leading the company with vision and innovation</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-center mb-4">
                                <div class="card">
                                    <div class="card-body">
                                        <i class="fas fa-user-circle fa-4x text-success mb-3"></i>
                                        <h5>Jane Smith</h5>
                                        <p class="text-muted">CTO</p>
                                        <p>Technical expertise and system architecture</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-center mb-4">
                                <div class="card">
                                    <div class="card-body">
                                        <i class="fas fa-user-circle fa-4x text-info mb-3"></i>
                                        <h5>Mike Johnson</h5>
                                        <p class="text-muted">Support Manager</p>
                                        <p>Ensuring excellent customer service</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'testimonials': `
                <div class="card card-success">
                    <div class="card-header">
                        <h2 class="card-title">💬 Customer Testimonials</h2>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="alert alert-light">
                                    <blockquote class="blockquote mb-0">
                                        <p>"Excellent service and support. Highly recommended!"</p>
                                        <footer class="blockquote-footer">Ahmed Ali <cite title="Source Title">Business Owner</cite></footer>
                                    </blockquote>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="alert alert-light">
                                    <blockquote class="blockquote mb-0">
                                        <p>"Fast, reliable, and professional service."</p>
                                        <footer class="blockquote-footer">Sarah Khan <cite title="Source Title">Developer</cite></footer>
                                    </blockquote>
                                </div>
                            </div>
                        </div>
                        <div class="text-center">
                            <div class="alert alert-success">
                                <h5>⭐⭐⭐⭐⭐ 5/5 Rating</h5>
                                <p class="mb-0">Based on 500+ customer reviews</p>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'faq': `
                <div class="card card-info">
                    <div class="card-header">
                        <h2 class="card-title">❓ Frequently Asked Questions</h2>
                    </div>
                    <div class="card-body">
                        <div class="accordion" id="faqAccordion">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <button class="btn btn-link" type="button">
                                            How do I get started?
                                        </button>
                                    </h5>
                                </div>
                                <div class="card-body">
                                    Simply sign up for an account and follow our quick setup guide.
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <button class="btn btn-link" type="button">
                                            What payment methods do you accept?
                                        </button>
                                    </h5>
                                </div>
                                <div class="card-body">
                                    We accept all major credit cards, PayPal, and bank transfers.
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <button class="btn btn-link" type="button">
                                            Is there a money-back guarantee?
                                        </button>
                                    </h5>
                                </div>
                                <div class="card-body">
                                    Yes, we offer a 30-day money-back guarantee on all plans.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'stats': `
                <div class="card card-warning">
                    <div class="card-header">
                        <h2 class="card-title">📊 Our Statistics</h2>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-3 mb-3">
                                <div class="card card-outline-primary">
                                    <div class="card-body">
                                        <h2 class="text-primary">10,000+</h2>
                                        <p>Happy Customers</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card card-outline-success">
                                    <div class="card-body">
                                        <h2 class="text-success">99.9%</h2>
                                        <p>Uptime</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card card-outline-info">
                                    <div class="card-body">
                                        <h2 class="text-info">24/7</h2>
                                        <p>Support</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card card-outline-warning">
                                    <div class="card-body">
                                        <h2 class="text-warning">5 Years</h2>
                                        <p>Experience</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'hero': `
                <div class="card card-danger">
                    <div class="card-header">
                        <h2 class="card-title">🌟 Hero Section</h2>
                    </div>
                    <div class="card-body text-center">
                        <h1 class="display-4">Welcome to Our Platform</h1>
                        <p class="lead">Experience the best service with cutting-edge technology</p>
                        
                        <div class="alert alert-primary">
                            <h4>🚀 Get Started Today!</h4>
                            <p>Join thousands of satisfied customers worldwide</p>
                            <button class="btn btn-success btn-lg">Start Free Trial</button>
                            <button class="btn btn-outline-primary btn-lg ml-2">Learn More</button>
                        </div>
                        
                        <div class="row mt-4">
                            <div class="col-md-4">
                                <i class="fas fa-rocket fa-3x text-primary mb-3"></i>
                                <h5>Fast & Reliable</h5>
                                <p>Lightning-fast performance you can count on</p>
                            </div>
                            <div class="col-md-4">
                                <i class="fas fa-shield-alt fa-3x text-success mb-3"></i>
                                <h5>Secure & Safe</h5>
                                <p>Enterprise-grade security for your peace of mind</p>
                            </div>
                            <div class="col-md-4">
                                <i class="fas fa-headset fa-3x text-info mb-3"></i>
                                <h5>24/7 Support</h5>
                                <p>Round-the-clock support whenever you need it</p>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            // Bengali VPN Templates
            'vpn_bangla_welcome': `
                <div class="card card-primary">
                    <div class="card-header">
                        <h2 class="card-title">🛡️ VPN সেবায় স্বাগতম</h2>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <h3 class="text-primary">নিরাপদ ও দ্রুত ইন্টারনেট সংযোগ</h3>
                            <p class="lead">আমাদের প্রিমিয়াম VPN সেবা দিয়ে আপনার অনলাইন নিরাপত্তা নিশ্চিত করুন</p>
                        </div>
                        
                        <div class="alert alert-success">
                            <h5>🔥 বিশেষ অফার!</h5>
                            <p class="mb-0">এখনই সাইন আপ করুন এবং ৩০% ছাড় পান। সীমিত সময়ের জন্য!</p>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <i class="fas fa-shield-alt fa-3x text-success mb-3"></i>
                                <h5>সম্পূর্ণ নিরাপত্তা</h5>
                                <p>আপনার ডেটা সুরক্ষিত রাখুন</p>
                            </div>
                            <div class="col-md-4 text-center">
                                <i class="fas fa-globe fa-3x text-info mb-3"></i>
                                <h5>বিশ্বব্যাপী সার্ভার</h5>
                                <p>৫০+ দেশে সার্ভার</p>
                            </div>
                            <div class="col-md-4 text-center">
                                <i class="fas fa-bolt fa-3x text-warning mb-3"></i>
                                <h5>দ্রুত গতি</h5>
                                <p>কোন গতি হ্রাস নেই</p>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'vpn_bangla_packages': `
                <div class="card card-success">
                    <div class="card-header">
                        <h2 class="card-title">📦 VPN প্যাকেজ সমূহ</h2>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="card card-outline-primary">
                                    <div class="card-header text-center">
                                        <h4>বেসিক প্ল্যান</h4>
                                        <h3 class="text-primary">৫০০ টাকা/মাস</h3>
                                    </div>
                                    <div class="card-body">
                                        <ul>
                                            <li>✅ ১টি ডিভাইস</li>
                                            <li>✅ ১০+ সার্ভার লোকেশন</li>
                                            <li>✅ ২৪/৭ সাপোর্ট</li>
                                            <li>✅ মাসিক ১০০ জিবি ডেটা</li>
                                        </ul>
                                        <button class="btn btn-primary btn-block">অর্ডার করুন</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card card-outline-success">
                                    <div class="card-header text-center">
                                        <h4>প্রিমিয়াম প্ল্যান</h4>
                                        <h3 class="text-success">১০০০ টাকা/মাস</h3>
                                    </div>
                                    <div class="card-body">
                                        <ul>
                                            <li>✅ ৫টি ডিভাইস</li>
                                            <li>✅ ৫০+ সার্ভার লোকেশন</li>
                                            <li>✅ প্রাইওরিটি সাপোর্ট</li>
                                            <li>✅ আনলিমিটেড ডেটা</li>
                                        </ul>
                                        <button class="btn btn-success btn-block">অর্ডার করুন</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card card-outline-warning">
                                    <div class="card-header text-center">
                                        <h4>বিজনেস প্ল্যান</h4>
                                        <h3 class="text-warning">২০০০ টাকা/মাস</h3>
                                    </div>
                                    <div class="card-body">
                                        <ul>
                                            <li>✅ আনলিমিটেড ডিভাইস</li>
                                            <li>✅ সব সার্ভার</li>
                                            <li>✅ ডেডিকেটেড সাপোর্ট</li>
                                            <li>✅ কাস্টম কনফিগারেশন</li>
                                        </ul>
                                        <button class="btn btn-warning btn-block">অর্ডার করুন</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'vpn_bangla_features': `
                <div class="card card-info">
                    <div class="card-header">
                        <h2 class="card-title">⭐ VPN এর বিশেষ ফিচার সমূহ</h2>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h4>🔒 নিরাপত্তা ফিচার</h4>
                                <ul>
                                    <li><strong>AES-256 এনক্রিপশন</strong> - সর্বোচ্চ নিরাপত্তা</li>
                                    <li><strong>Kill Switch</strong> - সংযোগ বিচ্ছিন্ন হলে ইন্টারনেট বন্ধ</li>
                                    <li><strong>DNS লিক প্রোটেকশন</strong> - আপনার পরিচয় গোপন</li>
                                    <li><strong>No-Log Policy</strong> - কোন ডেটা সংরক্ষণ করা হয় না</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h4>🌐 কানেক্টিভিটি ফিচার</h4>
                                <ul>
                                    <li><strong>৫০+ দেশে সার্ভার</strong> - বিশ্বব্যাপী অ্যাক্সেস</li>
                                    <li><strong>আনলিমিটেড ব্যান্ডউইথ</strong> - কোন সীমাবদ্ধতা নেই</li>
                                    <li><strong>P2P সাপোর্ট</strong> - টরেন্ট ডাউনলোড</li>
                                    <li><strong>স্ট্রিমিং অপটিমাইজড</strong> - নেটফ্লিক্স, ইউটিউব</li>
                                </ul>
                            </div>
                        </div>
                        
                        <div class="alert alert-primary mt-3">
                            <h5>🎯 কেন আমাদের VPN বেছে নিবেন?</h5>
                            <p class="mb-0">আমরা বাংলাদেশের সবচেয়ে দ্রুত ও নিরাপদ VPN সেবা প্রদান করি। আমাদের রয়েছে ২৪/৭ বাংলা সাপোর্ট এবং সাশ্রয়ী মূল্য।</p>
                        </div>
                    </div>
                </div>
            `,
            
            'vpn_bangla_setup': `
                <div class="card card-warning">
                    <div class="card-header">
                        <h2 class="card-title">⚙️ VPN সেটআপ গাইড</h2>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <h5>📱 মোবাইলে VPN সেটআপ (Android/iOS)</h5>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <h4>📱 Android সেটআপ</h4>
                                <ol>
                                    <li>Google Play Store থেকে আমাদের অ্যাপ ডাউনলোড করুন</li>
                                    <li>অ্যাপ খুলে আপনার একাউন্ট দিয়ে লগইন করুন</li>
                                    <li>পছন্দের সার্ভার লোকেশন নির্বাচন করুন</li>
                                    <li>"Connect" বাটনে ক্লিক করুন</li>
                                    <li>VPN সংযোগ সফল হলে নোটিফিকেশন দেখবেন</li>
                                </ol>
                            </div>
                            <div class="col-md-6">
                                <h4>🍎 iOS সেটআপ</h4>
                                <ol>
                                    <li>App Store থেকে আমাদের অ্যাপ ডাউনলোড করুন</li>
                                    <li>অ্যাপ খুলে আপনার একাউন্ট দিয়ে লগইন করুন</li>
                                    <li>VPN প্রোফাইল ইনস্টল করার অনুমতি দিন</li>
                                    <li>সার্ভার নির্বাচন করে কানেক্ট করুন</li>
                                    <li>স্ট্যাটাস বারে VPN আইকন দেখবেন</li>
                                </ol>
                            </div>
                        </div>
                        
                        <div class="alert alert-success mt-3">
                            <h5>💻 Windows/Mac সেটআপ</h5>
                            <p>আমাদের ওয়েবসাইট থেকে ডেস্কটপ অ্যাপ ডাউনলোড করুন এবং একই পদ্ধতি অনুসরণ করুন।</p>
                        </div>
                        
                        <div class="text-center">
                            <button class="btn btn-primary btn-lg">অ্যাপ ডাউনলোড করুন</button>
                            <button class="btn btn-outline-info btn-lg ml-2">ভিডিও টিউটোরিয়াল দেখুন</button>
                        </div>
                    </div>
                </div>
            `,
            
            'vpn_bangla_support': `
                <div class="card card-danger">
                    <div class="card-header">
                        <h2 class="card-title">🎧 VPN সাপোর্ট ও সহায়তা</h2>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-primary">
                            <h5>📞 ২৪/৭ বাংলা সাপোর্ট</h5>
                            <p class="mb-0">আমাদের দক্ষ টিম সর্বদা আপনার সেবায় নিয়োজিত</p>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4">
                                <div class="card card-outline-success">
                                    <div class="card-body text-center">
                                        <i class="fas fa-comments fa-3x text-success mb-3"></i>
                                        <h5>লাইভ চ্যাট</h5>
                                        <p>তাৎক্ষণিক সহায়তা</p>
                                        <button class="btn btn-success">চ্যাট শুরু করুন</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card card-outline-info">
                                    <div class="card-body text-center">
                                        <i class="fas fa-envelope fa-3x text-info mb-3"></i>
                                        <h5>ইমেইল সাপোর্ট</h5>
                                        <p>support@vpnbangla.com</p>
                                        <button class="btn btn-info">ইমেইল পাঠান</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card card-outline-warning">
                                    <div class="card-body text-center">
                                        <i class="fas fa-phone fa-3x text-warning mb-3"></i>
                                        <h5>ফোন সাপোর্ট</h5>
                                        <p>+৮৮০ ১৭১২-৩৪৫৬৭৮</p>
                                        <button class="btn btn-warning">কল করুন</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <h4 class="mt-4">❓ সাধারণ সমস্যা ও সমাধান</h4>
                        <div class="accordion">
                            <div class="card">
                                <div class="card-header">
                                    <h6>VPN কানেক্ট হচ্ছে না</h6>
                                </div>
                                <div class="card-body">
                                    ইন্টারনেট সংযোগ চেক করুন এবং অ্যাপ রিস্টার্ট করুন।
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <h6>ইন্টারনেট স্পিড কম</h6>
                                </div>
                                <div class="card-body">
                                    নিকটবর্তী সার্ভার নির্বাচন করুন বা প্রোটোকল পরিবর্তন করুন।
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `,
            
            'vpn_bangla_pricing': `
                <div class="card card-secondary">
                    <div class="card-header">
                        <h2 class="card-title">💰 VPN মূল্য তালিকা ও অফার</h2>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-warning text-center">
                            <h4>🎉 বিশেষ ছাড়! সীমিত সময়ের জন্য</h4>
                            <p class="mb-0">বার্ষিক প্ল্যানে ৫০% পর্যন্ত ছাড়</p>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <h4>📅 মাসিক প্ল্যান</h4>
                                <ul class="list-group">
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>বেসিক প্ল্যান</span>
                                        <strong>৫০০ টাকা/মাস</strong>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>প্রিমিয়াম প্ল্যান</span>
                                        <strong>১০০০ টাকা/মাস</strong>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>বিজনেস প্ল্যান</span>
                                        <strong>২০০০ টাকা/মাস</strong>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h4>📆 বার্ষিক প্ল্যান (৫০% ছাড়)</h4>
                                <ul class="list-group">
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>বেসিক প্ল্যান</span>
                                        <strong>৩০০০ টাকা/বছর</strong>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>প্রিমিয়াম প্ল্যান</span>
                                        <strong>৬০০০ টাকা/বছর</strong>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>বিজনেস প্ল্যান</span>
                                        <strong>১২০০০ টাকা/বছর</strong>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        
                        <div class="alert alert-success mt-3">
                            <h5>💳 পেমেন্ট অপশন</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <ul>
                                        <li>বিকাশ, নগদ, রকেট</li>
                                        <li>ব্যাংক ট্রান্সফার</li>
                                        <li>ক্রেডিট/ডেবিট কার্ড</li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <ul>
                                        <li>৭ দিনের মানি-ব্যাক গ্যারান্টি</li>
                                        <li>ফ্রি ট্রায়াল উপলব্ধ</li>
                                        <li>কোন লুকানো চার্জ নেই</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `
        };
        
        var template = templates[templateType];
        if (template) {
            // Insert template into Summernote editor
            $('#htmlEditor').summernote('code', template);
            
            // Show success message
            Swal.fire({
                icon: 'success',
                title: 'Template Inserted!',
                text: 'The ' + templateType + ' template has been added to the editor.',
                timer: 2000,
                showConfirmButton: false
            });
            
        }
    };
    
    
    // Function to insert multiple templates
    window.insertMultipleTemplates = function(templateTypes) {
        if (!Array.isArray(templateTypes) || templateTypes.length === 0) {
            console.error('❌ Invalid template types array');
            return;
        }
        
        var combinedContent = '';
        var validTemplates = [];
        
        // Get all templates
        var templates = {
            'basic': `<div class="card"><div class="card-header"><h2 class="card-title">সাইট তথ্য-এ স্বাগতম</h2></div><div class="card-body"><p>Welcome to our platform. This is a basic page template with essential information.</p><h4>About Us</h4><p>We provide reliable and fast services to our customers across the region.</p><h4>Our Mission</h4><p>To deliver exceptional service quality and customer satisfaction.</p></div></div>`,
            'features': `<div class="card card-success"><div class="card-header"><h2 class="card-title">🚀 Platform Features</h2></div><div class="card-body"><h4>Key Features:</h4><ul><li><strong>High Speed</strong> - Lightning fast performance</li><li><strong>Reliable</strong> - 99.9% uptime guarantee</li><li><strong>Secure</strong> - Enterprise-grade security</li><li><strong>24/7 Support</strong> - Round-the-clock assistance</li></ul><div class="alert alert-success"><h5>✅ Why Choose Us?</h5><p class="mb-0">We offer the best combination of speed, reliability, and customer service in the industry.</p></div></div></div>`,
            'pricing': `<div class="card card-primary"><div class="card-header"><h2 class="card-title">💰 Pricing Plans</h2></div><div class="card-body"><div class="row"><div class="col-md-6"><div class="card card-outline-primary"><div class="card-header"><h4 class="card-title">Basic Plan</h4></div><div class="card-body"><h3 class="text-primary">$10/month</h3><ul><li>Basic features</li><li>Email support</li><li>1GB storage</li></ul></div></div></div><div class="col-md-6"><div class="card card-outline-success"><div class="card-header"><h4 class="card-title">Premium Plan</h4></div><div class="card-body"><h3 class="text-success">$25/month</h3><ul><li>All features</li><li>Priority support</li><li>10GB storage</li></ul></div></div></div></div></div></div>`,
            'hero': `<div class="card card-danger"><div class="card-header"><h2 class="card-title">🌟 Hero Section</h2></div><div class="card-body text-center"><h1 class="display-4">Welcome to Our Platform</h1><p class="lead">Experience the best service with cutting-edge technology</p><div class="alert alert-primary"><h4>🚀 Get Started Today!</h4><p>Join thousands of satisfied customers worldwide</p><button class="btn btn-success btn-lg">Start Free Trial</button><button class="btn btn-outline-primary btn-lg ml-2">Learn More</button></div></div></div>`,
            'services': `<div class="card card-dark"><div class="card-header"><h2 class="card-title">🔧 Our Services</h2></div><div class="card-body"><div class="row"><div class="col-md-4 mb-3"><div class="card card-outline-primary"><div class="card-body text-center"><i class="fas fa-server fa-3x text-primary mb-3"></i><h5>Web Hosting</h5><p>Reliable and fast web hosting solutions</p></div></div></div><div class="col-md-4 mb-3"><div class="card card-outline-success"><div class="card-body text-center"><i class="fas fa-shield-alt fa-3x text-success mb-3"></i><h5>Security</h5><p>Advanced security and protection services</p></div></div></div><div class="col-md-4 mb-3"><div class="card card-outline-info"><div class="card-body text-center"><i class="fas fa-headset fa-3x text-info mb-3"></i><h5>Support</h5><p>24/7 customer support and assistance</p></div></div></div></div></div></div>`,
            'testimonials': `<div class="card card-success"><div class="card-header"><h2 class="card-title">💬 Customer Testimonials</h2></div><div class="card-body"><div class="row"><div class="col-md-6 mb-3"><div class="alert alert-light"><blockquote class="blockquote mb-0"><p>"Excellent service and support. Highly recommended!"</p><footer class="blockquote-footer">Ahmed Ali <cite title="Source Title">Business Owner</cite></footer></blockquote></div></div><div class="col-md-6 mb-3"><div class="alert alert-light"><blockquote class="blockquote mb-0"><p>"Fast, reliable, and professional service."</p><footer class="blockquote-footer">Sarah Khan <cite title="Source Title">Developer</cite></footer></blockquote></div></div></div><div class="text-center"><div class="alert alert-success"><h5>⭐⭐⭐⭐⭐ 5/5 Rating</h5><p class="mb-0">Based on 500+ customer reviews</p></div></div></div></div>`,
            'contact': `<div class="card card-danger"><div class="card-header"><h2 class="card-title">📞 Contact Information</h2></div><div class="card-body"><div class="alert alert-light"><h4>Get in Touch</h4><div class="row"><div class="col-md-4"><h5><i class="fas fa-envelope"></i> Email</h5><p>support@example.com</p></div><div class="col-md-4"><h5><i class="fas fa-phone"></i> Phone</h5><p>+1 (555) 123-4567</p></div><div class="col-md-4"><h5><i class="fas fa-clock"></i> Hours</h5><p>24/7 Support Available</p></div></div></div><h4>Support Channels:</h4><ul><li>Live Chat (Available 24/7)</li><li>Email Support</li><li>Phone Support</li><li>Knowledge Base</li></ul></div></div>`,
            'vpn_bangla_welcome': `<div class="card card-primary"><div class="card-header"><h2 class="card-title">🛡️ VPN সেবায় স্বাগতম</h2></div><div class="card-body"><div class="text-center mb-4"><h3 class="text-primary">নিরাপদ ও দ্রুত ইন্টারনেট সংযোগ</h3><p class="lead">আমাদের প্রিমিয়াম VPN সেবা দিয়ে আপনার অনলাইন নিরাপত্তা নিশ্চিত করুন</p></div><div class="alert alert-success"><h5>🔥 বিশেষ অফার!</h5><p class="mb-0">এখনই সাইন আপ করুন এবং ৩০% ছাড় পান। সীমিত সময়ের জন্য!</p></div><div class="row"><div class="col-md-4 text-center"><i class="fas fa-shield-alt fa-3x text-success mb-3"></i><h5>সম্পূর্ণ নিরাপত্তা</h5><p>আপনার ডেটা সুরক্ষিত রাখুন</p></div><div class="col-md-4 text-center"><i class="fas fa-globe fa-3x text-info mb-3"></i><h5>বিশ্বব্যাপী সার্ভার</h5><p>৫০+ দেশে সার্ভার</p></div><div class="col-md-4 text-center"><i class="fas fa-bolt fa-3x text-warning mb-3"></i><h5>দ্রুত গতি</h5><p>কোন গতি হ্রাস নেই</p></div></div></div></div>`,
            'vpn_bangla_packages': `<div class="card card-success"><div class="card-header"><h2 class="card-title">📦 VPN প্যাকেজ সমূহ</h2></div><div class="card-body"><div class="row"><div class="col-md-4"><div class="card card-outline-primary"><div class="card-header text-center"><h4>বেসিক প্ল্যান</h4><h3 class="text-primary">৫০০ টাকা/মাস</h3></div><div class="card-body"><ul><li>✅ ১টি ডিভাইস</li><li>✅ ১০+ সার্ভার লোকেশন</li><li>✅ ২৪/৭ সাপোর্ট</li><li>✅ মাসিক ১০০ জিবি ডেটা</li></ul><button class="btn btn-primary btn-block">অর্ডার করুন</button></div></div></div><div class="col-md-4"><div class="card card-outline-success"><div class="card-header text-center"><h4>প্রিমিয়াম প্ল্যান</h4><h3 class="text-success">১০০০ টাকা/মাস</h3></div><div class="card-body"><ul><li>✅ ৫টি ডিভাইস</li><li>✅ ৫০+ সার্ভার লোকেশন</li><li>✅ প্রাইওরিটি সাপোর্ট</li><li>✅ আনলিমিটেড ডেটা</li></ul><button class="btn btn-success btn-block">অর্ডার করুন</button></div></div></div><div class="col-md-4"><div class="card card-outline-warning"><div class="card-header text-center"><h4>বিজনেস প্ল্যান</h4><h3 class="text-warning">২০০০ টাকা/মাস</h3></div><div class="card-body"><ul><li>✅ আনলিমিটেড ডিভাইস</li><li>✅ সব সার্ভার</li><li>✅ ডেডিকেটেড সাপোর্ট</li><li>✅ কাস্টম কনফিগারেশন</li></ul><button class="btn btn-warning btn-block">অর্ডার করুন</button></div></div></div></div></div></div>`,
            'vpn_bangla_features': `<div class="card card-info"><div class="card-header"><h2 class="card-title">⭐ VPN এর বিশেষ ফিচার সমূহ</h2></div><div class="card-body"><div class="row"><div class="col-md-6"><h4>🔒 নিরাপত্তা ফিচার</h4><ul><li><strong>AES-256 এনক্রিপশন</strong> - সর্বোচ্চ নিরাপত্তা</li><li><strong>Kill Switch</strong> - সংযোগ বিচ্ছিন্ন হলে ইন্টারনেট বন্ধ</li><li><strong>DNS লিক প্রোটেকশন</strong> - আপনার পরিচয় গোপন</li><li><strong>No-Log Policy</strong> - কোন ডেটা সংরক্ষণ করা হয় না</li></ul></div><div class="col-md-6"><h4>🌐 কানেক্টিভিটি ফিচার</h4><ul><li><strong>৫০+ দেশে সার্ভার</strong> - বিশ্বব্যাপী অ্যাক্সেস</li><li><strong>আনলিমিটেড ব্যান্ডউইথ</strong> - কোন সীমাবদ্ধতা নেই</li><li><strong>P2P সাপোর্ট</strong> - টরেন্ট ডাউনলোড</li><li><strong>স্ট্রিমিং অপটিমাইজড</strong> - নেটফ্লিক্স, ইউটিউব</li></ul></div></div><div class="alert alert-primary mt-3"><h5>🎯 কেন আমাদের VPN বেছে নিবেন?</h5><p class="mb-0">আমরা বাংলাদেশের সবচেয়ে দ্রুত ও নিরাপদ VPN সেবা প্রদান করি। আমাদের রয়েছে ২৪/৭ বাংলা সাপোর্ট এবং সাশ্রয়ী মূল্য।</p></div></div></div>`,
            'vpn_bangla_setup': `<div class="card card-warning"><div class="card-header"><h2 class="card-title">⚙️ VPN সেটআপ গাইড</h2></div><div class="card-body"><div class="alert alert-info"><h5>📱 মোবাইলে VPN সেটআপ (Android/iOS)</h5></div><div class="row"><div class="col-md-6"><h4>📱 Android সেটআপ</h4><ol><li>Google Play Store থেকে আমাদের অ্যাপ ডাউনলোড করুন</li><li>অ্যাপ খুলে আপনার একাউন্ট দিয়ে লগইন করুন</li><li>পছন্দের সার্ভার লোকেশন নির্বাচন করুন</li><li>"Connect" বাটনে ক্লিক করুন</li><li>VPN সংযোগ সফল হলে নোটিফিকেশন দেখবেন</li></ol></div><div class="col-md-6"><h4>🍎 iOS সেটআপ</h4><ol><li>App Store থেকে আমাদের অ্যাপ ডাউনলোড করুন</li><li>অ্যাপ খুলে আপনার একাউন্ট দিয়ে লগইন করুন</li><li>VPN প্রোফাইল ইনস্টল করার অনুমতি দিন</li><li>সার্ভার নির্বাচন করে কানেক্ট করুন</li><li>স্ট্যাটাস বারে VPN আইকন দেখবেন</li></ol></div></div><div class="text-center"><button class="btn btn-primary btn-lg">অ্যাপ ডাউনলোড করুন</button><button class="btn btn-outline-info btn-lg ml-2">ভিডিও টিউটোরিয়াল দেখুন</button></div></div></div>`,
            'vpn_bangla_support': `<div class="card card-danger"><div class="card-header"><h2 class="card-title">🎧 VPN সাপোর্ট ও সহায়তা</h2></div><div class="card-body"><div class="alert alert-primary"><h5>📞 ২৪/৭ বাংলা সাপোর্ট</h5><p class="mb-0">আমাদের দক্ষ টিম সর্বদা আপনার সেবায় নিয়োজিত</p></div><div class="row"><div class="col-md-4"><div class="card card-outline-success"><div class="card-body text-center"><i class="fas fa-comments fa-3x text-success mb-3"></i><h5>লাইভ চ্যাট</h5><p>তাৎক্ষণিক সহায়তা</p><button class="btn btn-success">চ্যাট শুরু করুন</button></div></div></div><div class="col-md-4"><div class="card card-outline-info"><div class="card-body text-center"><i class="fas fa-envelope fa-3x text-info mb-3"></i><h5>ইমেইল সাপোর্ট</h5><p>support@vpnbangla.com</p><button class="btn btn-info">ইমেইল পাঠান</button></div></div></div><div class="col-md-4"><div class="card card-outline-warning"><div class="card-body text-center"><i class="fas fa-phone fa-3x text-warning mb-3"></i><h5>ফোন সাপোর্ট</h5><p>+৮৮০ ১৭১২-৩৪৫৬৭৮</p><button class="btn btn-warning">কল করুন</button></div></div></div></div></div></div>`
        };
        
        // Combine templates
        templateTypes.forEach(function(templateType) {
            if (templates[templateType]) {
                combinedContent += templates[templateType] + '\n\n<hr class="my-4">\n\n';
                validTemplates.push(templateType);
            } else {
                console.warn('⚠️ Template not found:', templateType);
            }
        });
        
        if (combinedContent) {
            // Remove the last separator
            combinedContent = combinedContent.replace(/\n\n<hr class="my-4">\n\n$/, '');
            
            // Get current content and append
            var currentContent = $('#htmlEditor').summernote('code');
            var newContent = currentContent + '\n\n' + combinedContent;
            
            // Insert into editor
            $('#htmlEditor').summernote('code', newContent);
            
            // Show success message
            Swal.fire({
                icon: 'success',
                title: 'Multiple Templates Added!',
                text: validTemplates.length + ' templates have been combined and added to the editor.',
                timer: 3000,
                showConfirmButton: false
            });
            
        } else {
            Swal.fire({
                icon: 'error',
                title: 'No Valid Templates',
                text: 'None of the specified templates were found.',
                timer: 2000,
                showConfirmButton: false
            });
        }
    };
    
    // Function to clear editor and insert multiple templates
    window.clearAndInsertMultiple = function(templateTypes) {
        if (confirm('This will clear all current content and insert the selected templates. Continue?')) {
            // Clear editor first
            $('#htmlEditor').summernote('code', '');
            
            // Then insert templates
            insertMultipleTemplates(templateTypes);
        }
    };
});
</script>


<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>