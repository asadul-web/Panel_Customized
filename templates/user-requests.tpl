<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — User Requests</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/dist/modules/bootstrap-social/bootstrap-social.css">
<link rel="stylesheet" href="/dist/modules/datatables/datatables.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/Select-1.2.4/css/select.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
</head>
<body>
    
<div class="center" id="loading">
    <div class='building-blocks'>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
    </div>
</div>

<div class="main-wrapper">
{include file='apps/topnav.tpl'}
{include file='apps/sidenav.tpl'}

<div class="main-content">
<section class="section">
<div class="section-header">
<h1><i class="fas fa-user-check"></i> User Requests</h1>
<div class="section-header-breadcrumb">
<div class="breadcrumb-item">Main</div>
<div class="breadcrumb-item">Reseller Manage</div>
<div class="breadcrumb-item active">User Requests</div>
</div>
</div>
<div class="section-body">

<!-- Statistics Cards -->
<div class="row">
<div class="col-lg-4 col-md-6">
<div class="card card-statistic-2 card-warning">
<div class="card-icon shadow-warning bg-warning">
<i class="fas fa-clock"></i>
</div>
<div class="card-wrap">
<div class="card-header">
<h4>Pending Approval</h4>
</div>
<div class="card-body">
{$total_pending}
</div>
</div>
</div>
</div>

<div class="col-lg-4 col-md-6">
<div class="card card-statistic-2 card-info">
<div class="card-icon shadow-info bg-info">
<i class="fas fa-money-bill-wave"></i>
</div>
<div class="card-wrap">
<div class="card-header">
<h4>Payment Pending</h4>
</div>
<div class="card-body">
{$total_payment_pending}
</div>
</div>
</div>
</div>

<div class="col-lg-4 col-md-6">
<div class="card card-statistic-2 card-success">
<div class="card-icon shadow-success bg-success">
<i class="fas fa-check-circle"></i>
</div>
<div class="card-wrap">
<div class="card-header">
<h4>Approved (Recent)</h4>
</div>
<div class="card-body">
{$total_approved}
</div>
</div>
</div>
</div>
</div>

<!-- Tabs -->
<div class="row">
<div class="col-12">
<div class="card">
<div class="card-header">
<h4>User Registration Requests</h4>
</div>
<div class="card-body">
<ul class="nav nav-tabs" id="myTab" role="tablist">
<li class="nav-item">
<a class="nav-link active" id="pending-tab" data-toggle="tab" href="#pending" role="tab">
<i class="fas fa-clock"></i> Pending Approval ({$total_pending})
</a>
</li>
<li class="nav-item">
<a class="nav-link" id="payment-tab" data-toggle="tab" href="#payment" role="tab">
<i class="fas fa-money-bill-wave"></i> Payment Pending ({$total_payment_pending})
</a>
</li>
<li class="nav-item">
<a class="nav-link" id="approved-tab" data-toggle="tab" href="#approved" role="tab">
<i class="fas fa-check-circle"></i> Approved ({$total_approved})
</a>
</li>
</ul>

<div class="tab-content" id="myTabContent">
<!-- Pending Approval Tab -->
<div class="tab-pane fade show active" id="pending" role="tabpanel">
<div class="table-responsive mt-3">
<table class="table table-striped table-hover" id="pendingTable">
<thead>
<tr>
<th>Username</th>
<th>Full Name</th>
<th>Email</th>
<th>Mobile</th>
<th>Duration</th>
<th>Applied Date</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
{foreach from=$pending_requests item=request}
<tr>
<td><strong>{$request.user_name}</strong></td>
<td>{$request.full_name}</td>
<td>{$request.user_email}</td>
<td>{$request.mobile}</td>
<td>{$request.duration_months} month(s)</td>
<td>{$request.regdate}</td>
<td>
<button class="btn btn-success btn-sm" onclick="approveUser('{$request.user_name}', '{$request.user_id}')">
<i class="fas fa-check"></i> Approve
</button>
<button class="btn btn-danger btn-sm" onclick="rejectUser('{$request.user_name}', '{$request.user_id}')">
<i class="fas fa-times"></i> Reject
</button>
</td>
</tr>
{foreachelse}
<tr>
<td colspan="7" class="text-center">No pending requests</td>
</tr>
{/foreach}
</tbody>
</table>
</div>
</div>

