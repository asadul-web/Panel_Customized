<script>
{literal}
$(document).ready(function() {
    
    // Hide loading animation
    setTimeout(function() {
        $('#loading').fadeOut();
    }, 1000);
    
    // Check FontAwesome loading
    setTimeout(function() {
        checkFontAwesome();
    }, 500);
    
    // Initialize select2
    $('.select2').select2();
    
    // Check and initialize campaigns table
    checkCampaignsTable();
    
    // Initialize DataTable for campaigns (matching view-user style)
    function campaignTable() {
        let timerInterval;
        $.fn.dataTable.ext.errMode = () => 
        Swal.fire({
            title: "Error",
            icon: "error",
            html: "Failed getting table data from ajax.<br><b></b>",
            customClass: {
                confirmButton: 'btn-primary'
            },
            timer: 3000,
            timerProgressBar: true,
            didOpen: () => {
                Swal.showLoading();
                const timer = Swal.getPopup().querySelector("b");
                timerInterval = setInterval(() => {
                    timer.textContent = `${
                        Swal.getTimerLeft()
                    }`;
                }, 100);
            },
            willClose: () => {
                clearInterval(timerInterval);
            }
        }).then((result) => {
            if (result.dismiss === Swal.DismissReason.timer) {
                $('.table-listcampaign').DataTable().ajax.reload();
            }
        });
        
        $('.table-listcampaign').dataTable({
            responsive: true,
            "bProcessing": false,
            "bServerSide": true,
            "ajax": {
                "url": "./serverside/data/get_email_campaigns.php",
                "type": "POST"
            },
            "drawCallback": function( settings ) {
                var rows = this.fnGetData();
                if (rows.length === 0 ) {
                    $('.pdata').addClass('d-none');
                }else{
                    $('.pdata').removeClass('d-none');
                }    
            },
            order: [[ 6, 'desc' ], [ 0, 'asc' ]],
            "language": {                
                "infoFiltered": ""
            },
            columnDefs: [
                {
                  width: '15%',
                  targets: 0, // Campaign Name
                },
                {
                  width: '20%',
                  targets: 1, // Subject
                },
                {
                  width: '10%',
                  targets: 2, // Status
                },
                {
                  width: '10%',
                  targets: 3, // Recipients
                },
                {
                  width: '10%',
                  targets: 4, // Sent
                },
                {
                  width: '10%',
                  targets: 5, // Opens
                },
                {
                  width: '10%',
                  targets: 6, // Created Date
                },
                {
                  width: '15%',
                  targets: 7, // Actions
                },
                {
                  orderable: false,
                  targets: [1, 2, 3, 4, 5, 7],
                },
            ],
            "columns": [
                { 
                    "data": "name",
                    "render": function(data, type, row) {
                        var badgeClass = 'primary';
                        
                        switch(row.status) {
                            case 'draft': 
                                badgeClass = 'secondary';
                                break;
                            case 'sent': 
                                badgeClass = 'success';
                                break;
                            case 'sending': 
                                badgeClass = 'warning';
                                break;
                            case 'scheduled':
                                badgeClass = 'info';
                                break;
                            case 'paused':
                                badgeClass = 'danger';
                                break;
                            default:
                                badgeClass = 'primary';
                        }
                        
                        return '<span class="badge badge-' + badgeClass + '">' +
                               '<span class="campaign-name-class" style="cursor: pointer;" onclick="previewCampaign(' + row.id + ');">' + data + '</span>' +
                               '</span>';
                    }
                },
                { 
                    "data": "subject",
                    "render": function(data, type, row) {
                        return data.length > 30 ? data.substring(0, 30) + '...' : data;
                    }
                },
                { 
                    "data": "status",
                    "render": function(data, type, row) {
                        var badgeClass = '';
                        var icon = '';
                        switch(data) {
                            case 'draft': 
                                badgeClass = 'badge-secondary'; 
                                icon = '<i class="fas fa-edit"></i> ';
                                break;
                            case 'scheduled': 
                                badgeClass = 'badge-info'; 
                                icon = '<i class="far fa-calendar-alt"></i> ';
                                break;
                            case 'sending': 
                                badgeClass = 'badge-warning'; 
                                icon = '<i class="fas fa-spinner"></i> ';
                                break;
                            case 'sent': 
                                badgeClass = 'badge-success'; 
                                icon = '<i class="fa fa-check-circle"></i> ';
                                break;
                            case 'paused': 
                                badgeClass = 'badge-danger'; 
                                icon = '<i class="fa fa-times-circle"></i> ';
                                break;
                            default: 
                                badgeClass = 'badge-secondary';
                                icon = '<i class="fas fa-question"></i> ';
                        }
                        return '<span class="badge ' + badgeClass + '">' + icon + data.charAt(0).toUpperCase() + data.slice(1) + '</span>';
                    }
                },
                { 
                    "data": "total_recipients",
                    "render": function(data, type, row) {
                        return '<span class="badge badge-info"><i class="fas fa-users"></i> ' + (data || 0) + '</span>';
                    }
                },
                { 
                    "data": "emails_sent",
                    "render": function(data, type, row) {
                        return '<span class="badge badge-primary"><i class="fas fa-paper-plane"></i> ' + (data || 0) + '</span>';
                    }
                },
                { 
                    "data": "opens",
                    "render": function(data, type, row) {
                        return '<span class="badge badge-success"><i class="fas fa-eye"></i> ' + (data || 0) + '</span>';
                    }
                },
                { 
                    "data": "created_date",
                    "render": function(data, type, row) {
                        if(data) {
                            var date = new Date(data);
                            var formattedDate = date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
                            return '<span class="badge badge-info"><i class="far fa-calendar-alt"></i> ' + formattedDate + '</span>';
                        } else {
                            return '<span class="badge badge-secondary"><i class="far fa-calendar-alt"></i> N/A</span>';
                        }
                    }
                },
                {
                    "data": null,
                    "orderable": false,
                    "render": function(data, type, row) {
                        var actions = '<div class="btn-group btn-group-md" role="group">';
                        actions += '<button type="button" class="btn btn-primary mr-1" onclick="previewCampaign(' + row.id + ');" title="Preview"><i class="far fa-eye"></i></button>';
                        
                        if(row.status == 'draft') {
                            actions += '<button type="button" class="btn btn-primary mr-1" onclick="editCampaign(' + row.id + ')" title="Edit"><i class="fas fa-edit"></i></button>';
                            actions += '<button type="button" class="btn btn-success mr-1" onclick="sendCampaign(' + row.id + ')" title="Send"><i class="fas fa-paper-plane"></i></button>';
                        }
                        
                        actions += '<button type="button" class="btn btn-danger" onclick="deleteCampaign(' + row.id + ')" title="Delete"><i class="fas fa-trash"></i></button>';
                        actions += '</div>';
                        
                        return actions;
                    }
                }
            ]
        });
    }
    
    // Initialize the campaign table
    campaignTable();
    
    // Filter handlers removed with sidebar
    
    // Initialize HTML editor and icon picker for modal
    initializeCampaignEditor();
    initializeCampaignIconPicker();
    
    // Initialize bulk email functionality
    initializeBulkEmailManagement();
    
    // Load templates for campaign creation
    loadTemplates();
    
    // Recipient type radio handler
    $('input[name="recipient_type"]').on('change', function() {
        if($(this).val() === 'tagged') {
            $('#tagsGroup').show();
        } else {
            $('#tagsGroup').hide();
        }
    });
    
    // Template selection handler
    $('#campaignTemplate').on('change', function() {
        var templateId = $(this).val();
        if(templateId) {
            loadTemplateContent(templateId);
        }
    });
    
    // Reset form when modal is closed
    $('#createCampaignModal').on('hidden.bs.modal', function() {
        resetCampaignForm();
    });
    
    // Modal event handlers for stable normal-modalize system
    $('.normal-modalize').on('hidden.bs.modal', function() {
        // Clear modal content when closed
        $('.normal-modal-title').text('');
        $('.normal-modal-error').html('');
        $('.normal-modal-html').html('');
    });
});

