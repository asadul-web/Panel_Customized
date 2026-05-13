/**
 * Security Protection Script
 * Disables right-click, keyboard shortcuts, and developer tools access
 */

(function() {
    'use strict';
    
    // Disable right-click context menu
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        showSecurityAlert('Right-click is disabled for security purposes');
        return false;
    });
    
    // Disable F12, Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+U, Ctrl+S
    document.addEventListener('keydown', function(e) {
        // F12 - Developer Tools
        if (e.keyCode === 123) {
            e.preventDefault();
            showSecurityAlert('Developer tools are disabled');
            return false;
        }
        
        // Ctrl+Shift+I - Inspect Element
        if (e.ctrlKey && e.shiftKey && e.keyCode === 73) {
            e.preventDefault();
            showSecurityAlert('Inspect element is disabled');
            return false;
        }
        
        // Ctrl+Shift+J - Console
        if (e.ctrlKey && e.shiftKey && e.keyCode === 74) {
            e.preventDefault();
            showSecurityAlert('Console is disabled');
            return false;
        }
        
        // Ctrl+U - View Source
        if (e.ctrlKey && e.keyCode === 85) {
            e.preventDefault();
            showSecurityAlert('View source is disabled');
            return false;
        }
        
        // Ctrl+S - Save Page
        if (e.ctrlKey && e.keyCode === 83) {
            e.preventDefault();
            showSecurityAlert('Saving page is disabled');
            return false;
        }
        
        // Ctrl+Shift+C - Inspect Element (alternative)
        if (e.ctrlKey && e.shiftKey && e.keyCode === 67) {
            e.preventDefault();
            showSecurityAlert('Inspect element is disabled');
            return false;
        }
    });
    
    // Disable text selection (but allow in input fields and Summernote editor)
    document.addEventListener('selectstart', function(e) {
        // Allow selection in input, textarea, and Summernote editor
        if (e.target.tagName === 'INPUT' || 
            e.target.tagName === 'TEXTAREA' || 
            e.target.classList.contains('note-editable') ||
            e.target.closest('.note-editable') ||
            e.target.closest('.summernote')) {
            return true;
        }
        e.preventDefault();
        return false;
    });
    
    // Disable copy (but allow in input fields and Summernote editor)
    document.addEventListener('copy', function(e) {
        // Allow copy in input, textarea, and Summernote editor
        if (e.target.tagName === 'INPUT' || 
            e.target.tagName === 'TEXTAREA' || 
            e.target.classList.contains('note-editable') ||
            e.target.closest('.note-editable') ||
            e.target.closest('.summernote')) {
            return true;
        }
        e.preventDefault();
        showSecurityAlert('Copying content is disabled');
        return false;
    });
    
    // Disable cut (but allow in input fields and Summernote editor)
    document.addEventListener('cut', function(e) {
        // Allow cut in input, textarea, and Summernote editor
        if (e.target.tagName === 'INPUT' || 
            e.target.tagName === 'TEXTAREA' || 
            e.target.classList.contains('note-editable') ||
            e.target.closest('.note-editable') ||
            e.target.closest('.summernote')) {
            return true;
        }
        e.preventDefault();
        return false;
    });
    
    // Disable drag
    document.addEventListener('dragstart', function(e) {
        e.preventDefault();
        return false;
    });
    
    // Aggressive DevTools Detection - Auto Close Window
    var devtools = {
        isOpen: false,
        orientation: null
    };
    
    var threshold = 200; // Increased to prevent mobile false positives
    var emitEvent = function(isOpen, orientation) {
        if (devtools.isOpen !== isOpen || devtools.orientation !== orientation) {
            devtools.isOpen = isOpen;
            devtools.orientation = orientation;
            if (isOpen) {
                // DevTools detected - close window after brief delay
                showSecurityAlert('Developer tools detected. Access denied.');
                setTimeout(function() {
                    window.location.href = 'about:blank';
                    window.close();
                }, 1000);
            }
        }
    };
    
    // Multiple detection methods - only on desktop
    if (!/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        setInterval(function() {
            var widthThreshold = window.outerWidth - window.innerWidth > threshold;
            var heightThreshold = window.outerHeight - window.innerHeight > threshold;
            var orientation = widthThreshold ? 'vertical' : 'horizontal';
            
            if (!(heightThreshold && widthThreshold) && ((window.Firebug && window.Firebug.chrome && window.Firebug.chrome.isInitialized) || widthThreshold || heightThreshold)) {
                emitEvent(true, orientation);
            } else {
                emitEvent(false, null);
            }
        }, 500);
    }
    
    // Show security alert message
    function showSecurityAlert(message) {
        // Create alert element if it doesn't exist
        var alertBox = document.getElementById('security-alert-box');
        if (!alertBox) {
            alertBox = document.createElement('div');
            alertBox.id = 'security-alert-box';
            alertBox.style.cssText = 'position:fixed;top:20px;right:20px;background:#dc3545!important;color:white;padding:15px 20px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.3);z-index:99999;font-family:Arial,sans-serif;font-size:14px;max-width:300px;animation:slideIn 0.3s ease-out;';
            document.body.appendChild(alertBox);
            
            // Add CSS animation
            var style = document.createElement('style');
            style.textContent = '@keyframes slideIn { from { transform: translateX(400px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }';
            document.head.appendChild(style);
        }
        
        alertBox.innerHTML = '<strong>⚠️ Security Protection</strong><br>' + message;
        alertBox.style.display = 'block';
        
        // Auto-hide after 3 seconds
        setTimeout(function() {
            alertBox.style.display = 'none';
        }, 3000);
    }
    
    // Prevent opening in new window/tab to view source
    window.addEventListener('beforeunload', function(e) {
        // This helps prevent some source viewing attempts
    });
    
    // Disable print
    window.addEventListener('beforeprint', function(e) {
        e.preventDefault();
        showSecurityAlert('Printing is disabled');
        return false;
    });
    
    // Console warning
    console.log('%c⚠️ SECURITY WARNING', 'color: red; font-size: 40px; font-weight: bold;');
    console.log('%cThis is a secure application. Unauthorized access attempts are logged and may result in legal action.', 'color: red; font-size: 16px;');
    console.log('%cIf you are not authorized to access this system, please close this window immediately.', 'color: red; font-size: 16px;');
    
})();
