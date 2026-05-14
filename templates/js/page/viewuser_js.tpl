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

function normalMessage(type,title,message)
	{
		$(".normal-modal-body > .normal-modal-error").html('').append('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
	}

function view_info(u) {
	$.ajax({
        url: "{$base_url}serverside/data/get_userinfo.php",
        data: "uid="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            var template_html =  `<div class="form-group"><label for="username">Username</label><input class="form-control" id="username" type="text" value="`+data.username+`" readonly><div>
				<div class="form-group mt-3"><label for="password">Password</label><input class="form-control" id="password" type="text" value="`+data.userpass+`" readonly><div>
				<div class="form-group mt-3"><label for="subscription">Subscription</label><input class="form-control" id="subscription" type="text" value="`+data.subscription+`" readonly><div>
				<div class="form-group mt-3"><label for="expiration">Expiration</label><input class="form-control" id="expiration" type="text" value="`+data.expired+`" readonly><div>
				<div class="form-group mt-3"><label for="upline">Upline</label><input class="form-control" id="upline" type="text" value="`+data.upline+`" readonly><div>
				<div class="form-group mt-3"><label for="device">Device</label><input class="form-control" id="device" type="text" value="`+data.device+`" readonly><div>`;
			normal_modalize('Details', template_html);
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

function user_option(u) {
	$.ajax({
        url: "{$base_url}serverside/data/get_useroption.php",
        data: "uid="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
			var template_html = `<div class="form-group">
                                	<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-changepassword" tabindex="4" data-id="`+u+`">Change Password</button>
                                	<button type="submit" class="btn btn-`+data.freezecolor+` btn-lg btn-block btn-modal-blockuser" data-id="`+u+`" data-username="`+data.username+`" data-freezestatus="`+data.freezestatus+`" tabindex="4">`+data.freezestatus+` User</button>
                                	<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-sessionreset" tabindex="4" data-id="`+u+`" data-username="`+data.username+`">Session Reset</button>
                                	<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-devicereset" tabindex="4" data-id="`+u+`" data-username="`+data.username+`">Device Reset</button>
                                	<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-extendduration" tabindex="4" data-id="`+u+`">Extend Duration</button>
                                	<button type="submit" class="btn btn-`+data.socksipcolor+` btn-lg btn-block btn-modal-socksip" data-id="`+u+`" data-username="`+data.username+`" data-socksipstatus="`+data.socksipstatus+`" data-confirmsocksip="`+data.confirmsocksip+`" data-proceedsocksip="`+data.proceedsocksip+`" data-socksipinfo="`+data.socksipinfo+`" tabindex="4">`+data.socksipstatus+` SocksIP</button>
                                	<button type="submit" class="btn btn-danger btn-lg btn-block btn-modal-deleteuser" tabindex="4" data-id="`+u+`" data-username="`+data.username+`">Delete User</button>
                                </div>`;
			normal_modalize('Actions', template_html);
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
	
// Server timezone offset (set from PHP)
var serverTimezoneOffset = {$server_timezone_offset|default:0};

// Real-time session time update function
function updateSessionTimes() {
    var badges = document.querySelectorAll('.table-listuser tbody tr td:nth-child(3) .badge[data-timestamp]');
    for (var i = 0; i < badges.length; i++) {
        var badge = badges[i];
        var timestamp = badge.getAttribute('data-timestamp');
        if (timestamp && timestamp !== '0000-00-00 00:00:00') {
            var elapsed = calculateElapsedTime(timestamp);
            if (elapsed) {
                badge.innerHTML = '<i class="far fa-clock"></i> ' + elapsed;
            }
        }
    }
}

function calculateElapsedTime(timestamp) {
    if (!timestamp || timestamp === '0000-00-00 00:00:00') {
        return 'never';
    }
    
    try {
        // Parse timestamp in multiple formats
        var startTime;
        
        // Try ISO format first (YYYY-MM-DDTHH:MM:SS)
        if (timestamp.indexOf('T') !== -1) {
            startTime = new Date(timestamp);
        } else {
            // Parse MySQL format (YYYY-MM-DD HH:MM:SS)
            var parts = timestamp.split(' ');
            if (parts.length === 2) {
                var dateParts = parts[0].split('-');
                var timeParts = parts[1].split(':');
                if (dateParts.length === 3 && timeParts.length === 3) {
                    startTime = new Date(
                        parseInt(dateParts[0], 10),
                        parseInt(dateParts[1], 10) - 1,
                        parseInt(dateParts[2], 10),
                        parseInt(timeParts[0], 10),
                        parseInt(timeParts[1], 10),
                        parseInt(timeParts[2], 10)
                    );
                }
            }
        }
        
        if (!startTime || isNaN(startTime.getTime())) {
            return 'invalid';
        }
        
        var now = new Date();
        
        // Calculate difference in seconds
        var diffSeconds = Math.floor((now.getTime() - startTime.getTime()) / 1000);
        
        // Handle future dates or very small differences
        if (diffSeconds < 5) {
            return 'just now';
        }
        
        // Convert to readable format
        var years = Math.floor(diffSeconds / 31536000);
        var months = Math.floor((diffSeconds % 31536000) / 2592000);
        var days = Math.floor((diffSeconds % 2592000) / 86400);
        var hours = Math.floor((diffSeconds % 86400) / 3600);
        var minutes = Math.floor((diffSeconds % 3600) / 60);
        var seconds = diffSeconds % 60;
        
        var parts = [];
        
        if (years > 0) parts.push(years + ' year' + (years > 1 ? 's' : ''));
        if (months > 0) parts.push(months + ' month' + (months > 1 ? 's' : ''));
        if (days > 0) parts.push(days + ' day' + (days > 1 ? 's' : ''));
        if (hours > 0) parts.push(hours + ' hour' + (hours > 1 ? 's' : ''));
        if (minutes > 0) parts.push(minutes + ' min' + (minutes > 1 ? 's' : ''));
        if (seconds > 0 && parts.length < 3) parts.push(seconds + ' sec' + (seconds !== 1 ? 's' : ''));
        
        // Show up to 3 most significant parts
        parts = parts.slice(0, 3);
        
        if (parts.length === 0) {
            return 'just now';
        }
        
        return parts.join(' ') + ' ago';
    } catch (e) {
        console.error('Error parsing timestamp:', timestamp, e);
        return 'error';
    }
}

// Start real-time updates every second
var sessionUpdateInterval = setInterval(updateSessionTimes, 1000);

// Initial update
$(document).ready(function() {
    setTimeout(updateSessionTimes, 500);
});

$('document').ready(function()
{
    function normalTable() {
        let timerInterval;
        $.fn.dataTable.ext.errMode = () => 
        Swal.fire({
            title: "Error",
            icon: "error",
            html: "Failed getting table data from ajax.<br><b></b>",
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
                $('.table-listuser').DataTable().ajax.reload();
            }
        });
    	$('.table-listuser').dataTable({
    	    responsive: true,
            "bProcessing": false,
            "bServerSide": true,
            "ajax": {
                "url": "/normal-serverside",
                "type": "POST"
            },
            "drawCallback": function( settings ) {
                var rows = this.fnGetData();
                if (rows.length === 0 ) {
                    $('.pdata').addClass('d-none');
                }else{
                    $('.pdata').removeClass('d-none');
                }    
            },
            order: [[ 0, 'desc' ], [ 0, 'asc' ]],
            "language": {                
                "infoFiltered": ""
            },
            columnDefs: [
                {
                  width: '11%',
                  targets: 0,
                },
                {
                  width: '11%',
                  targets: 1,
                },
                {
                  width: '11%',
                  targets: 2,
                },
                {
                  width: '11%',
                  targets: 3,
                },
                {
                  width: '11%',
                  targets: 4,
                },
                {
                  width: '5%',
                  targets: 5,
                },
                {
                  orderable: false,
                  targets: [1, 2, 3, 4, 5],
                },
            ],
    	});
    }
    
    function bulkTable() {
        let timerInterval;
        $.fn.dataTable.ext.errMode = () => 
        Swal.fire({
            title: "Error",
            icon: "error",
            html: "Failed getting table data from ajax.<br><b></b>",
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
                $('.table-listuser').DataTable().ajax.reload();
            }
        });
    	$('.table-listuser').dataTable({
    	    responsive: true,
            "bProcessing": false,
            "bServerSide": true,
            "ajax": {
                "url": "/bulk-serverside",
                "type": "POST"
            },
            "drawCallback": function( settings ) {
                var rows = this.fnGetData();
                if (rows.length === 0 ) {
                    $('.pdata').addClass('d-none');
                }else{
                    $('.pdata').removeClass('d-none');
                }    
            },
            order: [[ 0, 'desc' ], [ 0, 'asc' ]],
            "language": {                
                "infoFiltered": ""
            },
            columnDefs: [
            {
              width: '11%',
              targets: 0,
            },
            {
              width: '11%',
              targets: 1,
            },
            {
              width: '11%',
              targets: 2,
            },
            {
              width: '11%',
              targets: 3,
            },
            {
              width: '11%',
              targets: 4,
            },
            {
              width: '5%',
              targets: 5,
            },
            {
              orderable: false,
              targets: [1, 2, 3, 4, 5],
            },
          ],
    	});
    }
    
    function inactiveTable() {
        let timerInterval;
        $.fn.dataTable.ext.errMode = () => 
        Swal.fire({
            title: "Error",
            icon: "error",
            html: "Failed getting table data from ajax.<br><b></b>",
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
                $('.table-listuser').DataTable().ajax.reload();
            }
        });
    	$('.table-listuser').dataTable({
    	    responsive: true,
            "bProcessing": false,
            "bServerSide": true,
            "ajax": {
                "url": "/inactive-serverside",
                "type": "POST"
            },
            "drawCallback": function( settings ) {
                var rows = this.fnGetData();
                if (rows.length === 0 ) {
                    $('.pdata').addClass('d-none');
                }else{
                    $('.pdata').removeClass('d-none');
                }    
            },
            order: [[ 0, 'desc' ], [ 0, 'asc' ]],
            "language": {                
                "infoFiltered": ""
            },
            columnDefs: [
            {
              width: '11%',
              targets: 0,
            },
            {
              width: '11%',
              targets: 1,
            },
            {
              width: '11%',
              targets: 2,
            },
            {
              width: '11%',
              targets: 3,
            },
            {
              width: '11%',
              targets: 4,
            },
            {
              width: '5%',
              targets: 5,
            },
            {
              orderable: false,
              targets: [1, 2, 3, 4, 5],
            },
          ],
    	});
    }
    
    function trialTable() {
        let timerInterval;
        $.fn.dataTable.ext.errMode = () => 
        Swal.fire({
            title: "Error",
            icon: "error",
            html: "Failed getting table data from ajax.<br><b></b>",
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
                $('.table-listuser').DataTable().ajax.reload();
            }
        });
    	$('.table-listuser').dataTable({
    	    responsive: true,
            "bProcessing": false,
            "bServerSide": true,
            "ajax": {
                "url": "/trial-serverside",
                "type": "POST"
            },
            "drawCallback": function( settings ) {
                var rows = this.fnGetData();
                if (rows.length === 0 ) {
                    $('.pdata').addClass('d-none');
                }else{
                    $('.pdata').removeClass('d-none');
                }    
            },
            "language": {                
                "infoFiltered": ""
            },
            columnDefs: [
            {
              width: '11%',
              targets: 0,
            },
            {
              width: '11%',
              targets: 1,
            },
            {
              width: '11%',
              targets: 2,
            },
            {
              width: '11%',
              targets: 3,
            },
            {
              width: '11%',
              targets: 4,
            },
            {
              width: '5%',
              targets: 5,
            },
            {
              orderable: false,
              targets: [1, 2, 3, 4, 5],
            },
          ],
    	});
    }
    
    function reinitializeTable() {
        if ($.fn.DataTable.isDataTable('.table-listuser')) {
          $('.table-listuser').DataTable().clear().destroy();
        }
    }
    
    function getActive(u) {
		$.ajax({
        url: "{$base_url}serverside/data/get_active.php",
        data: "type="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
			$('.Active').val(data.active);
			$('.Total').val(data.total);
			
			var curTabl = $("#tabletype option:selected").text();
			
			if(curTabl === "Trial")
    		{
    			$('.Inactive').val(data.inactive);
    		}else if(curTabl === "Bulk")
    		{
    			$('.Inactive').val(data.inactive);
    		}else if(curTabl === "Inactive")
    		{
    			$('.Inactive').val(data.inactive2);
    		}else if(curTabl === "Normal")
    		{
    			$('.Inactive').val(data.inactive);
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
    
    getActive('normal')
    normalTable()
    
    $('#tabletype').on('change', function () {
        var curTable = $("#tabletype option:selected").text();
        
        if(curTable === "Trial")
		{
			$('#ActiveCounter').addClass("d-none")
			$('.currentloaded').val(curTable +' Users')
			$('.currentuser').html(curTable +' User List')
			reinitializeTable()
			trialTable()
		}else if(curTable === "Bulk")
		{
			$('#ActiveCounter').removeClass("d-none")
			$('.currentloaded').val(curTable +' Users')
			$('.currentuser').html(curTable +' User List')
			getActive($("#tabletype option:selected").val());
			reinitializeTable()
			bulkTable()
		}else if(curTable === "Inactive")
		{
			$('#ActiveCounter').removeClass("d-none")
			$('.currentloaded').val(curTable +' Users')
			$('.currentuser').html(curTable +' User List')
			getActive($("#tabletype option:selected").val());
			reinitializeTable()
			inactiveTable()
		}else if(curTable === "Normal")
		{
			$('#ActiveCounter').removeClass("d-none")
			$('.currentloaded').val(curTable +' Users')
			$('.currentuser').html(curTable +' User List')
			getActive($("#tabletype option:selected").val());
			reinitializeTable()
			normalTable()
		}
    });
    
    
    //Change Password
    $(".normal-modalize").on("click", ".btn-modal-changepassword", function(e)
	{
		var userid = $(this).data("id");

		var template_html = `<form class="changepassword" method="post" autocomplete="off">`
						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
						+ `<input type="hidden" name="id" value="`+userid+`">`
						+ `<input type="hidden" name="submitted" value="change_password">`
						+ `<div class="form-group"><label for="newpassword">New Password</label><input id="newpassword" class="form-control" name="newpassword" type="text"></div>`
						+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-changepass" id="btn-changepass" tabindex="4">Change</button></div>`
						+ `</form>`;
		normal_modalize('Change Password', template_html);
		
		var $form = $('.changepassword');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/user/change_password.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-changepass").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
            			$(".changepassword").trigger("reset");
                        $(".changepassword").remove();
                        $(".normal-modalize").modal('hide');
            			
            			Swal.fire({
                          title: "Success",
                          html: data.msg,
                          icon: "success",
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
            		}
            		if(data.response == 2){
            			Swal.fire({
                          title: "Failed",
                          html: data.msg,
                          icon: "error",
                          allowOutsideClick: false,
                          allowEscapeKey: false,
                          didOpen: function () {
                            Swal.getConfirmButton().blur()
                          }
                        });
            		}
            		if(data.response == 3){
            			Swal.fire({
                          title: "Failed",
                          html: data.errormsg,
                          icon: "error",
                          allowOutsideClick: false,
                          allowEscapeKey: false
                        });
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
        			$('.table-listuser').DataTable().ajax.reload( getActive($("#tabletype option:selected").val()), false );
    				$("#btn-changepass").removeClass("btn-progress");
        		}
        	});
	})
	
	
	//Block User
    $(".normal-modalize").on("click", ".btn-modal-blockuser", function(e)
	{
		var userid = $(this).data("id");
		var blockstatus = $(this).data("freezestatus");
		$.ajax({
            url: "{$base_url}serverside/data/get_userinfo.php",
            data: "uid="+userid,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			var template_html = `<form class="blockuser" method="post" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="block_user">`
                        		+ `<input type="hidden" name="confirmblock" value="`+data.confirmblock+`">`
                        		+ `<p class="text-center">Do you want to `+data.proceedblock+` <code>`+data.username+`</code>?</p>`
                        		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-blockuser" id="btn-blockuser" tabindex="4">Confirm</button></div>`
                        		+ `</form>`;
        		normal_modalize(blockstatus +' User', template_html);
        		
        		var $form = $('.blockuser');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/user/block_user.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-blockuser").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
                			    $(".blockuser").remove();
                                $(".normal-modalize").modal('hide');
                                
                    			Swal.fire({
                                  title: "Success",
                                  html: data.msg,
                                  icon: "success",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 2){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.msg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 3){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.errormsg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false
                                });
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
                			$('.table-listuser').DataTable().ajax.reload( getActive($("#tabletype option:selected").val()), false );
            				$("#btn-blockuser").removeClass("btn-progress");
                		}
                	});
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
	
	//SocksIP
    $(".normal-modalize").on("click", ".btn-modal-socksip", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");
		var confirmsocksip = $(this).data("confirmsocksip");
		var proceedsocksip = $(this).data("proceedsocksip");
		var socksipinfo = $(this).data("socksipinfo");
		$.ajax({
            url: "{$base_url}serverside/data/get_userinfo.php",
            data: "uid="+userid,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			var template_html = `<form class="socksip" autocomplete="off">`
                                		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                                		+ `<input type="hidden" name="id" value="`+userid+`">`
                                		+ `<input type="hidden" name="submitted" value="add_socksip">`
                                		+ `<input type="hidden" name="confirmsocksip" value="`+confirmsocksip+`">`
                                		+ `<p class="text-center">Do you want to `+proceedsocksip+` <code>`+username+`'s</code> socksip access ?</p>`
                                		+ `<p class="text-center `+socksipinfo+`">This will activate <code>`+username+`</code> account status</p>`
                                		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-socksip" id="btn-socksip" tabindex="4">Confirm</button></div>`
                                		+ `</form>`;
        		normal_modalize('Activate SocksIP', template_html);
        		
        		var $form = $('.socksip');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/user/socksip.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-socksip").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
                			    $(".socksip").remove();
                                $(".normal-modalize").modal('hide');
                                
                    			Swal.fire({
                                  title: "Success",
                                  html: data.msg,
                                  icon: "success",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 2){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.msg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 3){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.errormsg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false
                                });
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
                			$('.table-listuser').DataTable().ajax.reload( getActive($("#tabletype option:selected").val()), false );
            				$("#btn-socksip").removeClass("btn-progress");
                		}
                	});
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
	
	//Session Reset
    $(".normal-modalize").on("click", ".btn-modal-sessionreset", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<form class="sessionreset" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="session_reset">`
                        		+ `<p class="text-center">Proceed resetting <code>`+username+`'s</code> vpn session ?</p>`
                        		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-session" id="btn-session" tabindex="4">Confirm</button></div>`
                        		+ `</form>`;
		normal_modalize('Session Reset', template_html);
		
		var $form = $('.sessionreset');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/user/session_reset.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-session").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
                		$(".sessionreset").remove();
                        $(".normal-modalize").modal('hide');
                                
                    	Swal.fire({
                            title: "Success",
                            html: data.msg,
                            icon: "success",
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            didOpen: function () {
                            Swal.getConfirmButton().blur()
                            }
                                });
                    		}
                    		if(data.response == 2){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.msg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 3){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.errormsg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false
                                });
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
        			$('.table-listuser').DataTable().ajax.reload( getActive($("#tabletype option:selected").val()), false );
    				$("#btn-session").removeClass("btn-progress");
        		}
        	});
	})
	
	//Device Reset
    $(".normal-modalize").on("click", ".btn-modal-devicereset", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<form class="devicereset" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="device_reset">`
                        		+ `<p class="text-center">Proceed resetting <code>`+username+`'s</code> device ?</p>`
                        		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-device" id="btn-device" tabindex="4">Confirm</button></div>`
                        		+ `</form>`;
		normal_modalize('Device Reset', template_html);
		
		var $form = $('.devicereset');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/user/device_reset.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-device").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
                			$(".devicereset").remove();
                            $(".normal-modalize").modal('hide');
                                
                    			Swal.fire({
                                  title: "Success",
                                  html: data.msg,
                                  icon: "success",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 2){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.msg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 3){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.errormsg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false
                                });
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
        			$('.table-listuser').DataTable().ajax.reload( getActive($("#tabletype option:selected").val()), false );
    				$("#btn-device").removeClass("btn-progress");
        		}
        	});
	})
	
	//Extend User
    $(".normal-modalize").on("click", ".btn-modal-extendduration", function(e)
	{
		var userid = $(this).data("id");
		var template_html
		
		$.ajax({
            url: "{$base_url}serverside/data/get_userinfo.php",
            data: "uid="+userid,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			if(data.expired == 'none')
    			{
    				template_html = `<p class="text-center">User <code>`+data.username+`</code> is not activated.</p>`
    			}else{
    				template_html = `<form class="extendduration" autocomplete="off">`
    					+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        + `<input type="hidden" name="id" value="`+userid+`">`
                        + `<input type="hidden" name="submitted" value="extend_user">`
    					+ `<p><code>Note :</code> You must have enough remaining credit to extend a duration.</p>`
    					+ `<div class="form-group"><label for="username">Username</label><input class="form-control" type="text" value="`+data.username+`" readonly><div>`
    					+ `<div class="form-group mt-3"><label for="expiration">Expiration</label><input class="form-control" type="text" value="`+data.expired+`" readonly><div>`
    					+ `<div class="form-group mt-3"><label for="duration">Duration</label><select class="form-control select2" id="duration" name="duration" data-minimum-results-for-search="-1">`
    					+ `<option value="1m">1 Month</option>`
    					+ `<option value="2m">2 Months</option>`
    					+ `<option value="3m">3 Months</option>`
    					+ `<option value="4m">4 Months</option>`
    					+ `<option value="5m">5 Months</option>`
    					+ `</select></div>`
    					+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-extend" id="btn-extend" tabindex="4">Confirm</button></div>`
    					+ `</form>`;
    				}
    			normal_modalize('Extend', template_html);
        		
        		$('#duration').select2({
                    dropdownParent: $('.normal-modalize')
                });
                
        		var $form = $('.extendduration');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/user/extend_user.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-extend").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
                			    $(".extendduration").remove();
                                $(".normal-modalize").modal('hide');
                                
                    			Swal.fire({
                                  title: "Success",
                                  html: data.msg,
                                  icon: "success",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 2){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.msg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 3){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.errormsg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false
                                });
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
                			$('.table-listuser').DataTable().ajax.reload( getActive($("#tabletype option:selected").val()), false );
            				$("#btn-extend").removeClass("btn-progress");
                		}
                	});
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
	
	//User Delete
    $(".normal-modalize").on("click", ".btn-modal-deleteuser", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<form class="deleteuser" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="delete_user">`
                        		+ `<div class="form-group"><label for="username">Username</label><input id="username" class="form-control" type="text" value="`+username+`" readonly></div>`
                        		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-deleteuser" id="btn-deleteuser" tabindex="4">Confirm</button></div>`
                        		+ `</form>`;
		normal_modalize('Delete', template_html);
		
		var $form = $('.deleteuser');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/user/delete_user.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-deleteuser").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
                			    $(".deleteuser").remove();
                                $(".normal-modalize").modal('hide');
                                
                    			Swal.fire({
                                  title: "Success",
                                  html: data.msg,
                                  icon: "success",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 2){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.msg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false,
                                  didOpen: function () {
                                    Swal.getConfirmButton().blur()
                                  }
                                });
                    		}
                    		if(data.response == 3){
                    			Swal.fire({
                                  title: "Failed",
                                  html: data.errormsg,
                                  icon: "error",
                                  allowOutsideClick: false,
                                  allowEscapeKey: false
                                });
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
        			$('.table-listuser').DataTable().ajax.reload( getActive($("#tabletype option:selected").val()), false );
    				$("#btn-deleteuser").removeClass("btn-progress");
        		}
        	});
	})
	
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
    
    $(".btn-print").click(function(){
	    var dataUser = $("#tabletype option:selected").val();
        $('<a href="api/print/print-user.php?data='+dataUser+'" target="_blank"></a>')[0].click();
    }); 
});
</script>
