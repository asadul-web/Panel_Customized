<div class="navbar-bg"></div>
<nav class="navbar navbar-expand-lg main-navbar">

<form class="form-inline mr-auto">
<ul class="navbar-nav mr-auto  mr-3">
<li><a href="#" data-toggle="sidebar" class="nav-link nav-link-lg"><i class="fas fa-bars"></i></a></li>
<li><a href="#" data-toggle="search" class="nav-link nav-link-lg d-sm-none"><i class="fas fa-search"></i></a></li>
</ul>
<div class="search-element">
            <input class="form-control data-search" type="search" placeholder="Search" aria-label="Search" data-width="250">
            <button class="btn" type="button"><i class="fas fa-search" id="icon-fa"></i></button>
            <div class="search-backdrop"></div>
            <div class="search-result d-none">
              <div class="search-header">
                Result
              </div>
              <div class="search--item">
                
              </div>
            </div>
          </div>
        </form>


<ul class="navbar-nav navbar-right">

<li class="dropdown dropdown-list-toggle"><a href="#" data-toggle="dropdown" class="nav-link notification-toggle nav-link-lg"><i class="far fa-bell"></i></a>
<div class="dropdown-menu dropdown-list dropdown-menu-right">
<div class="dropdown-header">Notifications</div>
<div class=" dropdown-list-icons notice-dropdown notificationlist">
<div class="profile-notifications"></div>
</div>
</div>
</li>

<li class="dropdown"><a href="#" data-toggle="dropdown" class="nav-link dropdown-toggle nav-link-lg nav-link-user">
{$avatar}
<div class="d-sm-none d-lg-inline-block">Hi, {$user_name_2}</div></a>
<div class="dropdown-menu dropdown-menu-right">
<a href="profile-settings" class="dropdown-item has-icon">
<i class="fas fa-user-cog"></i> Profile
</a>
<div class="dropdown-divider"></div>
<a href="{$base_url}logout" class="dropdown-item has-icon text-danger btn-logout">
<i class="fas fa-sign-out-alt"></i> Logout
</a>
</div>
</li>

</ul>
</nav>
