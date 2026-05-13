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
    
    //Create Trial
    function create()
	{
	    $.ajax({
            url: "{$base_url}serverside/forms/extra/gen_user.php",
            type: "GET",
            dataType: "JSON",
    		cache: false,
    		beforeSend: function() {

    		},
            success: function(data)
            {
    
    			var template_html = `<form class="createtrial" method="post" autocomplete="off">`
        						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
        						+ `<input type="hidden" name="submitted" value="create_trial">`
        						
        						+ `<div class="alert alert-primary" role="alert"><strong>TRIAL ACCOUNT </strong> is valid only for <u>`+data.tri_dur+`</u> after activation.</div>`
        						+ `<div class="form-group"><label for="username">Username</label><input id="username" class="form-control" name="username" value="`+data.ran_user+`" type="text"></div>`
        						+ `<div class="form-group"><label for="password">Password</label><input id="password" class="form-control" name="password" value="`+data.ran_pass+`" type="text"></div>`
        						+ `<div class="form-group text-center" id="turnstile"><div class="cf-turnstile"></div></div>`
        						+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-create" id="btn-create" tabindex="4">Submit</button></div>`
        						+ `</form>`;
        		normal_modalize('Create Trial', template_html);
        		
                turnstile.render('#turnstile', {
                    sitekey: '{$turnstile_key}',
                    theme: 'light',
                    size: 'normal',
                });
                
        		var $form = $('.createtrial');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/extra/create_trial.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-create").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
            					modalMessage('success', 'Success', data.msg);
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
                		    $(".createtrial").remove();
            				$(".createtrial").trigger("reset");
            				$("#btn-create").removeClass("btn-progress");
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
	
	//Check Account
    function check()
	{
	    var template_html = `<form class="checkaccount" method="post" autocomplete="off">`
        						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
        						+ `<input type="hidden" name="submitted" value="create_trial">`
        						+ `<div class="form-group"><label for="username">Username</label><input id="username" class="form-control" name="username" type="text"></div>`
        						+ `<div class="form-group text-center" id="turnstile"><div class="cf-turnstile"></div></div>`
        						+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-check" id="btn-check" tabindex="4">Submit</button></div>`
        						+ `</form>`;
        		normal_modalize('Check Account', template_html);
        		
                turnstile.render('#turnstile', {
                    sitekey: '{$turnstile_key}',
                    theme: 'light',
                    size: 'normal',
                });
                
        		var $form = $('.checkaccount');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/extra/check_account.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-check").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
            					var template_html =  `<div class="form-group"><label for="username">Username</label><input class="form-control" id="username" type="text" value="`+data.username+`" readonly><div>
                    				<div class="form-group mt-3"><label for="subscription">Subscription</label><input class="form-control" id="subscription" type="text" value="`+data.subscription+`" readonly><div>
                    				<div class="form-group mt-3"><label for="expiration">Expiration</label><input class="form-control" id="expiration" type="text" value="`+data.duration+`" readonly><div>
                    				<div class="form-group mt-3"><label for="device">Device</label><input class="form-control" id="device" type="text" value="`+data.device+`" readonly><div>`;
                    			normal_modalize('Details', template_html);
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
                		    $(".checkaccount").remove();
            				$(".checkaccount").trigger("reset");
            				$("#btn-check").removeClass("btn-progress");
                		}
                	});
	}
	
	//Device Reset
    function device()
	{
	    var template_html = `<form class="devicereset" method="post" autocomplete="off">`
        						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
        						+ `<input type="hidden" name="submitted" value="device_reset">`
        						+ `<div class="form-group"><label for="username">Username</label><input id="username" class="form-control" name="username" type="text"></div>`
        						+ `<div class="form-group text-center" id="turnstile"><div class="cf-turnstile"></div></div>`
        						+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-device" id="btn-device" tabindex="4">Submit</button></div>`
        						+ `</form>`;
        		normal_modalize('Device Reset', template_html);
                
                turnstile.render('#turnstile', {
                    sitekey: '{$turnstile_key}',
                    theme: 'light',
                    size: 'normal',
                });
                
        		var $form = $('.devicereset');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/extra/device_reset.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-device").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
            					modalMessage('success', 'Success', data.msg);
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
                		    $(".devicereset").remove();
            				$(".devicereset").trigger("reset");
            				$("#btn-device").removeClass("btn-progress");
                		}
                	});
	}
	
</script>