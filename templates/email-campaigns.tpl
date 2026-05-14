<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — Email Campaigns</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/dist/modules/bootstrap-social/bootstrap-social.css">
<link rel="stylesheet" href="/dist/modules/datatables/datatables.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/Select-1.2.4/css/select.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/select2.min.css">
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}

<style>
/* Icon Picker Styles for Email Campaigns */
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

/* Enhanced editor container */
.editor-container {
    position: relative;
}

/* Template preview mode isolation */
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
    background: white !important;
    color: #333 !important;
}

.note-toolbar .dropdown-item:hover {
    background: #f8f9fa !important;
    color: #333 !important;
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

.theme-toggle {
    position: absolute;
    top: -35px;
    right: 0;
    z-index: 10;
}

.theme-toggle .btn {
    background: #2d2d2d;
    border: 1px solid #404040;
    color: #ffffff;
    padding: 5px 10px;
    font-size: 12px;
}

.theme-toggle .btn:hover {
    background: #404040;
}

/* Bulk Email Recipients Styles */
.recipient-options {
    background: #f8f9fa;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 20px;
    margin-top: 10px;
}

.recipient-options .form-check {
    margin-bottom: 15px;
    padding: 10px;
    border-radius: 6px;
    transition: background-color 0.2s ease;
}

.recipient-options .form-check:hover {
    background-color: #e9ecef;
}

.recipient-options .form-check-input:checked + .form-check-label {
    color: #007bff;
    font-weight: 600;
}

.custom-file-label::after {
    content: "Browse";
    background: #007bff;
    color: white;
    border-color: #007bff;
}

#uploadPreview {
    max-height: 200px;
    overflow-y: auto;
}

#recipientSummary {
    border-left: 4px solid #17a2b8;
    background: #e8f4f8;
    border-color: #bee5eb;
}

.email-list-stats {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
    gap: 10px;
    margin-top: 10px;
}

.stat-item {
    text-align: center;
    padding: 8px;
    background: white;
    border-radius: 4px;
    border: 1px solid #dee2e6;
}

.stat-number {
    font-size: 18px;
    font-weight: bold;
    color: #007bff;
}

.stat-label {
    font-size: 12px;
    color: #6c757d;
    text-transform: uppercase;
}

/* Campaign table styling to match view-user page */
.campaign-name-class {
    color: white !important;
    text-decoration: none;
    cursor: pointer;
}

.campaign-name-class:hover {
    color: #f8f9fa !important;
    text-decoration: underline;
}

/* Avatar icon styles removed */

.table-listcampaign .badge {
    font-size: 0.75rem;
    padding: 0.25rem 0.5rem;
}

.table-listcampaign .btn-group-md .btn {
    padding: 0.375rem 0.75rem;
    font-size: 0.875rem;
}

/* Card header button styling - original template design */
.card-header-action {
    display: flex;
    align-items: center;
    margin-left: auto;
}

.card-header-action .btn {
    margin-left: 0.5rem;
}

.card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 1.25rem 1.25rem;
    margin-bottom: 0;
    background-color: rgba(0,0,0,.03);
    border-bottom: 1px solid rgba(0,0,0,.125);
}

.card-header h4 {
    margin-bottom: 0;
    font-size: 1.25rem;
    font-weight: 600;
    color: #34395e;
}

/* Summernote editor icon fixes */
.note-editor .note-toolbar {
    background: #f8f9fa;
    border-bottom: 1px solid #e9ecef;
    padding: 10px;
}

.note-editor .note-toolbar .note-btn {
    background: white;
    border: 1px solid #e9ecef;
    color: #495057;
    margin: 2px;
    padding: 6px 12px;
    border-radius: 4px;
}

.note-editor .note-toolbar .note-btn:hover {
    background: #e9ecef;
    border-color: #adb5bd;
}

.note-editor .note-toolbar .note-btn.active {
    background: #007bff;
    border-color: #007bff;
    color: white;
}

/* Better Summernote icon styling */
.note-toolbar .note-btn {
    min-width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    font-weight: normal;
}

/* Preview modal styling */
#previewCampaignModal .modal-dialog {
    max-width: 90%;
    width: 800px;
}