// Campaign statistics and filter functions removed with sidebar

// Load templates for dropdown
function loadTemplates() {
    $.ajax({
        url: './serverside/data/get_email_templates.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                var select = $('#campaignTemplate');
                select.empty().append('<option value="">Select a template (optional)</option>');
                
                $.each(response.templates, function(index, template) {
                    select.append('<option value="' + template.id + '">' + template.name + '</option>');
                });
            }
        },
        error: function() {
            }
    });
}

// Load template content
function loadTemplateContent(templateId) {
    $.ajax({
        url: './serverside/data/get_template_content.php',
        type: 'POST',
        data: { template_id: templateId },
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                $('#campaignSubject').val(response.subject);
                
                // Load content and immediately apply protection
                $('#campaignContent').summernote('code', response.content);
                $('#campaignType').val(response.content_type);
                
                // Force CSS protection after content load
                setTimeout(function() {
                    protectPageFromTemplateStyles();
                }, 100);
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to load template content', 'error');
        }
    });
}

// Save as draft
function saveDraft() {
    createCampaign('draft');
}

// Create or update campaign
function createCampaign(status = 'draft') {
    var editId = $('#createCampaignModal').data('edit-id');
    var isEdit = editId ? true : false;
    
    var formData = {
        name: $('#campaignName').val().trim(),
        subject: $('#campaignSubject').val().trim(),
        content: $('#campaignContent').summernote('code'),
        content_type: $('#campaignType').val(),
        scheduled_date: $('#scheduledDate').val(),
        recipient_type: $('input[name="recipient_type"]:checked').val(),
        recipient_tags: $('#recipientTags').val().trim(),
        status: status
    };
    
    // Add campaign ID for updates
    if(isEdit) {
        formData.campaign_id = editId;
    }
    
    // Validation
    if(!formData.name || !formData.subject || !formData.content) {
        Swal.fire('Error', 'Please fill in all required fields', 'error');
        return;
    }
    
    // Convert FontAwesome icons to Unicode symbols for email compatibility
    formData.content = convertFontAwesomeToUnicode(formData.content);
    formData.subject = convertFontAwesomeToUnicode(formData.subject);
    
    var url = isEdit ? './serverside/forms/update_email_campaign.php' : './serverside/forms/create_email_campaign.php';
    var action = isEdit ? 'updated' : 'created';
    
    $.ajax({
        url: url,
        type: 'POST',
        data: formData,
        dataType: 'json',
        success: function(response) {
            try {
                // Handle both JSON and string responses
                if(typeof response === 'string') {
                    response = JSON.parse(response);
                }
                
                if(response.response == 1) {
                    Swal.fire('Success', response.msg, 'success');
                    $('#createCampaignModal').modal('hide');
                    resetCampaignForm();
                    $('.table-listcampaign').DataTable().ajax.reload();
                } else {
                    Swal.fire('Error', response.msg || 'Unknown error occurred', 'error');
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
            Swal.fire('Error', 'Failed to ' + action + ' campaign. Please try again.', 'error');
        }
    });
}

// Stable modal system from view-user page
function normal_modalize(title, body) {
    $(".normal-modalize").modal({
        backdrop: 'static',
        keyboard: false  // to prevent closing with Esc button (if you want this too)
    })
    $(".normal-modalize").modal('show');
    $(".normal-modal-title").text(title);
    $(".normal-modal-error").html('');
    $(".normal-modal-html").html(body);
}

function normalMessage(type, title, message) {
    $(".normal-modal-body > .normal-modal-error").html('').append('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
}

// Reset campaign form
function resetCampaignForm() {
    $('#createCampaignForm')[0].reset();
    $('#campaignContent').summernote('code', '');
    $('#createCampaignModal').removeData('edit-id');
    $('#createCampaignModal .modal-title').text('Create New Campaign');
    $('#createCampaignModal .btn-primary').text('Create & Send');
}

// Preview campaign - using stable normal_modalize system
function previewCampaign(id) {
    // Show loading modal immediately using stable system
    var loadingHtml = '<div class="text-center p-4">';
    loadingHtml += '<i class="fas fa-spinner fa-spin fa-2x text-primary mb-3"></i>';
    loadingHtml += '<h5>Loading Campaign Preview...</h5>';
    loadingHtml += '<p class="text-muted">Campaign ID: ' + id + '</p>';
    loadingHtml += '</div>';
    
    normal_modalize('Campaign Preview', loadingHtml);
    
    // Load campaign data
    $.ajax({
        url: './serverside/data/get_campaign_preview.php',
        type: 'POST',
        data: { campaign_id: id },
        dataType: 'json',
        cache: false,
        success: function(response) {
            if(response.response == 1) {
                // Create professional preview content
                var previewHtml = '<div class="campaign-preview-container">';
                
                // Campaign info header
                previewHtml += '<div class="alert alert-info mb-3">';
                previewHtml += '<div class="row">';
                previewHtml += '<div class="col-md-4"><strong><i class="fas fa-envelope"></i> Campaign:</strong><br>' + (response.campaign_name || 'Unknown') + '</div>';
                previewHtml += '<div class="col-md-4"><strong><i class="fas fa-tag"></i> Subject:</strong><br>' + (response.campaign_subject || 'No Subject') + '</div>';
                previewHtml += '<div class="col-md-4"><strong><i class="fas fa-code"></i> Type:</strong><br>HTML Email</div>';
                previewHtml += '</div>';
                previewHtml += '</div>';
                
                // Preview content area
                previewHtml += '<div class="preview-content-wrapper">';
                previewHtml += '<h6><i class="fas fa-eye"></i> Email Preview:</h6>';
                previewHtml += '<div class="preview-content-frame">';
                previewHtml += response.content || '<p class="text-muted text-center p-4">No content available</p>';
                previewHtml += '</div>';
                previewHtml += '</div>';
                
                // Action buttons
                previewHtml += '<div class="text-center mt-3">';
                previewHtml += '<button type="button" class="btn btn-primary btn-sm mr-2" onclick="openPreviewNewTab(\'' + id + '\')">';
                previewHtml += '<i class="fas fa-external-link-alt"></i> Open in New Tab';
                previewHtml += '</button>';
                previewHtml += '<button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">';
                previewHtml += '<i class="fas fa-times"></i> Close';
                previewHtml += '</button>';
                previewHtml += '</div>';
                
                previewHtml += '</div>';
                
                // Update modal with preview content
                normal_modalize('📧 ' + (response.campaign_name || 'Campaign Preview'), previewHtml);
                
            } else {
                // Show error using normalMessage
                normalMessage('danger', 'Preview Error', response.msg || 'Failed to load campaign preview');
            }
        },
        error: function(xhr, status, error) {
            normalMessage('danger', 'Connection Error', 'Failed to load campaign preview. Please check your connection and try again.');
        }
    });
}

// Open preview in new tab
function openPreviewNewTab(campaignId) {
    var newWindow = window.open('about:blank', '_blank');
    newWindow.document.write($('.preview-content-frame').html());
    newWindow.document.close();
}

// Edit campaign
function editCampaign(id) {
    Swal.fire('Info', 'Edit campaign functionality coming soon', 'info');
}

// Send campaign
function sendCampaign(id) {
    Swal.fire({
        title: 'Send Campaign?',
        text: 'This will send the campaign to all selected recipients',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, Send',
        cancelButtonText: 'Cancel'
    }).then(function(result) {
        if(result.isConfirmed) {
            $.ajax({
                url: './serverside/forms/send_email_campaign.php',
                type: 'POST',
                data: { campaign_id: id },
                dataType: 'json',
                success: function(response) {
                    if(response.response == 1) {
                        Swal.fire('Success', response.msg, 'success');
                        $('#campaignsTable').DataTable().ajax.reload();
                    } else {
                        Swal.fire('Error', response.msg, 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to send campaign', 'error');
                }
            });
        }
    });
}

// Delete campaign
function deleteCampaign(id) {
    // First get campaign details to show appropriate warning
    $.ajax({
        url: './serverside/data/get_campaign_preview.php',
        type: 'POST',
        data: { campaign_id: id },
        dataType: 'json',
        success: function(campaignData) {
            var title = 'Delete Campaign?';
            var text = 'This action cannot be undone';
            var confirmButtonText = 'Yes, Delete';
            
            // Show different warnings based on campaign status
            if(campaignData.campaign_status === 'sending') {
                title = 'Delete Sending Campaign?';
                text = 'This campaign is currently being sent. Deleting it will stop the sending process. This action cannot be undone.';
                confirmButtonText = 'Yes, Stop & Delete';
            } else if(campaignData.campaign_status === 'sent') {
                title = 'Delete Sent Campaign?';
                text = 'This campaign has already been sent. Deleting it will remove all records. This action cannot be undone.';
            }
            
            Swal.fire({
                title: title,
                text: text,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: confirmButtonText,
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#d33'
            }).then(function(result) {
                if(result.isConfirmed) {
                    performDelete(id);
                }
            });
        },
        error: function() {
            // Fallback to simple delete if can't get campaign details
            Swal.fire({
                title: 'Delete Campaign?',
                text: 'This action cannot be undone',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, Delete',
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#d33'
            }).then(function(result) {
                if(result.isConfirmed) {
                    performDelete(id);
                }
            });
        }
    });
}

// Perform the actual deletion
function performDelete(id) {
    $.ajax({
        url: './serverside/forms/delete_email_campaign.php',
        type: 'POST',
        data: { campaign_id: id },
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                Swal.fire('Deleted', response.msg, 'success');
                $('.table-listcampaign').DataTable().ajax.reload();
            } else {
                Swal.fire('Error', response.msg, 'error');
            }
        },
        error: function() {
            Swal.fire('Error', 'Failed to delete campaign', 'error');
        }
    });
}

// Initialize Summernote HTML editor for campaigns
function initializeCampaignEditor() {
    // Check if FontAwesome is loaded
    if (typeof FontAwesome === 'undefined') {
        }
    
    $('#campaignContent').summernote({
        height: 400,
        minHeight: 300,
        maxHeight: 600,
        placeholder: 'Enter your campaign content here...',
        fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', 'Helvetica Neue', 'Helvetica', 'Impact', 'Lucida Grande', 'Tahoma', 'Times New Roman', 'Verdana'],
        fontSizes: ['8', '9', '10', '11', '12', '14', '16', '18', '20', '24', '36', '48'],
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic', 'underline', 'strikethrough', 'superscript', 'subscript', 'clear']],
            ['fontname', ['fontname']],
            ['fontsize', ['fontsize']],
            ['color', ['forecolor', 'backcolor']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ],
        icons: {
            'align': 'note-icon-align',
            'alignCenter': 'note-icon-align-center',
            'alignJustify': 'note-icon-align-justify',
            'alignLeft': 'note-icon-align-left',
            'alignRight': 'note-icon-align-right',
            'rowBelow': 'note-icon-row-below',
            'colBefore': 'note-icon-col-before',
            'colAfter': 'note-icon-col-after',
            'rowAbove': 'note-icon-row-above',
            'rowRemove': 'note-icon-row-remove',
            'colRemove': 'note-icon-col-remove',
            'indent': 'note-icon-align-indent',
            'outdent': 'note-icon-align-outdent',
            'arrowsAlt': 'note-icon-arrows-alt',
            'bold': 'note-icon-bold',
            'caret': 'note-icon-caret',
            'circle': 'note-icon-circle',
            'close': 'note-icon-close',
            'code': 'note-icon-code',
            'eraser': 'note-icon-eraser',
            'font': 'note-icon-font',
            'frame': 'note-icon-frame',
            'italic': 'note-icon-italic',
            'link': 'note-icon-link',
            'unlink': 'note-icon-unlink',
            'magic': 'note-icon-magic',
            'menuCheck': 'note-icon-menu-check',
            'minus': 'note-icon-minus',
            'orderedlist': 'note-icon-orderedlist',
            'pencil': 'note-icon-pencil',
            'picture': 'note-icon-picture',
            'question': 'note-icon-question',
            'redo': 'note-icon-redo',
            'rollback': 'note-icon-rollback',
            'square': 'note-icon-square',
            'strikethrough': 'note-icon-strikethrough',
            'subscript': 'note-icon-subscript',
            'superscript': 'note-icon-superscript',
            'table': 'note-icon-table',
            'textHeight': 'note-icon-text-height',
            'trash': 'note-icon-trash',
            'underline': 'note-icon-underline',
            'undo': 'note-icon-undo',
            'unorderedlist': 'note-icon-unorderedlist',
            'video': 'note-icon-video'
        },
        callbacks: {
            onInit: function() {
                // Apply protection immediately after init
                setTimeout(protectPageFromTemplateStyles, 100);
                
                // Fix icon display after initialization - multiple attempts
                setTimeout(fixSummernoteIcons, 200);
                setTimeout(fixSummernoteIcons, 500);
                setTimeout(fixSummernoteIcons, 1000);
                
                // Also add a mutation observer to fix icons when DOM changes
                observeToolbarChanges();
            },
            onChange: function(contents, $editable) {
                // Protect against style bleeding when content changes
                setTimeout(protectPageFromTemplateStyles, 50);
            }
        }
    });
}

// Fix Summernote icons if FontAwesome is not loading properly
function fixSummernoteIcons() {
    // Wait a bit for the toolbar to be fully rendered
    setTimeout(function() {
        // More comprehensive icon fixing
        $('.note-toolbar .note-btn').each(function() {
            var $btn = $(this);
            var $icon = $btn.find('i');
            var title = $btn.attr('title') || $btn.attr('data-original-title') || '';
            
            // If icon is empty or not displaying properly
            if ($icon.length && ($icon.text() === '' || $icon.html() === '')) {
                var iconText = '';
                
                // Map based on button title/tooltip
                if (title.toLowerCase().includes('bold')) iconText = 'B';
                else if (title.toLowerCase().includes('italic')) iconText = 'I';
                else if (title.toLowerCase().includes('underline')) iconText = 'U';
                else if (title.toLowerCase().includes('strikethrough')) iconText = 'S';
                else if (title.toLowerCase().includes('superscript')) iconText = 'x²';
                else if (title.toLowerCase().includes('subscript')) iconText = 'x₂';
                else if (title.toLowerCase().includes('remove') || title.toLowerCase().includes('clear')) iconText = '✗';
                else if (title.toLowerCase().includes('link')) iconText = '🔗';
                else if (title.toLowerCase().includes('picture') || title.toLowerCase().includes('image')) iconText = '🖼';
                else if (title.toLowerCase().includes('video')) iconText = '🎥';
                else if (title.toLowerCase().includes('table')) iconText = '⊞';
                else if (title.toLowerCase().includes('code')) iconText = '</>';
                else if (title.toLowerCase().includes('undo')) iconText = '↶';
                else if (title.toLowerCase().includes('redo')) iconText = '↷';
                else if (title.toLowerCase().includes('fullscreen')) iconText = '⛶';
                else if (title.toLowerCase().includes('help')) iconText = '?';
                else if (title.toLowerCase().includes('unordered') || title.toLowerCase().includes('bullet')) iconText = '•';
                else if (title.toLowerCase().includes('ordered') || title.toLowerCase().includes('number')) iconText = '1.';
                else if (title.toLowerCase().includes('align left')) iconText = '⫷';
                else if (title.toLowerCase().includes('align center')) iconText = '≡';
                else if (title.toLowerCase().includes('align right')) iconText = '⫸';
                else if (title.toLowerCase().includes('justify')) iconText = '⫼';
                else if (title.toLowerCase().includes('text color') || title.toLowerCase().includes('forecolor')) iconText = 'A';
                else if (title.toLowerCase().includes('background') || title.toLowerCase().includes('backcolor')) iconText = '▌';
                
                if (iconText) {
                    $icon.html(iconText);
                    $icon.css({
                        'font-family': 'inherit',
                        'font-style': 'normal',
                        'font-weight': title.toLowerCase().includes('bold') ? 'bold' : 'normal',
                        'text-decoration': title.toLowerCase().includes('underline') ? 'underline' : 
                                         title.toLowerCase().includes('strikethrough') ? 'line-through' : 'none'
                    });
                }
            }
        });
        
        }, 300);
}

// Observe toolbar changes and fix icons dynamically
function observeToolbarChanges() {
    var toolbar = document.querySelector('.note-toolbar');
    if (toolbar && window.MutationObserver) {
        var observer = new MutationObserver(function(mutations) {
            var needsFix = false;
            mutations.forEach(function(mutation) {
                if (mutation.type === 'childList' || mutation.type === 'attributes') {
                    needsFix = true;
                }
            });
            if (needsFix) {
                setTimeout(fixSummernoteIcons, 100);
            }
        });
        
        observer.observe(toolbar, {
            childList: true,
            subtree: true,
            attributes: true,
            attributeFilter: ['class', 'title', 'data-original-title']
        });
        
        }
}

// Initialize icon picker for campaigns
function initializeCampaignIconPicker() {
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
    var iconGrid = $('#campaignIconGrid');
    iconGrid.empty();
    
    emailSafeIcons.forEach(function(icon) {
        var iconItem = $('<div class="icon-item" data-symbol="' + icon.symbol + '" data-name="' + icon.name + '">' +
            '<div class="icon">' + icon.symbol + '</div>' +
            '<div class="label">' + icon.name + '</div>' +
            '</div>');
        
        iconItem.click(function() {
            insertIconIntoCampaignEditor(icon.symbol, icon.name);
        });
        
        iconGrid.append(iconItem);
    });
}

// Insert icon into campaign editor
function insertIconIntoCampaignEditor(symbol, name) {
    // Insert the icon at cursor position in Summernote
    if ($('#campaignContent').summernote('code')) {
        $('#campaignContent').summernote('insertText', symbol + ' ');
        
        // Show success message
        Swal.fire({
            title: 'Icon Inserted!',
            text: name + ' icon (' + symbol + ') has been added to your campaign',
            icon: 'success',
            timer: 1500,
            showConfirmButton: false
        });
    }
}

// Convert FontAwesome icons to Unicode symbols
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

// Toggle preview mode for campaign editor
function togglePreviewMode(editorId) {
    var editorContainer = $('#' + editorId).closest('.editor-container');
    var toggleButton = editorContainer.find('.theme-toggle .btn');
    var icon = toggleButton.find('i');
    
    if (editorContainer.hasClass('template-preview-mode')) {
        // Switch back to edit mode
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

// Initialize bulk email management
function initializeBulkEmailManagement() {
    // Load subscriber count for "All Subscribers" option
    loadSubscriberCount();
    
    // Load saved email lists
    loadSavedEmailLists();
    
    // Recipient type change handlers
    $('input[name="recipient_type"]').on('change', function() {
        var selectedType = $(this).val();
        
        // Hide all option groups
        $('#tagsGroup, #uploadGroup, #savedListsGroup, #manualGroup').hide();
        
        // Show relevant group
        switch(selectedType) {
            case 'tagged':
                $('#tagsGroup').show();
                break;
            case 'upload':
                $('#uploadGroup').show();
                break;
            case 'saved':
                $('#savedListsGroup').show();
                break;
            case 'manual':
                $('#manualGroup').show();
                break;
        }
        
        // Update recipient count
        updateRecipientCount();
    });
    
    // File upload handler
    $('#emailListFile').on('change', function() {
        handleEmailListUpload(this);
    });
    
    // Manual email input handler
    $('#manualEmailList').on('input', function() {
        updateManualEmailCount();
    });
    
    // Tags input handler
    $('#recipientTags').on('input', function() {
        updateTaggedSubscriberCount();
    });
}

// Load subscriber count
function loadSubscriberCount() {
    $.ajax({
        url: './serverside/data/get_subscriber_count.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                $('#allSubscribersCount').text('(' + response.count + ' subscribers)');
                updateRecipientCount();
            } else {
                $('#allSubscribersCount').text('(Error loading count)');
            }
        },
        error: function() {
            $('#allSubscribersCount').text('(Error loading count)');
        }
    });
}

// Load saved email lists
function loadSavedEmailLists() {
    $.ajax({
        url: './serverside/data/get_saved_email_lists.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                var select = $('#savedEmailLists');
                select.empty().append('<option value="">Select a saved email list...</option>');
                
                $.each(response.lists, function(index, list) {
                    select.append('<option value="' + list.id + '" data-count="' + list.email_count + '">' + 
                                list.name + ' (' + list.email_count + ' emails)</option>');
                });
            }
        },
        error: function() {
            }
    });
}

// Handle email list file upload
function handleEmailListUpload(fileInput) {
    var file = fileInput.files[0];
    if (!file) return;
    
    // Validate file size (10MB max)
    if (file.size > 10 * 1024 * 1024) {
        Swal.fire('Error', 'File size must be less than 10MB', 'error');
        $(fileInput).val('');
        return;
    }
    
    // Update file label
    $(fileInput).next('.custom-file-label').text(file.name);
    
    // Show preview
    $('#uploadPreview').show();
    $('#uploadStats').html('<i class="fas fa-spinner fa-spin"></i> Processing file...');
    
    // Process file
    var formData = new FormData();
    formData.append('email_list_file', file);
    
    $.ajax({
        url: './serverside/forms/process_email_list_upload.php',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                var stats = '<div class="email-list-stats">' +
                    '<div class="stat-item"><div class="stat-number">' + response.total_emails + '</div><div class="stat-label">Total Emails</div></div>' +
                    '<div class="stat-item"><div class="stat-number">' + response.valid_emails + '</div><div class="stat-label">Valid</div></div>' +
                    '<div class="stat-item"><div class="stat-number">' + response.invalid_emails + '</div><div class="stat-label">Invalid</div></div>' +
                    '<div class="stat-item"><div class="stat-number">' + response.duplicates + '</div><div class="stat-label">Duplicates</div></div>' +
                    '</div>';
                
                $('#uploadStats').html(stats);
                updateRecipientCount();
            } else {
                $('#uploadStats').html('<span class="text-danger">Error: ' + response.msg + '</span>');
            }
        },
        error: function() {
            $('#uploadStats').html('<span class="text-danger">Error processing file</span>');
        }
    });
}

