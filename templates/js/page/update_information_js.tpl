<script>
{literal}
$(document).ready(function() {
    
    // Text Slider functionality
    let currentSlide = 0;
    const slides = $('.slider-text');
    const totalSlides = slides.length;
    
    function showNextSlide() {
        // Fade out current slide
        slides.eq(currentSlide).removeClass('active').addClass('fade-out');
        
        // Move to next slide
        currentSlide = (currentSlide + 1) % totalSlides;
        
        // Fade in next slide after a short delay
        setTimeout(function() {
            slides.removeClass('active fade-out');
            slides.eq(currentSlide).addClass('active');
        }, 400);
    }
    
    // Start the slider
    setInterval(showNextSlide, 3000); // Change slide every 3 seconds
    
    // SIM card click functionality
    $('.sim-card').on('click', function() {
        const company = $(this).data('company');
        showSimInfo(company);
    });
    
    // SIM packages data
    const simPackages = {
        'mobily': [
            'Mobily 30 SR Mashawir Pack',
            'Mobily 30 SR Taxi Bundle',
            'Mobily 60 SR Social Pack'
        ],
        'lebara': [
            'Lebara Free Unlimited Net'
        ],
        'stc': [
            'STC Sawa Free Net (50% Device Offer)'
        ],
        'salam': [
            'Salam SIM Free Unlimited 4G+ Net'
        ],
        'zain': [
            'Zain All Social Media Pack'
        ],
        'redbull': [
            'Redbull 60 SR Social Media Pack'
        ],
        'virgin': [
            'Virgin Mobile 40 SR Data Pack',
            'Virgin Mobile Social Bundle'
        ],
        'friendi': [
            'Friendi Mobile KSA Special Pack',
            'Friendi Unlimited Social Media'
        ],
        'jawwy': [
            'Jawwy Unlimited Streaming Pack',
            'Jawwy Social Media Bundle'
        ],
        'yaqoot': [
            'Yaqoot Premium Data Pack',
            'Yaqoot Social Media Package'
        ]
    };
    
    // Function to show SIM information modal
    function showSimInfo(company) {
        const companyNames = {
            'stc': 'STC',
            'mobily': 'Mobily',
            'zain': 'Zain',
            'virgin': 'Virgin Mobile',
            'lebara': 'Lebara',
            'friendi': 'Friendi Mobile',
            'redbull': 'Red Bull Mobile',
            'salam': 'Salam Mobile',
            'jawwy': 'Jawwy',
            'yaqoot': 'Yaqoot'
        };
        
        const packages = simPackages[company] || ['No packages available'];
        const companyName = companyNames[company] || company.toUpperCase();
        
        // Update modal title
        $('#companyName').text(companyName);
        
        // Clear and populate packages list
        const packagesList = $('#simPackagesList');
        packagesList.empty();
        
        // Get the tag type for this company from the card
        const companyCard = $(`.sim-card[data-company="${company}"]`);
        const tagType = companyCard.find('.card-tag').hasClass('free') ? 'FREE' : 'PACKAGE';
        const tagClass = tagType === 'FREE' ? 'badge-success' : 'badge-primary';
        
        packages.forEach(function(packageName) {
            const packageItem = $(`
                <div class="sim-package-item">
                    <div class="check-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="package-text">
                        ${packageName}
                    </div>
                    <div class="package-price">
                        <span class="badge ${tagClass}">${tagType}</span>
                    </div>
                </div>
            `);
            packagesList.append(packageItem);
        });
        
        // Show modal
        $('#simInfoModal').modal('show');
    }
    
    // Contact button functionality
    $('#contactBtn').on('click', function() {
        const companyName = $('#companyName').text();
        Swal.fire({
            title: 'Contact Support',
            html: `<div class="text-left">
                <p><strong>Company:</strong> ${companyName}</p>
                <p><strong>Support Phone:</strong> +966 800 123 4567</p>
                <p><strong>Email:</strong> support@${companyName.toLowerCase().replace(' ', '')}.sa</p>
                <p><strong>Working Hours:</strong> 24/7 Customer Support</p>
            </div>`,
            icon: 'info',
            confirmButtonText: 'Got it!',
            confirmButtonClass: 'btn btn-primary',
            buttonsStyling: false
        });
    });
    
    // Order button functionality
    $('#orderBtn').on('click', function() {
        const companyName = $('#companyName').text();
        Swal.fire({
            title: 'Order Package',
            html: `<div class="text-left">
                <p>Ready to order from <strong>${companyName}</strong>?</p>
                <p>You will be redirected to the official ordering system.</p>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> 
                    Please have your ID and payment method ready.
                </div>
            </div>`,
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-external-link-alt"></i> Continue to Order',
            cancelButtonText: '<i class="fas fa-times"></i> Cancel',
            confirmButtonClass: 'btn btn-success',
            cancelButtonClass: 'btn btn-light',
            buttonsStyling: false
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Redirecting...',
                    text: `Opening ${companyName} ordering system`,
                    icon: 'success',
                    timer: 2000,
                    showConfirmButton: false,
                    confirmButtonClass: 'btn btn-success',
                    buttonsStyling: false
                });
            }
        });
    });
    
    // Auto-detect and apply Bangla font
    function applyBanglaFont() {
        // Check for Bangla text in any inputs or text areas
        $('input, textarea, select').on('input change', function() {
            var text = $(this).val();
            var banglaRegex = /[\u0980-\u09FF]/;
            
            if (banglaRegex.test(text)) {
                $(this).addClass('bangla-text');
            } else {
                $(this).removeClass('bangla-text');
            }
        });
    }
    
    // Initialize Bangla font detection
    applyBanglaFont();
    
    // Custom feature card hover effects
    $('.custom-feature-card').on('mouseenter', function() {
        $(this).addClass('shadow-lg');
    }).on('mouseleave', function() {
        $(this).removeClass('shadow-lg');
    });
    
    // Add your custom JavaScript functions here
    // Example:
    // function customFeature() {
    //     // Your custom feature code
    // }
    
});

// Global functions for custom features
window.updateInformationUtils = {
    showAlert: function(title, message, type) {
        type = type || 'info';
        Swal.fire({
            title: title,
            text: message,
            icon: type,
            confirmButtonText: 'OK'
        });
    },
    
    addCustomCard: function(title, content, iconClass, colorClass) {
        var cardHtml = '<div class="col-lg-3 col-md-6 col-sm-6 col-12">' +
                      '<div class="card custom-feature-card">' +
                      '<div class="card-body text-center">' +
                      '<div class="feature-icon ' + (colorClass || 'primary') + '">' +
                      '<i class="' + (iconClass || 'fas fa-star') + '"></i>' +
                      '</div>' +
                      '<h6>' + title + '</h6>' +
                      '<p class="text-muted">' + content + '</p>' +
                      '</div></div></div>';
        
        return cardHtml;
    }
};
{/literal}
</script>
