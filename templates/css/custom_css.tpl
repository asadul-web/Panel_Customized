<style>
/* Import Modern Fonts */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Hind+Siliguri:wght@300;400;500;600;700&display=swap');

/* Global Dark Theme Variables */
:root {
  --bg-primary: #0f0f23;
  --bg-secondary: #1a1a2e;
  --bg-tertiary: #16213e;
  --bg-card: rgba(22, 33, 62, 0.8);
  --bg-glass: rgba(255, 255, 255, 0.05);
  --bg-glass-hover: rgba(255, 255, 255, 0.1);
  --text-primary: #ffffff;
  --text-secondary: #b8c5d6;
  --text-muted: #8892a0;
  --accent-primary: #6366f1;
  --accent-secondary: #8b5cf6;
  --accent-success: #10b981;
  --accent-warning: #f59e0b;
  --accent-danger: #ef4444;
  --border-color: rgba(255, 255, 255, 0.1);
  --border-hover: rgba(255, 255, 255, 0.2);
  --shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  --shadow-hover: 0 12px 40px rgba(0, 0, 0, 0.4);
}

/* Global Styles */
* {
  box-sizing: border-box !important;
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif !important;
  background: linear-gradient(135deg, var(--bg-primary) 0%, var(--bg-secondary) 100%) !important;
  color: var(--text-primary) !important;
  line-height: 1.6 !important;
  margin: 0 !important;
  padding: 0 !important;
  min-height: 100vh !important;
}

/* Glassmorphism Effect */
.glass-card {
  background: var(--bg-glass) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: 16px !important;
  box-shadow: var(--shadow) !important;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.glass-card:hover {
  background: var(--bg-glass-hover) !important;
  border-color: var(--border-hover) !important;
  box-shadow: var(--shadow-hover) !important;
  transform: translateY(-2px) !important;
}

/* Sidebar Styles */
.main-sidebar {
  background: var(--bg-tertiary) !important;
  border-right: 1px solid var(--border-color) !important;
  box-shadow: var(--shadow) !important;
}

.sidebar-brand {
  background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary)) !important;
  border-radius: 0 0 16px 16px !important;
  padding: 1rem !important;
  text-align: center !important;
  margin-bottom: 2rem !important;
}

.sidebar-brand a {
  color: white !important;
  text-decoration: none !important;
  font-weight: 600 !important;
  font-size: 1.25rem !important;
}

.sidebar-menu .nav-link {
  color: var(--text-secondary) !important;
  padding: 0.75rem 1.5rem !important;
  margin: 0.25rem 1rem !important;
  border-radius: 12px !important;
  transition: all 0.3s ease !important;
  position: relative !important;
}

.sidebar-menu .nav-link:hover,
.sidebar-menu .nav-link.active {
  background: var(--bg-glass) !important;
  color: var(--text-primary) !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2) !important;
}

.sidebar-menu .nav-link i {
  margin-right: 0.75rem !important;
  width: 20px !important;
  text-align: center !important;
}

/* Top Navigation */
.navbar-bg {
  background: linear-gradient(135deg, var(--bg-tertiary), var(--bg-secondary)) !important;
  height: 60px !important;
}

.main-navbar {
  background: transparent !important;
  border-bottom: 1px solid var(--border-color) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
}

.main-navbar .navbar-nav .nav-link {
  color: var(--text-secondary) !important;
  padding: 0.5rem 1rem !important;
  border-radius: 8px !important;
  transition: all 0.3s ease !important;
}

.main-navbar .navbar-nav .nav-link:hover {
  background: var(--bg-glass) !important;
  color: var(--text-primary) !important;
}

/* Search Element */
.search-element .form-control {
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-color) !important;
  color: var(--text-primary) !important;
  border-radius: 12px !important;
  padding: 0.5rem 1rem !important;
}

.search-element .form-control:focus {
  background: var(--bg-glass-hover) !important;
  border-color: var(--accent-primary) !important;
  box-shadow: 0 0 0 0.2rem rgba(99, 102, 241, 0.25) !important;
}

.search-element .btn {
  background: var(--accent-primary) !important;
  border: none !important;
  border-radius: 12px !important;
  color: white !important;
  padding: 0.5rem 1rem !important;
  transition: all 0.3s ease !important;
}

