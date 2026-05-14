<script>
    function reloadPage()
    {
    	setTimeout(function(){
    		location.reload();
    	}, 3000)
    }
    
    function getSettings()
    {
    	$.ajax({
            url: "{$base_url}serverside/data/get_settings.php",
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			if(data.response == 1)
    			{
    				$('.logoshow').html(data.logoshow);
    				$('.logoshow').val(data.logoshow_);
    				
    				$('#logoshow').select2({
                        templateResult: function (firenetdev) {
                        var $span = $("<span>" + firenetdev.text + "</span>");
                        return $span;
                        },
                	    templateSelection: function (firenetdev) {
                  	    var $span = $("<span>" + firenetdev.text + "</span>");
                  	    return $span;
                        }
                    });
    				
    				$('.maintenance').html(data.maintenance);
    				$('.maintenance').val(data.maintenance_);
    				
    				$('#maintenance').select2({
                        templateResult: function (firenetdev) {
                        var $span = $("<span>" + firenetdev.text + "</span>");
                        return $span;
                        },
                	    templateSelection: function (firenetdev) {
                  	    var $span = $("<span>" + firenetdev.text + "</span>");
                  	    return $span;
                        }
                    });
                    
    				$('.theme').html(data.theme);
    				$('.theme').val(data.theme_);
    				
    				$('#theme').select2({
                        templateResult: function (firenetdev) {
                        var $span = $("<span><img src='/dist/img/theme/" + firenetdev.id + ".png' height='20' width='20'/> " + firenetdev.text + "</span>");
                        return $span;
                        },
                	    templateSelection: function (firenetdev) {
                  	    var $span = $("<span><img src='/dist/img/theme/" + firenetdev.id + ".png' height='20' width='20'/> " + firenetdev.text + "</span>");
                  	    return $span;
                        }
                    });
    				
    				$('#title').val(data.name);
    				$('#description').val(data.description);
    				$('#owner').val(data.owner);
    				$('#logo').val(data.logo);
    				$(".trialcounter").val(data.trialuser);
    				$(".sessions").val(data.sessions);
    				
    				$(".download1_name").val(data.download1_name);
    				$(".download1_url").val(data.download1_url);
    				$(".download2_name").val(data.download2_name);
    				$(".download2_url").val(data.download2_url);
    				$(".download3_name").val(data.download3_name);
    				$(".download3_url").val(data.download3_url);
    				
    				if($(".download1_name").val() == ''){
    				    $(".download2").addClass('d-none');
    				}else{
    				    $(".download2").removeClass('d-none');
    				}
    				
    				if($(".download2_name").val() == ''){
    				    $(".download3").addClass('d-none');
    				}else{
    				    $(".download3").removeClass('d-none');
    				}
    				
    				$(".summernote").summernote("code", data.note);
    				
    				var $firenet5 = $('.prefix').html(data.prefixz);
    				var $firenet6 = $('.prefix').val(data.prefixz_);
                    $('#uprefix').val(data.uprefix);
                    
                    $('#prefix').select2({
                        templateResult: function (firenetdev) {
                        var $span = $("<span>" + firenetdev.text + "</span>");
                        return $span;
                        },
                	    templateSelection: function (firenetdev) {
                  	    var $span = $("<span>" + firenetdev.text + "</span>");
                  	    return $span;
                        }
                    });
                    
                    var $firenet7 = $('.trialdur').html(data.trialdura);
    				var $firenet8 = $('.trialdur').val(data.trialdura_);
    				
    				$('#trialdur').select2({
                        templateResult: function (firenetdev) {
                        var $span = $("<span>" + firenetdev.text + "</span>");
                        return $span;
                        },
                	    templateSelection: function (firenetdev) {
                  	    var $span = $("<span>" + firenetdev.text + "</span>");
                  	    return $span;
                        }
                    });
    			}
    			if(data.response == 2)
    			{
    				Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    			}
    			if(data.response == 0){
    				Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    			}
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
            }
        });
    }
    	
    $('document').ready(function()
    {
        getSettings()
        
        //Web Settings
        $("#websettings > .btn-confirm-web").click(function(){
            $("#websettings > .btn-confirm-cancel").removeClass("d-none")
            $("#websettings > .btn-confirm-web").addClass("d-none")
            $("#websettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#websettings > .btn-confirm-cancel").click(function(){
            $("#websettings > .btn-confirm-cancel").addClass("d-none")
            $("#websettings > .btn-confirm-web").removeClass("d-none")
            $("#websettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.websettings');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/web_settings.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#websettings > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		        if(data.response == 1){
            			Swal.fire({
                          title: "Success",
                          html: data.msg,
                          icon: "success",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 2){
            			Swal.fire({
                          title: "Failed",
                          html: data.msg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 3){
            			Swal.fire({
                          title: "Failed",
                          html: data.errormsg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false
                        });
                        reloadPage();
            		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    			Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    		},
    		complete: function(){
    			$("#websettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#websettings > .btn-confirm-web").removeClass("d-none")
    			$("#websettings > .btn-confirm-auth").addClass("d-none")
    			$("#websettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//Trial Reset
    	$("#trialsettings > .btn-confirm-trial").click(function(){
            $("#trialsettings > .btn-confirm-cancel").removeClass("d-none")
            $("#trialsettings > .btn-confirm-trial").addClass("d-none")
            $("#trialsettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#trialsettings > .btn-confirm-cancel").click(function(){
            $("#trialsettings > .btn-confirm-cancel").addClass("d-none")
            $("#trialsettings > .btn-confirm-trial").removeClass("d-none")
            $("#trialsettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.trialsettings');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/trial_reset.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#trialsettings > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		    if(data.response == 1){
            			Swal.fire({
                          title: "Success",
                          html: data.msg,
                          icon: "success",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 2){
            			Swal.fire({
                          title: "Failed",
                          html: data.msg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 3){
            			Swal.fire({
                          title: "Failed",
                          html: data.errormsg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false
                        });
                        reloadPage();
            		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    			Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    		},
    		complete: function(){
    			$("#trialsettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#trialsettings > .btn-confirm-trial").removeClass("d-none")
    			$("#trialsettings > .btn-confirm-auth").addClass("d-none")
    			$("#trialsettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//VPN Session
    	$("#vpnsettings > .btn-confirm-session").click(function(){
            $("#vpnsettings > .btn-confirm-cancel").removeClass("d-none")
            $("#vpnsettings > .btn-confirm-session").addClass("d-none")
            $("#vpnsettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#vpnsettings > .btn-confirm-cancel").click(function(){
            $("#vpnsettings > .btn-confirm-cancel").addClass("d-none")
            $("#vpnsettings > .btn-confirm-session").removeClass("d-none")
            $("#vpnsettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.vpnsettings');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/vpn_session.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#vpnsettings > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		    if(data.response == 1){
            			Swal.fire({
                          title: "Success",
                          html: data.msg,
                          icon: "success",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 2){
            			Swal.fire({
                          title: "Failed",
                          html: data.msg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 3){
            			Swal.fire({
                          title: "Failed",
                          html: data.errormsg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false
                        });
                        reloadPage();
            		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    			Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    		},
    		complete: function(){
    			$("#vpnsettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#vpnsettings > .btn-confirm-session").removeClass("d-none")
    			$("#vpnsettings > .btn-confirm-auth").addClass("d-none")
    			$("#vpnsettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//App Update
    	$("#downloadsettings > .btn-confirm-app").click(function(){
            $("#downloadsettings > .btn-confirm-cancel").removeClass("d-none")
            $("#downloadsettings > .btn-confirm-app").addClass("d-none")
            $("#downloadsettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#downloadsettings > .btn-confirm-cancel").click(function(){
            $("#downloadsettings > .btn-confirm-cancel").addClass("d-none")
            $("#downloadsettings > .btn-confirm-app").removeClass("d-none")
            $("#downloadsettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.downloadsettings');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/app_update.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#downloadsettings > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		    if(data.response == 1){
            			Swal.fire({
                          title: "Success",
                          html: data.msg,
                          icon: "success",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 2){
            			Swal.fire({
                          title: "Failed",
                          html: data.msg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 3){
            			Swal.fire({
                          title: "Failed",
                          html: data.errormsg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false
                        });
                        reloadPage();
            		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    			Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    		},
    		complete: function(){
    			$("#downloadsettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#downloadsettings > .btn-confirm-app").removeClass("d-none")
    			$("#downloadsettings > .btn-confirm-auth").addClass("d-none")
    			$("#downloadsettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//User Settings
    	$("#usersettings > .btn-confirm-user").click(function(){
            $("#usersettings > .btn-confirm-cancel").removeClass("d-none")
            $("#usersettings > .btn-confirm-user").addClass("d-none")
            $("#usersettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#usersettings > .btn-confirm-cancel").click(function(){
            $("#usersettings > .btn-confirm-cancel").addClass("d-none")
            $("#usersettings > .btn-confirm-user").removeClass("d-none")
            $("#usersettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.usersettings');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/user_settings.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#usersettings > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		    if(data.response == 1){
            			Swal.fire({
                          title: "Success",
                          html: data.msg,
                          icon: "success",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 2){
            			Swal.fire({
                          title: "Failed",
                          html: data.msg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 3){
            			Swal.fire({
                          title: "Failed",
                          html: data.errormsg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false
                        });
                        reloadPage();
            		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    			Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    		},
    		complete: function(){
    			$("#usersettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#usersettings > .btn-confirm-user").removeClass("d-none")
    			$("#usersettings > .btn-confirm-auth").addClass("d-none")
    			$("#usersettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//Bandwidth Settings
    	$("#bandwidthsettings > .btn-confirm-bandwidth").click(function(){
            $("#bandwidthsettings > .btn-confirm-cancel").removeClass("d-none")
            $("#bandwidthsettings > .btn-confirm-bandwidth").addClass("d-none")
            $("#bandwidthsettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#bandwidthsettings > .btn-confirm-cancel").click(function(){
            $("#bandwidthsettings > .btn-confirm-cancel").addClass("d-none")
            $("#bandwidthsettings > .btn-confirm-bandwidth").removeClass("d-none")
            $("#bandwidthsettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.bandwidthsettings');
    	$form.ajaxForm({
    		url: "{$base_url}serverside/forms/bandwidth_settings.php",
    		type: "POST",
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#bandwidthsettings > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		    if(data.response == 1){
    		        Swal.fire({
                        title: "Success",
                        icon: "success",
                        html: data.msg,
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    		    }
    		    if(data.response == 2){
    		        Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: data.msg,
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        }
                    });
    		    }
    		    if(data.response == 3){
    		        Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: data.errormsg,
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        }
                    });
    		    }
    		},
    		complete: function(){
    			$("#bandwidthsettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#bandwidthsettings > .btn-confirm-bandwidth").removeClass("d-none")
    			$("#bandwidthsettings > .btn-confirm-auth").addClass("d-none")
    			$("#bandwidthsettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	// Bandwidth calculation function
    	function calculateBytes() {
    	    var value = parseFloat($('#bandwidth_value').val()) || 0;
    	    var unit = $('#bandwidth_unit').val();
    	    var bytes = 0;
    	    
    	    switch(unit) {
    	        case 'bytes':
    	            bytes = value;
    	            break;
    	        case 'kb':
    	            bytes = value * 1024;
    	            break;
    	        case 'mb':
    	            bytes = value * 1024 * 1024;
    	            break;
    	        case 'gb':
    	            bytes = value * 1024 * 1024 * 1024;
    	            break;
    	        case 'tb':
    	            bytes = value * 1024 * 1024 * 1024 * 1024;
    	            break;
    	        default:
    	            bytes = 0;
    	    }
    	    
    	    $('#result-bytes').text(Math.round(bytes).toLocaleString());
    	}
    	
    	// Update bytes calculation when value or unit changes
    	$('#bandwidth_value, #bandwidth_unit').on('change keyup', function() {
    	    calculateBytes();
    	});
    	
    	// Initialize select2 for bandwidth dropdowns
    	$('#xray_limit').select2({
            templateResult: function (option) {
                var $span = $("<span>" + option.text + "</span>");
                return $span;
            },
            templateSelection: function (option) {
                var $span = $("<span>" + option.text + "</span>");
                return $span;
            }
        });
        
        $('#bandwidth_unit').select2({
            templateResult: function (option) {
                var $span = $("<span>" + option.text + "</span>");
                return $span;
            },
            templateSelection: function (option) {
                var $span = $("<span>" + option.text + "</span>");
                return $span;
            }
        });
    	
    	
    	//Clear Device
        $("#deletedevice > .btn-confirm-clrdevice").click(function(){
            $("#deletedevice > .btn-confirm-cancel").removeClass("d-none")
            $("#deletedevice > .btn-confirm-clrdevice").addClass("d-none")
            $("#deletedevice > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#deletedevice > .btn-confirm-cancel").click(function(){
            $("#deletedevice > .btn-confirm-cancel").addClass("d-none")
            $("#deletedevice > .btn-confirm-clrdevice").removeClass("d-none")
            $("#deletedevice > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.clrdevice');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/device_reset.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#deletedevice > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		    if(data.response == 1){
            			Swal.fire({
                          title: "Success",
                          html: data.msg,
                          icon: "success",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 2){
            			Swal.fire({
                          title: "Failed",
                          html: data.msg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 3){
            			Swal.fire({
                          title: "Failed",
                          html: data.errormsg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false
                        });
                        reloadPage();
            		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    			Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    		},
    		complete: function(){
    			$("#deletedevice > .btn-confirm-auth").removeClass("btn-progress")
    			$("#deletedevice > .btn-confirm-clrdevice").removeClass("d-none")
    			$("#deletedevice > .btn-confirm-auth").addClass("d-none")
    			$("#deletedevice > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//Delete Expired
        $("#delete_xpired > .btn-confirm-delxpired").click(function(){
            $("#delete_xpired > .btn-confirm-cancel").removeClass("d-none")
            $("#delete_xpired > .btn-confirm-delxpired").addClass("d-none")
            $("#delete_xpired > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#delete_xpired > .btn-confirm-cancel").click(function(){
            $("#delete_xpired > .btn-confirm-cancel").addClass("d-none")
            $("#delete_xpired > .btn-confirm-delxpired").removeClass("d-none")
            $("#delete_xpired > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.deletexpired');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/delete_expired.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#delete_xpired > .btn-confirm-auth").addClass("btn-progress")
    		},
    		success: function(data){
    		    if(data.response == 1){
            			Swal.fire({
                          title: "Success",
                          html: data.msg,
                          icon: "success",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 2){
            			Swal.fire({
                          title: "Failed",
                          html: data.msg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
                        reloadPage();
            		}
            		if(data.response == 3){
            			Swal.fire({
                          title: "Failed",
                          html: data.errormsg,
                          icon: "error",
                          customClass: {
                                confirmButton: 'btn-primary'
                            },
                          allowOutsideClick: false,
                          allowEscapeKey: false
                        });
                        reloadPage();
            		}
    		},
    		error: function(jqXHR, textStatus, errorThrown) {
    			Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
    		},
    		complete: function(){
    			$("#delete_xpired > .btn-confirm-auth").removeClass("btn-progress")
    			$("#delete_xpired > .btn-confirm-delxpired").removeClass("d-none")
    			$("#delete_xpired > .btn-confirm-auth").addClass("d-none")
    			$("#delete_xpired > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	$('.download1_name').on('input', function() {
            if($(".download1_name").val() == ''){
        	    $(".download2").addClass('d-none')
        	}else{
        	    $(".download2").removeClass('d-none')
        	}
        });
    	
    	$('.download2_name').on('input', function() {
            if($(".download2_name").val() == ''){
        	    $(".download3").addClass('d-none')
        	}else{
        	    $(".download3").removeClass('d-none')
        	}
        });
    	
    	$(document).on('click', '.upload-field', function(){
            var file = $(this).parent().parent().parent().find('.input-file');
            file.trigger('click');
        });

        $(document).on('change', '.input-file', function(){
            $(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
        });
    	
    	function getD(){
            $.ajax({
                url: "{$base_url}serverside/data/get_data.php",
                type: "GET",
                dataType: "JSON",
            	cache: false,
                success: function(data)
                {
            		if(data.response == 1){
           
                    }
                    if(data.response == 2){
                    	Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: data.licmsg,
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 5000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
                    }
                    if(data.response == 3){
                    	Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: data.licmsg,
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 5000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
                    }
                },
                error: function (jqXHR, textStatus, errorThrown)
                {
                    Swal.fire({
                        title: "Error",
                        icon: "error",
                        html: "Failed getting data from ajax.<br><b></b>",
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        customClass: {
                            confirmButton: 'btn-primary'
                        },
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: () => {
                            Swal.showLoading();
                            const timer = Swal.getPopup().querySelector("b");
                            timerInterval = setInterval(() => {
                                timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.reload()
                        }
                    });
                },
                complete: function(){
            
            	}
            });
        }
        getD()
    });
</script>
