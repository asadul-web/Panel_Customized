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
	
function modalMessage(type,title,message){
	$(".normal-modal-body > .normal-modal-error").html('').append('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
}

function normalMessage(type,title,message){
	$(".errors").html('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><button class="close" data-dismiss="alert"><span>&times;</span></button><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
}

$('document').ready(function()
{
    // Load active Cloudflare domains into dropdown
    $.ajax({
        url: "{$base_url}serverside/forms/get_active_domains.php",
        type: "GET",
        dataType: "JSON",
        cache: false,
        success: function(data){
            if(data.response == 1 && data.domains.length > 0){
                $.each(data.domains, function(index, domain){
                    $('.select-domain').append('<option value="'+domain.id+'">'+domain.domain_name+'</option>');
                });
            }
        }
    });

    $.fn.dataTable.ext.errMode = () => swal(`Failed`, `Failed getting data from RADEV.`, `warning`, {
        button: false,
        closeOnClickOutside: false,
        timer: 3000
    }).then(() => {
        location.reload()
    });
	var table = $('.table-listdns').dataTable({
        "bProcessing": false,
        "bServerSide": true,
        "ajax": {
            "url": "/dns-serverside",
            "type": "POST"
        },
		responsive: true,
		"order": [[ 0, "desc" ]],
		"language": {                
                "infoFiltered": ""
            },
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
              width: '5%',
              targets: 2,
            },
            {
              orderable: false,
              targets: [2],
            },
        ],
	});
	
	var $form = $('.add-dns');
	$form.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/add_dns.php",
		data: $form.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".btn-add-dns").addClass("btn-progress")
		},
		success: function(data){
			if(data.response == 1){
    			normalMessage('success', 'Success', data.msg);
    			$(".add-dns").trigger("reset");
    			table.DataTable().ajax.reload();
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
			swal(`Failed`, `Failed getting data from RADEV.`, `warning`, {
                button: false,
                closeOnClickOutside: false,
                timer: 3000
            }).then(() => {
                location.reload()
            });
		},
		complete: function(){
			$(".btn-add-dns").removeClass("btn-progress")
		}
	});
	
	$(".btn-reset").click(function(){
		$(".add-dns").trigger("reset");
	})
	
	//DNS Tools
	$(".dnstools").on("click", ".btn-tool-hostcheck", function(e)
	{
		let template_html = `<form class="httpcheckform" autocomplete="off">
                            <div class="alert alert-primary">
                            It will check : <code>Http Status Code and Message</code>.
                            </div>
                            <div class="form-group">
                            <input type="hidden" name="_key" value="{$firenet_encrypt}">
                            <input type="hidden" name="submitted" value="http_check">
                            <input type="text" class="form-control" name="hostname" placeholder="Enter a hostname" required>
                            </div>
                            <div class="form-group"><button type="submit" class="btn btn-success btn-lg btn-block btn-modal" tabindex="4">CHECK</button></div>
                            </form>`
        normal_modalize('HTTP CHECK', template_html);
		
		var $form = $('.httpcheckform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/http_check.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$(".btn-modal").prop("disabled", "disabled").text('Please wait...');
        		},
        		success: function(data){
        			if(data.response == 1){
    					modalMessage('success', 'Information', data.msg);
    				}
    				if(data.response == 2){
    					modalMessage('danger','Error', data.msg);
    				}
    				if(data.response == 3){
    					modalMessage('danger','Error', data.errormsg);
    				}
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			swal(`Failed`, `Failed getting data from RADEV.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
        		},
        		complete: function(){
    				$(".httpcheckform").remove();
        		}
        	});
	})
	
	$(".dnstools").on("click", ".btn-tool-dnstoip", function(e)
	{
		let template_html = `<form class="dnstoipform" autocomplete="off">
                            <div class="alert alert-primary">
                            If you see your server ip from your dns then the dns is working fine. Don't include <code>https://</code> or <code>http://</code> only hostname or domain name.<br><br>
                            Correct : <code>server1.example.com</code> <br>
                            Wrong : <code>https://server1.example.com/</code>
                            </div>
                            <div class="form-group">
                            <input type="hidden" name="_key" value="{$firenet_encrypt}">
                            <input type="hidden" name="submitted" value="dns_ip">
                            <input type="text" class="form-control" name="hostname" placeholder="Enter a hostname" required>
                            </div>
                            <div class="form-group"><button type="submit" class="btn btn-success btn-lg btn-block btn-modal" tabindex="4">CHECK</button></div>
                            </form>`
        normal_modalize('DNS TO IP', template_html);
		
		var $form = $('.dnstoipform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/dns_ip.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$(".btn-modal").prop("disabled", "disabled").text('Please wait...');
        		},
        		success: function(data){
        			if(data.response == 1){
    					modalMessage('success', 'Information', data.msg);
    				}
    				if(data.response == 2){
    					modalMessage('danger','Error', data.msg);
    				}
    				if(data.response == 3){
    					modalMessage('danger','Error', data.errormsg);
    				}
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			swal(`Failed`, `Failed getting data from RADEV.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
        		},
        		complete: function(){
    				$(".dnstoipform").remove();
        		}
        	});
	})
	
	$(".dnstools").on("click", ".btn-tool-fixdnsrecords", function(e)
	{
		let template_html = `<form class="fixdnsrecordsform" autocomplete="off">
                            <div class="alert alert-primary">
                            It will attempt to fix all dns records you created when you receive an error while <code>updating dns ip address</code>.
                            </div>
                            <div class="form-group">
                            <input type="hidden" name="_key" value="{$firenet_encrypt}">
                            <input type="hidden" name="submitted" value="fix_dns">
                            </div>
                            <div class="form-group"><button type="submit" class="btn btn-success btn-lg btn-block btn-modal" tabindex="4">FIX NOW</button></div>
                            </form>`
        normal_modalize('FIX DNS RECORDS', template_html);
		
		var $form = $('.fixdnsrecordsform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/dns_fix.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$(".btn-modal").prop("disabled", "disabled").text('Please wait...');
        		},
        		success: function(data){
        			if(data.response == 1){
    					modalMessage('success', 'Information', data.msg);
    				}
    				if(data.response == 2){
    					modalMessage('danger','Error', data.msg);
    				}
    				if(data.response == 3){
    					modalMessage('danger','Error', data.errormsg);
    				}
        		},
        		error: function(jqXHR, textStatus, errorThrown) {
        			swal(`Failed`, `Failed getting data from RADEV.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
        		},
        		complete: function(){
    				$(".fixdnsrecordsform").remove();
        		}
        	});
	})
	
	$(".table-listdns").on("click", ".btn-dns-update", function(){
        let identifier = $(this).data("identifier")
    	let hostname = $(this).data("hostname");
        let template_html = `<form class="updateform" autocomplete="off">`
                                + `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                                + `<input type="hidden" name="submitted" value="dns_update">`
                    			+ `<input type="hidden" name="record_id" value="`+identifier+`">`
                                + `<p>New ip address for <code>`+hostname+`</code></p>`
                                + `<div class="form-group"><input type="text" placeholder="Enter a valid ip address" class="form-control" name="ip" required></div>`
                                + `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-modal" tabindex="4">Confirm</button></div>`
                                + `</form>`;
        normal_modalize('Update', template_html);
        		
        var $form = $('.updateform');
            $form.ajaxForm({
                type: "POST",
                url: "{$base_url}serverside/forms/dns_update.php",
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
                	swal(`Failed`, `Failed getting data from RADEV.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
                },
                complete: function(){
                	$('.table-listdns').DataTable().ajax.reload();
            		$(".updateform").remove();
            		$(".btn-modal").removeClass("btn-progress");
                }
            });
	})
	
	$(".table-listdns").on("click", ".btn-dns-delete", function(e)
	{
		let identifier = $(this).data("identifier")
        let hostname = $(this).data("hostname")
        let template_html = `<form class="deleteform" autocomplete="off">`
                                + `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                                + `<input type="hidden" name="submitted" value="dns_update">`
                    			+ `<input type="hidden" name="record_id" value="`+identifier+`">`
                                + `<p>Are you sure you want to delete <code>`+hostname+`</code>?</p>`
                                + `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-modal" tabindex="4">Confirm</button></div>`
                                + `</form>`;
        normal_modalize('Delete', template_html);
		
		var $form = $('.deleteform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/delete_dns.php",
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
        			swal(`Failed`, `Failed getting data from RADEV.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
        		},
        		complete: function(){
        			$('.table-listdns').DataTable().ajax.reload();
    				$(".deleteform").remove();
    				$(".btn-modal").removeClass("btn-progress");
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
    getD()

});
</script>