.search-element .btn:hover {
  background: var(--accent-secondary) !important;
  transform: scale(1.05) !important;
}

/* Cards */
.card {
  background: var(--bg-card) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: 16px !important;
  box-shadow: var(--shadow) !important;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
  overflow: hidden !important;
}

.card:hover {
  transform: translateY(-4px) !important;
  box-shadow: var(--shadow-hover) !important;
  border-color: var(--border-hover) !important;
}

.card-header {
  background: var(--bg-glass) !important;
  border-bottom: 1px solid var(--border-color) !important;
  padding: 1.5rem !important;
  font-weight: 600 !important;
  color: var(--text-primary) !important;
}

.card-body {
  padding: 1.5rem !important;
  color: var(--text-secondary) !important;
}

.card-statistic-2 {
  background: var(--bg-card) !important;
  border-radius: 16px !important;
  overflow: hidden !important;
}

.card-statistic-2 .card-icon {
  background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary)) !important;
  border-radius: 12px !important;
  padding: 1rem !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 60px !important;
  height: 60px !important;
  margin: 1rem !important;
}

.card-statistic-2 .card-wrap {
  padding: 1rem !important;
}

.card-statistic-2 .card-header h4 {
  color: var(--text-primary) !important;
  font-weight: 600 !important;
  margin-bottom: 0.5rem !important;
}

.card-statistic-2 .card-body {
  font-size: 1.5rem !important;
  font-weight: 700 !important;
  color: var(--accent-primary) !important;
}

/* Buttons */
.btn {
  border-radius: 12px !important;
  font-weight: 500 !important;
  padding: 0.75rem 1.5rem !important;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
  border: none !important;
  position: relative !important;
  overflow: hidden !important;
}

.btn::before {
  content: '' !important;
  position: absolute !important;
  top: 0 !important;
  left: -100% !important;
  width: 100% !important;
  height: 100% !important;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent) !important;
  transition: left 0.5s !important;
}

.btn:hover::before {
  left: 100% !important;
}

.btn-primary {
  background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary)) !important;
  color: white !important;
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3) !important;
}

.btn-primary:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 8px 24px rgba(99, 102, 241, 0.4) !important;
}

.btn-success {
  background: linear-gradient(135deg, var(--accent-success), #059669) !important;
  color: white !important;
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3) !important;
}

.btn-success:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 8px 24px rgba(16, 185, 129, 0.4) !important;
}

.btn-danger {
  background: linear-gradient(135deg, var(--accent-danger), #dc2626) !important;
  color: white !important;
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3) !important;
}

.btn-danger:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 8px 24px rgba(239, 68, 68, 0.4) !important;
}

.btn-warning {
  background: linear-gradient(135deg, var(--accent-warning), #d97706) !important;
  color: white !important;
  box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3) !important;
}

.btn-warning:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 8px 24px rgba(245, 158, 11, 0.4) !important;
}

/* Tables */
.table {
  background: var(--bg-card) !important;
  color: var(--text-primary) !important;
  border-radius: 12px !important;
  overflow: hidden !important;
  box-shadow: var(--shadow) !important;
}

.table thead th {
  background: var(--bg-glass) !important;
  border-bottom: 1px solid var(--border-color) !important;
  color: var(--text-primary) !important;
  font-weight: 600 !important;
  padding: 1rem !important;
  text-transform: uppercase !important;
  font-size: 0.875rem !important;
  letter-spacing: 0.05em !important;
}

.table tbody tr {
  transition: all 0.3s ease !important;
}

.table tbody tr:hover {
  background: var(--bg-glass) !important;
}

.table tbody td {
  border-bottom: 1px solid var(--border-color) !important;
  padding: 1rem !important;
  color: var(--text-secondary) !important;
}

/* Forms */
.form-control {
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: 12px !important;
  color: var(--text-primary) !important;
  padding: 0.75rem 1rem !important;
  transition: all 0.3s ease !important;
}

.form-control:focus {
  background: var(--bg-glass-hover) !important;
  border-color: var(--accent-primary) !important;
  box-shadow: 0 0 0 0.2rem rgba(99, 102, 241, 0.25) !important;
  color: var(--text-primary) !important;
}

