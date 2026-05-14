<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Email Templates</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="./dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="./dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-bs4.min.css">
<style>
/* Complete CSS isolation for template preview */
.template-preview-mode .note-editable {
    /* Create completely isolated preview container */
    background: #f8f9fa !important;
    color: #333 !important;
    padding: 15px !important;
    border-radius: 4px !important;
    border: 2px solid #dee2e6 !important;
    /* CSS containment to prevent style bleeding */
    contain: layout style paint !important;
    isolation: isolate !important;
    position: relative !important;
    overflow: auto !important;
    max-height: 400px !important;
}

/* Aggressive protection against template style bleeding */
body {
    background: #fafbfc !important;
    color: #495057 !important;
}

.main-wrapper {
    background: transparent !important;
}

.modal-content {
    background: white !important;
    color: #495057 !important;
}

.modal-body {
    background: white !important;
    color: #495057 !important;
}

.card {
    background: white !important;
    color: #495057 !important;
}

.card-body {
    background: white !important;
    color: #495057 !important;
}

/* Specifically protect the modal when template preview is active */
.template-preview-mode ~ * .modal-content,
.template-preview-mode .modal-content {
    background: white !important;
    color: #495057 !important;
}

/* Ensure editor interface stays completely normal - STRONGEST PROTECTION */
.note-editor {
    background: white !important;
    color: #333 !important;
    border: 1px solid #ddd !important;
}

.note-toolbar {
    background: #f8f9fa !important;
    color: #333 !important;
    border-bottom: 1px solid #ddd !important;
}

.note-toolbar .btn {
    background: white !important;
    color: #333 !important;
    border: 1px solid #ddd !important;
}

.note-toolbar .btn:hover {
    background: #e9ecef !important;
    color: #333 !important;
    border: 1px solid #adb5bd !important;
}

.note-toolbar .btn:active,
.note-toolbar .btn.active {
    background: #007bff !important;
    color: white !important;
    border: 1px solid #007bff !important;
}

.note-statusbar {
    background: #f8f9fa !important;
    color: #6c757d !important;
    border-top: 1px solid #ddd !important;
}

/* Dropdown menus in editor */
.note-toolbar .dropdown-menu {
    background: white !important;
    color: #333 !important;
    border: 1px solid #ddd !important;
}

.note-toolbar .dropdown-item {
    color: #333 !important;
}

.note-toolbar .dropdown-item:hover {
    background: #f8f9fa !important;
    color: #333 !important;
}

/* Font and color picker elements */
.note-toolbar .note-color .dropdown-menu,
.note-toolbar .note-fontname .dropdown-menu,
.note-toolbar .note-fontsize .dropdown-menu {
    background: white !important;
    border: 1px solid #ddd !important;
}

/* Ensure all toolbar elements are visible */
.note-toolbar * {
    color: #333 !important;
}

/* EXTRA PROTECTION: When preview mode is active, force toolbar to stay normal */
.template-preview-mode .note-editor {
    background: white !important;
    color: #333 !important;
}

.template-preview-mode .note-toolbar {
    background: #f8f9fa !important;
    color: #333 !important;
    border-bottom: 1px solid #ddd !important;
}

.template-preview-mode .note-toolbar .btn {
    background: white !important;
    color: #333 !important;
    border: 1px solid #ddd !important;
    opacity: 1 !important;
    visibility: visible !important;
}

.template-preview-mode .note-toolbar .btn:hover {
    background: #e9ecef !important;
    color: #333 !important;
}

.template-preview-mode .note-toolbar .btn:active,
.template-preview-mode .note-toolbar .btn.active {
    background: #007bff !important;
    color: white !important;
}

.template-preview-mode .note-toolbar * {
    color: #333 !important;
    background: inherit !important;
}

/* Force override any inherited styles from template */
.template-preview-mode .note-toolbar .note-btn-group .btn,
.template-preview-mode .note-toolbar .dropdown-toggle,
.template-preview-mode .note-toolbar .note-color-btn,
.template-preview-mode .note-toolbar i {
    color: #333 !important;
    background: white !important;
    opacity: 1 !important;
}

/* Template content preview area with scroll */
.template-preview-mode .note-editable {
    font-family: Arial, sans-serif !important;
    line-height: 1.4 !important;
}

/* Prevent template styles from escaping the preview area */
.template-preview-mode .note-editable * {
    max-width: 100% !important;
    box-sizing: border-box !important;
}

/* Dark theme toggle button */
.theme-toggle {
    position: absolute;
    top: 10px;
    right: 10px;
    z-index: 1000;
}

/* Modal scrolling improvements - Taller height, same width */
.modal-dialog-scrollable {
    max-height: 95vh; /* Increased height */
}

.modal-dialog-scrollable .modal-content {
    max-height: calc(95vh - 1rem);
    overflow: hidden;
}

.modal-dialog-scrollable .modal-body {
    overflow-y: auto;
    max-height: calc(95vh - 150px); /* Account for header and footer */
    padding: 20px; /* Normal padding for modal-lg */
}