#previewCampaignModal .modal-body {
    max-height: 70vh;
    overflow-y: auto;
}

#campaignPreviewContent {
    border: 1px solid #dee2e6;
    border-radius: 5px;
    background: #f8f9fa;
    min-height: 200px;
}

/* Ensure modal stays on top and doesn't affect page layout */
.modal-backdrop {
    z-index: 1040;
}

.modal {
    z-index: 1050;
}

/* Campaign preview styling for normal-modalize system */
.normal-modal-dialog.modal-lg {
    max-width: 90%;
    width: 900px;
}

.campaign-preview-container {
    max-height: 70vh;
    overflow-y: auto;
}

.preview-content-wrapper {
    margin-top: 15px;
}

.preview-content-frame {
    border: 2px solid #dee2e6;
    border-radius: 8px;
    padding: 20px;
    background: #ffffff;
    min-height: 300px;
    max-height: 400px;
    overflow-y: auto;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.preview-content-frame img {
    max-width: 100%;
    height: auto;
}

.preview-content-frame table {
    width: 100%;
    border-collapse: collapse;
}

.preview-content-frame table td,
.preview-content-frame table th {
    padding: 8px;
    border: 1px solid #ddd;
}

/* Prevent any layout shifts during modal */
.modal-open {
    padding-right: 0 !important;
}

.modal-backdrop {
    z-index: 1040 !important;
}

#previewCampaignModal {
    z-index: 1050 !important;
}

/* Ensure main page stays stable */
.card {
    position: relative !important;
}

.card-body {
    position: relative !important;
}

/* Loading spinner styling */
.fa-spinner.fa-spin {
    animation: fa-spin 1s infinite linear;
}

@keyframes fa-spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

/* FontAwesome icon fallbacks with better styling */
.note-btn[data-original-title*="Bold"] i::before,
.note-btn[title*="Bold"] i::before { content: "B"; font-weight: bold; font-size: 16px; }

.note-btn[data-original-title*="Italic"] i::before,
.note-btn[title*="Italic"] i::before { content: "I"; font-style: italic; font-size: 16px; }

.note-btn[data-original-title*="Underline"] i::before,
.note-btn[title*="Underline"] i::before { content: "U"; text-decoration: underline; font-size: 16px; }

.note-btn[data-original-title*="Strikethrough"] i::before,
.note-btn[title*="Strikethrough"] i::before { content: "S"; text-decoration: line-through; font-size: 16px; }

.note-btn[data-original-title*="Superscript"] i::before,
.note-btn[title*="Superscript"] i::before { content: "x²"; font-size: 12px; }

.note-btn[data-original-title*="Subscript"] i::before,
.note-btn[title*="Subscript"] i::before { content: "x₂"; font-size: 12px; }

