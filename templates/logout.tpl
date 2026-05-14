<!DOCTYPE html>
<html class="no-js" lang="en" data-theme="dark">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
<title>{$sitename} - Logout</title>
<link rel="shortcut icon" href="{$base_url}assets/favicon.ico" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">

<style>
body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.logout-container {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    padding: 40px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    text-align: center;
    max-width: 400px;
    width: 100%;
    margin: 20px;
}

.logout-icon {
    font-size: 4rem;
    color: #667eea;
    margin-bottom: 20px;
}

.logout-title {
    font-size: 2rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 15px;
}

.logout-message {
    color: #666;
    margin-bottom: 30px;
    font-size: 1.1rem;
}

.btn-login {
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
    color: white;
    padding: 12px 30px;
    border-radius: 25px;
    font-weight: 500;
    text-decoration: none;
    display: inline-block;
    transition: all 0.3s ease;
}

.btn-login:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    color: white;
    text-decoration: none;
}

.spinner {
    border: 3px solid #f3f3f3;
    border-top: 3px solid #667eea;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    animation: spin 1s linear infinite;
    margin: 20px auto;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>
</head>
<body>
    <div class="logout-container">
        <div class="logout-icon">
            <i class="fas fa-sign-out-alt"></i>
        </div>
        <h2 class="logout-title">Logging Out...</h2>
        <p class="logout-message">Please wait while we securely log you out of your account.</p>
        <div class="spinner"></div>
        <p style="margin-top: 20px;">
            <a href="{$base_url}login" class="btn-login">
                <i class="fas fa-sign-in-alt me-2"></i>
                Back to Login
            </a>
        </p>
    </div>

    <script src="/dist/modules/jquery/jquery.min.js"></script>
    <script src="/dist/modules/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/dist/sweetalert2/sweetalert2.min.js"></script>
    
    <script>
        // Auto redirect to login after 3 seconds
        setTimeout(function() {
            window.location.href = '{$base_url}login';
        }, 3000);
        
        // Show success message
        setTimeout(function() {
            Swal.fire({
                title: 'Logged Out Successfully!',
                text: 'You have been securely logged out of your account.',
                icon: 'success',
                timer: 2000,
                showConfirmButton: false
            });
        }, 1000);
    </script>
</body>
</html>
