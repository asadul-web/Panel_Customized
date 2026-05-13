<div class="main-sidebar sidebar-style-2">
<aside id="sidebar-wrapper">

<div class="sidebar-brand mt-2">
<a href="/">
{$s_logo}
<span 
   class="animate-charcter" 
   data-text="{$site_name}"
>{$site_name}</span>
</a>
</div>

<div class="sidebar-brand sidebar-brand-sm">
    <a href="/">{$t_logo}</a>
</div>

<ul class="sidebar-menu">
{if $user_id_2=='1' || $user_level_2=='superadmin' || $user_level_2 == 'reseller'}
<li class="menu-header">Main</li>
<li class="{$dashboard_active}"><a class="nav-link" href="dashboard"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
<li class="dropdown {$create_active}">
<a href="" class="nav-link has-dropdown"><i class="fas fa-user-plus"></i><span>Create</span></a>
<ul class="dropdown-menu">
<li class="{$create_user_active}"><a class="nav-link" href="add-user">User</a></li>
<li class="{$create_reseller_active}"><a class="nav-link" href="add-reseller">Reseller</a></li>
</ul>
</li>
<li class="dropdown {$manage_active}">
<a href="" class="nav-link has-dropdown"><i class="fas fa-users-cog"></i><span>Manage</span></a>
<ul class="dropdown-menu">
<li class="{$manage_user_active}"><a class="nav-link" href="view-user">User List</a></li>
<li class="{$manage_reseller_active}"><a class="nav-link" href="view-reseller">Reseller List</a></li>
</ul>
</li>
<li class="dropdown {$logs_active}">
<a href="" class="nav-link has-dropdown"><i class="fas fa-clipboard-list"></i><span>Logs</span></a>
<ul class="dropdown-menu">
<li class="{$logs_activity_active}"><a class="nav-link" href="log-activity">Activity Log</a></li>
<li class="{$logs_bulk_active}"><a class="nav-link" href="log-bulk">Bulk Log</a></li>
<li class="{$logs_credit_active}"><a class="nav-link" href="log-credit">Credits Log</a></li>
<li class="{$logs_deleted_active}"><a class="nav-link" href="log-deleted">Deleted Log</a></li>
</ul>
</li>
<li><a class="nav-link" href="privacy-policy"><i class="fas fa-shield-alt"></i> <span>Privacy Policy</span></a></li>
{/if}
{if $user_id_2=='1' || $user_level_2=='superadmin' || $user_level_2=='administrator'}
<li class="menu-header">Panel</li>
<li class="{$server_active}"><a class="nav-link" href="server"><i class="fas fa-server"></i> <span>Servers</span></a></li>
<li class="{$dns_active}"><a class="nav-link" href="dns"><i class="fas fa-cloud"></i> <span>Dns</span></a></li>
<li class="{$application_active}"><a class="nav-link" href="application"><i class="fab fa-android"></i> <span>Application</span></a></li>
<li class="{$notification_active}"><a class="nav-link" href="notification"><i class="fas fa-bell"></i> <span>Notification</span></a></li>
<li class="{$json_active}"><a class="nav-link" href="json"><i class="fas fa-code"></i> <span>Json</span></a></li>
<li class="dropdown {$ads_active}">
<a href="" class="nav-link has-dropdown"><i class="fas fa-ad"></i><span>Ads Manager</span></a>
<ul class="dropdown-menu">
<li class="{$ads_manage_active}"><a class="nav-link" href="ads-manage">Ads</a></li>
<li class="{$ads_view_active}"><a class="nav-link" href="ads-view">Ads View</a></li>
<li class="{$ads_revenue_active}"><a class="nav-link" href="ads-revenue">Revenue</a></li>
</ul>
</li>
<li class="dropdown {$reseller_management_active}">
<a href="" class="nav-link has-dropdown"><i class="fas fa-handshake"></i><span>Reseller Manage</span></a>
<ul class="dropdown-menu">
<li class="{$reseller_applications_active}"><a class="nav-link" href="reseller-applications">Applications</a></li>
<li class="{$user_requests_active}"><a class="nav-link" href="user-requests">User Requests</a></li>
<li class="{$reseller_settings_active}"><a class="nav-link" href="reseller-settings">Settings</a></li>
</ul>
</li>
<li class="dropdown {$bulk_email_active}">
<a href="" class="nav-link has-dropdown"><i class="fas fa-envelope"></i><span>Bulk Email</span></a>
<ul class="dropdown-menu">
<li class="{$email_subscribers_active}"><a class="nav-link" href="email-subscribers">Subscribers</a></li>
<li class="{$email_campaigns_active}"><a class="nav-link" href="email-campaigns">Campaigns</a></li>
<li class="{$email_templates_active}"><a class="nav-link" href="email-templates">Templates</a></li>
<li class="{$bulk_email_settings_active}"><a class="nav-link" href="bulk-email-settings">Settings</a></li>
</ul>
</li>
<li class="dropdown">
<a href="" class="nav-link has-dropdown"><i class="fas fa-info-circle"></i><span>Info Manage</span></a>
<ul class="dropdown-menu">
<li><a class="nav-link" href="info-edit">Info Edit</a></li>
</ul>
</li>
<li class="{$setting_active}"><a class="nav-link" href="settings"><i class="fas fa-cog"></i> <span>Settings</span></a></li>