.note-btn[data-original-title*="Remove"] i::before,
.note-btn[title*="Remove"] i::before { content: "✗"; font-size: 14px; color: #dc3545; }

.note-btn[data-original-title*="Link"] i::before,
.note-btn[title*="Link"] i::before { content: "🔗"; font-size: 14px; }

.note-btn[data-original-title*="Picture"] i::before,
.note-btn[title*="Picture"] i::before { content: "🖼"; font-size: 14px; }

.note-btn[data-original-title*="Video"] i::before,
.note-btn[title*="Video"] i::before { content: "🎥"; font-size: 14px; }

.note-btn[data-original-title*="Table"] i::before,
.note-btn[title*="Table"] i::before { content: "⊞"; font-size: 16px; }

.note-btn[data-original-title*="Code"] i::before,
.note-btn[title*="Code"] i::before { content: "</>"; font-size: 12px; font-family: monospace; }

.note-btn[data-original-title*="Undo"] i::before,
.note-btn[title*="Undo"] i::before { content: "↶"; font-size: 16px; }

.note-btn[data-original-title*="Redo"] i::before,
.note-btn[title*="Redo"] i::before { content: "↷"; font-size: 16px; }

.note-btn[data-original-title*="Fullscreen"] i::before,
.note-btn[title*="Fullscreen"] i::before { content: "⛶"; font-size: 14px; }

.note-btn[data-original-title*="Help"] i::before,
.note-btn[title*="Help"] i::before { content: "?"; font-size: 16px; font-weight: bold; }

/* List icons */
.note-btn[data-original-title*="Unordered"] i::before,
.note-btn[title*="Unordered"] i::before { content: "•"; font-size: 16px; }

.note-btn[data-original-title*="Ordered"] i::before,
.note-btn[title*="Ordered"] i::before { content: "1."; font-size: 12px; }

/* Alignment icons */
.note-btn[data-original-title*="Left"] i::before,
.note-btn[title*="Left"] i::before { content: "⫷"; font-size: 14px; }

.note-btn[data-original-title*="Center"] i::before,
.note-btn[title*="Center"] i::before { content: "≡"; font-size: 14px; }

.note-btn[data-original-title*="Right"] i::before,
.note-btn[title*="Right"] i::before { content: "⫸"; font-size: 14px; }

.note-btn[data-original-title*="Justify"] i::before,
.note-btn[title*="Justify"] i::before { content: "⫼"; font-size: 14px; }

/* Color icons */
.note-btn[data-original-title*="Text Color"] i::before,
.note-btn[title*="Text Color"] i::before { content: "A"; font-size: 16px; font-weight: bold; }

.note-btn[data-original-title*="Background"] i::before,
.note-btn[title*="Background"] i::before { content: "▌"; font-size: 16px; }

/* Ensure all icons are properly centered */
.note-toolbar .note-btn i {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100%;
    font-style: normal;
}

/* Fix empty icons */
.note-toolbar .note-btn i:empty::before {
    content: "⚙";
    font-size: 14px;
    color: #6c757d;
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
<h1>Email Campaigns</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Main</div>
<div class="breadcrumb-item active">Bulk Email</div>
<div class="breadcrumb-item active">Email Campaigns</div>
</div>
</div>
<div class="section-body">
<div class="row">
<div class="col-md-12">
<div class="card card-primary">
<div class="card-header">
<h4>Manage Campaigns</h4>
<div class="card-header-action">
<button class="btn btn-primary" data-toggle="modal" data-target="#createCampaignModal">
<i class="fas fa-plus"></i> Create Campaign
</button>
</div>
</div>
<div class="card-body">
<div class="alert alert-primary" role="alert">
    <strong>EMAIL CAMPAIGNS : </strong> Manage and send bulk email campaigns to your subscribers.<br>
    <strong>TEMPLATES : </strong> Use predefined templates or create custom email content with rich text editor.
</div>

{* Auto-Fix System Notification *}
{if $auto_fix_result.fixed > 0}
<div class="alert alert-success alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="alert-heading">🚀 Auto-Fix Complete!</h4>
    <p><strong>{$auto_fix_result.fixed}</strong> stuck campaigns were automatically detected and sent successfully!</p>
    {if $auto_fix_result.campaigns}
        <hr>
        <h6>📧 Campaign Details:</h6>
        <ul class="mb-0">
        {foreach from=$auto_fix_result.campaigns item=campaign}
            <li><strong>{$campaign.name|escape}</strong> - Sent: {$campaign.sent}, Failed: {$campaign.failed}</li>
        {/foreach}
        </ul>
    {/if}
    <hr>
    <p class="mb-0">
        <small class="text-muted">
            <i class="fas fa-info-circle"></i>
            Campaigns that were stuck in "sending" status have been automatically processed and delivered to subscribers.
        </small>
    </p>
</div>
{/if}
<table class="table table-striped table-listcampaign" id="campaignsTable" style="width: 100%">
<thead>
<tr>
<th>Campaign Name</th>
<th>Subject</th>
<th>Status</th>
<th>Recipients</th>
<th>Sent</th>
<th>Opens</th>
<th>Created Date</th>
<th>Action</th>
</tr>
</thead>
</table>
</div>
</div>
</div>
</div>
</div>
</section>
</div>

<!-- Create Campaign Modal -->
<div class="modal fade" id="createCampaignModal" tabindex="-1" role="dialog">
<div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Create New Campaign</h5>
<button type="button" class="close" data-dismiss="modal">
<span>&times;</span>
</button>
</div>
<div class="modal-body">
<form id="createCampaignForm">
<div class="row">
<div class="col-md-6">
<div class="form-group">
<label for="campaignName">Campaign Name *</label>
<input type="text" class="form-control" id="campaignName" name="name" required>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label for="campaignSubject">Email Subject *</label>
<input type="text" class="form-control" id="campaignSubject" name="subject" required>
</div>
</div>
</div>

<div class="form-group">
<label for="campaignTemplate">Use Template</label>
<select class="form-control" id="campaignTemplate" name="template_id">
<option value="">Select a template (optional)</option>
<!-- Templates loaded via AJAX -->
</select>
</div>

<div class="form-group">
<label for="campaignContent">Email Content *</label>
<div class="editor-container" style="position: relative;">
<div class="theme-toggle">
<button type="button" class="btn btn-sm" onclick="togglePreviewMode('campaignContent')" title="Toggle Template Preview">
<i class="fas fa-eye"></i>
</button>
</div>
<textarea class="form-control" id="campaignContent" name="content" rows="15" required></textarea>
</div>
<small class="form-text text-muted">
Available placeholders: <code>{literal}{name}, {email}, {unsubscribe_url}, {website_url}{/literal}</code>
</small>
</div>

<!-- Icon Picker Section -->
<div class="form-group">
<label>Email-Safe Icons</label>
<div class="icon-picker-container">
<div class="alert alert-info">
<i class="fas fa-info-circle"></i> <strong>Click any icon below to insert it into your campaign</strong> - These icons work in all email clients!
</div>
<div class="icon-grid" id="campaignIconGrid">
<!-- Icons will be populated by JavaScript -->
</div>
</div>
</div>

<div class="row">
<div class="col-md-6">
<div class="form-group">
<label for="campaignType">Content Type</label>
<select class="form-control" id="campaignType" name="content_type">
<option value="html">HTML</option>
<option value="text">Plain Text</option>
</select>
</div>
</div>
<div class="col-md-6">
<div class="form-group">
<label for="scheduledDate">Schedule Date (Optional)</label>
<input type="datetime-local" class="form-control" id="scheduledDate" name="scheduled_date">
</div>
</div>
</div>

<div class="form-group">
<label>📧 Bulk Email Recipients</label>
<div class="recipient-options">

<!-- All Subscribers Option -->
<div class="form-check">
<input class="form-check-input" type="radio" name="recipient_type" id="allSubscribers" value="all" checked>
<label class="form-check-label" for="allSubscribers">
<strong>All Active Subscribers</strong> <span class="text-muted" id="allSubscribersCount">(Loading...)</span>
</label>
</div>

<!-- Tagged Subscribers Option -->
<div class="form-check">
<input class="form-check-input" type="radio" name="recipient_type" id="taggedSubscribers" value="tagged">
<label class="form-check-label" for="taggedSubscribers">
<strong>Subscribers with specific tags</strong>
</label>
</div>
<div class="form-group mt-2" id="tagsGroup" style="display: none;">
<input type="text" class="form-control" id="recipientTags" name="recipient_tags" placeholder="Enter tags separated by commas (e.g., premium, newsletter, vip)">
<small class="form-text text-muted">Available tags will be suggested as you type</small>
</div>

<!-- Email List Upload Option -->
<div class="form-check">
<input class="form-check-input" type="radio" name="recipient_type" id="uploadList" value="upload">
<label class="form-check-label" for="uploadList">
<strong>Upload Email List</strong> <span class="text-muted">(CSV, TXT)</span>
</label>
</div>
<div class="form-group mt-2" id="uploadGroup" style="display: none;">
<div class="custom-file">
<input type="file" class="custom-file-input" id="emailListFile" accept=".csv,.txt,.xlsx" name="email_list_file">
<label class="custom-file-label" for="emailListFile">Choose email list file...</label>
</div>
<small class="form-text text-muted">
<strong>Supported formats:</strong> CSV (email,name), TXT (one email per line), Excel<br>
<strong>Max file size:</strong> 10MB | <strong>Max emails:</strong> 10,000
</small>
<div id="uploadPreview" class="mt-2" style="display: none;">
<div class="alert alert-info">
<strong>📊 File Preview:</strong>
<div id="uploadStats"></div>
</div>
</div>
</div>

<!-- Saved Email Lists Option -->
<div class="form-check">
<input class="form-check-input" type="radio" name="recipient_type" id="savedLists" value="saved">
<label class="form-check-label" for="savedLists">
<strong>Use Saved Email List</strong>
</label>
</div>
<div class="form-group mt-2" id="savedListsGroup" style="display: none;">
<select class="form-control" id="savedEmailLists" name="saved_list_id">
<option value="">Select a saved email list...</option>
<!-- Lists loaded via AJAX -->
</select>
<div class="mt-2">
<button type="button" class="btn btn-sm btn-outline-primary" onclick="manageSavedLists()">
<i class="fas fa-cog"></i> Manage Lists
</button>
<button type="button" class="btn btn-sm btn-outline-success" onclick="createNewList()">
<i class="fas fa-plus"></i> Create New List
</button>
</div>
</div>

<!-- Manual Email Entry Option -->
<div class="form-check">
<input class="form-check-input" type="radio" name="recipient_type" id="manualEmails" value="manual">
<label class="form-check-label" for="manualEmails">
<strong>Enter Emails Manually</strong>
</label>
</div>
<div class="form-group mt-2" id="manualGroup" style="display: none;">
<textarea class="form-control" id="manualEmailList" name="manual_emails" rows="4"
placeholder="Enter email addresses separated by commas or new lines:
john@example.com, jane@example.com
admin@company.com"></textarea>
<small class="form-text text-muted">Enter one email per line or separate with commas</small>
</div>

</div>

<!-- Recipient Summary -->
<div class="alert alert-info mt-3" id="recipientSummary">
<strong>📊 Campaign Summary:</strong>
<div id="recipientCount">Select recipients to see count</div>
</div>

</div>
</form>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
<button type="button" class="btn btn-info" onclick="saveDraft()">Save as Draft</button>
<button type="button" class="btn btn-primary" onclick="createCampaign('sending')">Create & Send</button>
</div>
</div>
</div>
</div>

<!-- Campaign Preview Modal - Using stable normal-modalize system -->
<div class="modal fade normal-modalize" role="dialog" aria-labelledby="smallmodal">
<div class="modal-dialog modal-lg normal-modal-dialog" role="document">
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
<script src="/dist/modules/select2.full.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/notification_js.tpl'}
{include file='js/page/email_campaigns_js.tpl'}
{include file='js/page/search_js.tpl'}

{* Auto-Fix JavaScript Notification *}
{if $auto_fix_result.fixed > 0}
<script>
$(document).ready(function() {
    // Show success toast notification
    const toastHtml = '<div class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-delay="10000" style="position: fixed; top: 80px; right: 20px; z-index: 9999; min-width: 350px;">' +
        '<div class="toast-header" style="background: #28a745; color: white;">' +
        '<strong class="mr-auto">🚀 Auto-Fix Complete</strong>' +
        '<small class="text-light">{$auto_fix_result.fixed} campaigns fixed</small>' +
        '<button type="button" class="ml-2 mb-1 close text-light" data-dismiss="toast" aria-label="Close">' +
        '<span aria-hidden="true">&times;</span>' +
        '</button>' +
        '</div>' +
        '<div class="toast-body" style="background: #d4edda; color: #155724;">' +
        '<strong>{$auto_fix_result.fixed}</strong> stuck campaigns were automatically sent!<br>' +
        '<small>Campaigns have been delivered to subscribers.</small>' +
        '</div>' +
        '</div>';

    $('body').append(toastHtml);
    $('.toast').toast('show');

    // Auto-reload campaigns table after showing notification
    setTimeout(function() {
        if (typeof campaignsTable !== 'undefined') {
            campaignsTable.ajax.reload();
        }
    }, 2000);

    // Console log for debugging
    });
</script>
{/if}

{* Campaign creation success handling *}
<script>
// Simple campaign management without auto-fix monitoring
$(document).ready(function() {
    // Focus on campaign creation and sending functionality
    // Handle campaign creation success
    if (typeof createCampaignForm !== 'undefined') {
        // Campaign form handling can be added here if needed
    }
});
</script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>