.form-control::placeholder {
  color: var(--text-muted) !important;
}

.form-group label {
  color: var(--text-primary) !important;
  font-weight: 500 !important;
  margin-bottom: 0.5rem !important;
}

/* DataTables */
.dataTables_wrapper {
  background: var(--bg-card) !important;
  border-radius: 16px !important;
  overflow: hidden !important;
  box-shadow: var(--shadow) !important;
}

.dataTables_wrapper .dataTables_length,
.dataTables_wrapper .dataTables_filter,
.dataTables_wrapper .dataTables_info,
.dataTables_wrapper .dataTables_paginate {
  color: var(--text-secondary) !important;
  padding: 1rem !important;
}

.dataTables_wrapper .dataTables_filter input {
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: 8px !important;
  color: var(--text-primary) !important;
  padding: 0.5rem !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button {
  background: var(--bg-glass) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: 8px !important;
  color: var(--text-secondary) !important;
  padding: 0.5rem 0.75rem !important;
  margin: 0 0.25rem !important;
  transition: all 0.3s ease !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button:hover,
.dataTables_wrapper .dataTables_paginate .paginate_button.current {
  background: var(--accent-primary) !important;
  color: white !important;
  border-color: var(--accent-primary) !important;
}

/* Alerts */
.alert {
  border-radius: 12px !important;
  border: none !important;
  box-shadow: var(--shadow) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
}

.alert-primary {
  background: rgba(99, 102, 241, 0.1) !important;
  color: #c7d2fe !important;
  border-left: 4px solid var(--accent-primary) !important;
}

.alert-success {
  background: rgba(16, 185, 129, 0.1) !important;
  color: #a7f3d0 !important;
  border-left: 4px solid var(--accent-success) !important;
}

.alert-danger {
  background: rgba(239, 68, 68, 0.1) !important;
  color: #fecaca !important;
  border-left: 4px solid var(--accent-danger) !important;
}

.alert-warning {
  background: rgba(245, 158, 11, 0.1) !important;
  color: #fde68a !important;
  border-left: 4px solid var(--accent-warning) !important;
}

/* Badges */
.badge {
  border-radius: 20px !important;
  font-weight: 500 !important;
  padding: 0.375rem 0.75rem !important;
}

.badge-primary {
  background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary)) !important;
}