// Update manual email count
function updateManualEmailCount() {
    var emails = $('#manualEmailList').val();
    if (!emails.trim()) {
        updateRecipientCount();
        return;
    }
    
    // Split by comma or newline and count valid emails
    var emailList = emails.split(/[,\n]/).map(function(email) {
        return email.trim();
    }).filter(function(email) {
        return email && isValidEmail(email);
    });
    
    updateRecipientCount(emailList.length);
}

// Update tagged subscriber count
function updateTaggedSubscriberCount() {
    var tags = $('#recipientTags').val();
    if (!tags.trim()) {
        updateRecipientCount();
        return;
    }
    
    $.ajax({
        url: './serverside/data/get_tagged_subscriber_count.php',
        type: 'POST',
        data: { tags: tags },
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                updateRecipientCount(response.count);
            }
        }
    });
}

// Update recipient count display
function updateRecipientCount(count) {
    var selectedType = $('input[name="recipient_type"]:checked').val();
    var countText = '';
    
    if (count !== undefined) {
        countText = count + ' recipients selected';
    } else {
        switch(selectedType) {
            case 'all':
                var allCount = $('#allSubscribersCount').text().match(/\d+/);
                countText = allCount ? allCount[0] + ' active subscribers' : 'Loading...';
                break;
            case 'saved':
                var selectedList = $('#savedEmailLists option:selected');
                if (selectedList.val()) {
                    countText = selectedList.data('count') + ' emails from saved list';
                } else {
                    countText = 'No list selected';
                }
                break;
            default:
                countText = 'Select recipients to see count';
        }
    }
    
    $('#recipientCount').text(countText);
}

