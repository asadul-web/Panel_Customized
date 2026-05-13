/**
 * Lazy Loading and Performance Optimization
 * Defers non-critical resources for faster initial page load
 */

(function() {
    'use strict';
    
    // Defer non-critical CSS
    function loadCSS(href) {
        var link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = href;
        document.head.appendChild(link);
    }
    
    // Defer non-critical JavaScript
    function loadJS(src, callback) {
        var script = document.createElement('script');
        script.src = src;
        script.async = true;
        if (callback) {
            script.onload = callback;
        }
        document.body.appendChild(script);
    }
    
    // Lazy load images
    function lazyLoadImages() {
        var images = document.querySelectorAll('img[data-src]');
        var imageObserver = new IntersectionObserver(function(entries, observer) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    var img = entry.target;
                    img.src = img.dataset.src;
                    img.removeAttribute('data-src');
                    imageObserver.unobserve(img);
                }
            });
        });
        
        images.forEach(function(img) {
            imageObserver.observe(img);
        });
    }
    
    // Optimize DataTables loading
    window.optimizedDataTable = function(selector, options) {
        var defaultOptions = {
            deferRender: true,
            processing: false,
            serverSide: false,
            stateSave: true,
            stateDuration: 300, // 5 minutes
            pageLength: 25,
            lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            dom: "<'row'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                 "<'row'<'col-sm-12'tr>>" +
                 "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            language: {
                processing: '<i class="fa fa-spinner fa-spin fa-3x fa-fw"></i><span class="sr-only">Loading...</span>'
            }
        };
        
        var mergedOptions = Object.assign({}, defaultOptions, options || {});
        return $(selector).DataTable(mergedOptions);
    };
    
    // Debounce function for search inputs
    window.debounce = function(func, wait) {
        var timeout;
        return function() {
            var context = this, args = arguments;
            clearTimeout(timeout);
            timeout = setTimeout(function() {
                func.apply(context, args);
            }, wait);
        };
    };
    
    // Initialize on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            lazyLoadImages();
        });
    } else {
        lazyLoadImages();
    }
    
    // Preconnect to external domains
    function addPreconnect(url) {
        var link = document.createElement('link');
        link.rel = 'preconnect';
        link.href = url;
        document.head.appendChild(link);
    }
    
    // Add preconnect for common CDNs
    addPreconnect('https://cdn.datatables.net');
    addPreconnect('https://cdn.jsdelivr.net');
    addPreconnect('https://cdnjs.cloudflare.com');
    
})();