.modal-footer {
    flex-shrink: 0; /* Prevent footer from shrinking */
    border-top: 1px solid #dee2e6;
    background: white;
    padding: 15px 20px; /* Normal padding for modal-lg */
}

/* Taller Summernote editor for better template viewing */
.modal-dialog-scrollable .note-editor {
    max-height: 700px; /* Much taller for better template viewing */
    min-height: 500px; /* Minimum height for seeing full templates */
}

.modal-dialog-scrollable .note-editable {
    max-height: 550px; /* Much taller for seeing full template content */
    min-height: 400px; /* Minimum height for comfortable viewing */
    overflow-y: auto;
}

/* Keep normal form elements for modal-lg width */
.modal-lg .form-control {
    font-size: 14px; /* Normal text size */
    padding: 8px 12px; /* Normal padding */
}

.modal-lg .form-group {
    margin-bottom: 20px; /* Normal spacing */
}

.modal-lg .modal-header {
    padding: 15px 20px; /* Normal header padding */
}

.modal-lg .modal-title {
    font-size: 18px; /* Normal title size */
}

.theme-toggle .btn {
    background: #2d2d2d;
    border: 1px solid #404040;
    color: #ffffff;
}

.theme-toggle .btn.active {
    background: #404040;
    color: #ffffff;
}

/* FontAwesome Icon Fix */
.fas, .far, .fab, .fa {
    font-family: "Font Awesome 5 Free", "Font Awesome 5 Brands", "FontAwesome" !important;
    font-weight: 900 !important;
    font-style: normal !important;
    font-variant: normal !important;
    text-transform: none !important;
    line-height: 1 !important;
    -webkit-font-smoothing: antialiased !important;
    -moz-osx-font-smoothing: grayscale !important;
}

/* Ensure icons display properly */
i.fas, i.far, i.fab, i.fa {
    display: inline-block !important;
    font-style: normal !important;
    font-variant: normal !important;
    text-rendering: auto !important;
    -webkit-font-smoothing: antialiased !important;
}

/* Email Templates Bangla Font Support */
.template-card .bangla-text, .template-card .card-text.bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

/* Modal content Bangla support */
.modal-body .bangla-text, #templatesContainer .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

/* Template Cards Styling */
.template-card {
    transition: transform 0.2s ease-in-out;
    border: 1px solid #e3e6f0;
}

.template-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 0.25rem 1rem rgba(0, 0, 0, 0.15);
}

.template-card .card-body {
    padding: 1.5rem;
}

.template-card .btn-group {
    margin-top: 1rem;
}

/* Statistics Cards Enhancement */
.card-statistic-2 {
    border: none;
    box-shadow: 0 0.25rem 1rem rgba(0, 0, 0, 0.15);
}

.card-statistic-2 .card-icon {
    border-radius: 50%;
    width: 70px;
    height: 70px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 2rem;
}

/* Icon Picker Styles */
.icon-picker-container {
    background: #f8f9fa;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 15px;
    margin-top: 10px;
}

.icon-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(60px, 1fr));
    gap: 10px;
    max-height: 200px;
    overflow-y: auto;
    padding: 10px;
    background: white;
    border-radius: 4px;
}

.icon-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 10px;
    border: 2px solid #e9ecef;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.2s ease;
    background: white;
}

.icon-item:hover {
    border-color: #007bff;
    background: #f8f9ff;
    transform: translateY(-2px);
}

.icon-item .icon {
    font-size: 24px;
    margin-bottom: 5px;
}

.icon-item .label {
    font-size: 10px;
    text-align: center;
    color: #6c757d;
    line-height: 1.2;
}
</style>
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
</head>

<body>
<div id="app">
<div class="main-wrapper main-wrapper-1">
<div class="navbar-bg"></div>
{include file='apps/topnav.tpl'}
{include file='apps/sidenav.tpl'}

<div class="main-content">
<section class="section">
<div class="section-header">
<h1><i class="fas fa-file-alt"></i> Email Templates</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item active"><a href="dashboard">Dashboard</a></div>
<div class="breadcrumb-item">Email Templates</div>
</div>
</div>

<div class="section-body">
<!-- Statistics Cards - Dashboard Style -->
<div class="row mb-4">
<div class="col-lg-3 col-md-6 col-sm-6 col-12">
    <div class="card card-statistic-2 card-primary">
        <div class="card-icon shadow-primary bg-primary">
            <i class="fas fa-file-alt"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Total Templates</h4>
            </div>
            <div class="card-body">
                {$stats.total_templates|default:0}
            </div>
        </div>
    </div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6 col-12">
    <div class="card card-statistic-2 card-success">
        <div class="card-icon shadow-success bg-success">
            <i class="fas fa-check-circle"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Active Templates</h4>
            </div>
            <div class="card-body">
                {$stats.active_templates|default:0}
            </div>
        </div>
    </div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6 col-12">
    <div class="card card-statistic-2 card-info">
        <div class="card-icon shadow-info bg-info">
            <i class="fas fa-handshake"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Welcome Templates</h4>
            </div>
            <div class="card-body">
                {$stats.welcome_templates|default:0}
            </div>
        </div>
    </div>
</div>

