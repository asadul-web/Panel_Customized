<script>
function search_modalize(title, body) {
		$(".search-modalize").modal({
			backdrop: "static"
		});
		$(".search-modal-title").html(title);
		$(".search-modal-html").html(body);
	}

function searchMessage(type,title,message)
	{
		$(".useroption").html('').append('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><div class="alert-title">'+title+'</div>'+message+'</div></div><div class="form-group"><button type="button" class="btn btn-primary btn-lg btn-block btn-alertdone" id="btn-alertdone" tabindex="4">Done</button></div>').slideDown();
	}
	
//Get Account
function searchuser(u)
	{
	    $.ajax({
        url: "{$base_url}serverside/data/search/get_result.php",
        data: "uid="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            if(data.userlevel == 'reseller'){
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
                                        </div>   
                                        <div class="form-group useroption">
                                    		<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-research-editcredit" data-id="`+u+`" tabindex="4">Edit Credit</button>
                                    		<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-research-changepassword" data-id="`+u+`" data-username="`+data.username+`" tabindex="4">Change Password</button>
                                    		<button type="submit" class="btn btn-`+data.freezecolor+` btn-lg btn-block btn-modal-research-blockreseller" data-id="`+u+`" data-username="`+data.username+`" data-freezestatus="`+data.freezestatus+`" tabindex="4">`+data.freezestatus+` Reseller</button>
                                    		<button type="submit" class="btn btn-danger btn-lg btn-block btn-modal-research-deletereseller" data-id="`+u+`" data-username="`+data.username+`" tabindex="4">Delete Reseller</button>
                                	    </div>
                                    </div>`
            }else if(data.userlevel == 'normal' || data.userlevel == 'bulk' || data.userlevel == 'trial'){
                var template_html = `<div class="form-group">
    						            <div class="card profile-widget">
                                          <div class="profile-widget-header">
                                            `+data.upic+`
                                            <div class="profile-widget-items">
                                              <div class="profile-widget-item">
                                                <div class="profile-widget-item-label">User Level</div>
                                                <div class="profile-widget-item-value">`+data.subscription+`</div>
                                              </div>
                                              <div class="profile-widget-item">
                                                <div class="profile-widget-item-label">Expiration</div>
                                                <div class="profile-widget-item-value">`+data.expired+`</div>
                                              </div>
                                            </div>
                                          </div>
                                        </div>   
                                        <div class="form-group useroption">
                                    		<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-search-changepassword" tabindex="4" data-id="`+u+`" data-username="`+data.username+`">Change Password</button>
                                        	<button type="submit" class="btn btn-`+data.freezecolor+` btn-lg btn-block btn-modal-search-blockuser" data-id="`+u+`" data-username="`+data.username+`" data-freezestatus="`+data.freezestatus+`" tabindex="4">`+data.freezestatus+` User</button>
                                        	<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-search-sessionreset" tabindex="4" data-id="`+u+`" data-username="`+data.username+`">Session Reset</button>
                                        	<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-search-devicereset" tabindex="4" data-id="`+u+`" data-username="`+data.username+`">Device Reset</button>
                                        	<button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-search-extendduration" tabindex="4" data-id="`+u+`">Extend Duration</button>
                                        	<button type="submit" class="btn btn-`+data.socksipcolor+` btn-lg btn-block btn-modal-search-socksip" data-id="`+u+`" data-username="`+data.username+`" data-socksipstatus="`+data.socksipstatus+`" data-confirmsocksip="`+data.confirmsocksip+`" data-proceedsocksip="`+data.proceedsocksip+`" data-socksipinfo="`+data.socksipinfo+`" tabindex="4">`+data.socksipstatus+` SocksIP</button>
                                        	<button type="submit" class="btn btn-danger btn-lg btn-block btn-modal-search-deleteuser" tabindex="4" data-id="`+u+`" data-username="`+data.username+`">Delete User</button>
                                	    </div>
                                    </div>`
            }
			search_modalize('Username: '+data.username, template_html);
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
            $(".mr-auto").trigger("reset")
            $(".search-result").addClass("d-none")
		}
    });
}

$('document').ready(function()
{
    
    $('.data-search').keyup(function(e) {
        if($('.data-search').val() == ''){

            $(".mr-auto").trigger("reset")
            $(".search-result").addClass("d-none")
        }else{
            
            var search_val = $('.data-search').val();
		
    		$.ajax({
                type: "POST",
                url: "/serverside/data/search/get_search.php",
                data: {
                	search: search_val
                },
                dataType: "JSON",
        		cache: false,
        		beforeSend: function() {
                    $('#icon-fa').removeClass('fa-search');
                    $('#icon-fa').addClass('fa-spinner fa-spin');
        		},
                success: function(data){
                	if(data.response == 1){
            			$(".search--item").html(data.ulist).show();
            			$('.search-result').removeClass('d-none');
            		}
            		if(data.response == 2){
            			$(".search--item").html('<div class="search-item"><a href="#">No result found.</a></div>').show();
            		}
                },
                error: function(jqXHR, textStatus, errorThrown) {
                			
                },
                complete: function(){
                    $('#icon-fa').removeClass('fa-spinner fa-spin');
                    $('#icon-fa').addClass('fa-search');
                }
            });
        }
    });
    
    //Change Password
    $(".search-modalize").on("click", ".btn-modal-search-changepassword", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<div class="form-group user-changepass">`
		                + `<form class="changepassword" method="post" autocomplete="off">`
						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
						+ `<input type="hidden" name="id" value="`+userid+`">`
						+ `<input type="hidden" name="submitted" value="change_password">`
						+ `<div class="form-group"><label for="newpassword">New Password</label><input id="newpassword" class="form-control" name="newpassword" type="text"></div>`
						+ `<div class="form-group">
        						<button type="submit" class="btn btn-primary btn-lg btn-block btn-changepass" id="btn-changepass" tabindex="4">Confirm</button>
        						<button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
    						</div>`
						+ `</form>`;
		$(".useroption").html(template_html);
		
		$(".btn-changepasscancel").on("click", function(e) {
            searchuser(userid);
        });
		
		var $form = $('.changepassword');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/data/search/change_password.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-changepass").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
        			    $(".useroption").html(searchMessage('success','Success', data.msg));
    				}
    				if(data.response == 2){
    					$(".useroption").html(searchMessage('danger','Error', data.msg));
    				}
    				if(data.response == 3){
    					$(".useroption").html(searchMessage('danger','Error', data.errormsg));
    				}
    				
    				$(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			$(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
        			
        			$(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
        		},
        		complete: function(){
    				$(".changepassword").trigger("reset")
    				$("#btn-changepass").removeClass("btn-progress");
        		}
        	});
	})
	
	//Block User
    $(".search-modalize").on("click", ".btn-modal-search-blockuser", function(e)
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
                        		+ `<div class="form-group">
                        		        <button type="submit" class="btn btn-primary btn-lg btn-block btn-blockuser" id="btn-blockuser" tabindex="4">Confirm</button>
                        		        <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
                        		  </div>`
                        		+ `</form>`;
        		$(".useroption").html(template_html);
		
        		$(".btn-changepasscancel").on("click", function(e) {
                    searchuser(userid);
                });
        		
        		var $form = $('.blockuser');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/data/search/block_user.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-blockuser").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
            					$(".useroption").html(searchMessage('success','Success', data.msg));
            				}
            				if(data.response == 2){
            					$(".useroption").html(searchMessage('danger','Error', data.msg));
            				}
            				if(data.response == 3){
            					$(".useroption").html(searchMessage('danger','Error', data.errormsg));
            				}
            				
            				$(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                		},
                		error: function(jqXHR, textStatus, errorThrown) {
                			$(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
        			
                			$(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                		},
                		complete: function(){
            				$(".blockuser").remove();
            				$("#btn-blockuser").removeClass("btn-progress");
                		}
                	});
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                $(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
        			
                $(".btn-alertdone").on("click", function(e) {
                    searchuser(userid);
                });
            },
            complete: function(){
    
    		}
        });
	})
	
	//Session Reset
    $(".search-modalize").on("click", ".btn-modal-search-sessionreset", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<form class="sessionreset" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="session_reset">`
                        		+ `<p class="text-center">Proceed resetting <code>`+username+`'s</code> vpn session ?</p>`
                        		+ `<div class="form-group">
                        		        <button type="submit" class="btn btn-primary btn-lg btn-block btn-session" id="btn-session" tabindex="4">Confirm</button>
                        		        <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
                        		  </div>`
                        		+ `</form>`;
		$(".useroption").html(template_html);
		
        $(".btn-changepasscancel").on("click", function(e) {
            searchuser(userid);
        });
		
		var $form = $('.sessionreset');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/data/search/session_reset.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-session").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
            			$(".useroption").html(searchMessage('success','Success', data.msg));
            		}
            		if(data.response == 2){
            			$(".useroption").html(searchMessage('danger','Error', data.msg));
            		}
            		if(data.response == 3){
            			$(".useroption").html(searchMessage('danger','Error', data.errormsg));
            		}
            				
            		$(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			$(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
        			
                	$(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
        		},
        		complete: function(){
        			$(".sessionreset").remove();
    				$("#btn-session").removeClass("btn-progress");
        		}
        	});
	})
	
	//Device Reset
    $(".search-modalize").on("click", ".btn-modal-search-devicereset", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<form class="devicereset" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="device_reset">`
                        		+ `<p class="text-center">Proceed resetting <code>`+username+`'s</code> device ?</p>`
                        		+ `<div class="form-group">
                        		        <button type="submit" class="btn btn-primary btn-lg btn-block btn-device" id="btn-device" tabindex="4">Confirm</button>
                        		        <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
                        		  </div>`
                        		+ `</form>`;
		$(".useroption").html(template_html);
		
        $(".btn-changepasscancel").on("click", function(e) {
            searchuser(userid);
        });
		
		var $form = $('.devicereset');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/data/search/device_reset.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-device").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
            			$(".useroption").html(searchMessage('success','Success', data.msg));
            		}
            		if(data.response == 2){
            			$(".useroption").html(searchMessage('danger','Error', data.msg));
            		}
            		if(data.response == 3){
            			$(".useroption").html(searchMessage('danger','Error', data.errormsg));
            		}
            				
            		$(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			$(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
        			
                	$(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
        		},
        		complete: function(){
    				$(".devicereset").remove();
    				$("#btn-device").removeClass("btn-progress");
        		}
        	});
	})
	
	//Extend User
    $(".search-modalize").on("click", ".btn-modal-search-extendduration", function(e)
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
    					+ `<div class="form-group">
    					        <button type="submit" class="btn btn-primary btn-lg btn-block btn-extend" id="btn-extend" tabindex="4">Confirm</button>
    					        <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
    					   </div>`
    					+ `</form>`;
    				}
    			$(".useroption").html(template_html);
		
                $(".btn-changepasscancel").on("click", function(e) {
                    searchuser(userid);
                });
        		
        		$('#duration').select2({
                    dropdownParent: $('.useroption')
                });
                
        		var $form = $('.extendduration');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/data/search/extend_user.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-extend").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
                    			$(".useroption").html(searchMessage('success','Success', data.msg));
                    		}
                    		if(data.response == 2){
                    			$(".useroption").html(searchMessage('danger','Error', data.msg));
                    		}
                    		if(data.response == 3){
                    			$(".useroption").html(searchMessage('danger','Error', data.errormsg));
                    		}
                    				
                    		$(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                		},
                		error: function(jqXHR, textStatus, errorThrown) {
                			$(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
                			
                        	$(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                		},
                		complete: function(){
            				$(".extendduration").remove();
            				$("#btn-extend").removeClass("btn-progress");
                		}
                	});
            },
            error: function(jqXHR, textStatus, errorThrown) {
                $(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
                			
                $(".btn-alertdone").on("click", function(e) {
                    searchuser(userid);
                });
            },
            complete: function(){
    
    		}
        });
	})
	
	//SocksIP
    $(".search-modalize").on("click", ".btn-modal-search-socksip", function(e)
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
                                		+ `<div class="form-group">
                                		        <button type="submit" class="btn btn-primary btn-lg btn-block btn-socksip" id="btn-socksip" tabindex="4">Confirm</button>
                                		        <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
                                		  </div>`
                                		+ `</form>`;
        		$(".useroption").html(template_html);
		
                $(".btn-changepasscancel").on("click", function(e) {
                    searchuser(userid);
                });
        		
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
                    			$(".useroption").html(searchMessage('success','Success', data.msg));
                    		}
                    		if(data.response == 2){
                    			$(".useroption").html(searchMessage('danger','Error', data.msg));
                    		}
                    		if(data.response == 3){
                    			$(".useroption").html(searchMessage('danger','Error', data.errormsg));
                    		}
                    				
                    		$(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                		},
                		error: function(jqXHR, textStatus, errorThrown) {
                			$(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
                			
                        	$(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                		},
                		complete: function(){
            				$(".socksip").remove();
            				$("#btn-socksip").removeClass("btn-progress");
                		}
                	});
            },
            error: function(jqXHR, textStatus, errorThrown) {
                $(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
                			
                $(".btn-alertdone").on("click", function(e) {
                    searchuser(userid);
                });
            },
            complete: function(){
    
    		}
        });
	})
	
	//User Delete
    $(".search-modalize").on("click", ".btn-modal-search-deleteuser", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<form class="deleteuser" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="delete_user">`
                        		+ `<div class="form-group"><label for="username">Username</label><input id="username" class="form-control" type="text" value="`+username+`" readonly></div>`
                        		+ `<div class="form-group">
                        		        <button type="submit" class="btn btn-primary btn-lg btn-block btn-deleteuser" id="btn-deleteuser" tabindex="4">Confirm</button>
                        		        <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
                        		  </div>`
                        		+ `</form>`;
		$(".useroption").html(template_html);
		
        $(".btn-changepasscancel").on("click", function(e) {
            searchuser(userid);
        });
		
		var $form = $('.deleteuser');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/data/search/delete_user.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-deleteuser").addClass("btn-progress");
        		},
        		success: function(data){
                    if(data.response == 1){
                        $(".useroption").html(searchMessage('success','Success', data.msg));
                        
                        $(".btn-alertdone").on("click", function(e) {
                            location.reload();
                        });
                    }
                    if(data.response == 2){
                        $(".useroption").html(searchMessage('danger','Error', data.msg));
                        
                        $(".btn-alertdone").on("click", function(e) {
                            searchuser(userid);
                        });
                    }
                    if(data.response == 3){
                        $(".useroption").html(searchMessage('danger','Error', data.errormsg));
                        
                        $(".btn-alertdone").on("click", function(e) {
                            searchuser(userid);
                        });
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    $(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
                    			
                    $(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
                },
        		complete: function(){
    				$(".deleteuser").remove();
    				$("#btn-deleteuser").removeClass("btn-progress");
        		}
        	});
	})
	
	//Edit Credit
    $(".search-modalize").on("click", ".btn-modal-research-editcredit", function(e)
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
                                        `<div class="form-group">
                                            <button type="submit" class="btn btn-primary btn-lg btn-block btn-editcredit" id="btn-editcredit" tabindex="4">Confirm</button>
                                            <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
                                        </div>` +
                                        `</form>`;
        		$(".useroption").html(template_html);
		        
		        $('#credittype').select2({
                    dropdownParent: $('.useroption')
                });
		        
        		$(".btn-changepasscancel").on("click", function(e) {
                    searchuser(userid);
                });
                
        		var $form1 = $('.editcreditform');
                	$form1.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/data/search/edit_credit.php",
                		data: $form1.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-editcredit").addClass("btn-progress");
                		},
                		success: function(data){
                            if(data.response == 1){
                                $(".useroption").html(searchMessage('success','Success', data.msg));
                            }
                            if(data.response == 2){
                                $(".useroption").html(searchMessage('danger','Error', data.msg));
                            }
                            if(data.response == 3){
                                $(".useroption").html(searchMessage('danger','Error', data.errormsg));
                            }
                                				
                            $(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            $(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
                            			
                            $(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                        },
                		complete: function(){
            				$("#btn-editcredit").removeClass("btn-progress");
                		}
                	});
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                $(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
                            			
                $(".btn-alertdone").on("click", function(e) {
                    searchuser(userid);
                });
            },
            complete: function(){
    
    		}
        });
	})
	
	//Change Reseller Password
    $(".search-modalize").on("click", ".btn-modal-research-changepassword", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<div class="form-group user-changepass">`
		                + `<form class="changepassword" method="post" autocomplete="off">`
						+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
						+ `<input type="hidden" name="id" value="`+userid+`">`
						+ `<input type="hidden" name="submitted" value="change_password">`
						+ `<div class="form-group"><label for="newpassword">New Password</label><input id="newpassword" class="form-control" name="newpassword" type="text"></div>`
						+ `<div class="form-group">
        						<button type="submit" class="btn btn-primary btn-lg btn-block btn-changepass" id="btn-changepass" tabindex="4">Confirm</button>
        						<button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
    						</div>`
						+ `</form>`;
		$(".useroption").html(template_html);
		
		$(".btn-changepasscancel").on("click", function(e) {
            searchuser(userid);
        });
		
		var $form = $('.changepassword');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/data/search/rchange_password.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-changepass").addClass("btn-progress");
        		},
        		success: function(data){
        			if(data.response == 1){
        			    $(".useroption").html(searchMessage('success','Success', data.msg));
    				}
    				if(data.response == 2){
    					$(".useroption").html(searchMessage('danger','Error', data.msg));
    				}
    				if(data.response == 3){
    					$(".useroption").html(searchMessage('danger','Error', data.errormsg));
    				}
    				
    				$(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			$(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
        			
        			$(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
        		},
        		complete: function(){
    				$(".changepassword").trigger("reset")
    				$("#btn-changepass").removeClass("btn-progress");
        		}
        	});
	})
	
	//Block Reseller
    $(".search-modalize").on("click", ".btn-modal-research-blockreseller", function(e)
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
                        		+ `<div class="form-group">
                        		        <button type="submit" class="btn btn-primary btn-lg btn-block btn-blockuser" id="btn-blockuser" tabindex="4">Confirm</button>
                        		        <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
                        		  </div>`
                        		+ `</form>`;
        		$(".useroption").html(template_html);
		
        		$(".btn-changepasscancel").on("click", function(e) {
                    searchuser(userid);
                });
        		
        		var $form = $('.blockuser');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/data/search/block_reseller.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$("#btn-blockuser").addClass("btn-progress");
                		},
                		success: function(data){
                			if(data.response == 1){
            					$(".useroption").html(searchMessage('success','Success', data.msg));
            				}
            				if(data.response == 2){
            					$(".useroption").html(searchMessage('danger','Error', data.msg));
            				}
            				if(data.response == 3){
            					$(".useroption").html(searchMessage('danger','Error', data.errormsg));
            				}
            				
            				$(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                		},
                		error: function(jqXHR, textStatus, errorThrown) {
                			$(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
        			
                			$(".btn-alertdone").on("click", function(e) {
                                searchuser(userid);
                            });
                		},
                		complete: function(){
            				$(".blockuser").remove();
            				$("#btn-blockuser").removeClass("btn-progress");
                		}
                	});
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                $(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
        			
                $(".btn-alertdone").on("click", function(e) {
                    searchuser(userid);
                });
            },
            complete: function(){
    
    		}
        });
	})
	
	//Delete Reseller
    $(".search-modalize").on("click", ".btn-modal-research-deletereseller", function(e)
	{
		var userid = $(this).data("id");
		var username = $(this).data("username");

		var template_html = `<form class="deletereseller" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+userid+`">`
                        		+ `<input type="hidden" name="submitted" value="delete_user">`
                        		+ `<p class="text-center">Do you want to delete <code>`+username+`</code>?</p>`
                        		+ `<div class="form-group">
                        		        <button type="submit" class="btn btn-primary btn-lg btn-block btn-deletereseller" id="btn-deletereseller" tabindex="4">Confirm</button>
                        		        <button type="button" class="btn btn-secondary btn-lg btn-block btn-changepasscancel" id="btn-changepasscancel" tabindex="4">Cancel</button>
                        		  </div>`
                        		+ `</form>`;
		$(".useroption").html(template_html);
		
        $(".btn-changepasscancel").on("click", function(e) {
            searchuser(userid);
        });
		
		var $form = $('.deletereseller');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/data/search/delete_reseller.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-deletereseller").addClass("btn-progress");
        		},
        		success: function(data){
                    if(data.response == 1){
                        $(".useroption").html(searchMessage('success','Success', data.msg));
                        
                        $(".btn-alertdone").on("click", function(e) {
                            location.reload();
                        });
                    }
                    if(data.response == 2){
                        $(".useroption").html(searchMessage('danger','Error', data.msg));
                        
                        $(".btn-alertdone").on("click", function(e) {
                            searchuser(userid);
                        });
                    }
                    if(data.response == 3){
                        $(".useroption").html(searchMessage('danger','Error', data.errormsg));
                        
                        $(".btn-alertdone").on("click", function(e) {
                            searchuser(userid);
                        });
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    $(".useroption").html(searchMessage('danger','Error', 'Failed getting data from AJAX.'));
                    			
                    $(".btn-alertdone").on("click", function(e) {
                        searchuser(userid);
                    });
                },
        		complete: function(){
    				$(".deletereseller").remove();
    				$("#btn-deletereseller").removeClass("btn-progress");
        		}
        	});
	})
});
</script>