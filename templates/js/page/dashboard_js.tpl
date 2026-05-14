<script>
$('document').ready(function()
{
    $('.fetch-update').hide();
    $('.fetch-status').hide();
    $('.activity_id').hide();
    
    function normal_modalize(title, body) {
        $(".normal-modalize").modal({
            backdrop: "static"
        });
        $(".normal-modal-title").html(title);
        $(".normal-modal-html").html(body);
    }
    
    function getDashboard(){
    	$.ajax({
            url: "{$base_url}serverside/data/get_dashboard.php",
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			if(data.response == 1)
    			{
    				$('.stats-reseller').text(data.reseller);
    				$('.stats-user').text(data.user);
    				$('.stats-online').text(data.online);
    				$('.stats-server').text(data.servercount);
    				$('.profile-username').text(data.profile_username);
    				$('.profile-upline').text(data.profile_upline);
    				$('.profile-credits').text(data.profile_credits);
    				$('.stats-activity').append(data.activity);
    				$('.activity_id').show();
    				$('.activity_spinner').hide();
    				$(".profile-servers").html(data.servers)
    				$('.panel-duration').text(data.licdur);
    				
    				$('.stats-created').text(data.domain_created);
    				$('.stats-expired').text(data.domain_expired);
    				
    				var myChart = new Chart($("#userchart"), {
                        type: 'pie',
                        data: {
                            datasets: [{
                                data: [data.trial, data.normal, data.bulk, ],
                                backgroundColor: ['#fc544b', '#63ed7a', '#6777ef', ],
                                label: 'Dataset 1'
                            }],
                            labels: ['Trial', 'Normal', 'Bulk'],
                        },
                        options: {
                            responsive: true,
                            legend: {
                                position: 'bottom',
                            },
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

    function getNotification(){
        $.ajax({
            url: "{$base_url}serverside/data/get_notification.php",
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
                var notifications = '';
    			if(data.response == 1)
    			{
    			    if (data.notiftotal === 0) {
    			        $(".notification-toggle").removeClass("beep");
    				    notifications = `<a href="javascript:void(0)" class="dropdown-item dropdown-item-unread">
                                        	<div class="dropdown-item-icon bg-primary text-white">
                                        		<i class="far fa-smile"></i>
                                        	</div>
                                        	<div class="dropdown-item-desc"> No available notifications to show for now. <div class="time text-primary">Stay safe and secure.</div>
                                        	</div>
                                        </a>`;
    			    }else{
    			        $(".notification-toggle").addClass("beep");
    			        notifications = data.notifica;
    			    }
    			    $(".profile-notifications").html(notifications);
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
    
    $(".notificationlist").on("click", ".view-notification", function() {
        var id = $(this).data("id");
        var type = $(this).data("type");
        var date = $(this).data("date");
    
        $.ajax({
            url: "{$base_url}serverside/data/read_notification.php",
            data: "id="+id,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			if(data.response == 1){
            		normal_modalize(`<span class="badge badge-primary">`+type+`</span> Posted `+date+` `, data.content);
            	}
            	if(data.response == 2){
            		normal_modalize('danger','Error', data.msg);
            	}
            	if(data.response == 3){
            		normal_modalize('danger','Error', data.errormsg);
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
        
    })
    
    function getVersion(){
        $.ajax({
            url: "{$base_url}serverside/data/get_version.php",
            type: "GET",
            dataType: "JSON",
        	cache: false,
            success: function(data)
            {
        		if(data.response == 1){
                	if (data.length > 0) {
                        $('.fetch-update').show().addClass('show')
                        $('.fetch-status').show().addClass('show')
            		    $('.panel-version').text(data.version);
                    	$('.panel-update-list').append(data.content);
                    }
                    if (data.length < 1){
                        $('.fetch-update').show().addClass('d-none')
                        $('.fetch-status').show().addClass('show')
                    }
                    {if $user_id_2 == 1 || $user_level_2 == 'superadmin' || $user_level_2 == 'developer'}
                    if (data.versiontitle) {
                        var htmlContent = document.createElement("div");
                            htmlContent.innerHTML = data.versionmsg;
                        Swal.fire({
                            title: data.versiontitle,
                            icon: data.versiontype,
                            html: htmlContent,
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            confirmButtonText: "Confirm",
                            didOpen: function () {
                                Swal.getConfirmButton().blur()
                            },
                            customClass: {
                                confirmButton: 'swal2-confirm btn btn-primary swal2-styled'
                            }
                        });
                    }
                    {/if}
                }
                if(data.response == 2){
                	// Silently fail - don't show error popup
                }
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                // Silently fail - don't show error popup
            },
            complete: function(){
        
        	}
        });
    }
    
    function getD(){
        $.ajax({
            url: "{$base_url}serverside/data/get_data.php",
            type: "GET",
            dataType: "JSON",
        	cache: false,
            success: function(data)
            {
        		if(data.response == 1){
                    getVersion()
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
getDashboard()
});
</script>