<div class="col-lg-3 col-md-6 col-sm-6 col-12">
    <div class="card card-statistic-2 card-warning">
        <div class="card-icon shadow-warning bg-warning">
            <i class="fas fa-bullhorn"></i>
        </div>
        <div class="card-wrap">
            <div class="card-header">
                <h4>Promotion Templates</h4>
            </div>
            <div class="card-body">
                {$stats.promotion_templates|default:0}
            </div>
        </div>
    </div>
</div>
</div>

<!-- Templates Management -->
<div class="row">
<div class="col-12">
<div class="card">
<div class="card-header">
<h4>Email Templates</h4>
<div class="card-header-action">
<button class="btn btn-success btn-sm" onclick="showPresets()">
<i class="fas fa-magic"></i> Use Preset
</button>
<a href="/template-editor" class="btn btn-info btn-sm">
<i class="fas fa-expand"></i> Full Editor
</a>
<button class="btn btn-primary btn-sm" onclick="createTemplate()">
<i class="fas fa-plus"></i> Create Template
</button>
</div>
</div>
<div class="card-body">
<div class="alert alert-info">
<i class="fas fa-info-circle"></i>
<strong>Email Templates</strong> - Create reusable email templates for campaigns and automated emails.
<br>Available placeholders: <code>{literal}{name}, {email}, {website_url}, {unsubscribe_url}{/literal}</code>
</div>

<div class="row" id="templatesContainer">
<div class="col-12 text-center">
<i class="fas fa-spinner fa-spin fa-2x"></i>
<p>Loading templates...</p>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</section>
</div>

</div>
</div>

<!-- Create Template Modal -->
<div class="modal fade" id="createTemplateModal" tabindex="-1" role="dialog">
<div class="modal-dialog modal-lg modal-dialog-scrollable" role="document" style="max-height: 95vh;">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Create Email Template</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<form id="createTemplateForm">
<div class="row">
<div class="col-md-6">
<div class="form-group">
<label for="templateName">Template Name *</label>
<input type="text" class="form-control" id="templateName" name="name" required>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label for="templateType">Template Type</label>
<select class="form-control" id="templateType" name="template_type">
<option value="custom">Custom</option>
<option value="welcome">Welcome</option>
<option value="newsletter">Newsletter</option>
<option value="promotion">Promotion</option>
<option value="announcement">Announcement</option>
</select>
</div>
</div>
</div>

<div class="form-group">
<label for="templateSubject">Email Subject *</label>
<input type="text" class="form-control" id="templateSubject" name="subject" required>
</div>

<div class="form-group">
<label for="templateContent">Email Content *</label>
<div class="editor-container" style="position: relative;">
<div class="theme-toggle">
<button type="button" class="btn btn-sm" onclick="togglePreviewMode('templateContent')" title="Toggle Template Preview">
<i class="fas fa-eye"></i>
</button>
</div>
<textarea class="form-control" id="templateContent" name="content" rows="15" required></textarea>
</div>
<small class="form-text text-muted">
Available placeholders: <code>{literal}{name}, {email}, {website_url}, {unsubscribe_url}{/literal}</code>
</small>
</div>

<!-- Icon Picker Section -->
<div class="form-group">
<label>Email-Safe Icons</label>
<div class="icon-picker-container">
<div class="alert alert-info">
<i class="fas fa-info-circle"></i> <strong>Click any icon below to insert it into your template</strong> - These icons work in all email clients!
</div>
<div class="icon-grid" id="iconGrid">
<!-- Icons will be populated by JavaScript -->
</div>
</div>
</div>

<div class="row">
<div class="col-md-6">
<div class="form-group">
<label for="templateContentType">Content Type</label>
<select class="form-control" id="templateContentType" name="content_type">
<option value="html">HTML</option>
<option value="text">Plain Text</option>
</select>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label class="custom-switch mt-4">
<input type="checkbox" name="is_active" class="custom-switch-input" checked>
<span class="custom-switch-indicator"></span>
<span class="custom-switch-description">Active Template</span>
</label>
</div>
</div>
</div>
</form>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
<button type="button" class="btn btn-primary" onclick="saveTemplate()">Create Template</button>
</div>
</div>
</div>
</div>

<!-- Edit Template Modal -->
<div class="modal fade" id="editTemplateModal" tabindex="-1" role="dialog">
<div class="modal-dialog modal-lg modal-dialog-scrollable" role="document" style="max-height: 95vh;">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Edit Email Template</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<form id="editTemplateForm">
<input type="hidden" id="editTemplateId" name="template_id">
<div class="row">
<div class="col-md-6">
<div class="form-group">
<label for="editTemplateName">Template Name *</label>
<input type="text" class="form-control" id="editTemplateName" name="name" required>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label for="editTemplateType">Template Type</label>
<select class="form-control" id="editTemplateType" name="template_type">
<option value="custom">Custom</option>
<option value="welcome">Welcome</option>
<option value="newsletter">Newsletter</option>
<option value="promotion">Promotion</option>
<option value="announcement">Announcement</option>
</select>
</div>
</div>
</div>

