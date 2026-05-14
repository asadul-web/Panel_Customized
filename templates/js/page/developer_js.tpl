<script>
    function reloadPage()
    {
    	setTimeout(function(){
    		location.reload();
    	}, 3000)
    }
    
    function manual_bak()
    {
        $.ajax({
            url: "{$base_url}serverside/forms/manual_backup.php",
            type: "GET",
            dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#dbbakup > .btn-confirm-manbak").addClass("btn-progress")
    		},
            success: function(data)
            {
    
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
    			$("#dbbakup > .btn-confirm-manbak").removeClass("btn-progress")
    		}
        });
    }
    
    function getPanelSettings()
    {
    	$.ajax({
            url: "{$base_url}serverside/data/get_panelsettings.php",
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			if(data.response == 1)
    			{
    			    $(".github_username").val(data.github_username);
    			    $(".github_token").val(data.github_token);
    			    $(".github_repo").val(data.github_repo);
    			    $(".upnotice").val(data.update_link);
    			    $(".base-api-url").val(data.update_link); // Also update base API URL field
    			    $(".license").val(data.license);
    			    $(".turnstile").val(data.turnstile);
    			    $(".turnstilesecret").val(data.turnstilesecret);
    			    $(".whois").val(data.whois);
    			    
    			    // Trigger auto-update of API endpoints
    			    if(data.update_link) {
    			        $(".base-api-url").trigger('input');
    			    }
    			    
    			    $(".dns_prefix").val(data.dns_prefix);
    			    $(".dns_domain").val(data.dns_domain);
    			    $(".dns_zone").val(data.dns_zone);
    			    $(".dns_global").val(data.dns_global);
    			    $(".dns_email").val(data.dns_email);
    			    
    			    $(".recipient_email").val(data.recipient_email);
    			    $(".cc_email").val(data.cc_email);
    			    
    			    $(".admusername").val(data.admin_user);
    				$(".admpassword").val(data.admin_pass);
    			    
    				$(".usercounter").val(data.totaluser);
    				$(".resellercounter").val(data.totalreseller);
    				$(".useractive").val(data.totalactive);
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
        getPanelSettings()
        
        //General Settings
        $("#generalsettings > .btn-confirm-web").click(function(){
            $("#generalsettings > .btn-confirm-cancel").removeClass("d-none")
            $("#generalsettings > .btn-confirm-web").addClass("d-none")
            $("#generalsettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#generalsettings > .btn-confirm-cancel").click(function(){
            $("#generalsettings > .btn-confirm-cancel").addClass("d-none")
            $("#generalsettings > .btn-confirm-web").removeClass("d-none")
            $("#generalsettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.gensettings');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/developer_general_update.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#generalsettings > .btn-confirm-auth").addClass("btn-progress")
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
    			$("#generalsettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#generalsettings > .btn-confirm-web").removeClass("d-none")
    			$("#generalsettings > .btn-confirm-auth").addClass("d-none")
    			$("#generalsettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//DNS Settings
        $("#dnssettings > .btn-confirm-dns").click(function(){
            $("#dnssettings > .btn-confirm-cancel").removeClass("d-none")
            $("#dnssettings > .btn-confirm-dns").addClass("d-none")
            $("#dnssettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#dnssettings > .btn-confirm-cancel").click(function(){
            $("#dnssettings > .btn-confirm-cancel").addClass("d-none")
            $("#dnssettings > .btn-confirm-dns").removeClass("d-none")
            $("#dnssettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.dnsupdate');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/dns_setting.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#dnssettings > .btn-confirm-auth").addClass("btn-progress")
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
    			$("#dnssettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#dnssettings > .btn-confirm-dns").removeClass("d-none")
    			$("#dnssettings > .btn-confirm-auth").addClass("d-none")
    			$("#dnssettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//DB Bak
    	$("#dbbakup > .btn-confirm-db").click(function(){
            $("#dbbakup > .btn-confirm-cancel").removeClass("d-none")
            $("#dbbakup > .btn-confirm-db").addClass("d-none")
            $("#dbbakup > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#dbbakup > .btn-confirm-cancel").click(function(){
            $("#dbbakup > .btn-confirm-cancel").addClass("d-none")
            $("#dbbakup > .btn-confirm-db").removeClass("d-none")
            $("#dbbakup > .btn-confirm-auth").addClass("d-none")
        });
        
    	var $form = $('.dbbak');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/db_backup.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#dbbakup > .btn-confirm-auth").addClass("btn-progress")
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
    			$("#dbbakup > .btn-confirm-auth").removeClass("btn-progress")
    			$("#dbbakup > .btn-confirm-db").removeClass("d-none")
    			$("#dbbakup > .btn-confirm-auth").addClass("d-none")
    			$("#dbbakup > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//Admin Settings
        $("#admsettings > .btn-confirm-adm").click(function(){
            $("#admsettings > .btn-confirm-cancel").removeClass("d-none")
            $("#admsettings > .btn-confirm-adm").addClass("d-none")
            $("#admsettings > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#admsettings > .btn-confirm-cancel").click(function(){
            $("#admsettings > .btn-confirm-cancel").addClass("d-none")
            $("#admsettings > .btn-confirm-adm").removeClass("d-none")
            $("#admsettings > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.adminsettings');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/adm_setting.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#admsettings > .btn-confirm-auth").addClass("btn-progress")
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
    			$("#admsettings > .btn-confirm-auth").removeClass("btn-progress")
    			$("#admsettings > .btn-confirm-adm").removeClass("d-none")
    			$("#admsettings > .btn-confirm-auth").addClass("d-none")
    			$("#admsettings > .btn-confirm-cancel").addClass("d-none")
    		}
    	});
    	
    	//Clear Panel
        $("#deletedata > .btn-confirm-clr").click(function(){
            $("#deletedata > .btn-confirm-cancel").removeClass("d-none")
            $("#deletedata > .btn-confirm-clr").addClass("d-none")
            $("#deletedata > .btn-confirm-auth").removeClass("d-none")
        });
        
        $("#deletedata > .btn-confirm-cancel").click(function(){
            $("#deletedata > .btn-confirm-cancel").addClass("d-none")
            $("#deletedata > .btn-confirm-clr").removeClass("d-none")
            $("#deletedata > .btn-confirm-auth").addClass("d-none")
        });
        
        var $form = $('.clrsettings');
    	$form.ajaxForm({
    		type: "POST",
    		url: "{$base_url}serverside/forms/panel_reset.php",
    		data: $form.serialize(),
    		dataType: "JSON",
    		cache: false,
    		beforeSend: function() {
    			$("#deletedata > .btn-confirm-auth").addClass("btn-progress")
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
    			$("#deletedata > .btn-confirm-auth").removeClass("btn-progress")
    			$("#deletedata > .btn-confirm-clrdevice").removeClass("d-none")
    			$("#deletedata > .btn-confirm-auth").addClass("d-none")
    			$("#deletedata > .btn-confirm-cancel").addClass("d-none")
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
    });
</script>