<!-- Payment Pending Tab -->
<div class="tab-pane fade" id="payment" role="tabpanel">
<div class="table-responsive mt-3">
<table class="table table-striped table-hover" id="paymentTable">
<thead>
<tr>
<th>Username</th>
<th>Full Name</th>
<th>Email</th>
<th>Mobile</th>
<th>Duration</th>
<th>Request Date</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
{foreach from=$payment_pending item=request}
<tr>
<td><strong>{$request.user_name}</strong></td>
<td>{$request.full_name}</td>
<td>{$request.user_email}</td>
<td>{$request.mobile}</td>
<td>{$request.duration_months} month(s)</td>
<td>{$request.regdate}</td>
<td>
<button class="btn btn-success btn-sm" onclick="verifyPayment('{$request.user_name}', '{$request.user_id}')">
<i class="fas fa-check-double"></i> Verify Payment
</button>
<button class="btn btn-danger btn-sm" onclick="rejectUser('{$request.user_name}', '{$request.user_id}')">
<i class="fas fa-times"></i> Reject
</button>
</td>
</tr>
{foreachelse}
<tr>
<td colspan="7" class="text-center">No payment pending requests</td>
</tr>
{/foreach}
</tbody>
</table>
</div>
</div>

<!-- Approved Tab -->
<div class="tab-pane fade" id="approved" role="tabpanel">
<div class="table-responsive mt-3">
<table class="table table-striped table-hover" id="approvedTable">
<thead>
<tr>
<th>Username</th>
<th>Full Name</th>
<th>Email</th>
<th>Mobile</th>
<th>Duration</th>
<th>Status</th>
<th>Approved Date</th>
</tr>
</thead>
<tbody>
{foreach from=$approved_requests item=request}
<tr>
<td><strong>{$request.user_name}</strong></td>
<td>{$request.full_name}</td>
<td>{$request.user_email}</td>
<td>{$request.mobile}</td>
<td>{$request.duration_months} month(s)</td>
<td>
{if $request.is_active == 1}
<span class="badge badge-success">Active</span>
{else}
<span class="badge badge-secondary">Inactive</span>
{/if}
</td>
<td>{$request.regdate}</td>
</tr>
{foreachelse}
<tr>
<td colspan="7" class="text-center">No approved requests</td>
</tr>
{/foreach}
</tbody>
</table>
</div>
</div>

</div>
</div>
</div>
</div>
</div>

</div>
</section>
</div>
</div>

<script src="/dist/modules/jquery.min.js"></script>
<script src="/dist/modules/popper.js"></script>
<script src="/dist/modules/tooltip.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="/dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script src="/dist/modules/moment.min.js"></script>
<script src="/dist/js/stisla.js"></script>
<script src="/dist/modules/datatables/datatables.min.js"></script>
<script src="/dist/modules/datatables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script src="/dist/sweetalert2/sweetalert2.all.min.js"></script>
<script src="/dist/js/scripts.js"></script>
{include file='js/page/custom_js.tpl'}

<script>
$(document).ready(function() {
    $('#pendingTable').DataTable({
        "order": [[5, "desc"]]
    });
    $('#paymentTable').DataTable({
        "order": [[5, "desc"]]
    });
    $('#approvedTable').DataTable({
        "order": [[6, "desc"]]
    });
});

function approveUser(username, userId) {
    Swal.fire({
        title: 'Approve User?',
        text: 'Approve registration for: ' + username,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, Approve!'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/api/app_user_api.php',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    action: 'approve_user',
                    api_key: '{$api_key}',
                    username: username
                }),
                success: function(response) {
                    if (response.response == 1) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Approved!',
                            text: 'User has been approved successfully.',
                            timer: 2000
                        }).then(() => {
                            location.reload();
                        });
                    } else {
                        Swal.fire('Error!', response.message, 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error!', 'Failed to approve user', 'error');
                }
            });
        }
    });
}

function verifyPayment(username, userId) {
    Swal.fire({
        title: 'Verify Payment?',
        text: 'Verify payment and activate user: ' + username,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, Verify!'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/api/app_user_api.php',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    action: 'verify_payment',
                    api_key: '{$api_key}',
                    username: username
                }),
                success: function(response) {
                    if (response.response == 1) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Payment Verified!',
                            text: 'User has been activated successfully.',
                            timer: 2000
                        }).then(() => {
                            location.reload();
                        });
                    } else {
                        Swal.fire('Error!', response.message, 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error!', 'Failed to verify payment', 'error');
                }
            });
        }
    });
}

function rejectUser(username, userId) {
    Swal.fire({
        title: 'Reject User?',
        text: 'This will delete the user: ' + username,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes, Reject!'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/serverside/forms/user/delete_user.php',
                type: 'POST',
                data: {
                    user_id: userId
                },
                success: function(response) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Rejected!',
                        text: 'User request has been rejected.',
                        timer: 2000
                    }).then(() => {
                        location.reload();
                    });
                },
                error: function() {
                    Swal.fire('Error!', 'Failed to reject user', 'error');
                }
            });
        }
    });
}
</script>


<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>