<div class="form-group">
<label for="editTemplateSubject">Email Subject *</label>
<input type="text" class="form-control" id="editTemplateSubject" name="subject" required>
</div>

<div class="form-group">
<label for="editTemplateContent">Email Content *</label>
<div class="editor-container" style="position: relative;">
<div class="theme-toggle">
<button type="button" class="btn btn-sm" onclick="togglePreviewMode('editTemplateContent')" title="Toggle Template Preview">
<i class="fas fa-eye"></i>
</button>
</div>
<textarea class="form-control" id="editTemplateContent" name="content" rows="15" required></textarea>
</div>
<small class="form-text text-muted">
Available placeholders: <code>{literal}{name}, {email}, {website_url}, {unsubscribe_url}{/literal}</code>
</small>
</div>

<div class="row">
<div class="col-md-6">
<div class="form-group">
<label for="editTemplateContentType">Content Type</label>
<select class="form-control" id="editTemplateContentType" name="content_type">
<option value="html">HTML</option>
<option value="text">Plain Text</option>
</select>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label class="custom-switch mt-4">
<input type="checkbox" name="is_active" id="editTemplateActive" class="custom-switch-input">
<span class="custom-switch-indicator"></span>
<span class="custom-switch-description">Active Template</span>
</label>
</div>
</div>
</div>
</form>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
<button type="button" class="btn btn-primary" onclick="updateTemplate()">Update Template</button>
</div>
</div>
</div>
</div>

<!-- Template Presets Modal -->
<div class="modal fade" id="templatePresetsModal" tabindex="-1" role="dialog">
<div class="modal-dialog modal-xl" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Choose a Template Preset</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<div class="alert alert-info">
<i class="fas fa-magic"></i>
<strong>Dynamic HTML Templates</strong> - Choose from our collection of professionally designed email templates.
</div>
<div id="presetsContainer" class="row">
<!-- Presets will be loaded here -->
</div>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
</div>
</div>
</div>
</div>

<!-- Template Preview Modal -->
<div class="modal fade" id="previewTemplateModal" tabindex="-1" role="dialog">
<div class="modal-dialog modal-lg" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Template Preview</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<div id="templatePreviewContent">
<!-- Preview content loaded here -->
</div>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
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
<script src="/dist/js/stisla.js"></script>
<script src="/dist/sweetalert2/sweetalert2.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-bs4.min.js"></script>

<script>
{literal}
$(document).ready(function() {
    // Check if FontAwesome loaded properly
    checkFontAwesome();
    loadTemplates();
    initializeEditors();
    initializeIconPicker();
});

function checkFontAwesome() {
    // Create a test element to check if FontAwesome is working
    var testIcon = $('<i class="fas fa-check" style="position: absolute; left: -9999px;"></i>');
    $('body').append(testIcon);
    
    setTimeout(function() {
        var computedStyle = window.getComputedStyle(testIcon[0], ':before');
        var content = computedStyle.getPropertyValue('content');
        
        // If FontAwesome didn't load, try to load local version
        if (!content || content === 'none' || content === '""') {
            var localFA = $('<link rel="stylesheet" href="./dist/bootstrap/dashboard/plugins/font-awesome-4.7.0/css/font-awesome.min.css">');
            $('head').append(localFA);
        }
        
        testIcon.remove();
    }, 1000);
}

function initializeEditors() {
    // Initialize Summernote for create template
    $('#templateContent').summernote({
        height: 400,
        minHeight: 300,
        maxHeight: 600,
        placeholder: 'Enter your email content here...',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['fontname', ['fontname']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ],
        callbacks: {
            // onChange callback removed since live preview is disabled
        }
    });
    
    // Initialize Summernote for edit template
    $('#editTemplateContent').summernote({
        height: 400,
        minHeight: 300,
        maxHeight: 600,
        placeholder: 'Enter your email content here...',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['fontname', ['fontname']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ],
        callbacks: {
            // onChange callback removed since live preview is disabled
        }
    });
}

// Live preview functions removed as requested

function togglePreviewMode(editorId) {
    var editorContainer = $('#' + editorId).closest('.editor-container');
    var toggleButton = editorContainer.find('.theme-toggle .btn');
    var icon = toggleButton.find('i');
    
    if (editorContainer.hasClass('template-preview-mode')) {
        // Switch to edit mode
        editorContainer.removeClass('template-preview-mode');
        icon.removeClass('fa-edit').addClass('fa-eye');
        toggleButton.attr('title', 'Toggle Template Preview');
    } else {
        // Switch to preview mode - shows template colors as they are
        editorContainer.addClass('template-preview-mode');
        icon.removeClass('fa-eye').addClass('fa-edit');
        toggleButton.attr('title', 'Toggle Edit Mode');
    }
}

