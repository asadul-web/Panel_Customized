<script>
{literal}
// SMTP password toggle function
function toggleSmtpPassword() {
    var passwordField = document.getElementById('smtp_password');
    var toggleIcon = document.getElementById('smtp-password-toggle-icon');
    
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        toggleIcon.innerHTML = '<i class="fas fa-eye-slash"></i>';
    } else {
        passwordField.type = 'password';
        toggleIcon.innerHTML = '<i class="fas fa-eye"></i>';
    }
}

// Helper function to add placeholder buttons
function addPlaceholderButtons(editor, placeholders) {
    var editorId = editor.attr('id');
    var toolbar = editor.next('.note-editor').find('.note-toolbar');
    
    // Create placeholder dropdown
    var placeholderGroup = $('<div class="note-btn-group btn-group">');
    var placeholderBtn = $('<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" title="Insert Placeholder">' +
                          '<i class="fas fa-tags"></i> <span class="caret"></span></button>');
    var placeholderMenu = $('<ul class="dropdown-menu">');
    
    placeholders.forEach(function(placeholder) {
        var menuItem = $('<li><a href="#" data-placeholder="' + placeholder + '">{' + placeholder + '}</a></li>');
        menuItem.find('a').on('click', function(e) {
            e.preventDefault();
            var placeholderText = '{' + $(this).data('placeholder') + '}';
            editor.summernote('insertText', placeholderText);
        });
        placeholderMenu.append(menuItem);
    });
    
    placeholderGroup.append(placeholderBtn);
    placeholderGroup.append(placeholderMenu);
    toolbar.append(placeholderGroup);
    
    // Add Bangla font button
    var banglaGroup = $('<div class="note-btn-group btn-group">');
    var banglaBtn = $('<button type="button" class="btn btn-sm bangla-font-btn" title="Apply Bangla Font (Hind Siliguri)">বাংলা</button>');
    
    banglaBtn.on('click', function(e) {
        e.preventDefault();
        var selection = editor.summernote('createRange');
        if (selection.toString()) {
            // Apply font to selected text
            editor.summernote('formatBlock', 'p');
            editor.summernote('fontName', 'Hind Siliguri');
        } else {
            // Set default font for new text
            editor.summernote('fontName', 'Hind Siliguri');
            var editable = editor.next('.note-editor').find('.note-editable');
            editable.addClass('bangla-mode');
        }
    });
    
    banglaGroup.append(banglaBtn);
    toolbar.append(banglaGroup);
}

