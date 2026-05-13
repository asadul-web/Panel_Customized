<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
<title>{$site_name} — {$site_description}</title>
<link rel="shortcut icon" href="{$site_logo}" type="image/x-icon">
<link rel="icon" href="{$site_logo}" type="image/x-icon">

<link rel="stylesheet" href="/dist/modules/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<link rel="stylesheet" href="/dist/modules/bootstrap-social/bootstrap-social.css">
<link rel="stylesheet" href="/dist/modules/datatables/datatables.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/datatables/Select-1.2.4/css/select.bootstrap4.min.css">
<link rel="stylesheet" href="/dist/modules/select2.min.css">
<link rel="stylesheet" href="/dist/modules/summernote/summernote-bs4.css">
<link rel="stylesheet" href="/dist/sweetalert2/sweetalert2.min.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/style.css">
<link rel="stylesheet" href="/dist/css-{$site_theme}/components.css">
{include file='css/custom_css.tpl'}
</head>
<body>
<div class="main-wrapper">
{include file='apps/topnav.tpl'}
{include file='apps/sidenav.tpl'}

<div class="main-content">
<section class="section">
<div class="section-header">
<h1>Change Password</h1>
</div>
<div class="section-error">
<div class="errors"></div>
</div>
<div class="section-body">
<div class="container">
<div class="row">
<div class="col align-self-center">
<div class="card">
<div class="card-body">
<form action="" class="changepassword" autocomplete="off">
<input type="hidden" name="submitted" name="submitted" value="account_settings">
<input type="hidden" name="_key" id="_key" value="{$firenet_encrypt}">
<div class="form-group">
<label for="oldpassword">Old password</label>
<input id="oldpassword" type="text" value="" class="form-control" name="oldpassword" tabindex="1">
</div>
<div class="form-group">
<label for="newpassword">New password</label>
<input id="newpassword" type="text" value="" class="form-control" name="newpassword" tabindex="1">
</div>
<div class="form-group">
<label for="confirmpassword">Confirm password</label>
<input id="confirmpassword" type="text" value="" class="form-control" name="confirmpassword" tabindex="1">
</div>
<div class="form-group">
<button type="submit" class="btn btn-primary btn-lg btn-block btn-changepassword" tabindex="4">
Update
</button>
</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>
</section>
</div>
</div>
</div>

<div class="modal fade normal-modalize" role="dialog" aria-labelledby="smallmodal">
<div class="modal-dialog modal-md normal-modal-dialog" role="document">
<div class="modal-content normal-modal-content">
<div class="modal-header normal-modal-header">
<h5 class="modal-title normal-modal-title"></h5>
<button type="button" class="close" data-dismiss="modal">&times;</button>
</div>
<div class="modal-body normal-modal-body">
<div class="modal-error normal-modal-error"></div>
<div class="modal-html normal-modal-html"></div>
</div>
</div>
</div>
</div>

<div class="modal fade search-modalize" role="dialog" aria-labelledby="smallmodal">
<div class="modal-dialog modal-md search-modal-dialog" role="document">
<div class="modal-content search-modal-content">
<div class="modal-header search-modal-header">
<h5 class="modal-title search-modal-title"></h5>
<button type="button" class="close" data-dismiss="modal">&times;</button>
</div>
<div class="modal-body search-modal-body">
<div class="modal-error search-modal-error"></div>
<div class="modal-html search-modal-html"></div>
</div>
</div>
</div>
</div>

<script src="/dist/modules/jquery.min.js"></script>
<script src="/dist/modules/popper.js"></script>
<script src="/dist/modules/tooltip.js"></script>
<script src="/dist/modules/bootstrap/js/bootstrap.min.js"></script>
<script src="/dist/modules/nicescroll/jquery.nicescroll.min.js"></script>
<script src="/dist/modules/moment.min.js"></script>
<script src="/dist/sweetalert2/sweetalert2.min.js"></script>
<script src="/dist/modules/time.js"></script>
<script src="/dist/js/stisla.js"></script>

<script src="/dist/modules/chart.min.js"></script>
<script src="/dist/modules/datatables/datatables.min.js"></script>
<script src="/dist/modules/datatables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js"></script>
<script src="/dist/modules/datatables/Select-1.2.4/js/dataTables.select.min.js"></script>
<script src="/dist/modules/jquery-ui/jquery-ui.min.js"></script>
<script src="/dist/bootstrap/assets/jqueryform/jquery.form.js"></script>
<script src="/dist/modules/summernote/summernote-bs4.min.js"></script>
<script src="/dist/modules/select2.full.min.js"></script>

<script src="/dist/js/clipboard.min.js"></script>
<script src="/dist/js/scripts.js"></script>
<script src="/dist/js/custom-select.js"></script>
{include file='js/page/custom_js.tpl'}
{include file='js/page/notification_js.tpl'}
<script>
    function modalize(title, body){
	    $(".modalize").modal({
            backdrop: 'static',
            keyboard: false  // to prevent closing with Esc button (if you want this too)
        })
        $(".modalize").modal('show');
		$(".modal-title").text(title);
		$(".modal-error").html('');
		$(".modal-html").html(body);
	}
	
    function modalMessage(type,title,message){
    	$(".modal-body > .modal-error").html('').append('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
    }

    function errorMessage(type,title,message){
    	$(".errors").html('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><button class="close" data-dismiss="alert"><span>&times;</span></button><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
    }
	
    $('document').ready(function()
    {
    
    	var $form = $('.changepassword');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/account.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$(".btn-changepassword").addClass("btn-progress")
    		},
    		success: function(data){
    			if(data.response == 1){
        			errorMessage('success', 'Success', data.msg);
        			$(".changepassword").trigger("reset");
        		}
        		if(data.response == 2){
        			errorMessage('danger','Error', data.msg);
        		}
        		if(data.response == 3){
        			errorMessage('danger','Error', data.errormsg);
        		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    		    gen_user()
    			swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                    button: false,
                    closeOnClickOutside: false,
                    timer: 3000
                }).then(() => {
                    location.reload()
                });
    		},
    		complete: function(){
    			$(".btn-changepassword").removeClass("btn-progress")
    		}
    	});
    	
    });
</script>
{include file='js/page/search_js.tpl'}

<!-- Security Protection Script -->
<script src="{$security_protection_js}"></script>
</body>
</html>