.badge-success {
  background: linear-gradient(135deg, var(--accent-success), #059669) !important;
}

.badge-danger {
  background: linear-gradient(135deg, var(--accent-danger), #dc2626) !important;
}

.badge-warning {
  background: linear-gradient(135deg, var(--accent-warning), #d97706) !important;
}

/* Loading States */
.spinner-border {
  color: var(--accent-primary) !important;
}

.placeholder-loading {
  background: var(--bg-glass) !important;
  border-radius: 8px !important;
  animation: pulse 2s infinite !important;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

/* Section Headers */
.section-header {
  margin-bottom: 2rem !important;
}

.section-header h1 {
  color: var(--text-primary) !important;
  font-weight: 700 !important;
  font-size: 2rem !important;
  margin-bottom: 0.5rem !important;
}

.breadcrumb {
  background: var(--bg-glass) !important;
  border-radius: 8px !important;
  padding: 0.75rem 1rem !important;
}

.breadcrumb-item {
  color: var(--text-secondary) !important;
}

.breadcrumb-item.active {
  color: var(--accent-primary) !important;
  font-weight: 500 !important;
}

/* Dropdowns */
.dropdown-menu {
  background: var(--bg-card) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: 12px !important;
  box-shadow: var(--shadow) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
}

.dropdown-item {
  color: var(--text-secondary) !important;
  padding: 0.75rem 1rem !important;
  transition: all 0.3s ease !important;
}

.dropdown-item:hover {
  background: var(--bg-glass) !important;
  color: var(--text-primary) !important;
}

/* Modal */
.modal-content {
  background: var(--bg-card) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: 16px !important;
  box-shadow: var(--shadow) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
}

.modal-header {
  border-bottom: 1px solid var(--border-color) !important;
  padding: 1.5rem !important;
}

.modal-body {
  padding: 1.5rem !important;
}

.modal-footer {
  border-top: 1px solid var(--border-color) !important;
  padding: 1.5rem !important;
}

/* Responsive Design */
@media (max-width: 768px) {
  .main-sidebar {
    transform: translateX(-100%) !important;
    transition: transform 0.3s ease !important;
  }

  .main-sidebar.show {
    transform: translateX(0) !important;
  }

  .main-content {
    margin-left: 0 !important;
  }

  .card-statistic-2 {
    margin-bottom: 1rem !important;
  }

  .btn {
    width: 100% !important;
    margin-bottom: 0.5rem !important;
  }

  .table-responsive {
    border-radius: 12px !important;
    overflow-x: auto !important;
  }
}

/* Bangla Font Support */
.bangla-text, .hind-siliguri, .bangla-content {
    font-family: 'Hind Siliguri', Arial, sans-serif !important;
    font-feature-settings: "liga" 1, "kern" 1, "calt" 1;
    text-rendering: optimizeLegibility;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    line-height: 1.6;
}

/* Auto-detect Bangla text and apply font */
*:lang(bn), *[lang="bn"], *[lang="bengali"] {
    font-family: 'Hind Siliguri', Arial, sans-serif !important;
    line-height: 1.7;
}

/* Form inputs with Bangla support */
input.bangla-input, textarea.bangla-input, .form-control.bangla-input {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    font-size: 14px;
    line-height: 1.6;
}

/* Table cells with Bangla text */
.table td.bangla-text, .table th.bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

/* Card content with Bangla text */
.card-body .bangla-text, .card-title.bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

/* Modal content with Bangla text */
.modal-body .bangla-text, .modal-title.bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

/* Alert messages with Bangla text */
.alert .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

/* Button text with Bangla support */
.btn.bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    font-weight: 500;
}

/* Navigation items with Bangla text */
.nav-link.bangla-text, .sidebar-menu .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
}

/* Summernote editor Bangla support */
.note-editable {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.7;
}

.note-editable p, .note-editable div, .note-editable span {
    font-family: 'Hind Siliguri', Arial, sans-serif;
}

/* DataTable Bangla text support */
.dataTables_wrapper .bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif;
    line-height: 1.6;
}

/* SweetAlert Bangla text support */
.swal2-popup .bangla-text, .swal2-title.bangla-text, .swal2-content.bangla-text {
    font-family: 'Hind Siliguri', Arial, sans-serif !important;
    line-height: 1.7;
}

/* Remove old theme filters */
[data-theme="dark"] {
  filter: none !important;
}

[data-theme="dark"] img {
  filter: none !important;
}

.fa-spin-hover:not(:hover) {
   animation: none;
}

/* Hero Section for Resellers */
.hero {
  background: linear-gradient(135deg, var(--bg-tertiary), var(--bg-secondary));
  border-radius: 16px;
  padding: 2rem;
  margin-bottom: 2rem;
  box-shadow: var(--shadow);
}

.hero h2 {
  color: var(--text-primary);
  font-weight: 700;
}

.hero p {
  color: var(--text-secondary);
}

.hero .btn-outline-white {
  border-color: var(--border-hover);
  color: var(--text-primary);
  background: var(--bg-glass);
}

.hero .btn-outline-white:hover {
  background: var(--accent-primary);
  border-color: var(--accent-primary);
}

/* License Status Badge Animation */
@keyframes flash-active {
    0%, 100% {
        transform: scale(1);
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        opacity: 1;
    }
    50% {
        transform: scale(1.05);
        box-shadow: 0 0 20px rgba(16, 185, 129, 0.4);
        opacity: 0.95;
    }
}

.placeholder-loading {
    height: 30px;
    opacity: 0.7;
}

.card-body {
    transition: all 0.3s ease;
}

.stats-reseller, .stats-user, .stats-online, .stats-server {
    font-size: 1.5rem;
    font-weight: bold;
    min-height: 30px;
}

/* Top 5 Statistics Cards */
.top5-loading {
    padding: 20px;
    text-align: center;
}

.top5-content .list-group-item {
    border: none;
    border-bottom: 1px solid var(--border-color);
    padding: 12px 15px;
    transition: background-color 0.3s ease;
    background: transparent;
}

.top5-content .list-group-item:hover {
    background: var(--bg-glass);
}

.top5-content .list-group-item:last-child {
    border-bottom: none;
}

.top5-content .badge {
    font-size: 0.75em;
    padding: 4px 8px;
}

.top5-content h6 {
    font-size: 0.9em;
    font-weight: 600;
    margin-bottom: 2px;
    color: var(--text-primary);
}

.top5-content small {
    font-size: 0.75em;
    color: var(--text-muted);
}
</style>

.progress2 {
    display: -ms-flexbox;
    display: flex;
    height: 1rem;
    overflow: hidden;
    font-size: .75rem;
    background-color: #e9ecef;
    border-radius: .25rem;
}

.faz {
   width: 35px;
   height: 35px;
   background-color: var(--primary);
   border-radius: 50%;
   box-shadow: 0 4px 10px 0 #666;
   
   font-size: 15px;
   line-height: 35px;
   color: white;
   text-align: center;
   
   position: fixed;
   right: 20px;
   bottom: 20px;
   z-index: 5000;
   
  transition: all 0.1s ease-in-out;
}

.faz:hover {
   box-shadow: 0 4px 14px 0 #666;
   transform: scale(1.05);
}
 
.faz2 {
   width: 35px;
   height: 35px;
   background-color: var(--primary);
   border-radius: 50%;
   box-shadow: 0 4px 10px 0 #666;
   
   font-size: 15px;
   line-height: 35px;
   color: white;
   text-align: center;
   
   position: fixed;
   right: 20px;
   bottom: 70px;
   z-index: 5000;
   
  transition: all 0.1s ease-in-out;
}

.faz2:hover {
   box-shadow: 0 4px 14px 0 #666;
   transform: scale(1.05);
}

.app_image {
    width: 150px; 
    height: 150px; 
    border-radius: 50%; 
    border: 2px solid var(--primary);    
}

.animate-charcter
{
   text-transform: uppercase;
  background-image: linear-gradient(
    -225deg,
    #231557 0%,
    #44107a 29%,
    #ff1361 67%,
    var(--primary) 100%
  );
  background-size: auto auto;
  background-clip: border-box;
  background-size: 200% auto;
  color: #fff;
  background-clip: text;
  text-fill-color: transparent;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: textclip 2s linear infinite;
  display: inline-block;
}

@keyframes textclip {
  to {
    background-position: 200% center;
  }
}


@media(prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    transition-delay: 0s !important;
    animation-delay: -1ms !important;
    scroll-behavior: auto !important;
    animation-duration: 1ms !important;
    transition-duration: 0s !important;
    animation-iteration-count: 1 !important;
    background-attachment: initial !important;
  }
}