// Validate email format
function isValidEmail(email) {
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Manage saved lists
function manageSavedLists() {
    Swal.fire('Info', 'Saved lists management coming soon', 'info');
}

// Create new list
function createNewList() {
    Swal.fire('Info', 'Create new list functionality coming soon', 'info');
}

// Protect page from template style bleeding
function protectPageFromTemplateStyles() {
    // Force page background and modal styles
    $('body').css({
        'background': '#fafbfc',
        'color': '#495057'
    });
    
    $('.main-wrapper').css('background', 'transparent');
    
    $('.modal-content').css({
        'background': 'white',
        'color': '#495057'
    });
    
    $('.modal-body').css({
        'background': 'white',
        'color': '#495057'
    });
    
    $('.card').css({
        'background': 'white',
        'color': '#495057'
    });
    
    // Ensure editor toolbar stays normal
    $('.note-toolbar').css({
        'background': '#f8f9fa',
        'color': '#333'
    });
    
    $('.note-toolbar .btn').css({
        'background': 'white',
        'color': '#333',
        'border': '1px solid #ddd'
    });
}

// Check and initialize campaigns table
function checkCampaignsTable() {
    // First test database connection
    $.ajax({
        url: './serverside/data/test_database.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.success && response.connected) {
                if(!response.table_exists) {
                    createCampaignsTable();
                } else {
                    // Table exists, check if it needs updates
                    updateCampaignsTable();
                }
            } else {
                Swal.fire({
                    title: 'Database Error',
                    html: 'Database connection test failed:<br>' + (response.message || 'Unknown error'),
                    icon: 'error'
                });
            }
        },
        error: function(xhr, status, error) {
            }
    });
}