function initializeIconPicker() {
    // Define email-safe icons with their Unicode equivalents
    var emailSafeIcons = [
        {symbol: '📧', name: 'Email', category: 'communication'},
        {symbol: '📰', name: 'Newsletter', category: 'content'},
        {symbol: '🎉', name: 'Celebration', category: 'emotion'},
        {symbol: '🚀', name: 'Launch', category: 'action'},
        {symbol: '🔒', name: 'Security', category: 'security'},
        {symbol: '🌍', name: 'Global', category: 'location'},
        {symbol: '⚡', name: 'Fast', category: 'speed'},
        {symbol: '📊', name: 'Statistics', category: 'data'},
        {symbol: '💡', name: 'Idea', category: 'concept'},
        {symbol: '✅', name: 'Check', category: 'status'},
        {symbol: '❌', name: 'Cross', category: 'status'},
        {symbol: '⚠️', name: 'Warning', category: 'alert'},
        {symbol: '🔔', name: 'Notification', category: 'alert'},
        {symbol: '🎯', name: 'Target', category: 'goal'},
        {symbol: '📈', name: 'Growth', category: 'data'},
        {symbol: '💰', name: 'Money', category: 'finance'},
        {symbol: '🎁', name: 'Gift', category: 'reward'},
        {symbol: '⭐', name: 'Star', category: 'rating'},
        {symbol: '🏆', name: 'Trophy', category: 'achievement'},
        {symbol: '🔧', name: 'Tools', category: 'utility'},
        {symbol: '📱', name: 'Mobile', category: 'device'},
        {symbol: '💻', name: 'Computer', category: 'device'},
        {symbol: '🌟', name: 'Sparkle', category: 'decoration'},
        {symbol: '💎', name: 'Diamond', category: 'premium'},
        {symbol: '🔥', name: 'Fire', category: 'hot'},
        {symbol: '❤️', name: 'Heart', category: 'emotion'},
        {symbol: '👍', name: 'Thumbs Up', category: 'approval'},
        {symbol: '📅', name: 'Calendar', category: 'time'},
        {symbol: '⏰', name: 'Clock', category: 'time'},
        {symbol: '🎊', name: 'Confetti', category: 'celebration'}
    ];
    
    // Populate the icon grid
    var iconGrid = $('#iconGrid');
    iconGrid.empty();
    
    emailSafeIcons.forEach(function(icon) {
        var iconItem = $('<div class="icon-item" data-symbol="' + icon.symbol + '" data-name="' + icon.name + '">' +
            '<div class="icon">' + icon.symbol + '</div>' +
            '<div class="label">' + icon.name + '</div>' +
            '</div>');
        
        iconItem.click(function() {
            insertIconIntoEditor(icon.symbol, icon.name);
        });
        
        iconGrid.append(iconItem);
    });
}

function insertIconIntoEditor(symbol, name) {
    // Get the active Summernote editor
    var activeEditor = $('#templateContent');
    if ($('#editTemplateModal').hasClass('show')) {
        activeEditor = $('#editTemplateContent');
    }
    
    // Insert the icon at cursor position
    if (activeEditor.summernote('code')) {
        activeEditor.summernote('insertText', symbol + ' ');
        
        // Show success message
        Swal.fire({
            title: 'Icon Inserted!',
            text: name + ' icon (' + symbol + ') has been added to your template',
            icon: 'success',
            timer: 1500,
            showConfirmButton: false
        });
    }
}

function loadTemplates() {
    $('#templatesContainer').html('<div class="col-12 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Loading templates...</p></div>');
    
    $.ajax({
        url: './serverside/data/get_all_email_templates.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                displayTemplates(response.templates);
            } else {
                $('#templatesContainer').html('<div class="col-12"><div class="alert alert-warning">' + response.msg + '</div></div>');
            }
        },
        error: function() {
            $('#templatesContainer').html('<div class="col-12"><div class="alert alert-danger">Failed to load templates</div></div>');
        }
    });
}

function displayTemplates(templates) {
    var html = '';
    
    if(templates.length === 0) {
        html = '<div class="col-12"><div class="alert alert-info"><i class="fas fa-info-circle"></i> No templates found. <a href="#" onclick="createTemplate()">Create your first template</a>.</div></div>';
    } else {
        templates.forEach(function(template) {
            var statusBadge = template.is_active == 1 ? 
                '<span class="badge badge-success">Active</span>' : 
                '<span class="badge badge-secondary">Inactive</span>';
            
            var typeBadge = '';
            switch(template.template_type) {
                case 'welcome':
                    typeBadge = '<span class="badge badge-info">Welcome</span>';
                    break;
                case 'newsletter':
                    typeBadge = '<span class="badge badge-primary">Newsletter</span>';
                    break;
                case 'promotion':
                    typeBadge = '<span class="badge badge-warning">Promotion</span>';
                    break;
                case 'announcement':
                    typeBadge = '<span class="badge badge-danger">Announcement</span>';
                    break;
                default:
                    typeBadge = '<span class="badge badge-secondary">Custom</span>';
            }
            
            html += '<div class="col-md-6 col-lg-4 mb-4">' +
                '<div class="card template-card">' +
                '<div class="card-body">' +
                '<div class="d-flex justify-content-between align-items-start mb-2">' +
                '<h6 class="card-title mb-0">' + template.name + '</h6>' +
                statusBadge +
                '</div>' +
                '<p class="card-text text-muted small mb-2">' + template.subject + '</p>' +
                '<p class="card-text small">' + template.content_preview + '</p>' +
                '<div class="mb-2">' +
                typeBadge +
                '<span class="badge badge-light">' + template.content_type.toUpperCase() + '</span>' +
                '</div>' +
                '<div class="btn-group btn-group-sm w-100">' +
                '<button class="btn btn-info" onclick="previewTemplate(' + template.id + ')" title="Preview">' +
                '<i class="fas fa-eye"></i>' +
                '</button>' +
                '<a href="/template-editor&id=' + template.id + '" class="btn btn-success" title="Full Editor">' +
                '<i class="fas fa-expand"></i>' +
                '</a>' +
                '<button class="btn btn-primary" onclick="editTemplate(' + template.id + ')" title="Quick Edit">' +
                '<i class="fas fa-edit"></i>' +
                '</button>' +
                '<button class="btn btn-secondary" onclick="duplicateTemplate(' + template.id + ')" title="Duplicate">' +
                '<i class="fas fa-copy"></i>' +
                '</button>' +
                '<button class="btn btn-danger" onclick="deleteTemplate(' + template.id + ')" title="Delete">' +
                '<i class="fas fa-trash"></i>' +
                '</button>' +
                '</div>' +
                '</div>' +
                '<div class="card-footer text-muted small">' +
                'Created: ' + new Date(template.created_date).toLocaleDateString() +
                '</div>' +
                '</div>' +
                '</div>';
        });
    }
    
    $('#templatesContainer').html('<div class="row">' + html + '</div>');
}