.swal2-popup {
    font-size: 14px !important;
    box-shadow: none !important;
    font-weight: 500 !important;
}

.swal2-popup2 {
    font-size: 14px !important;
    box-shadow: none !important;
    font-weight: 500 !important;
}

.activitys-icon {
    width: 50px;
    height: 50px;
    border-radius: 3px;
    line-height: 50px;
    font-size: 20px;
    text-align: center;
    margin-right: 20px;
    border-radius: 50%;
    flex-shrink: 0;
    text-align: center;
    z-index: 1;
}

.section .section-title {
    font-size: 15px;
    color: #191d21;
    font-weight: 600;
    position: relative;
    margin: 0 !important;
}

.bg-image {
    background: #f8f9fa;
    min-height: 100vh;
    margin: 0;
    padding: 20px 0;
    position: relative;
    overflow-x: hidden;
}

/* Content Container */
.bg-image .container {
    position: relative;
    z-index: 100;
}

/* Login Card */
.bg-image .login-brand,
.bg-image .card {
    position: relative;
    z-index: 100;
}

.table td, .table th {
    vertical-align: baseline !important;
}

.btn-circle.btn-sm{
    width:50px;height:50px;
    padding:7px 10px;
    border-radius:25px;
    font-size:10px;
    text-align:center;
    position:fixed;
    bottom:8px;right:8px
}

.username-class:hover {
  cursor: pointer;
}

