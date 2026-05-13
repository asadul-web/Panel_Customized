<script>
function modalize(title, body)
	{
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

function formatServerType(option) {
    if (!option.id) {
        return option.text;
    }
    
    var $option = $(option.element);
    var text = option.text;
    var os = $option.data('os') || '';
    
    // Determine icon and color based on data-os attribute
    if (os === 'debian') {
        return '<i class="fab fa-linux" style="color: #D70A53; margin-right: 6px; font-size: 12px;"></i>' + text;
    } else if (os === 'ubuntu') {
        return '<i class="fab fa-ubuntu" style="color: #E95420; margin-right: 6px; font-size: 12px;"></i>' + text;
    }
    
    return '<i class="fas fa-server" style="color: #6c757d; margin-right: 6px; font-size: 12px;"></i>' + text;
}

function get_permission() {
	$.ajax({
        url: "{$base_url}serverside/data/get_updates.php",
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            if(data.allowinstall == false){
				$(".add-server-alert").removeClass('d-none')
			}else{
				$(".add-server").removeClass('d-none')
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
        },
        complete: function(){

		}
    });
}

$('document').ready(function()
{
    // Initialize Select2 for Server Type dropdown with Panel v9 styling
    $('.select2-server-type').select2({
        placeholder: 'Select Server Type',
        allowClear: false,
        width: '100%',
        minimumResultsForSearch: Infinity,
        templateResult: formatServerType,
        templateSelection: formatServerType,
        escapeMarkup: function(markup) {
            return markup;
        }
    });
    
    // Fix selection issue by ensuring proper event handling
    $('#servertype').on('select2:select', function (e) {
        var data = e.params.data;
        $(this).val(data.id).trigger('change');
    });

    $.fn.dataTable.ext.errMode = () => swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
        button: false,
        closeOnClickOutside: false,
        timer: 3000
    }).then(() => {
        location.reload()
    });
	var table = $('.table-listserver').dataTable({
        "bProcessing": false,
        "bServerSide": true,
        "ajax": {
            "url": "/server-serverside",
            "type": "POST"
        },
        "order": [[ 0, "desc" ]],
        "language": {                
                "infoFiltered": ""
            },
        columnDefs: [
            {
              width: '1%',
              targets: 0,
            },
            {
              width: '10%',
              targets: 1,
            },
            {
              width: '10%',
              targets: 2,
            },
            {
              width: '10%',
              targets: 3,
            },
            {
              width: '10%',
              targets: 4,
            },
            {
              width: '10%',
              targets: 5,
            },
            {
              orderable: false,
              targets: 0,
            },
            {
              orderable: true,
              targets: 1,
            },
            {
              orderable: false,
              targets: 2,
            },
            {
              orderable: true,
              targets: 3,
            },
            {
              orderable: false,
              targets: 4,
            },
            {
              orderable: false,
              targets: 5,
            },
        ],
	});
	
	let servertcp = $("#servertcp")
	let serverudp = $("#serverudp")
	let serverssl = $("#serverssl")
	let servervless = $("#servervless")
	let servertype = $("#servertype")
	let hysteriatype = $("#hysteriatype")
	let serverobfs = $("#serverobfs")
	let serverauthstr = $("#serverauthstr")
	let v2rayalert = $(".add-server-message")
	let ultimatealert = $(".add-ultimate-message")
    
    servertcp.prop("readonly", false)
	serverudp.prop("readonly", false)
	serverssl.prop("readonly", false)
	servervless.prop("readonly", true)
	hysteriatype.prop("disabled", false)
	serverobfs.prop("readonly", false)
	serverauthstr.prop("readonly", true)
	servertcp.val('1194')
	serverudp.val('110')
	serverssl.val('443')
	servervless.val('None')
	serverobfs.val('vollam')
	serverauthstr.val('None')
			
	servertype.change(function (){
		if(servertype.val() === "1" || servertype.val() === "4" || servertype.val() === "8" || servertype.val() === "11" || servertype.val() === "15" || servertype.val() === "18"){
			servertcp.prop("readonly", false)
			serverudp.prop("readonly", false)
			serverssl.prop("readonly", false)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", false)
			serverobfs.prop("readonly", false)
			serverauthstr.prop("readonly", true)
			servertcp.val('1194')
			serverudp.val('110')
			serverssl.val('443')
			servervless.val('None')
			serverobfs.val('vollam')
			serverauthstr.val('None')
			v2rayalert.addClass('d-none');
			ultimatealert.addClass('d-none');
		}else if(servertype.val() === "2" || servertype.val() === "9" || servertype.val() === "12"){
			servertcp.prop("readonly", false)
			serverudp.prop("readonly", true)
			serverssl.prop("readonly", false)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", false)
			serverobfs.prop("readonly", false)
			serverauthstr.prop("readonly", true)
			servertcp.val('1194')
			serverudp.val('None')
			serverssl.val('443')
			servervless.val('None')
			serverobfs.val('vollam')
			serverauthstr.val('None')
			v2rayalert.addClass('d-none');
			ultimatealert.addClass('d-none');
		}else if(servertype.val() === "13"){
			servertcp.prop("readonly", false)
			serverudp.prop("readonly", false)
			serverssl.prop("readonly", false)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", false)
			serverobfs.prop("readonly", false)
			serverauthstr.prop("readonly", true)
			servertcp.val('1194')
			serverudp.val('110')
			serverssl.val('443')
			servervless.val('None')
			serverobfs.val('vollam')
			serverauthstr.val('None')
		}else if(servertype.val() === "5"){
			servertcp.prop("readonly", false)
			serverudp.prop("readonly", false)
			serverssl.prop("readonly", false)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", false)
			serverobfs.prop("readonly", false)
			serverauthstr.prop("readonly", true)
			servertcp.val('1194')
			serverudp.val('110')
			serverssl.val('443')
			servervless.val('None')
			serverobfs.val('vollam')
			serverauthstr.val('None')
			v2rayalert.addClass('d-none');
			ultimatealert.addClass('d-none');
		}else if(servertype.val() === "31" || servertype.val() === "7"){
			servertcp.prop("readonly", true)
			serverudp.prop("readonly", true)
			serverssl.prop("readonly", true)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", true)
			serverobfs.prop("readonly", true)
			serverauthstr.prop("readonly", true)
			servertcp.val('None')
			serverudp.val('None')
			serverssl.val('None')
			servervless.val('None')
			serverobfs.val('None')
			serverauthstr.val('None')
			v2rayalert.removeClass('d-none');
			ultimatealert.addClass('d-none');
		}else if(servertype.val() === "41" || servertype.val() === "42" || servertype.val() === "43"){
			servertcp.prop("readonly", true)
			serverudp.prop("readonly", true)
			serverssl.prop("readonly", true)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", false)
			serverobfs.prop("readonly", false)
			serverauthstr.prop("readonly", true)
			servertcp.val('None')
			serverudp.val('None')
			serverssl.val('None')
			servervless.val('None')
			serverobfs.val('vollam')
			serverauthstr.val('None')
			v2rayalert.addClass('d-none');
			ultimatealert.addClass('d-none');
		}else if(servertype.val() === "61" || servertype.val() === "62" || servertype.val() === "63"){
			servertcp.prop("readonly", true)
			serverudp.prop("readonly", true)
			serverssl.prop("readonly", true)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", false)
			serverobfs.prop("readonly", false)
			serverauthstr.prop("readonly", false)
			servertcp.val('None')
			serverudp.val('None')
			serverssl.val('None')
			servervless.val('None')
			serverobfs.val('vollam')
			serverauthstr.val('vollam')
			v2rayalert.addClass('d-none');
			ultimatealert.addClass('d-none');
		}else if(servertype.val() === "81" || servertype.val() === "91"){
			servertcp.prop("readonly", true)
			serverudp.prop("readonly", true)
			serverssl.prop("readonly", true)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", true)
			serverobfs.prop("readonly", true)
			serverauthstr.prop("readonly", true)
			servertcp.val('None')
			serverudp.val('None')
			serverssl.val('None')
			servervless.val('None')
			serverobfs.val('None')
			serverauthstr.val('None')
			v2rayalert.removeClass('d-none');
			ultimatealert.addClass('d-none');
		}else if(servertype.val() === "99"){
			servertcp.prop("readonly", false)
			serverudp.prop("readonly", false)
			serverssl.prop("readonly", false)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", false)
			serverobfs.prop("readonly", false)
			serverauthstr.prop("readonly", false)
			servertcp.val('1194')
			serverudp.val('110')
			serverssl.val('443')
			servervless.val('None')
			serverobfs.val('vollam')
			serverauthstr.val('vollam')
			v2rayalert.addClass('d-none');
			ultimatealert.removeClass('d-none');
		}else{
			servertcp.prop("readonly", true)
			serverudp.prop("readonly", true)
			serverssl.prop("readonly", true)
			servervless.prop("readonly", true)
			hysteriatype.prop("disabled", true)
			serverobfs.prop("readonly", true)
			serverauthstr.prop("readonly", true)
			servertcp.val('None')
			serverudp.val('None')
			serverssl.val('None')
			servervless.val('None')
			hysteriatype.val('None')
			serverobfs.val('None')
			serverauthstr.val('None')
			v2rayalert.addClass('d-none');
			ultimatealert.addClass('d-none');
		}
	})
	
	var $form = $('.add-server');
	$form.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/add_server.php",
		data: $form.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".btn-add-server").addClass("btn-progress")
		},
		success: function(data){
			if(data.response == 1){
    			errorMessage('success', 'Success', data.msg);
    			$(".add-server").trigger("reset");
    			table.DataTable().ajax.reload();
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
			$(".btn-add-server").removeClass("btn-progress")
			$(".add-server").trigger("reset");
			v2rayalert.addClass('d-none');
			ultimatealert.addClass('d-none');
		}
	});
	
	$(".btn-reset").click(function(){
		$(".add-server").trigger("reset");
	})
	
	//status
	$(".table-listserver").on("click", ".btn-server-stats", function(e)
	{
		let template_html = ''
        let serverip = $(this).data("ip");
        modalize('Statistics', 'Getting information...');
		
        $.ajax({
            url: "{$base_url}serverside/data/get_server.php",
            data: "server_ip="+serverip,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			if(data.response == 1){
        		    template_html = data.proto +
        		                    data.ipaddress +
        		                    data.bandwidth +
        		                    data.distro +
        		                    data.cpu_model +
        		                    data.memory +
        		                    data.disk +
        		                    data.uptime +
        		                    data.ssh_status +
        		                    data.dropbear_status +
        		                    data.slowdns_status +
        		                    data.hysteria_status +
        		                    data.xray_tls +
        		                    data.xray_ntls +
        		                    data.tcp_status +
        		                    data.udp_status +
        		                    data.tcpssl +
        		                    data.udpssl +
        		                    data.socksip_status +
        		                    data.squid3 +
        		                    data.httpstatus +
        		                    data.svrinfo +
        		                    data.vmess_link +
        		                    data.vless_link +
        		                    data.trojan_link +
        		                    data.ss_link
    			    modalize('Statistics', template_html);
    			}
    			if(data.response == 2){
    				modalize('Oops...', `<div class="alert alert-danger" role="alert">`+data.msg+`</div>`);
    			}
    			if(data.response == 3){
    				modalize('Oops...', `<div class="alert alert-danger" role="alert">`+data.errormsg+`</div>`);
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
            },
            complete: function(){
    
    		}
        });
	})
	
	//reset
	$(".table-listserver").on("click", ".btn-server-restart", function(e)
	{
		let serverip = $(this).data("ip");
		let servername = $(this).data("name");
		let template_html = `<form class="restartform" autocomplete="off">`
                			+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                			+ `<input type="hidden" name="submitted" value="server_restart">`
                			+ `<input type="hidden" name="serverip" value="`+serverip+`">`
                			+ `<input type="hidden" name="servername" value="`+servername+`">`
                			+ `<p>Are you sure you want to restart server <code>`+servername+`</code> ?</p>`
                			+ `<div class="form-group"><button type="submit" class="btn btn-warning btn-lg btn-block btn-modal" tabindex="4">Restart</button></div>`
                			+ `</form>`;
		modalize('Restart', template_html);
		
		var $form = $('.restartform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/restart_server.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$(".btn-modal").addClass("btn-progress");
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
        		    $(".restartform").remove();
				    $('.table-listserver').DataTable().ajax.reload( null, false );
        		}
        	});
	})
	
	//delete
	$(".table-listserver").on("click", ".btn-server-delete", function(e)
	{
		let serverip = $(this).data("ip");
		let servername = $(this).data("name");
		let servertype = $(this).data("type");
		
		let template_html = `<form class="deleteform" autocomplete="off">`
                			+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                			+ `<input type="hidden" name="submitted" value="server_delete">`
                			+ `<input type="hidden" name="serverip" value="`+serverip+`">`
                			+ `<input type="hidden" name="servername" value="`+servername+`">`
                			+ `<p><strong>Are you sure you want to delete server?</strong> <br><br><code>`+servertype+` - `+servername+` - `+serverip+`</code><br><br></p>`
                			+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-modal" tabindex="4">Confirm</button></div><div class="text-center" style="color: orange"><small>The DNS RECORDS of this server will be deleted automatically.</small></div>`
                			+ `</form>`;
        modalize('Delete', template_html);
		
		var $form = $('.deleteform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/delete_server.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$(".btn-modal").addClass("btn-progress");
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
        		    $(".deleteform").remove();
				    $('.table-listserver').DataTable().ajax.reload( null, false );
        		}
        	});
	})
	
	$(".btn-vps").on("click", function()
	{
		let template = `
            		<p>Step 1 : Click the buttons below to avail this promos</p>
            		<p>Step 2 : Register as new user to activate this promos!</p>
            		<a href="https://m.do.co/c/b23dca2b7de6" target="_blank" class="btn btn-primary btn-block">Digital Ocean FREE $100 (New User)</a>
            		<a href="https://www.vultr.com/?ref=8824988-6G" target="_blank" class="btn btn-primary btn-block">Vultr FREE $100 (New User)</a>
            		<a href="https://www.vultr.com/?ref=8691668" target="_blank" class="btn btn-primary btn-block">Vultr FREE $25 (New User)</a>
            		<a href="https://hetzner.cloud/?ref=4gAvMLRqQqQv" target="_blank" class="btn btn-primary btn-block">Hetzner FREE €20 (New User)</a>`
        modalize('Vps Promo!', template);
	})
	
	// Click to copy all protocol info
	$(document).on('click', '.copy-all-ports', function() {
		var $button = $(this);
		var infoText = $('#ultimate-protocols-info').text().trim();
		
		// Create temporary textarea to copy text
		var $temp = $("<textarea>");
		$("body").append($temp);
		$temp.val(infoText).select();
		document.execCommand("copy");
		$temp.remove();
		
		// Visual feedback
		var originalHTML = $button.html();
		$button.html('<i class="fas fa-check"></i> Copied!');
		$button.removeClass('btn-primary').addClass('btn-success');
		
		setTimeout(function() {
			$button.html(originalHTML);
			$button.removeClass('btn-success').addClass('btn-primary');
		}, 2000);
	});
	
	// Click to copy port functionality
	$(document).on('click', '.copy-port', function() {
		var port = $(this).data('port');
		var $badge = $(this);
		
		// Create temporary input to copy text
		var $temp = $("<input>");
		$("body").append($temp);
		$temp.val(port).select();
		document.execCommand("copy");
		$temp.remove();
		
		// Visual feedback
		var originalHTML = $badge.html();
		$badge.html('<i class="fas fa-check"></i> Copied!');
		$badge.removeClass('badge-dark').addClass('badge-success');
		
		setTimeout(function() {
			$badge.html(originalHTML);
			$badge.removeClass('badge-success').addClass('badge-dark');
		}, 1500);
	});
	
	get_permission()
	
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
                	swal(`Error`, data.licmsg, `error`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 5000
                    }).then(() => {
                        location.reload()
                    });
                }
                if(data.response == 3){
                	swal(`Error`, data.licmsg, `error`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 5000
                    }).then(() => {
                        location.reload()
                    });
                }
            },
            error: function (jqXHR, textStatus, errorThrown)
            {
                swal(`Error`, `Error parsing data.`, `error`, {
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
    

    const myArray = [];
    var result = myArray;
    
    $('.checkbox-parent').click(function(event) {
        if(this.checked) {
            $('.checkbox-child').each(function() {
                if(this.checked = true){
                    $(".btn-multi-delete").removeClass('d-none')
                    myArray.push($(this).val());
                }else{
                    result.length = 0;
                }
            });
            $('.btn-server-restart').attr("disabled", true)
            $('.btn-server-delete').attr("disabled", true)
        }else{
            $('.checkbox-child').each(function() {
                this.checked = false;
                if ((index = myArray.indexOf($(this).val())) !== -1) {
                    myArray.splice(index, 1);
                }
            }); 
			if($(".checkbox-parent").prop('checked',false)){
                $(".btn-multi-delete").addClass('d-none')
                result.length = 0;
			}
			$('.btn-server-restart').attr("disabled", false)
            $('.btn-server-delete').attr("disabled", false)
        }
    });
	
	$('body').delegate('.checkbox-child','click',function(event){
		if ($('.checkbox-child').is(':checked',true)){
    		if ($('#select-this-' + $(this).data("selectid")).is(':checked',true)){
    		    
    		    myArray.push($(this).val());
    		    
                $(".btn-multi-delete").removeClass('d-none')
                
                if($("input[type=checkbox]:checked").length == $('.checkbox-child').length){
                    $(".checkbox-parent").prop('checked',true)
                }else{
                    
                }
    		}else{
    		    $(".checkbox-parent").prop('checked',false)
    		    if ((index = myArray.indexOf($(this).val())) !== -1) {
                    myArray.splice(index, 1);
                }
    		}
		}else{
		    $(".checkbox-parent").prop('checked',false)
		    $(".btn-multi-delete").addClass('d-none')
		    
		    if ((index = myArray.indexOf($(this).val())) !== -1) {
                myArray.splice(index, 1);
            }
		}
		
		if ($('#select-this-' + $(this).data("selectid")).is(':checked',true)){
		    $('#restart-btn-' + $(this).data("selectid")).attr("disabled", true);
            $('#delete-btn-' + $(this).data("selectid")).attr("disabled", true);
		}else{
		    $('#restart-btn-' + $(this).data("selectid")).attr("disabled", false);
            $('#delete-btn-' + $(this).data("selectid")).attr("disabled", false);
		}
	});
	
    //Multiple Delete
	$('.btn-multi-delete').click(function () {
        
        let template_html = `<form class="multideleteform" autocomplete="off">`
                			+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                			+ `<input type="hidden" name="submitted" value="server_delete">`
                			+ `<input type="hidden" name="serverxlist" value="`+result+`">`
                			+ `<p><strong>Are you sure to delete this server(s) ?</strong> <br><br><span style="color: red">` +result.join('<br>')+ `</span><br><br></p>`
                			+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-modal" tabindex="4">Confirm</button></div><div class="text-center" style="color: orange"><small>The DNS RECORD of the ip(s) listed above will be deleted automatically.</small></div>`
                			+ `</form>`;
        modalize('Delete Server(s)', template_html);
        
        var $form = $('.multideleteform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/delete_server_plus.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$(".btn-modal").addClass("btn-progress");
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
        		    $(".multideleteform").remove();
				    $('.table-listserver').DataTable().ajax.reload( null, false );
				    result.length = 0;
				    $(".checkbox-parent").prop('checked',false)
        		}
        	});
    
    })
    
    function checkServer(){
        $.ajax({
            url: '../serverside/data/check_server.php',
            data: "key={$firenet_encrypt}",
            success: function(data) {
                $('.table-listserver').DataTable().ajax.reload();
                result.length = 0;
                $(".checkbox-parent").prop('checked',false)
            }
        });
    }
    
    setInterval(function () {
        checkServer();
    }, 30000);
    
    checkServer();
    
});
</script>