// Create campaigns table if missing
function createCampaignsTable() {
    $.ajax({
        url: './serverside/data/check_campaigns_table.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.table_created) {
                Swal.fire('Success', 'Email campaigns table was created with sample data', 'success');
                // Reload the page to refresh the table
                setTimeout(function() {
                    location.reload();
                }, 2000);
            }
        },
        error: function(xhr, status, error) {
            }
    });
}

// Update campaigns table structure if needed
function updateCampaignsTable() {
    $.ajax({
        url: './serverside/data/update_campaigns_table.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if(response.response == 1 && response.total_updates > 0) {
                // Check if any actual column additions were made
                var hasColumnUpdates = response.updates_applied.some(function(update) {
                    return update.includes('Added column:');
                });
                
                if(hasColumnUpdates) {
                    Swal.fire({
                        title: 'Table Updated',
                        text: 'Email campaigns table structure has been updated with missing columns.',
                        icon: 'success',
                        confirmButtonText: 'Reload Page'
                    }).then(function() {
                        location.reload();
                    });
                }
            } else if(response.response == 2) {
                }
        },
        error: function(xhr, status, error) {
            }
    });
}

// Test database connection (manual trigger)
function testDatabaseConnection() {
    Swal.fire({
        title: 'Testing Database...',
        text: 'Please wait while we test the database connection',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
    
    $.ajax({
        url: './serverside/data/test_database.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            var resultHtml = '<div class="text-left">';
            resultHtml += '<strong>Database Connection:</strong> ' + (response.db_object_exists ? '✅ OK' : '❌ Failed') + '<br>';
            resultHtml += '<strong>Table Exists:</strong> ' + (response.table_exists ? '✅ Yes' : '❌ No') + '<br>';
            resultHtml += '<strong>Campaign Count:</strong> ' + (response.campaign_count || 0) + '<br>';
            
            if(response.sample_campaigns && response.sample_campaigns.length > 0) {
                resultHtml += '<strong>Sample Campaigns:</strong><br>';
                response.sample_campaigns.forEach(function(campaign) {
                    resultHtml += '• ID: ' + campaign.id + ' - ' + campaign.name + ' (' + campaign.status + ')<br>';
                });
            }
            
            if(response.response == 2) {
                resultHtml += '<br><strong>Error:</strong> ' + response.msg;
            }
            
            resultHtml += '</div>';
            
            Swal.fire({
                title: 'Database Test Results',
                html: resultHtml,
                icon: response.response == 1 ? 'success' : 'error',
                confirmButtonText: 'OK'
            });
        },
        error: function(xhr, status, error) {
            Swal.fire({
                title: 'Database Test Failed',
                html: 'Could not connect to test database.<br><br><strong>Error:</strong> ' + error + '<br><br><strong>Response:</strong><br><pre>' + xhr.responseText.substring(0, 500) + '</pre>',
                icon: 'error'
            });
        }
    });
}

// Check FontAwesome loading
function checkFontAwesome() {
    // Test if FontAwesome is loaded by checking if a FontAwesome class exists
    var testElement = $('<i class="fas fa-check" style="display:none;"></i>').appendTo('body');
    var fontFamily = testElement.css('font-family');
    testElement.remove();
    
    if (fontFamily.indexOf('Font Awesome') === -1) {
        // Apply fallback styles
        $('<style>')
            .prop('type', 'text/css')
            .html(`
                .fas, .far, .fab, .fal, .fad {
                    font-family: inherit !important;
                }
                .fa-check::before { content: "✓"; }
                .fa-times::before { content: "✕"; }
                .fa-plus::before { content: "+"; }
                .fa-edit::before { content: "✎"; }
                .fa-eye::before { content: "👁"; }
                .fa-trash::before { content: "🗑"; }
                .fa-paper-plane::before { content: "✈"; }
            `)
            .appendTo('head');
    } else {
        }
}

// Edit campaign
function editCampaign(id) {
    // Get campaign details first
    $.ajax({
        url: './serverside/data/get_campaign_details.php',
        type: 'POST',
        data: { campaign_id: id },
        dataType: 'json',
        success: function(response) {
            if(response.response == 1) {
                // Populate the form with existing data
                $('#campaignName').val(response.data.name);
                $('#campaignSubject').val(response.data.subject);
                $('#campaignContent').summernote('code', response.data.content);
                $('#campaignType').val(response.data.content_type);
                
                // Set recipient type if available
                if(response.data.recipient_type) {
                    $('input[name="recipient_type"][value="' + response.data.recipient_type + '"]').prop('checked', true);
                }
                
                // Store the campaign ID for updating
                $('#createCampaignModal').data('edit-id', id);
                
                // Change modal title and button text
                $('#createCampaignModal .modal-title').text('Edit Campaign');
                $('#createCampaignModal .btn-primary').text('Update Campaign');
                
                // Show the modal
                $('#createCampaignModal').modal('show');
            } else {
                var errorMsg = response.msg || 'Failed to load campaign details';
                if(response.debug) {
                    errorMsg += '<br><br><small>Debug info logged to console</small>';
                }
                Swal.fire({
                    title: 'Error',
                    html: errorMsg,
                    icon: 'error'
                });
            }
        },
        error: function(xhr, status, error) {
            Swal.fire({
                title: 'Connection Error',
                html: 'Failed to load campaign details.<br><small>Check console for details</small>',
                icon: 'error'
            });
        }
    });
}
{/literal}
</script>