function createTemplate() {
    $('#createTemplateModal').modal('show');
}

function showPresets() {
    $('#templatePresetsModal').modal('show');
    loadPresets();
}

function loadPresets() {
    $('#presetsContainer').html('<div class="col-12 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Loading presets...</p></div>');
    
    $.ajax({
        url: './serverside/data/get_template_presets.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                displayPresets(response.presets);
            } else {
                $('#presetsContainer').html('<div class="col-12"><div class="alert alert-warning">Failed to load presets</div></div>');
            }
        },
        error: function() {
            $('#presetsContainer').html('<div class="col-12"><div class="alert alert-danger">Error loading presets</div></div>');
        }
    });
}

function displayPresets(presets) {
    var html = '';
    
    presets.forEach(function(preset, index) {
        var typeBadge = '';
        switch(preset.template_type) {
            case 'welcome':
                typeBadge = '<span class="badge badge-info">Welcome</span>';
                break;
            case 'newsletter':
                typeBadge = '<span class="badge badge-primary">Newsletter</span>';
                break;
            case 'promotion':
                typeBadge = '<span class="badge badge-warning">Promotion</span>';
                break;
            case 'announcement':
                typeBadge = '<span class="badge badge-danger">Announcement</span>';
                break;
            default:
                typeBadge = '<span class="badge badge-secondary">Custom</span>';
        }
        
        html += '<div class="col-md-6 col-lg-4 mb-4">' +
            '<div class="card h-100">' +
            '<div class="card-body">' +
            '<div class="d-flex justify-content-between align-items-start mb-2">' +
            '<h6 class="card-title mb-0">' + preset.name + '</h6>' +
            typeBadge +
            '</div>' +
            '<p class="card-text text-muted small mb-2">' + preset.subject + '</p>' +
            '<p class="card-text small">' + preset.content.substring(0, 100).replace(/<[^>]*>/g, '') + '...</p>' +
            '</div>' +
            '<div class="card-footer">' +
            '<button class="btn btn-primary btn-sm btn-block" onclick="usePreset(' + index + ')">' +
            '<i class="fas fa-magic"></i> Use This Template' +
            '</button>' +
            '</div>' +
            '</div>' +
            '</div>';
    });
    
    $('#presetsContainer').html(html);
}

function usePreset(index) {
    $.ajax({
        url: './serverside/data/get_template_presets.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.response == 1 && response.presets[index]) {
                var preset = response.presets[index];
                
                // Fill create template form with preset data
                $('#templateName').val(preset.name);
                $('#templateSubject').val(preset.subject);
                $('#templateContent').summernote('code', preset.content);
                $('#templateType').val(preset.template_type);
                $('#templateContentType').val('html');
                
                // Live preview removed
                
                // Close presets modal and show create modal
                $('#templatePresetsModal').modal('hide');
                $('#createTemplateModal').modal('show');
                
                // Show success message
                Swal.fire({
                    title: 'Template Loaded!',
                    text: 'The preset template has been loaded. You can customize it before saving.',
                    icon: 'success',
                    timer: 2000,
                    showConfirmButton: false
                });
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to load preset template', 'error');
        }
    });
}