.hehe{
    color:#ffff;
    background-image:-webkit-linear-gradient(30deg,#f35626,#feab3a);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
    -webkit-animation:10s linear infinite hue
}

.navbar .nav-link.nav-link-user img {
    border: 1px solid #E5E4E2;
    height: 30px;
}

.profile-widget-picture1 {
    border: 1px solid #E5E4E2;
    height: 50px;
}

.site-logo-image {
    border: 1px solid #E5E4E2;
    height: 65px;
}

.imgz-container1 {
  width: 50; /*any size*/
  height: 50; /*any size*/
  display: inline-block;
}

.imgz-container2 {
  width: 65; /*any size*/
  height: 65; /*any size*/
  display: inline-block;
}

.imgz-container {
  width: 200px; /*any size*/
  height: 200px; /*any size*/
  display: inline-block;
}

.object-fit-cover {
  border: 2px solid #E5E4E2;
  border-radius: 50%;  
  width: 100%;
  height: 100%;
  object-fit: cover; /*magic*/
}

.user-item img {
    padding-left: 0px !important; 
    padding-right: 0px !important;
}

.notice-dropdown {
    max-height: 300px;
    overflow: scroll;
}

.avatar{
    background: none !important;
}

.swal-content {
    word-wrap: break-word !important;
}

.input-file { 
    visibility: hidden; 
}

.input-file2 { 
    visibility: hidden; 
}

@-webkit-keyframes hue{
    from{
        -webkit-filter:hue-rotate(0deg)
    }
    to{
        -webkit-filter:hue-rotate(-360deg)
        
    }
    
}

/* width */
    ::-webkit-scrollbar {
       width: 5px;
    }
/* Track */
    ::-webkit-scrollbar-track {
      background: #f1f1f1;
   }

/* Handle */
   ::-webkit-scrollbar-thumb {
      background: #bec4c4;
   }

/* Handle on hover */
    ::-webkit-scrollbar-thumb:hover {
       background: #555;
   }
   
   #loading {
  position: fixed;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  opacity: 100;
  background-color: #fff;
  z-index: 99999;
}

