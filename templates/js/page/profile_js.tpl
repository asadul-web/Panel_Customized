<script>
    function normal_modalize(title, body)
	{
	    $(".normal-modalize").modal({
            backdrop: 'static',
            keyboard: false  // to prevent closing with Esc button (if you want this too)
        })
        $(".normal-modalize").modal('show');
		$(".normal-modal-title").text(title);
		$(".normal-modal-error").html('');
		$(".normal-modal-html").html(body);
	}
	
    function modalMessage(type,title,message)
	{
		$(".normal-modal-body > .normal-modal-error").html('').append('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
	}

    function normalMessage(type,title,message){
    	$(".errors").html('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><button class="close" data-dismiss="alert"><span>&times;</span></button><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
    }
	
	function reloadPage()
    {
    	setTimeout(function(){
    		location.reload();
    	}, 3000)
    }
    
    function reloadProfile()
    {
    	setTimeout(function(){
    		getProfile();
    	}, 3000)
    }
    
    function emailverify()
    {
        var userid = {$user_id_2};
		$.ajax({
            url: "{$base_url}serverside/data/send_auth.php",
            data: "uid="+userid,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			var template_html = `<form class="verifyemail" method="post" autocomplete="off">`
        							+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
        							+ `<input type="hidden" name="id" value="`+userid+`">`
        							+ `<input type="hidden" name="submitted" value="verify_email">`
        							
        							+ `<div class="form-group">`
                                    + `<label>We've sent a Verification Code to your registered email address.</label>`
                                    + `<label>Kindly check your inbox or spam folder and provide the Verification Code to continue.</label>`
                                    + `<label>Verification Code will expire in 10 minutes.</label>`
                                    + `</div>`
                                    
        							+ `<div class="form-group"><label for="verification">Verification Code</label><input id="verification" name="verification" class="form-control" type="text" placeholder="Enter verification code"></div>`
        							
        							+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-verifyemail" id="btn-verifyemail" tabindex="4">Confirm</button></div>`
        							
        							+ `<div class="form-group">`
                                    + `<label>`+data.request+`</label>`
                                    + `</div>`
                                    
        							+ `</form>`;
        		normal_modalize('Email Verification', template_html);
        		
        		var $form = $('.verifyemail');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/verify_email.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-verifyemail").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
            					modalMessage('success', 'Success', data.msg);
            					reloadPage()
            				}
            				if(data.response == 2){
            					modalMessage('danger','Error', data.msg);
            				}
            				if(data.response == 3){
            					modalMessage('danger','Error', data.errormsg);
            				}
                		},
                		error: function(jqXHR, textStatus, errorThrown) {
                			swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                                button: false,
                                closeOnClickOutside: false,
                                timer: 3000
                            }).then(() => {
                                location.reload()
                            });
                		},
                		complete: function(){
            				$(".verifyemail").remove();
            				$(".verifyemail").trigger("reset");
            				$("#btn-verifyemail").removeClass("btn-progress");
                		}
                	});
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                    button: false,
                    closeOnClickOutside: false,
                    timer: 3000
                }).then(() => {
                    location.reload()
                });
            },
            complete: function(){
    
    		}
        });
    }
    
    //Change Password
    function changepassword()
	{
		var userid = {$user_id_2};

		var template_html = `<form class="changepassword" method="post" autocomplete="off">`
						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
						+ `<input type="hidden" name="id" value="`+userid+`">`
						+ `<input type="hidden" name="submitted" value="change_password">`
						+ `<div class="form-group"><label for="currentpassword">Current Password</label><input id="currentpassword" class="form-control" name="currentpassword" type="text"></div>`
						+ `<div class="form-group"><label for="newpassword">New Password</label><input id="newpassword" class="form-control" name="newpassword" type="text"></div>`
						+ `<div class="form-group"><label for="confirmpassword">Confirm Password</label><input id="confirmpassword" class="form-control" name="confirmpassword" type="text"></div>`
						+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-changepass" id="btn-changepass" tabindex="4">Submit</button></div>`
						+ `</form>`;
		normal_modalize('Change Password', template_html);
		
		var $form = $('.changepassword');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/change_password.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-changepass").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
    					modalMessage('success', 'Success', data.msg);
    					reloadPage()
    				}
    				if(data.response == 2){
    					modalMessage('danger','Error', data.msg);
    				}
    				if(data.response == 3){
    					modalMessage('danger','Error', data.errormsg);
    				}
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
        		},
        		complete: function(){
        		    $(".changepassword").remove();
    				$(".changepassword").trigger("reset");
    				$("#btn-changepass").removeClass("btn-progress");
        		}
        	});
	}
	
	//Update Avatar
    function avatarchange()
	{
		var userid = {$user_id_2};

		var template_html = `<form class="updateavatar" method="post" autocomplete="off">`
						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
						+ `<input type="hidden" name="id" value="`+userid+`">`
						+ `<input type="hidden" name="submitted" value="avatar_change">`
						+ `<div class="user-item">
						  <span class="imgz-container">
                          {$avatar7}
                          </span>
                          <div class="user-details mb-3">
                            <div class="user-name">{$user_name_2}</div>
                            <div class="text-job text-muted">{$rank}</div>
                          </div>
                        </div>`
						+ `<div class="form-group">
                                    <input type="file" id="images" name="images[]" class="input-file">
                                    <div class="input-group">
                                        <input type="text" class="form-control" disabled placeholder="Upload Avatar" tabindex="1">
                                        <div class="input-group-append">
                                            <button class="btn btn-primary upload-field" type="button"><i class="fa fa-search"></i> Browse</button>
                                        </div>
                                    </div>
                                    <label for="images" class="text-danger">Note: (Allowed Extension: gif, jpeg, jpg, png), 2MB</label>
                                </div>`
						+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-avatar" id="btn-avatar" tabindex="4">Submit</button></div>`
						+ `</form>`;
		normal_modalize('Update Avatar', template_html);
		
		var $form = $('.updateavatar');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/update_avatar.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-avatar").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
    					modalMessage('success', 'Success', data.msg);
    					reloadPage()
    				}
    				if(data.response == 2){
    					modalMessage('danger','Error', data.msg);
    				}
    				if(data.response == 3){
    					modalMessage('danger','Error', data.errormsg);
    				}
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			swal(`Failed`, `Failed getting data from AJAXx.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
        		},
        		complete: function(){
        		    $(".updateavatar").remove();
    				$(".updateavatar").trigger("reset")
    				$("#btn-avatar").removeClass("btn-progress");
        		}
        	});
	}
	
	//Update Email
    function emailchange()
	{
		var userid = {$user_id_2};

		var template_html = `<form class="updateemail" method="post" autocomplete="off">`
						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
						+ `<input type="hidden" name="id" value="`+userid+`">`
						+ `<input type="hidden" name="submitted" value="email_change">`
						+ `<div class="form-group"><label for="emailaddress">Email Address</label>
						    <div class="input-group mb-3">
                            <input type="email" class="form-control" id="emailaddress" name="emailaddress" placeholder="Enter email address" aria-label="">
                            <div class="input-group-append">
                            <button class="btn btn-primary" type="button">Send Verification</button>
                            </div>
                            </div>
                        </div>`
						+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-email" id="btn-email" tabindex="4">Submit</button></div>`
						+ `</form>`;
		normal_modalize('Update Email', template_html);
		
		var $form = $('.updateemail');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/update_email.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-email").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
    					modalMessage('success', 'Success', data.msg);
    					reloadPage()
    				}
    				if(data.response == 2){
    					modalMessage('danger','Error', data.msg);
    				}
    				if(data.response == 3){
    					modalMessage('danger','Error', data.errormsg);
    				}
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			swal(`Failed`, `Failed getting data from AJAXx.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
        		},
        		complete: function(){
        		    $(".updateemail").remove();
    				$(".updateemail").trigger("reset")
    				$("#btn-email").removeClass("btn-progress");
        		}
        	});
	}
	
    $('document').ready(function()
    {
        
        function getProfile(){
        	$.ajax({
                url: "{$base_url}serverside/data/get_profileinfo.php",
                type: "GET",
                dataType: "JSON",
        		cache: false,
                success: function(data)
                {
        			if(data.response == 1)
        			{
        				$('.data-firstname').val(data.firstname);
        				$('.data-lastname').val(data.lastname);
        				$('.data-email').val(data.emailadd);
        				$('.data-phone').val(data.pnumber);
        				$(".data-bio").summernote("code", data.bio);
        				
        				if(data.user2fa == 1){
        				    $('.data-2fa').prop('checked', true);
        				}else{
        				    $('.data-2fa').prop('checked', false);
        				}
        				
        				if(data.emailver == 1){
        				    $('#statemail').addClass('valid-feedback');
        				    $('#statemail').removeClass('invalid-feedback');
        				    $('.data-email').addClass('is-valid');
        				    $('.verified-img').addClass('text-success');
        				    $('.ver-msg').html('Email is verified');
        				    $('.iyot').addClass('fas fa-check-circle');
        				}else{
        				    $('#statemail').addClass('invalid-feedback');
        				    $('#statemail').removeClass('valid-feedback');
        				    $('.data-email').addClass('is-invalid');
        				    $('.verified-img').addClass('text-danger');
        				    $('.ver-msg').html('Email is not verified, <a type="button" href="javascript:void(0);" onclick="emailverify()">Click here</a> to verify your email.');
        				    $('.iyot').addClass('fas fa-times-circle');
        				}
        				
        				$('.profile-name').html(data.firstname+' '+data.lastname);
        				$('.profile-user').html(data.total_user);
        				$('.profile-reseller').html(data.total_reseller);
        				$('.profile-credit').html(data.mycredit);
        				
        				$('.profile-name-2').html(data.firstname+' '+data.lastname);
        				$('.profile-rank').html(data.rank+' '+data.rank2);
        				$(".profile-bio-2").html(data.bio);
        			}
        			if(data.response == 2)
        			{
        				swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                            button: false,
                            closeOnClickOutside: false,
                            timer: 3000
                        }).then(() => {
                            location.reload()
                        });
        			}
        			if(data.response == 0){
        				swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                            button: false,
                            closeOnClickOutside: false,
                            timer: 3000
                        }).then(() => {
                            location.reload()
                        });
        			}
                },
                error: function (jqXHR, textStatus, errorThrown)
                {
                    swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
                }
            });
        }
    
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
        			normalMessage('success', 'Success', data.msg);
        			$(".changepassword").trigger("reset");
        		}
        		if(data.response == 2){
        			normalMessage('danger','Error', data.msg);
        		}
        		if(data.response == 3){
        			normalMessage('danger','Error', data.errormsg);
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
    	
    	//Edit Profile
    	$("#profileupdate > .btn-confirm-submit").click(function(){
            $("#profileupdate > .btn-confirm-cancel").removeClass("d-none")
            $("#profileupdate > .btn-confirm-submit").addClass("d-none")
            $("#profileupdate > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#profileupdate > .btn-confirm-cancel").click(function(){
            $("#profileupdate > .btn-confirm-cancel").addClass("d-none")
            $("#profileupdate > .btn-confirm-submit").removeClass("d-none")
            $("#profileupdate > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.profileupdate');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/profile_settings.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#profileupdate > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		    if(data.response == 1){
        			normalMessage('success', 'Success', data.msg);
                    getProfile();
        		}
        		if(data.response == 2){
        			normalMessage('danger', 'Ooops!', data.msg);
                    getProfile();
        		}
        		if(data.response == 3){
        			normalMessage('danger', 'Ohh no!', data.errormsg);
                    getProfile();
        		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    			swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                    button: false,
                    closeOnClickOutside: false,
                    timer: 3000
                }).then(() => {
                    location.reload()
                });
    		},
    		complete: function(){
    			$("#profileupdate > .btn-confirm-auth").removeClass("btn-progress")
    			$("#profileupdate > .btn-confirm-submit").removeClass("d-none")
    			$("#profileupdate > .btn-confirm-auth").addClass("d-none")
    			$("#profileupdate > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	$(document).on('click', '.upload-field', function(){
            var file = $(this).parent().parent().parent().find('.input-file');
            file.trigger('click');
        });

        $(document).on('change', '.input-file', function(){
            $(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
        });
        
    	getProfile()
    });
</script>