function convertFontAwesomeToUnicode(content) {
    // FontAwesome to Unicode conversion map
    var iconMap = {
        'fas fa-envelope': '📧',
        'fas fa-newspaper': '📰',
        'fas fa-party-horn': '🎉',
        'fas fa-rocket': '🚀',
        'fas fa-lock': '🔒',
        'fas fa-globe': '🌍',
        'fas fa-bolt': '⚡',
        'fas fa-chart-bar': '📊',
        'fas fa-lightbulb': '💡',
        'fas fa-check': '✅',
        'fas fa-times': '❌',
        'fas fa-exclamation-triangle': '⚠️',
        'fas fa-bell': '🔔',
        'fas fa-bullseye': '🎯',
        'fas fa-chart-line': '📈',
        'fas fa-dollar-sign': '💰',
        'fas fa-gift': '🎁',
        'fas fa-star': '⭐',
        'fas fa-trophy': '🏆',
        'fas fa-wrench': '🔧',
        'fas fa-mobile-alt': '📱',
        'fas fa-laptop': '💻',
        'fas fa-sparkles': '🌟',
        'fas fa-gem': '💎',
        'fas fa-fire': '🔥',
        'fas fa-heart': '❤️',
        'fas fa-thumbs-up': '👍',
        'fas fa-calendar': '📅',
        'fas fa-clock': '⏰',
        'fas fa-confetti': '🎊',
        'fas fa-eye': '👁️',
        'fas fa-edit': '✏️',
        'fas fa-trash': '🗑️',
        'fas fa-copy': '📋',
        'fas fa-plus': '➕',
        'fas fa-magic': '✨'
    };
    
    // Replace FontAwesome classes with Unicode symbols
    var convertedContent = content;
    
    // Handle <i class="fas fa-xxx"></i> patterns
    convertedContent = convertedContent.replace(/<i\s+class="([^"]*fas\s+fa-[^"]*)"[^>]*><\/i>/gi, function(match, classes) {
        for (var faClass in iconMap) {
            if (classes.includes(faClass)) {
                return iconMap[faClass];
            }
        }
        return '📧'; // Default fallback icon
    });
    
    // Handle any remaining FontAwesome class references
    for (var faClass in iconMap) {
        var regex = new RegExp(faClass.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'gi');
        convertedContent = convertedContent.replace(regex, iconMap[faClass]);
    }
    
    return convertedContent;
}

function saveTemplate() {
    var formData = {
        name: $('#templateName').val().trim(),
        subject: $('#templateSubject').val().trim(),
        content: $('#templateContent').summernote('code'),
        content_type: $('#templateContentType').val(),
        template_type: $('#templateType').val(),
        is_active: $('input[name="is_active"]').is(':checked') ? 1 : 0
    };
    
    // Validation
    if(!formData.name || !formData.subject || !formData.content) {
        Swal.fire('Error', 'Please fill in all required fields', 'error');
        return;
    }
    
    // Convert FontAwesome icons to Unicode symbols for email compatibility
    formData.content = convertFontAwesomeToUnicode(formData.content);
    formData.subject = convertFontAwesomeToUnicode(formData.subject);
    
    $.ajax({
        url: './serverside/forms/create_email_template.php',
        type: 'POST',
        data: formData,
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire('Success', response.msg, 'success');
                $('#createTemplateModal').modal('hide');
                $('#createTemplateForm')[0].reset();
                loadTemplates(); // Reload templates
            } else {
                var errorMsg = response.msg;
                if(response.debug) {
                    errorMsg += '<br><br><small>Check browser console for debug details</small>';
                }
                Swal.fire({
                    title: 'Error',
                    html: errorMsg,
                    icon: 'error'
                });
            }
        },
        error: function(xhr, status, error) {
            var errorMsg = 'Failed to create template: ' + error;
            
            if(xhr.responseText) {
                try {
                    var response = JSON.parse(xhr.responseText);
                    if(response.msg) {
                        errorMsg = response.msg;
                        if(response.debug) {
                            }
                    }
                } catch(e) {
                    errorMsg += '<br><br><strong>Server Response:</strong><br><pre>' + xhr.responseText.substring(0, 500) + '</pre>';
                }
            }
            
            Swal.fire({
                title: 'Template Creation Error',
                html: errorMsg,
                icon: 'error'
            });
        }
    });
}

function previewTemplate(id) {
    // Get template content and show in preview modal
    $.ajax({
        url: './serverside/data/get_template_content.php',
        type: 'POST',
        data: { template_id: id },
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                $('#templatePreviewContent').html('<h5>' + response.subject + '</h5><hr>' + response.content);
                $('#previewTemplateModal').modal('show');
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to load template preview', 'error');
        }
    });
}

function editTemplate(id) {
    // Get template details
    $.ajax({
        url: './serverside/data/get_template_details.php',
        type: 'POST',
        data: { template_id: id },
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                var template = response.template;
                
                // Populate edit form
                $('#editTemplateId').val(template.id);
                $('#editTemplateName').val(template.name);
                $('#editTemplateSubject').val(template.subject);
                $('#editTemplateContent').summernote('code', template.content);
                $('#editTemplateContentType').val(template.content_type);
                $('#editTemplateType').val(template.template_type);
                $('#editTemplateActive').prop('checked', template.is_active == 1);
                
                // Live preview removed
                
                // Show edit modal
                $('#editTemplateModal').modal('show');
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to load template details', 'error');
        }
    });
}