.center {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
@-webkit-keyframes building-blocks {
  0%,
  20% {
    opacity: 0;
    -webkit-transform: translateY(-300%);
            transform: translateY(-300%); }
  30%,
  70% {
    opacity: 1;
    -webkit-transform: translateY(0);
            transform: translateY(0); }
  90%,
  100% {
    opacity: 0;
    -webkit-transform: translateY(300%);
            transform: translateY(300%); } }
@keyframes building-blocks {
  0%,
  20% {
    opacity: 0;
    -webkit-transform: translateY(-300%);
            transform: translateY(-300%); }
  30%,
  70% {
    opacity: 1;
    -webkit-transform: translateY(0);
            transform: translateY(0); }
  90%,
  100% {
    opacity: 0;
    -webkit-transform: translateY(300%);
            transform: translateY(300%); } }

.building-blocks {
  position: relative}
  .building-blocks div {
    height: 20px;
    position: absolute;
    width: 20px; }
    .building-blocks div:after {
      -webkit-animation: building-blocks 2.1s ease infinite backwards;
              animation: building-blocks 2.1s ease infinite backwards;
      background: #000000;
      content: '';
      display: block;
      height: 20px;
      width: 20px; }
    .building-blocks div:nth-child(1) {
      -webkit-transform: translate(-50%, -50%) translate(60%, 120%);
              transform: translate(-50%, -50%) translate(60%, 120%); }
    .building-blocks div:nth-child(2) {
      -webkit-transform: translate(-50%, -50%) translate(-60%, 120%);
              transform: translate(-50%, -50%) translate(-60%, 120%); }
    .building-blocks div:nth-child(3) {
      -webkit-transform: translate(-50%, -50%) translate(120%, 0);
              transform: translate(-50%, -50%) translate(120%, 0); }
    .building-blocks div:nth-child(4) {
      -webkit-transform: translate(-50%, -50%);
              transform: translate(-50%, -50%); }
    .building-blocks div:nth-child(5) {
      -webkit-transform: translate(-50%, -50%) translate(-120%, 0);
              transform: translate(-50%, -50%) translate(-120%, 0); }
    .building-blocks div:nth-child(6) {
      -webkit-transform: translate(-50%, -50%) translate(60%, -120%);
              transform: translate(-50%, -50%) translate(60%, -120%); }
    .building-blocks div:nth-child(7) {
      -webkit-transform: translate(-50%, -50%) translate(-60%, -120%);
              transform: translate(-50%, -50%) translate(-60%, -120%); }
  .building-blocks div:nth-child(1):after {
      background-color:var(--primary);
    -webkit-animation-delay: 0.15s;
            animation-delay: 0.15s; }
  .building-blocks div:nth-child(2):after {
      background-color:var(--primary);
    -webkit-animation-delay: 0.3s;
            animation-delay: 0.3s; }
  .building-blocks div:nth-child(3):after {
      background-color:var(--primary);
    -webkit-animation-delay: 0.45s;
            animation-delay: 0.45s; }
  .building-blocks div:nth-child(4):after {
      background-color:var(--primary);
    -webkit-animation-delay: 0.6s;
            animation-delay: 0.6s; }
  .building-blocks div:nth-child(5):after {
      background-color:var(--primary);
    -webkit-animation-delay: 0.75s;
            animation-delay: 0.75s; }
  .building-blocks div:nth-child(6):after {
      background-color:var(--primary);
    -webkit-animation-delay: 0.9s;
            animation-delay: 0.9s; }
  .building-blocks div:nth-child(7):after {
      background-color:var(--primary);
    -webkit-animation-delay: 1.05s;
            animation-delay: 1.05s; }
            
.profilepic {
  position: relative;
  width: 100px;
  height: 100px;
  border-radius: 50%;
  overflow: hidden;
  background-color: #111;
}

.profilepic:hover .profilepic__content {
  opacity: 1;
  cursor: pointer;
}

.profilepic:hover .profilepic__image {
  opacity: .5;
}

.profilepic__image {
  object-fit: cover;
  opacity: 1;
  transition: opacity .2s ease-in-out;
  float: none;
}

.profilepic__content {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: white;
  opacity: 0;
  transition: opacity .2s ease-in-out;
}

.profilepic__icon {
  color: white;
  padding-bottom: 8px;
}

.profilepic__icon .fas {
  font-size: 20px;
}

.profilepic__text {
  text-transform: uppercase;
  font-size: 12px;
  width: 50%;
  text-align: center;
}

/* Custom Logout Popup Styling */
.swal2-popup-custom {
    border-radius: 20px !important;
    padding: 2rem !important;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2) !important;
}

.swal2-popup-custom .swal2-image {
    margin: 1rem auto 1.5rem auto !important;
    border-radius: 15px !important;
}

.swal2-popup-custom .swal2-content {
    font-size: 1.1rem !important;
    color: #666 !important;
    margin: 1rem 0 2rem 0 !important;
    font-weight: 500 !important;
}

.swal2-confirm-custom {
    background: #6f42c1 !important;
    border: none !important;
    border-radius: 25px !important;
    padding: 12px 30px !important;
    font-weight: 600 !important;
    font-size: 1rem !important;
    margin: 0 8px !important;
    min-width: 100px !important;
    transition: all 0.3s ease !important;
}

.swal2-confirm-custom:hover {
    background: #5a359a !important;
    transform: translateY(-1px) !important;
    box-shadow: 0 4px 12px rgba(111, 66, 193, 0.4) !important;
}

.swal2-cancel-custom {
    background: #dc3545 !important;
    border: none !important;
    border-radius: 25px !important;
    padding: 12px 30px !important;
    font-weight: 600 !important;
    font-size: 1rem !important;
    margin: 0 8px !important;
    min-width: 100px !important;
    transition: all 0.3s ease !important;
}

.swal2-cancel-custom:hover {
    background: #c82333 !important;
    transform: translateY(-1px) !important;
    box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4) !important;
}

.swal2-popup-custom .swal2-actions {
    margin: 2rem 0 0 0 !important;
    justify-content: center !important;
    gap: 15px !important;
}

/* Remove default SweetAlert2 styling conflicts */
.swal2-popup-custom .swal2-styled {
    border: none !important;
    outline: none !important;
}

.swal2-popup-custom .swal2-styled:focus {
    box-shadow: none !important;
}

</style>