<div class="mt-4 mb-4 p-3 hide-sidebar-mini">
<a href="javascript:void(0)" class="btn btn-primary btn-block btn-icon-split btn-genuine" style="white-space: initial;">
<i class="fas fa-rocket"></i> Vollam™
</a>
</div>
          
{/if}
{if $user_id_2=='2' || $user_level_2=='developer'}
<li class="menu-header">Main</li>
<li class="{$dashboard_active}"><a class="nav-link" href="dashboard"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
<li class="menu-header">Panel Management</li>
<li class="{if isset($notice_api_active)}{$notice_api_active}{/if}"><a class="nav-link" href="notice-api"><i class="fas fa-bullhorn"></i> <span>Notice Manager</span></a></li>
<li class="{if isset($popup_notice_active)}{$popup_notice_active}{/if}"><a class="nav-link" href="popup-notice"><i class="fas fa-window-restore"></i> <span>Popup Notice</span></a></li>
<li class="menu-header">API Management</li>
<li class="dropdown {$api_manage_active}">
<a href="" class="nav-link has-dropdown"><i class="fas fa-plug"></i><span>API Manager</span></a>
<ul class="dropdown-menu">
<li class="{if isset($license_api_active)}{$license_api_active}{/if}"><a class="nav-link" href="license-api"><i class="fas fa-key"></i> License API</a></li>
<li class="{if isset($auth_api_active)}{$auth_api_active}{/if}"><a class="nav-link" href="auth-api"><i class="fas fa-shield-alt"></i> Auth API</a></li>
<li class="{if isset($api_settings_active)}{$api_settings_active}{/if}"><a class="nav-link" href="api-settings"><i class="fas fa-lock"></i> API Encryption</a></li>
<li class="{if isset($api_docs_active)}{$api_docs_active}{/if}"><a class="nav-link" href="api-docs"><i class="fas fa-book"></i> API Doc</a></li>
<li class="{if isset($api_logs_active)}{$api_logs_active}{/if}"><a class="nav-link" href="api-logs"><i class="fas fa-file-alt"></i> API Logs</a></li>
</ul>
</li>
<li class="menu-header">Developer</li>
<li class="{if isset($cloudflare_domains_active)}{$cloudflare_domains_active}{/if}"><a class="nav-link" href="cloudflare-domains"><i class="fab fa-cloudflare"></i> <span>Cloudflare Domains</span></a></li>
<li class="{$devsetting_active}"><a class="nav-link" href="developer-settings"><i class="fas fa-cog"></i> <span>Settings</span></a></li>
{/if}
</ul>
</aside>
</div>

<a class="faz" href="#" onclick="return false;" type="button" data-theme-toggle><i id="xtoggle"></i></a>