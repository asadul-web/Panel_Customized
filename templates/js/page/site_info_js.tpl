<script>
$(document).ready(function() {
    // Text Slider Animation - Professional Implementation
    let currentSlide = 0;
    const slides = $('.slider-text');
    const totalSlides = slides.length;
    
    if (totalSlides > 1) {
        function nextSlide() {
            // Fade out current slide
            slides.eq(currentSlide).removeClass('active').addClass('fade-out');
            
            // Move to next slide
            currentSlide = (currentSlide + 1) % totalSlides;
            
            // After fade out completes, show next slide
            setTimeout(function() {
                slides.removeClass('fade-out');
                slides.eq(currentSlide).addClass('active');
            }, 400);
        }
        
        // Start the slider with smooth transitions
        setInterval(nextSlide, 4000);
    }
    
    // SIM Card Click Handlers with Package Information
    $('.sim-card').on('click', function() {
        const company = $(this).data('company');
        const companyName = getCompanyDisplayName(company);
        
        // Update modal title
        $('#companyName').text(companyName);
        
        // Load package information
        loadSimPackages(company);
        
        // Show modal
        $('#simInfoModal').modal('show');
    });
    
    // Get display name for company
    function getCompanyDisplayName(company) {
        const names = {
            'stc': 'STC',
            'mobily': 'Mobily',
            'zain': 'Zain',
            'virgin': 'Virgin Mobile',
            'lebara': 'Lebara Mobile',
            'friendi': 'FRiENDi Mobile',
            'redbull': 'RedBull Mobile',
            'salam': 'Salam Mobile',
            'jawwy': 'Jawwy',
            'yaqoot': 'Yaqoot'
        };
        return names[company] || company.toUpperCase();
    }
    
    // Load SIM packages for selected company
    function loadSimPackages(company) {
        const packages = getPackagesByCompany(company);
        let html = '';
        
        packages.forEach(function(pkg) {
            const badgeClass = pkg.price === 'FREE' ? 'badge-success' : 'badge-primary';
            html += '<div class="sim-package-item">' +
                    '<div class="check-icon">' +
                    '<i class="fas fa-check-circle"></i>' +
                    '</div>' +
                    '<div class="package-text">' +
                    pkg.description +
                    '</div>' +
                    '<div class="package-price">' +
                    '<span class="badge ' + badgeClass + '">' + pkg.price + '</span>' +
                    '</div>' +
                    '</div>';
        });
        
        $('#simPackagesList').html(html);
    }
    
    // Package data for each company
    function getPackagesByCompany(company) {
        const allPackages = {
            'stc': [
                { description: 'Unlimited 5G Data + Calls', price: 'FREE' },
                { description: '100GB Data + International Calls', price: '99 SAR' },
                { description: '50GB Data + Local Calls', price: '79 SAR' },
                { description: '20GB Data + SMS Bundle', price: '49 SAR' }
            ],
            'mobily': [
                { description: 'Premium 5G Unlimited Package', price: '120 SAR' },
                { description: '80GB Data + Free Roaming', price: '89 SAR' },
                { description: '40GB Data + Entertainment', price: '69 SAR' },
                { description: 'Basic Starter Package', price: 'FREE' }
            ],
            'zain': [
                { description: 'Zain Plus Unlimited Everything', price: 'FREE' },
                { description: '150GB Data + Gaming Package', price: '110 SAR' },
                { description: '75GB Data + Social Media', price: '85 SAR' },
                { description: '30GB Data + Music Streaming', price: '59 SAR' }
            ],
            'virgin': [
                { description: 'Virgin Mega Unlimited Plan', price: '129 SAR' },
                { description: '100GB Data + Virgin Perks', price: '99 SAR' },
                { description: '60GB Data + Entertainment', price: '79 SAR' },
                { description: 'Student Special Package', price: 'FREE' }
            ],
            'lebara': [
                { description: 'International Calling Package', price: 'FREE' },
                { description: '90GB Data + Global Roaming', price: '95 SAR' },
                { description: '45GB Data + International SMS', price: '65 SAR' },
                { description: '25GB Data + Local Calls', price: '45 SAR' }
            ],
            'friendi': [
                { description: 'FRiENDi Unlimited 5G', price: '115 SAR' },
                { description: '70GB Data + KSA Roaming', price: '75 SAR' },
                { description: '35GB Data + Social Package', price: '55 SAR' },
                { description: 'Welcome Starter Pack', price: 'FREE' }
            ],
            'redbull': [
                { description: 'RedBull Energy Unlimited', price: '125 SAR' },
                { description: '85GB Data + Gaming Boost', price: '89 SAR' },
                { description: '50GB Data + Sports Streaming', price: '69 SAR' },
                { description: 'Energy Starter Package', price: 'FREE' }
            ],
            'salam': [
                { description: 'Salam Peace Unlimited', price: 'FREE' },
                { description: '120GB Data + Family Share', price: '105 SAR' },
                { description: '65GB Data + Video Streaming', price: '75 SAR' },
                { description: '35GB Data + Music Package', price: '55 SAR' }
            ],
            'jawwy': [
                { description: 'Jawwy Digital Unlimited', price: '135 SAR' },
                { description: '110GB Data + Digital Services', price: '99 SAR' },
                { description: '55GB Data + App Bundle', price: '69 SAR' },
                { description: 'Digital Starter Pack', price: 'FREE' }
            ],
            'yaqoot': [
                { description: 'Yaqoot Premium Unlimited', price: '140 SAR' },
                { description: '95GB Data + Luxury Services', price: '109 SAR' },
                { description: '60GB Data + Premium Support', price: '79 SAR' },
                { description: 'Yaqoot Welcome Package', price: 'FREE' }
            ]
        };
        
        return allPackages[company] || [
            { description: 'Standard Package Available', price: 'Contact Us' },
            { description: 'Premium Package Available', price: 'Contact Us' }
        ];
    }
    
    // Modal button handlers
    $('#contactBtn').on('click', function() {
        // Contact support functionality
        window.open('tel:+966920000000', '_self');
    });
    
    $('#orderBtn').on('click', function() {
        // Order functionality
        alert('Redirecting to order page...');
        // You can redirect to actual order page here
        // window.location.href = 'order.php';
    });
    
    // Enhanced hover effects for SIM cards
    $('.sim-card').hover(
        function() {
            $(this).find('.logo-container').addClass('hover-effect');
        },
        function() {
            $(this).find('.logo-container').removeClass('hover-effect');
        }
    );
    
    // Add professional flash effect to important text
    $('.professional-flash-text').each(function() {
        $(this).addClass('animate-flash');
    });
    
    // Loading animation completion
    setTimeout(function() {
        $('#loading').fadeOut(500);
        $('body').removeClass('bg-image');
    }, 1000);
    
    // Inline Text Editing Functionality
    let editMode = false;
    let originalTexts = {};
    
    // Enable Edit Mode
    $('#enableEditMode').on('click', function() {
        editMode = true;
        $(this).hide();
        $('#welcomeMessage').hide();
        $('#customizationPanel').hide();
        $('#editControls').show();
        
        // Store original texts
        $('.editable-text').each(function() {
            const section = $(this).data('section');
            originalTexts[section] = $(this).text().trim();
        });
        
        // Make text editable with appropriate editor
        $('.editable-text').each(function() {
            const $this = $(this);
            const type = $this.data('type');
            const section = $this.data('section');
            const text = $this.html().trim();
            const uniqueId = 'editor_' + Math.random().toString(36).substr(2, 9);
            
            // Check if this is a package section (should use normal text editor)
            const isPackageSection = section && (
                section.includes('_package_type') || 
                section.includes('_package_title') || 
                section.includes('_package_description') || 
                section.includes('_package_features')
            );
            
            if (isPackageSection) {
                // Use normal text input for package sections
                if (section.includes('_package_type') || section.includes('_package_title')) {
                    // Single line input for type and title
                    $this.html('<input type="text" class="form-control inline-edit text-input" value="' + $this.text().trim() + '" />');
                } else {
                    // Multi-line textarea for description and features
                    $this.html('<textarea class="form-control inline-edit text-input" rows="3">' + $this.text().trim() + '</textarea>');
                }
            } else if (type === 'textarea' || type === 'html') {
                // Use HTML editor for non-package textarea and html types
                $this.html('<div class="html-editor-container">' +
                          '<textarea class="form-control inline-edit html-editor" id="' + uniqueId + '" rows="4">' + text + '</textarea>' +
                          '</div>');
                
                // Initialize Summernote HTML editor
                $('#' + uniqueId).summernote({
                    height: 150,
                    minHeight: 100,
                    maxHeight: 300,
                    focus: true,
                    toolbar: [
                        ['style', ['style']],
                        ['font', ['bold', 'italic', 'underline', 'clear']],
                        ['fontname', ['fontname']],
                        ['fontsize', ['fontsize']],
                        ['color', ['color']],
                        ['para', ['ul', 'ol', 'paragraph']],
                        ['table', ['table']],
                        ['insert', ['link', 'picture']],
                        ['view', ['fullscreen', 'codeview', 'help']]
                    ],
                    callbacks: {
                        onInit: function() {
                            $(this).summernote('code', text);
                        }
                    }
                });
            } else {
                // Use rich text input for other simple text
                $this.html('<div class="html-editor-container">' +
                          '<textarea class="form-control inline-edit html-editor-simple" id="' + uniqueId + '" rows="2">' + text + '</textarea>' +
                          '</div>');
                
                // Initialize simple Summernote for single line
                $('#' + uniqueId).summernote({
                    height: 80,
                    minHeight: 60,
                    maxHeight: 120,
                    focus: true,
                    toolbar: [
                        ['font', ['bold', 'italic', 'underline']],
                        ['color', ['color']],
                        ['para', ['paragraph']]
                    ],
                    callbacks: {
                        onInit: function() {
                            $(this).summernote('code', text);
                        }
                    }
                });
            }
            
            $this.addClass('editing');
        });
        
        // Show edit indicators
        $('.editable-text').css({
            'border': '2px dashed #007bff',
            'padding': '5px',
            'margin': '2px',
            'border-radius': '4px',
            'background-color': '#f8f9fa'
        });
    });
    
    // Save All Changes
    $('#saveAllChanges').on('click', function() {
        const changes = {};
        let hasChanges = false;
        
        $('.editable-text').each(function() {
            const section = $(this).data('section');
            let newText = '';
            
            // Get content from HTML editor
            const htmlEditor = $(this).find('.html-editor, .html-editor-simple');
            if (htmlEditor.length > 0) {
                newText = htmlEditor.summernote('code');
            } else {
                newText = $(this).find('.inline-edit').val();
            }
            
            if (newText !== originalTexts[section]) {
                changes[section] = newText;
                hasChanges = true;
            }
        });
        
        if (!hasChanges) {
            exitEditMode();
            return;
        }
        
        // Save changes via AJAX
        $.ajax({
            url: '/serverside/forms/update_site_content_bulk.php',
            type: 'POST',
            data: {
                page_name: 'site-info',
                changes: changes
            },
            dataType: 'json',
            beforeSend: function() {
                $('#saveAllChanges').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...');
            },
            success: function(response) {
                if (response.response == 1) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: 'All changes saved successfully!',
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function() {
                        location.reload();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error!',
                        text: response.msg || 'Failed to save changes'
                    });
                    $('#saveAllChanges').prop('disabled', false).html('<i class="fas fa-save"></i> Save All Changes');
                }
            },
            error: function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: 'An error occurred while saving changes.'
                });
                $('#saveAllChanges').prop('disabled', false).html('<i class="fas fa-save"></i> Save All Changes');
            }
        });
    });
    
    // Cancel Edit Mode
    $('#cancelEdit').on('click', function() {
        exitEditMode();
    });
    
    // Exit Edit Mode Function
    function exitEditMode() {
        editMode = false;
        $('#enableEditMode').show();
        $('#editControls').hide();
        $('#customizationPanel').hide();
        $('#welcomeMessage').show();
        
        // Destroy Summernote editors before restoring content
        $('.editable-text').each(function() {
            const htmlEditor = $(this).find('.html-editor, .html-editor-simple');
            if (htmlEditor.length > 0) {
                htmlEditor.summernote('destroy');
            }
        });
        
        // Restore original text
        $('.editable-text').each(function() {
            const section = $(this).data('section');
            $(this).html(originalTexts[section]);
            $(this).removeClass('editing');
        });
        
        // Remove edit styling
        $('.editable-text').css({
            'border': 'none',
            'padding': '',
            'margin': '',
            'border-radius': '',
            'background-color': ''
        });
        
        originalTexts = {};
    }
    
    // Quick Edit on Double Click
    $('.editable-text').on('dblclick', function() {
        if (!editMode) {
            $('#enableEditMode').click();
        }
    });
    
    // Advanced Customization Features
    
    // Design Studio
    $('#designCustomizer').on('click', function() {
        showCustomizationPanel('design');
    });
    
    // Layout Manager
    $('#layoutManager').on('click', function() {
        showCustomizationPanel('layout');
    });
    
    // Content Manager
    $('#contentManager').on('click', function() {
        showCustomizationPanel('content');
    });
    
    // Show Customization Panel
    function showCustomizationPanel(type) {
        const panel = $('#customizationPanel');
        let content = '';
        
        switch(type) {
            case 'design':
                content = getDesignStudioContent();
                break;
            case 'layout':
                content = getLayoutManagerContent();
                break;
            case 'content':
                content = getContentManagerContent();
                break;
        }
        
        // Hide welcome message and show panel
        $('#welcomeMessage').hide();
        panel.html(content).show();
        initializeCustomizationFeatures(type);
    }
    
    // Design Studio Content
    function getDesignStudioContent() {
        return '<div class="customization-tabs">' +
               '<div class="customization-tab active" data-tab="colors">Colors</div>' +
               '<div class="customization-tab" data-tab="fonts">Typography</div>' +
               '<div class="customization-tab" data-tab="animations">Animations</div>' +
               '</div>' +
               '<div id="colorsTab" class="tab-content">' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-palette"></i> Color Scheme</h6>' +
               '<div class="color-picker-group">' +
               '<div class="color-option" style="background: #007bff" data-color="blue"></div>' +
               '<div class="color-option" style="background: #28a745" data-color="green"></div>' +
               '<div class="color-option" style="background: #dc3545" data-color="red"></div>' +
               '<div class="color-option" style="background: #ffc107" data-color="yellow"></div>' +
               '<div class="color-option" style="background: #6f42c1" data-color="purple"></div>' +
               '<div class="color-option" style="background: #fd7e14" data-color="orange"></div>' +
               '</div>' +
               '</div>' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-adjust"></i> Card Transparency</h6>' +
               '<input type="range" class="range-slider" id="cardOpacity" min="0.5" max="1" step="0.1" value="1">' +
               '<div class="preview-box" id="opacityPreview">Preview Card Opacity</div>' +
               '</div>' +
               '</div>' +
               '<div id="fontsTab" class="tab-content" style="display:none;">' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-font"></i> Font Family</h6>' +
               '<select class="form-control" id="fontFamily">' +
               '<option value="Arial">Arial</option>' +
               '<option value="Helvetica">Helvetica</option>' +
               '<option value="Georgia">Georgia</option>' +
               '<option value="Times New Roman">Times New Roman</option>' +
               '<option value="Courier New">Courier New</option>' +
               '</select>' +
               '<div class="font-preview" id="fontPreview">Sample Text Preview</div>' +
               '</div>' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-text-height"></i> Font Size</h6>' +
               '<input type="range" class="range-slider" id="fontSize" min="12" max="24" value="16">' +
               '</div>' +
               '</div>' +
               '<div id="animationsTab" class="tab-content" style="display:none;">' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-magic"></i> Animation Speed</h6>' +
               '<input type="range" class="range-slider" id="animationSpeed" min="1" max="5" value="3">' +
               '<div class="animation-preview" id="animationPreview"></div>' +
               '</div>' +
               '</div>';
    }
    
    // Layout Manager Content
    function getLayoutManagerContent() {
        return '<div class="customization-section">' +
               '<h6><i class="fas fa-th-large"></i> Layout Options</h6>' +
               '<div class="layout-option active" data-layout="grid">' +
               '<h6>Grid Layout (Current)</h6>' +
               '<p>6 cards per row on desktop, responsive grid</p>' +
               '</div>' +
               '<div class="layout-option" data-layout="list">' +
               '<h6>List Layout</h6>' +
               '<p>Vertical list with larger cards</p>' +
               '</div>' +
               '<div class="layout-option" data-layout="carousel">' +
               '<h6>Carousel Layout</h6>' +
               '<p>Horizontal scrolling carousel</p>' +
               '</div>' +
               '</div>' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-expand-arrows-alt"></i> Card Spacing</h6>' +
               '<input type="range" class="range-slider" id="cardSpacing" min="10" max="50" value="20">' +
               '</div>' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-arrows-alt-h"></i> Container Width</h6>' +
               '<input type="range" class="range-slider" id="containerWidth" min="80" max="100" value="100">' +
               '</div>';
    }
    
    // Content Manager Content
    function getContentManagerContent() {
        return '<div class="customization-section">' +
               '<h6><i class="fas fa-plus-circle"></i> Add New SIM Company</h6>' +
               '<div class="row">' +
               '<div class="col-md-6">' +
               '<input type="text" class="form-control" id="newCompanyName" placeholder="Company Name">' +
               '</div>' +
               '<div class="col-md-4">' +
               '<select class="form-control" id="newCompanyType">' +
               '<option value="free">FREE</option>' +
               '<option value="package">PACKAGE</option>' +
               '</select>' +
               '</div>' +
               '<div class="col-md-2">' +
               '<button class="btn btn-success btn-sm" id="addCompany">Add</button>' +
               '</div>' +
               '</div>' +
               '</div>' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-sliders-h"></i> Slider Management</h6>' +
               '<textarea class="form-control" id="newSliderText" placeholder="🚀 Enter new slider text..." rows="2"></textarea>' +
               '<button class="btn btn-primary btn-sm mt-2" id="addSliderText">Add Slider Text</button>' +
               '</div>' +
               '<div class="customization-section">' +
               '<h6><i class="fas fa-eye-slash"></i> Hide/Show Elements</h6>' +
               '<div class="form-check">' +
               '<input class="form-check-input" type="checkbox" id="showStats" checked>' +
               '<label class="form-check-label" for="showStats">Show Statistics Cards</label>' +
               '</div>' +
               '<div class="form-check">' +
               '<input class="form-check-input" type="checkbox" id="showSlider" checked>' +
               '<label class="form-check-label" for="showSlider">Show Text Slider</label>' +
               '</div>' +
               '</div>';
    }
    
    // Initialize Customization Features
    function initializeCustomizationFeatures(type) {
        // Tab switching
        $('.customization-tab').on('click', function() {
            const tab = $(this).data('tab');
            $('.customization-tab').removeClass('active');
            $(this).addClass('active');
            $('.tab-content').hide();
            $('#' + tab + 'Tab').show();
        });
        
        // Color picker
        $('.color-option').on('click', function() {
            const color = $(this).data('color');
            $('.color-option').removeClass('active');
            $(this).addClass('active');
            applyColorScheme(color);
        });
        
        // Range sliders
        $('.range-slider').on('input', function() {
            const id = $(this).attr('id');
            const value = $(this).val();
            applyRangeChange(id, value);
        });
        
        // Layout options
        $('.layout-option').on('click', function() {
            const layout = $(this).data('layout');
            $('.layout-option').removeClass('active');
            $(this).addClass('active');
            applyLayoutChange(layout);
        });
        
        // Font family
        $('#fontFamily').on('change', function() {
            const font = $(this).val();
            applyFontChange(font);
        });
        
        // Content management
        $('#addCompany').on('click', addNewCompany);
        $('#addSliderText').on('click', addNewSliderText);
        
        // Element visibility
        $('#showStats, #showSlider').on('change', function() {
            toggleElementVisibility();
        });
    }
    
    // Apply color scheme
    function applyColorScheme(color) {
        const colors = {
            blue: '#007bff',
            green: '#28a745',
            red: '#dc3545',
            yellow: '#ffc107',
            purple: '#6f42c1',
            orange: '#fd7e14'
        };
        
        const primaryColor = colors[color];
        $(':root').css('--primary-color', primaryColor);
        $('.btn-primary').css('background-color', primaryColor);
        $('.text-primary').css('color', primaryColor);
        
        // Save design customization
        const designData = {
            colorScheme: color,
            fontFamily: $('body').css('font-family'),
            fontSize: parseInt($('body').css('font-size')),
            cardOpacity: parseFloat($('.sim-card').css('opacity') || 1),
            animationSpeed: 3 // default value
        };
        saveCustomization('design', designData);
    }
    
    // Apply range changes
    function applyRangeChange(id, value) {
        switch(id) {
            case 'cardOpacity':
                $('.sim-card').css('opacity', value);
                $('#opacityPreview').css('opacity', value);
                saveDesignCustomization();
                break;
            case 'fontSize':
                $('body').css('font-size', value + 'px');
                saveDesignCustomization();
                break;
            case 'cardSpacing':
                $('.sim-card').css('margin', value + 'px');
                saveLayoutCustomization();
                break;
            case 'containerWidth':
                $('.container').css('max-width', value + '%');
                saveLayoutCustomization();
                break;
            case 'animationSpeed':
                $('.animation-preview').css('animation-duration', (6 - value) + 's');
                saveDesignCustomization();
                break;
        }
    }
    
    // Apply font changes
    function applyFontChange(font) {
        $('body').css('font-family', font);
        $('#fontPreview').css('font-family', font);
        saveDesignCustomization();
    }
    
    // Save design customization helper
    function saveDesignCustomization() {
        const designData = {
            colorScheme: getCurrentColorScheme(),
            fontFamily: $('body').css('font-family'),
            fontSize: parseInt($('body').css('font-size')),
            cardOpacity: parseFloat($('.sim-card').css('opacity') || 1),
            animationSpeed: getCurrentAnimationSpeed()
        };
        saveCustomization('design', designData);
    }
    
    // Save layout customization helper
    function saveLayoutCustomization() {
        const layoutData = {
            layoutType: getCurrentLayoutType(),
            cardSpacing: getCurrentCardSpacing(),
            containerWidth: getCurrentContainerWidth()
        };
        saveCustomization('layout', layoutData);
    }
    
    // Save content customization helper
    function saveContentCustomization() {
        const contentData = {
            showStats: $('#showStats').is(':checked'),
            showSlider: $('#showSlider').is(':checked')
        };
        saveCustomization('content', contentData);
    }
    
    // Helper functions to get current values
    function getCurrentColorScheme() {
        const currentColor = $('.btn-primary').css('background-color');
        const colorMap = {
            'rgb(0, 123, 255)': 'blue',
            'rgb(40, 167, 69)': 'green',
            'rgb(220, 53, 69)': 'red',
            'rgb(255, 193, 7)': 'yellow',
            'rgb(111, 66, 193)': 'purple',
            'rgb(253, 126, 20)': 'orange'
        };
        return colorMap[currentColor] || 'blue';
    }
    
    function getCurrentAnimationSpeed() {
        const duration = $('.animation-preview').css('animation-duration');
        if (duration) {
            const seconds = parseFloat(duration);
            return 6 - seconds; // Reverse calculation
        }
        return 3; // default
    }
    
    function getCurrentLayoutType() {
        const firstCard = $('.sim-card').first().parent();
        if (firstCard.hasClass('col-12')) {
            return 'list';
        } else if (firstCard.hasClass('col-lg-2')) {
            return 'grid';
        }
        return 'grid'; // default
    }
    
    function getCurrentCardSpacing() {
        const margin = $('.sim-card').css('margin');
        return parseInt(margin) || 20; // default
    }
    
    function getCurrentContainerWidth() {
        const maxWidth = $('.container').css('max-width');
        if (maxWidth && maxWidth.includes('%')) {
            return parseInt(maxWidth);
        }
        return 100; // default
    }
    
    // Apply layout changes
    function applyLayoutChange(layout) {
        const simCards = $('.sim-card').parent();
        
        switch(layout) {
            case 'grid':
                simCards.removeClass('col-12').addClass('col-lg-2 col-md-3 col-sm-4 col-6');
                break;
            case 'list':
                simCards.removeClass('col-lg-2 col-md-3 col-sm-4 col-6').addClass('col-12');
                break;
            case 'carousel':
                // Implement carousel layout
                break;
        }
        
        saveLayoutCustomization();
    }
    
    // Add new company
    function addNewCompany() {
        const name = $('#newCompanyName').val();
        const type = $('#newCompanyType').val();
        
        if (!name) {
            alert('Please enter company name');
            return;
        }
        
        // Add new SIM card (simplified implementation)
        const newCard = '<div class="col-lg-2 col-md-3 col-sm-4 col-6 mb-4">' +
                       '<div class="card custom-feature-card h-100 sim-card" data-company="' + name.toLowerCase() + '">' +
                       '<div class="card-tag ' + type + '">' + type.toUpperCase() + '</div>' +
                       '<div class="card-body text-center p-3">' +
                       '<div class="company-logo">' +
                       '<div class="logo-container" style="background: linear-gradient(135deg, #007bff, #0056b3);">' +
                       '<span style="font-size: 14px; font-weight: bold; color: white;">' + name + '</span>' +
                       '</div></div></div></div></div>';
        
        $('.sim-card').last().parent().after(newCard);
        $('#newCompanyName').val('');
        
        Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: 'New company added successfully!',
            timer: 2000,
            showConfirmButton: false
        });
    }
    
    // Add new slider text
    function addNewSliderText() {
        const text = $('#newSliderText').val();
        
        if (!text) {
            alert('Please enter slider text');
            return;
        }
        
        const newSlide = '<div class="slider-text">' + text + '</div>';
        $('.text-slider').append(newSlide);
        $('#newSliderText').val('');
        
        Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: 'New slider text added successfully!',
            timer: 2000,
            showConfirmButton: false
        });
    }
    
    // Toggle element visibility
    function toggleElementVisibility() {
        const showStats = $('#showStats').is(':checked');
        const showSlider = $('#showSlider').is(':checked');
        
        if (showStats) {
            $('.stats-card').show();
        } else {
            $('.stats-card').hide();
        }
        
        if (showSlider) {
            $('.text-slider').parent().parent().show();
        } else {
            $('.text-slider').parent().parent().hide();
        }
        
        saveContentCustomization();
    }
    
    // Load saved customizations on page load
    loadSavedCustomizations();
    
    // Package Editor Modal Save Function
    $('#savePackagesBtn').on('click', function() {
        const changes = {};
        let hasChanges = false;
        
        // Collect all package input values
        $('.package-input').each(function() {
            const section = $(this).data('section');
            const newValue = $(this).val().trim();
            
            if (newValue) {
                changes[section] = newValue;
                hasChanges = true;
            }
        });
        
        if (!hasChanges) {
            Swal.fire({
                icon: 'info',
                title: 'No Changes',
                text: 'No changes were made to save.'
            });
            return;
        }
        
        // Disable save button and show loading
        $('#savePackagesBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...');
        
        // Save changes via AJAX
        $.ajax({
            url: '/serverside/forms/update_site_content_bulk.php',
            method: 'POST',
            data: {
                page_name: 'site-info',
                content_updates: JSON.stringify(changes),
                firenet_encrypt: '{$firenet_encrypt}'
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: 'All package information saved successfully!',
                        showConfirmButton: false,
                        timer: 2000
                    }).then(function() {
                        $('#packageEditModal').modal('hide');
                        location.reload();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error!',
                        text: response.msg || 'Failed to save package information'
                    });
                    $('#savePackagesBtn').prop('disabled', false).html('<i class="fas fa-save"></i> 💾 Save All Packages');
                }
            },
            error: function() {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: 'An error occurred while saving package information.'
                });
                $('#savePackagesBtn').prop('disabled', false).html('<i class="fas fa-save"></i> 💾 Save All Packages');
            }
        });
    });
    
    // Save customization data
    function saveCustomization(type, data) {
        $.ajax({
            url: '/serverside/forms/save_customization.php',
            type: 'POST',
            data: {
                page_name: 'site-info',
                customization_type: type,
                customization_data: data
            },
            dataType: 'json',
            success: function(response) {
                if (response.response == 1) {
                    // Show subtle success indicator
                    showSaveIndicator(true);
                } else {
                    showSaveIndicator(false);
                }
            },
            error: function() {
                showSaveIndicator(false);
            }
        });
    }
    
    // Load saved customizations
    function loadSavedCustomizations() {
        $.ajax({
            url: '/serverside/data/get_customizations.php',
            type: 'GET',
            data: {
                page_name: 'site-info'
            },
            dataType: 'json',
            success: function(response) {
                if (response.response == 1 && response.customizations) {
                    applyLoadedCustomizations(response.customizations);
                    }
            },
            error: function() {
                }
        });
    }
    
    // Apply loaded customizations
    function applyLoadedCustomizations(customizations) {
        // Apply design customizations
        if (customizations.design && customizations.design.data) {
            const designData = customizations.design.data;
            
            if (designData.colorScheme) {
                applyColorScheme(designData.colorScheme);
            }
            if (designData.fontFamily) {
                applyFontChange(designData.fontFamily);
            }
            if (designData.fontSize) {
                applyRangeChange('fontSize', designData.fontSize);
            }
            if (designData.cardOpacity) {
                applyRangeChange('cardOpacity', designData.cardOpacity);
            }
            if (designData.animationSpeed) {
                applyRangeChange('animationSpeed', designData.animationSpeed);
            }
        }
        
        // Apply layout customizations
        if (customizations.layout && customizations.layout.data) {
            const layoutData = customizations.layout.data;
            
            if (layoutData.layoutType) {
                applyLayoutChange(layoutData.layoutType);
            }
            if (layoutData.cardSpacing) {
                applyRangeChange('cardSpacing', layoutData.cardSpacing);
            }
            if (layoutData.containerWidth) {
                applyRangeChange('containerWidth', layoutData.containerWidth);
            }
        }
        
        // Apply content customizations
        if (customizations.content && customizations.content.data) {
            const contentData = customizations.content.data;
            
            if (contentData.showStats !== undefined) {
                $('#showStats').prop('checked', contentData.showStats);
                toggleElementVisibility();
            }
            if (contentData.showSlider !== undefined) {
                $('#showSlider').prop('checked', contentData.showSlider);
                toggleElementVisibility();
            }
        }
    }
    
    // Show save indicator
    function showSaveIndicator(success) {
        const indicator = $('<div class="save-indicator">')
            .css({
                'position': 'fixed',
                'top': '20px',
                'right': '20px',
                'padding': '10px 15px',
                'border-radius': '4px',
                'color': 'white',
                'font-size': '14px',
                'z-index': '9999',
                'background-color': success ? '#28a745' : '#dc3545'
            })
            .text(success ? '✓ Saved' : '✗ Save Failed')
            .appendTo('body');
        
        setTimeout(function() {
            indicator.fadeOut(500, function() {
                $(this).remove();
            });
        }, 2000);
    }
    
    });
</script>

