<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — {if $is_editing}Edit{else}Create{/if} Email Template</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="./dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="./dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-bs4.min.css">
<link rel="stylesheet" href="./dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="./dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}

<style>
/* Full-page template editor styling */
body {
    background: #f8f9fa;
    overflow-x: hidden;
}

.template-editor-container {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

.editor-header {
    background: white;
    border-bottom: 1px solid #dee2e6;
    padding: 15px 0;
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.editor-content {
    flex: 1;
    display: flex;
    gap: 20px;
    padding: 20px;
    max-width: 1400px;
    margin: 0 auto;
    width: 100%;
}

.editor-panel {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    padding: 25px;
    flex: 1;
}

.preview-panel {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    padding: 25px;
    flex: 1;
    max-height: calc(100vh - 140px);
    overflow-y: auto;
}

.form-section {
    margin-bottom: 30px;
    padding-bottom: 25px;
    border-bottom: 1px solid #eee;
}

.form-section:last-child {
    border-bottom: none;
    margin-bottom: 0;
}

.section-title {
    font-size: 18px;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.editor-toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
}

.btn-group-custom {
    display: flex;
    gap: 10px;
}

/* Enhanced Summernote styling for full page */
.note-editor {
    border: 1px solid #dee2e6;
    border-radius: 8px;
    min-height: 600px;
}

.note-editable {
    min-height: 550px;
    padding: 20px;
    font-family: Arial, sans-serif;
    line-height: 1.6;
}

.note-toolbar {
    background: #f8f9fa;
    border-bottom: 1px solid #dee2e6;
    padding: 10px 15px;
}

/* Preview panel styling */
.preview-container {
    border: 1px solid #dee2e6;
    border-radius: 8px;
    background: #f8f9fa;
    min-height: 500px;
    padding: 20px;
}

.preview-header {
    background: #e9ecef;
    padding: 10px 15px;
    border-radius: 6px 6px 0 0;
    border-bottom: 1px solid #dee2e6;
    font-weight: 600;
    color: #495057;
}

.preview-content {
    padding: 20px;
    background: white;
    border-radius: 0 0 6px 6px;
    min-height: 400px;
}

/* Template preview mode styling */
.template-preview-mode .preview-content {
    background: transparent;
}

/* Responsive design */
@media (max-width: 1200px) {
    .editor-content {
        flex-direction: column;
    }
    
    .preview-panel {
        max-height: 500px;
    }
}

@media (max-width: 768px) {
    .editor-content {
        padding: 15px;
        gap: 15px;
    }
    
    .editor-panel,
    .preview-panel {
        padding: 20px;
    }
    
    .editor-toolbar {
        flex-direction: column;
        align-items: stretch;
    }
    
    .btn-group-custom {
        justify-content: center;
    }
}

/* Action buttons styling */
.action-buttons {
    display: flex;
    gap: 10px;
    align-items: center;
}

.btn-save {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    border: none;
    color: white;
    padding: 10px 25px;
    border-radius: 6px;
    font-weight: 600;
}

.btn-save:hover {
    background: linear-gradient(135deg, #218838 0%, #1ea085 100%);
    color: white;
}

.btn-preview-toggle {
    background: #17a2b8;
    border: none;
    color: white;
    padding: 10px 20px;
    border-radius: 6px;
}

.btn-preview-toggle:hover {
    background: #138496;
    color: white;
}
</style>
</head>

<body>
<div class="template-editor-container">
    <!-- Header -->
    <div class="editor-header">
        <div class="container-fluid">
            <div class="editor-toolbar">
                <div class="d-flex align-items-center">
                    <a href="/email-templates" class="btn btn-outline-secondary me-3">
                        <i class="fas fa-arrow-left"></i> Back to Templates
                    </a>
                    <h4 class="mb-0">
                        <i class="fas fa-envelope"></i>
                        {if $is_editing}Edit Email Template{else}Create New Email Template{/if}
                    </h4>
                </div>
                
                <div class="action-buttons">
                    <button type="button" class="btn btn-preview-toggle" onclick="togglePreview()">
                        <i class="fas fa-eye"></i> <span id="previewToggleText">Show Preview</span>
                    </button>
                    <button type="button" class="btn btn-outline-primary" onclick="loadPreset()">
                        <i class="fas fa-magic"></i> Use Preset
                    </button>
                    <button type="button" class="btn btn-save" onclick="saveTemplate()">
                        <i class="fas fa-save"></i> {if $is_editing}Update Template{else}Create Template{/if}
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="editor-content">
        <!-- Editor Panel -->
        <div class="editor-panel">
            <form id="templateForm">
                {if $is_editing}
                <input type="hidden" id="templateId" value="{$template_data.id}">
                {/if}
                
                <!-- Basic Information -->
                <div class="form-section">
                    <h5 class="section-title">
                        <i class="fas fa-info-circle text-primary"></i>
                        Basic Information
                    </h5>
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label for="templateName">Template Name *</label>
                                <input type="text" class="form-control" id="templateName" name="name" 
                                       value="{if $is_editing}{$template_data.name}{/if}" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="templateType">Template Type</label>
                                <select class="form-control" id="templateType" name="template_type">
                                    <option value="custom" {if $is_editing && $template_data.template_type == 'custom'}selected{/if}>Custom</option>
                                    <option value="welcome" {if $is_editing && $template_data.template_type == 'welcome'}selected{/if}>Welcome</option>
                                    <option value="newsletter" {if $is_editing && $template_data.template_type == 'newsletter'}selected{/if}>Newsletter</option>
                                    <option value="promotion" {if $is_editing && $template_data.template_type == 'promotion'}selected{/if}>Promotion</option>
                                    <option value="announcement" {if $is_editing && $template_data.template_type == 'announcement'}selected{/if}>Announcement</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="templateSubject">Email Subject *</label>
                        <input type="text" class="form-control" id="templateSubject" name="subject" 
                               value="{if $is_editing}{$template_data.subject}{/if}" required>
                    </div>
                </div>

                <!-- Content Editor -->
                <div class="form-section">
                    <h5 class="section-title">
                        <i class="fas fa-edit text-success"></i>
                        Email Content
                    </h5>
                    
                    <div class="form-group">
                        <textarea class="form-control" id="templateContent" name="content">{if $is_editing}{$template_data.content}{/if}</textarea>
                        <small class="form-text text-muted mt-2">
                            <strong>Available placeholders:</strong> 
                            <code>{literal}{name}, {email}, {website_url}, {unsubscribe_url}, {website_name}{/literal}</code>
                        </small>
                    </div>
                </div>

                <!-- Settings -->
                <div class="form-section">
                    <h5 class="section-title">
                        <i class="fas fa-cog text-warning"></i>
                        Template Settings
                    </h5>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="templateContentType">Content Type</label>
                                <select class="form-control" id="templateContentType" name="content_type">
                                    <option value="html" {if $is_editing && $template_data.content_type == 'html'}selected{/if}>HTML</option>
                                    <option value="text" {if $is_editing && $template_data.content_type == 'text'}selected{/if}>Plain Text</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <div class="custom-control custom-switch mt-4">
                                    <input type="checkbox" class="custom-control-input" id="templateActive" name="is_active" 
                                           {if !$is_editing || ($is_editing && $template_data.is_active == 1)}checked{/if}>
                                    <label class="custom-control-label" for="templateActive">Active Template</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- Preview Panel -->
        <div class="preview-panel" id="previewPanel" style="display: none;">
            <h5 class="section-title">
                <i class="fas fa-eye text-info"></i>
                Live Preview
            </h5>
            
            <div class="preview-container">
                <div class="preview-header" id="previewSubject">
                    Subject: Enter email subject...
                </div>
                <div class="preview-content" id="previewContent">
                    <p class="text-muted text-center">Preview will appear here...</p>
                </div>
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

<script src="./dist/modules/jquery.min.js"></script>
<script src="./dist/modules/popper.js"></script>
<script src="./dist/modules/tooltip.js"></script>
<script src="./dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="./dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script src="./dist/modules/moment.min.js"></script>
<script src="./dist/js/stisla.js"></script>
<script src="./dist/sweetalert2/sweetalert2.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-bs4.min.js"></script>

<script>
{literal}
$(document).ready(function() {
    initializeEditor();
    
    // Auto-update preview when content changes
    $('#templateSubject').on('input', updatePreview);
});

function initializeEditor() {
    $('#templateContent').summernote({
        height: 550,
        minHeight: 400,
        placeholder: 'Enter your email content here...',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
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
                updatePreview();
            }
        }
    });
}

function togglePreview() {
    var previewPanel = $('#previewPanel');
    var toggleText = $('#previewToggleText');
    
    if (previewPanel.is(':visible')) {
        previewPanel.hide();
        toggleText.text('Show Preview');
    } else {
        previewPanel.show();
        toggleText.text('Hide Preview');
        updatePreview();
    }
}

function updatePreview() {
    var subject = $('#templateSubject').val() || 'Enter email subject...';
    var content = $('#templateContent').summernote('code');
    
    // Replace placeholders with sample data
    var previewContent = content
        .replace(/\{name\}/g, 'John Doe')
        .replace(/\{email\}/g, 'john@example.com')
        .replace(/\{website_url\}/g, window.location.origin)
        .replace(/\{unsubscribe_url\}/g, '#unsubscribe')
        .replace(/\{website_name\}/g, 'VPN Service');
    
    $('#previewSubject').text('Subject: ' + subject);
    $('#previewContent').html(previewContent || '<p class="text-muted text-center">Preview will appear here...</p>');
}

function loadPreset() {
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
                
                // Fill form with preset data
                $('#templateName').val(preset.name);
                $('#templateSubject').val(preset.subject);
                $('#templateContent').summernote('code', preset.content);
                $('#templateType').val(preset.template_type);
                $('#templateContentType').val('html');
                
                // Close modal and update preview
                $('#templatePresetsModal').modal('hide');
                updatePreview();
                
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

function saveTemplate() {
    var isEditing = $('#templateId').length > 0;
    var formData = {
        name: $('#templateName').val().trim(),
        subject: $('#templateSubject').val().trim(),
        content: $('#templateContent').summernote('code'),
        content_type: $('#templateContentType').val(),
        template_type: $('#templateType').val(),
        is_active: $('#templateActive').is(':checked') ? 1 : 0
    };
    
    if(isEditing) {
        formData.template_id = $('#templateId').val();
    }
    
    // Validation
    if(!formData.name || !formData.subject || !formData.content) {
        Swal.fire('Error', 'Please fill in all required fields', 'error');
        return;
    }
    
    var url = isEditing ? './serverside/forms/update_email_template.php' : './serverside/forms/create_email_template.php';
    
    $.ajax({
        url: url,
        type: 'POST',
        data: formData,
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire({
                    title: 'Success!',
                    text: response.msg,
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then(function() {
                    window.location.href = '/email-templates';
                });
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function(xhr, status, error) {
            console.error('Template save error:', xhr, status, error);
            Swal.fire('Error', 'Failed to save template: ' + error, 'error');
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