function updateTemplate() {
    var formData = {
        template_id: $('#editTemplateId').val(),
        name: $('#editTemplateName').val().trim(),
        subject: $('#editTemplateSubject').val().trim(),
        content: $('#editTemplateContent').summernote('code'),
        content_type: $('#editTemplateContentType').val(),
        template_type: $('#editTemplateType').val(),
        is_active: $('#editTemplateActive').is(':checked') ? 1 : 0
    };
    
    // Validation
    if(!formData.name || !formData.subject || !formData.content) {
        Swal.fire('Error', 'Please fill in all required fields', 'error');
        return;
    }
    
    $.ajax({
        url: './serverside/forms/update_email_template.php',
        type: 'POST',
        data: formData,
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire('Success', response.msg, 'success');
                $('#editTemplateModal').modal('hide');
                loadTemplates(); // Reload templates
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function(xhr, status, error) {
            Swal.fire('Error', 'Failed to update template: ' + error, 'error');
        }
    });
}

function duplicateTemplate(id) {
    Swal.fire({
        title: 'Duplicate Template?',
        text: 'This will create a copy of the template with a new name',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Duplicate',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#28a745'
    }).then(function(result) {
        if(result.isConfirmed) {
            // Show loading
            Swal.fire({
                title: 'Duplicating Template...',
                text: 'Please wait while we create a copy',
                icon: 'info',
                allowOutsideClick: false,
                showConfirmButton: false,
                willOpen: () => {
                    Swal.showLoading();
                }
            });
            
            $.ajax({
                url: './serverside/forms/duplicate_email_template.php',
                type: 'POST',
                data: { template_id: id },
                dataType: 'json',
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire({
                            title: 'Success!',
                            text: response.msg,
                            icon: 'success',
                            confirmButtonText: 'OK'
                        }).then(function() {
                            loadTemplates(); // Reload templates to show the duplicate
                        });
                    } else {
                        Swal.fire('Error', response.msg, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    var errorMsg = 'Failed to duplicate template: ' + error;
                    
                    if(xhr.responseText) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if(response.msg) {
                                errorMsg = response.msg;
                            }
                        } catch(e) {
                            // If not JSON, show raw response
                            errorMsg += '<br><br><strong>Server Response:</strong><br><pre>' + xhr.responseText.substring(0, 500) + '</pre>';
                        }
                    }
                    
                    Swal.fire({
                        title: 'Duplication Error',
                        html: errorMsg,
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            });
        }
    });
}

function deleteTemplate(id) {
    Swal.fire({
        title: 'Delete Template?',
        text: 'This action cannot be undone',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, Delete',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#d33'
    }).then(function(result) {
        if(result.isConfirmed) {
            // Show loading
            Swal.fire({
                title: 'Deleting Template...',
                text: 'Please wait while we delete the template',
                icon: 'info',
                allowOutsideClick: false,
                showConfirmButton: false,
                willOpen: () => {
                    Swal.showLoading();
                }
            });
            
            $.ajax({
                url: './serverside/forms/delete_email_template.php',
                type: 'POST',
                data: { template_id: id },
                dataType: 'json',
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire({
                            title: 'Deleted!',
                            text: response.msg,
                            icon: 'success',
                            confirmButtonText: 'OK'
                        }).then(function() {
                            loadTemplates(); // Reload templates to reflect the deletion
                        });
                    } else if(response.response == 3) {
                        // Template is in use, ask for confirmation
                        Swal.fire({
                            title: 'Template In Use',
                            html: response.msg + '<br><br><small>' + response.usage_details.join('<br>') + '</small>',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonText: 'Delete Anyway',
                            cancelButtonText: 'Cancel',
                            confirmButtonColor: '#d33'
                        }).then(function(forceResult) {
                            if(forceResult.isConfirmed) {
                                // Force delete
                                $.ajax({
                                    url: './serverside/forms/delete_email_template.php',
                                    type: 'POST',
                                    data: { template_id: id, force_delete: 1 },
                                    dataType: 'json',
                                    success: function(forceResponse) {
                                        if(forceResponse.response == 1) {
                                            Swal.fire({
                                                title: 'Deleted!',
                                                text: forceResponse.msg,
                                                icon: 'success',
                                                confirmButtonText: 'OK'
                                            }).then(function() {
                                                loadTemplates();
                                            });
                                        } else {
                                            Swal.fire('Error', forceResponse.msg, 'error');
                                        }
                                    },
                                    error: function(xhr, status, error) {
                                        Swal.fire('Error', 'Failed to delete template: ' + error, 'error');
                                    }
                                });
                            }
                        });
                    } else {
                        Swal.fire('Error', response.msg, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    var errorMsg = 'Failed to delete template: ' + error;
                    
                    if(xhr.responseText) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if(response.msg) {
                                errorMsg = response.msg;
                            }
                        } catch(e) {
                            // If not JSON, show raw response
                            errorMsg += '<br><br><strong>Server Response:</strong><br><pre>' + xhr.responseText.substring(0, 500) + '</pre>';
                        }
                    }
                    
                    Swal.fire({
                        title: 'Deletion Error',
                        html: errorMsg,
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            });
        }
    });
}
{/literal}
</script>

<script src="./dist/js/scripts.js"></script>
<script src="./dist/js/custom.js?v=2"></script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>

