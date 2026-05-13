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
            var template_html = `<div class="form-group">
						            <div class="card profile-widget">
                                      <div class="profile-widget-header">
                                        `+data.upic+`
                                        <div class="profile-widget-items">
                                          <div class="profile-widget-item">
                                            <div class="profile-widget-item-label">Normal</div>
                                            <div class="profile-widget-item-value">`+data.dnormal+`</div>
                                          </div>
                                          <div class="profile-widget-item">
                                            <div class="profile-widget-item-label">Bulk</div>
                                            <div class="profile-widget-item-value">`+data.dbulk+`</div>
                                          </div>
                                          <div class="profile-widget-item">
                                            <div class="profile-widget-item-label">Trial</div>
                                            <div class="profile-widget-item-value">`+data.dtrial+`</div>
                                          </div>
                                          <div class="profile-widget-item">
                                            <div class="profile-widget-item-label">Reseller</div>
                                            <div class="profile-widget-item-value">`+data.dreseller+`</div>
                                          </div>
                                        </div>
                                      </div>
                                      <div class="profile-widget-description">
                                        <span class="profile-bio">`+data.bio+`</span><hr>
                                        <div class="form-group"><label for="username">Username</label><input class="form-control" id="username" type="text" value="`+data.username+`" readonly><div>
                                        <div class="form-group mt-3"><label for="password">Password</label><input class="form-control" id="password" type="text" value="`+data.userpass+`" readonly><div>
                                        <div class="form-group mt-3"><label for="upline">Upline</label><input class="form-control" id="upline" type="text" value="`+data.upline+`" readonly><div>
                                      </div>
                                    </div>   
                                    <div class="form-group">
                            		<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-editcredit" data-id="`+u+`" tabindex="4">Edit Credit</button>
                            		<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-changepassword" data-id="`+u+`" data-username="`+data.username+`" tabindex="4">Change Password</button>
                            		<button type="submit" class="btn btn-`+data.freezecolor+` btn-lg btn-block btn-modal-blockreseller" data-id="`+u+`" data-username="`+data.username+`" data-freezestatus="`+data.freezestatus+`" tabindex="4">`+data.freezestatus+` Reseller</button>
                            		<button type="submit" class="btn btn-danger btn-lg btn-block btn-modal-deletereseller" data-id="`+u+`" data-username="`+data.username+`" tabindex="4">Delete Reseller</button>
                            	</div>
                                </div>`
			normal_modalize('', template_html);
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
        url: "{$base_url}serverside/data/get_reselleroption.php",
        data: "uid="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
			var template_html = `<div class="form-group">
                            		<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-editcredit" data-id="`+u+`" tabindex="4">Edit Credit</button>
                            		<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-changepassword" data-id="`+u+`" data-username="`+data.username+`" tabindex="4">Change Password</button>
                            		<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-blockreseller" data-id="`+u+`" data-username="`+data.username+`" tabindex="4">Block Reseller</button>
                            		<button type="submit" class="btn btn-danger btn-lg btn-block btn-modal-deletereseller" data-id="`+u+`" data-username="`+data.username+`" tabindex="4">Delete Reseller</button>
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
    
function getResellerData() {
	$.ajax({
        url: "{$base_url}serverside/data/get_myinfo.php",
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            {if $user_id_2 != 1 || $user_level_2 != 'superadmin'}
    			if (data.mycredit < 5) {
                    $(".accountalert").html(`<div class="alert alert-warning alert-has-icon">
                          <div class="alert-icon"><i class="far fa-lightbulb"></i></div>
                          <div class="alert-body">
                            <div class="alert-title">Ohh no!</div>
                            Your remaining credit balance is getting low, Please contact your upline if you wish to reload.
                          </div>
                        </div>`)
                } else {
                    $(".accountalert").html('')
                }
            {/if}
            $(".profile-username").val(data.myusername)
            $(".profile-credits").val(data.mycredit)
            $(".profile-upline").val(data.myupline)
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
	
$('document').ready(function()
{
    
    function resellerTable() {
        $.fn.dataTable.ext.errMode = function() {
            Swal.fire({
                title: 'Error',
                icon: 'error',
                text: 'Failed getting table data from ajax.',
                timer: 3000
            });
        };
    	$('.table-listreseller').DataTable({
    	    responsive: true,
            processing: false,
            serverSide: true,
            deferRender: true,
            ajax: {
                url: "/reseller-serverside",
                type: "POST",
                error: function() {}
            },
            language: {
                infoFiltered: ""
            },
            order: [[ 0, 'desc' ]],
            columnDefs: [
                {
                  width: '20%',
                  targets: 0,
                },
                {
                  width: '20%',
                  targets: 1,
                },
                {
                  width: '20%',
                  targets: 2,
                },
                {
                  width: '20%',
                  targets: 3,
                },
                {
                  width: '20%',
                  targets: 4,
                },
                {
                  orderable: false,
                  targets: [1, 2, 3],
                },
            ],
    	});
    }
    
    function reinitializeTable() {
        if ($.fn.DataTable.isDataTable('.table-listreseller')) {
          $('.table-listreseller').DataTable().clear().destroy();
        }
    }
    
    resellerTable()
    getResellerData()
    
    //Edit Credit
    $(".normal-modalize").on("click", ".btn-modal-editcredit", function(e)
	{
		var userid = $(this).data("id");
		$.ajax({
            url: "{$base_url}serverside/data/get_creditinfo.php",
            data: "uid="+userid,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
                var template_html = `<form class="editcreditform" autocomplete="off">` +
                                        `<input type="hidden" name="_key" value="{$firenet_encrypt}">` +
        							    `<input type="hidden" name="id" value="`+userid+`">` +
        							    `<input type="hidden" name="submitted" value="edit_credit">` +
                                        `<div class="form-group"><label for="creditsupline">Your Credit</label><input id="creditsupline" class="form-control" type="text" value="`+data.mycredit+`" readonly></div>` +
                                        `<div class="form-group"><label for="creditsclient">Client Credit</label><input id="creditsclient" class="form-control" type="text" value="`+data.clientcredit+`" readonly></div>` +
                                        `<div class="form-group"><label for="creditamount">Amount</label><input id="creditamount" class="form-control" name="creditamount" type="number" min="0" value="0" required></div>` +
                                        `<div class="form-group" id="xxc"><label>Type</label>` +
                                        `<select class="form-control select2" name="credittype" id="credittype" data-minimum-results-for-search="-1">` +
                                        `<option value="add">Add</option>` +
                                        `<option value="deduct">Deduct</option>` +
                                        `</select>` +
                                        `</div>` +
                                        `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-editcredit" id="btn-editcredit" tabindex="4">Confirm</button></div>` +
                                        `</form>`;
        		normal_modalize('Edit Credits', template_html);
        		
        		$('#credittype').select2({
                    dropdownParent: $('.normal-modalize')
                });
        		
        		var $form1 = $('.editcreditform');
                	$form1.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/reseller/edit_credit.php",
                		data: $form1.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-editcredit").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
            					normalMessage('success', 'Success', data.msg);
            					$(".editcreditform").remove();
            				}
            				if(data.response == 2){
            					normalMessage('danger','Error', data.msg);
            				}
            				if(data.response == 3){
            					normalMessage('danger','Error', data.errormsg);
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
                			$('.table-listreseller').DataTable().ajax.reload();
            				$("#btn-editcredit").removeClass("btn-progress");
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
        		url: "{$base_url}serverside/forms/reseller/change_password.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-changepass").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
    					normalMessage('success', 'Success', data.msg);
    				}
    				if(data.response == 2){
    					normalMessage('danger','Error', data.msg);
    				}
    				if(data.response == 3){
    					normalMessage('danger','Error', data.errormsg);
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
        			$('.table-listreseller').DataTable().ajax.reload();
    				$(".changepassword").trigger("reset");
    				$(".changepassword").remove();
    				$("#btn-changepass").removeClass("btn-progress");
        		}
        	});
	})
	
	//Block Reseller
    $(".normal-modalize").on("click", ".btn-modal-blockreseller", function(e)
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
    			var template_html = `<form class="blockreseller" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="block_user">`
                        		+ `<input type="hidden" name="confirmblock" value="`+data.confirmblock+`">`
                        		+ `<p class="text-center">Do you want to `+data.proceedblock+` <code>`+data.username+`</code>?</p>`
                        		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-blockreseller" id="btn-blockreseller" tabindex="4">Confirm</button></div>`
                        		+ `</form>`;
        		normal_modalize(blockstatus +' Reseller', template_html);
        		
        		var $form = $('.blockreseller');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/reseller/block_reseller.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-blockreseller").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
            					normalMessage('success', 'Success', data.msg);
            				}
            				if(data.response == 2){
            					normalMessage('danger','Error', data.msg);
            				}
            				if(data.response == 3){
            					normalMessage('danger','Error', data.errormsg);
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
                			$('.table-listreseller').DataTable().ajax.reload();
            				$(".blockreseller").remove();
            				$("#btn-blockreseller").removeClass("btn-progress");
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
    
    //Reseller Delete
    $(".normal-modalize").on("click", ".btn-modal-deletereseller", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<form class="deletereseller" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="delete_user">`
                        		+ `<div class="form-group"><label for="username">Username</label><input id="username" class="form-control" type="text" value="`+username+`" readonly></div>`
                        		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-deletereseller" id="btn-deletereseller" tabindex="4">Confirm</button></div>`
                        		+ `</form>`;
		normal_modalize('Delete', template_html);
		
		var $form = $('.deletereseller');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/reseller/delete_reseller.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-deletereseller").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
    					normalMessage('success', 'Success', data.msg);
    				}
    				if(data.response == 2){
    					normalMessage('danger','Error', data.msg);
    				}
    				if(data.response == 3){
    					normalMessage('danger','Error', data.errormsg);
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
        			$('.table-listreseller').DataTable().ajax.reload();
    				$(".deletereseller").remove();
    				$("#btn-deletereseller").removeClass("btn-progress");
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
});
</script>