$(document).ready(function() {
    
    // Initialize Summernote HTML editors for email bodies
    $('.summernote-editor').summernote({
        height: 300,
        minHeight: 200,
        maxHeight: 500,
        placeholder: 'Enter your email content here...',
        fontNames: ['Hind Siliguri', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', 'Helvetica', 'Impact', 'Tahoma', 'Times New Roman', 'Verdana'],
        fontSizes: ['8', '9', '10', '11', '12', '14', '16', '18', '20', '24', '36', '48'],
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'italic', 'clear']],
            ['fontname', ['fontname']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ],
        icons: {
            'align': 'fas fa-align-left',
            'alignCenter': 'fas fa-align-center',
            'alignJustify': 'fas fa-align-justify',
            'alignLeft': 'fas fa-align-left',
            'alignRight': 'fas fa-align-right',
            'bold': 'fas fa-bold',
            'caret': 'fas fa-caret-down',
            'circle': 'fas fa-circle',
            'close': 'fas fa-times',
            'code': 'fas fa-code',
            'eraser': 'fas fa-eraser',
            'font': 'fas fa-font',
            'frame': 'far fa-square',
            'italic': 'fas fa-italic',
            'link': 'fas fa-link',
            'unlink': 'fas fa-unlink',
            'magic': 'fas fa-magic',
            'menuCheck': 'fas fa-check',
            'minus': 'fas fa-minus',
            'orderedlist': 'fas fa-list-ol',
            'pencil': 'fas fa-pencil-alt',
            'picture': 'fas fa-image',
            'question': 'fas fa-question',
            'redo': 'fas fa-redo',
            'rollback': 'fas fa-undo',
            'square': 'far fa-square',
            'strikethrough': 'fas fa-strikethrough',
            'subscript': 'fas fa-subscript',
            'superscript': 'fas fa-superscript',
            'table': 'fas fa-table',
            'textHeight': 'fas fa-text-height',
            'trash': 'fas fa-trash',
            'underline': 'fas fa-underline',
            'undo': 'fas fa-undo',
            'unorderedlist': 'fas fa-list-ul',
            'video': 'fas fa-video'
        },
        styleTags: [
            'p',
            { title: 'Blockquote', tag: 'blockquote', className: 'blockquote', value: 'blockquote' },
            'pre', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'
        ],
        callbacks: {
            onInit: function() {
                // Add placeholder support for email templates
                var editor = $(this);
                var editorId = editor.attr('id');
                
                // Add placeholder buttons to toolbar
                if(editorId === 'welcome_email_body') {
                    addPlaceholderButtons(editor, ['name', 'username', 'password', 'reseller_url']);
                } else if(editorId === 'approval_email_body') {
                    addPlaceholderButtons(editor, ['name', 'business_name']);
                } else if(editorId === 'rejection_email_body') {
                    addPlaceholderButtons(editor, ['name', 'business_name', 'reason']);
                }
                
                // Fix duplicate Summernote IDs by making them unique
                var noteEditor = editor.next('.note-editor');
                noteEditor.find('[id]').each(function() {
                    var el = $(this);
                    var oldId = el.attr('id');
                    if(oldId && oldId.indexOf('sn-') === 0) {
                        var newId = oldId + '-' + editorId;
                        el.attr('id', newId);
                        // Also fix any labels pointing to this ID
                        noteEditor.find('label[for="' + oldId + '"]').attr('for', newId);
                    }
                });
            }
        }
    });
    
    // Settings are already loaded from PHP template
    
    // Toggle SMTP settings visibility
    $('#smtp_enabled').on('change', function() {
        if($(this).is(':checked')) {
            $('#smtp-settings').slideDown();
        } else {
            $('#smtp-settings').slideUp();
        }
    });
    
    // Test SMTP connection
    $('#testSmtp').on('click', function() {
        var btn = $(this);
        var originalText = btn.html();
        
        // Validate required fields
        var host = $('#smtp_host').val().trim();
        var port = $('#smtp_port').val().trim();
        var username = $('#smtp_username').val().trim();
        var password = $('#smtp_password').val().trim();
        
        if(!host || !port || !username || !password) {
            Swal.fire({
                title: 'Missing Information',
                text: 'Please fill in all SMTP fields before testing',
                icon: 'warning',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        btn.html('<i class="fas fa-spinner fa-spin"></i> Testing...').prop('disabled', true);
        
        $.ajax({
            url: '{/literal}/serverside/forms/test_smtp_clean.php{literal}',
            type: 'POST',
            data: {
                smtp_host: host,
                smtp_port: port,
                smtp_security: $('#smtp_security').val(),
                smtp_username: username,
                smtp_password: password,
                smtp_from_email: $('#smtp_from_email').val().trim(),
                smtp_from_name: $('#smtp_from_name').val().trim()
            },
            timeout: 30000, // 30 second timeout
            success: function(response) {
                try {
                    // Handle both JSON and string responses
                    if(typeof response === 'string') {
                        response = JSON.parse(response);
                    }
                    
                    if(response.response == 1) {
                        Swal.fire({
                            title: 'SMTP Test Successful!',
                            html: response.msg,
                            icon: 'success',
                            confirmButtonText: 'OK'
                        });
                    } else {
                        Swal.fire({
                            title: 'SMTP Test Failed',
                            html: response.msg || 'Unknown error occurred',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    }
                } catch(e) {
                    Swal.fire({
                        title: 'Response Error',
                        html: 'Invalid response from server:<br><pre>' + response + '</pre>',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            },
            error: function(xhr, status, error) {
                var errorMsg = 'SMTP test failed with error: ' + error;
                
                if(status === 'timeout') {
                    errorMsg = 'Request timed out. The SMTP server may be slow or unreachable.';
                } else if(xhr.responseText) {
                    errorMsg += '<br><br><strong>Server Response:</strong><br><pre>' + xhr.responseText + '</pre>';
                }
                
                Swal.fire({
                    title: 'Connection Error',
                    html: errorMsg,
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            },
            complete: function() {
                btn.html(originalText).prop('disabled', false);
            }
        });
    });
    
    // Save settings
    $('.reseller-settings-form').on('submit', function(e) {
        e.preventDefault();
        
        // Get Summernote content before serializing
        $('#welcome_email_body').val($('#welcome_email_body').summernote('code'));
        $('#approval_email_body').val($('#approval_email_body').summernote('code'));
        $('#rejection_email_body').val($('#rejection_email_body').summernote('code'));
        
        var formData = $(this).serialize();
        
        $.ajax({
            url: '{/literal}/serverside/forms/save_reseller_settings.php{literal}',
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
                    });
                } else {
                    Swal.fire({
                        title: 'Error!',
                        text: response.msg,
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            },
            error: function() {
                Swal.fire({
                    title: 'Error!',
                    text: 'Failed to save settings',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            }
        });
    });
    
    // Reset to defaults
    $('#resetDefaults').on('click', function() {
        Swal.fire({
            title: 'Reset to Defaults?',
            text: 'This will reset all email templates to their default values.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, Reset',
            cancelButtonText: 'Cancel'
        }).then(function(result) {
            if(result.isConfirmed) {
                resetToDefaults();
            }
        });
    });
    
    function loadSettings() {
        $.ajax({
            url: '{/literal}/serverside/data/get_reseller_settings.php{literal}',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if(response.success) {
                    var settings = response.data;
                    
                    // Set form values
                    $('#email_notifications').prop('checked', settings.email_notifications == '1');
                    $('#auto_approval').prop('checked', settings.auto_approval == '1');
                    $('#admin_email').val(settings.admin_email || '');
                    $('#welcome_email_subject').val(settings.welcome_email_subject || '');
                    $('#welcome_email_body').summernote('code', settings.welcome_email_body || '');
                    $('#approval_email_subject').val(settings.approval_email_subject || '');
                    $('#approval_email_body').summernote('code', settings.approval_email_body || '');
                    $('#rejection_email_subject').val(settings.rejection_email_subject || '');
                    $('#rejection_email_body').summernote('code', settings.rejection_email_body || '');
                }
            }
        });
    }
    
    function resetToDefaults() {
        $.ajax({
            url: '{/literal}/serverside/forms/reset_reseller_settings.php{literal}',
            type: 'POST',
            dataType: 'json',
            success: function(response) {
                if(response.response == 1) {
                    Swal.fire({
                        title: 'Success!',
                        text: 'Settings have been reset to defaults',
                        icon: 'success',
                        confirmButtonText: 'OK'
                    });
                    loadSettings(); // Reload settings
                } else {
                    Swal.fire({
                        title: 'Error!',
                        text: response.msg,
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            },
            error: function() {
                Swal.fire({
                    title: 'Error!',
                    text: 'Failed to reset settings',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            }
        });
    }
});


{/literal}
</script>

