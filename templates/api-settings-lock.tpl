<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — API Settings Access</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<style>
.lock-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.lock-card {
    max-width: 450px;
    width: 100%;
    margin: 20px;
}
.lock-icon {
    font-size: 4rem;
    color: #667eea;
    margin-bottom: 20px;
}
.password-input {
    font-size: 1.1rem;
    padding: 12px 20px;
    border-radius: 8px;
}
.unlock-btn {
    padding: 12px 40px;
    font-size: 1.1rem;
    border-radius: 8px;
}
</style>
</head>
<body>
<div class="lock-container">
    <div class="lock-card">
        <div class="card shadow-lg">
            <div class="card-body text-center p-5">
                <div class="lock-icon">
                    <i class="fas fa-lock"></i>
                </div>
                <h3 class="mb-3">API Settings Access</h3>
                <p class="text-muted mb-4">This page is password protected. Please enter the password to continue.</p>
                
                {if $password_error}
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> {$password_error}
                </div>
                {/if}
                
                <form method="POST" action="">
                    <div class="form-group">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fas fa-key"></i>
                                </span>
                            </div>
                            <input type="password" 
                                   name="access_password" 
                                   class="form-control password-input" 
                                   placeholder="Enter password"
                                   required
                                   autofocus>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg unlock-btn">
                        <i class="fas fa-unlock"></i> Unlock
                    </button>
                </form>
                
                <div class="mt-4">
                    <a href="/dashboard" class="text-muted">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="/dist/modules/jquery.min.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
