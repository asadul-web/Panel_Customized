<style>
/* Import Hind Siliguri font for Bangla text support */
@import url('https://fonts.googleapis.com/css2?family=Hind+Siliguri:wght@300;400;500;600;700&display=swap');

/* Global Bangla Font Support */
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

[data-theme="light"]  {
  filter: invert(0%) hue-rotate(0deg);
}

[data-theme="dark"] {
  filter: invert(100%) hue-rotate(180deg);
}

[data-theme="dark"] img{
  filter: invert(100%) hue-rotate(180deg);
}

.fa-spin-hover:not(:hover) {
   animation: none;
}

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