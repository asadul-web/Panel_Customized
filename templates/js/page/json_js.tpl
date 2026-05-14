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

    $.fn.dataTable.ext.errMode = () => swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
        button: false,
        closeOnClickOutside: false,
        timer: 3000
    }).then(() => {
        location.reload()
    });
	var table = $('.table-listjson').dataTable({
        "bProcessing": false,
        "bServerSide": true,
        "ajax": {
            "url": "/json-serverside",
            "type": "POST"
        },
        order: [[ 0, 'desc' ], [ 0, 'asc' ]],
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
          width: '20%',
          targets: 2,
        },
        {
          width: '5%',
          targets: 3,
        },
        {
          orderable: false,
          targets: 3,
        },
      ],
	});
	
	var $form = $('.add-json');
	$form.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/add_json.php",
		data: $form.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".btn-add-json").addClass("btn-progress")
		},
		success: function(data){
			if(data.response == 1){
    			normalMessage('success', 'Success', data.msg);
    			$(".add-json").trigger("reset");
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
			swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                button: false,
                closeOnClickOutside: false,
                timer: 3000
            }).then(() => {
                location.reload()
            });
		},
		complete: function(){
			$(".btn-add-json").removeClass("btn-progress")
		}
	});
	
	$(".btn-reset").click(function(){
		$(".add-json").trigger("reset");
	})
	
	$(".table-listjson").on("click", ".btn-json-view", function(){
        var hash = $(this).data("hash");
        window.open('../api/files/app?json=' + hash, '_blank')
	})
	
	$(".table-listjson").on("click", ".btn-json-edit", function(){
        var hash = $(this).data("hash");
        var name = $(this).data("name");
        var template_html
		
		$.ajax({
            url: "{$base_url}serverside/data/get_json.php",
            data: "json="+hash,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			template_html = `<form class="updateform" autocomplete="off">`
                    			+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                                + `<input type="hidden" name="submitted" value="json_update">`
                    			+ `<input type="hidden" name="hash" value="`+hash+`">`
                    			+ `<div class="form-group"><input type="text" class="form-control" value="`+name+`" disabled></div>`
                    			+ `<div class="form-group"><input type="text" class="form-control" value="`+hash+`" disabled></div>`
                    			+ `<div class="form-group"><textarea rows="30" style="min-width: 100%;" name="json">`+data.content+`</textarea></div>`
                    			+ `<div class="form-group"><button type="submit" class="btn btn-primary btn-lg btn-block btn-json" tabindex="4">Update</button></div>`
                    			+ `</form>`;
    			normal_modalize('Update', template_html);
        		
        		var $form = $('.updateform');
                	$form.ajaxForm({
                		type: "POST",
                		url: "{$base_url}serverside/forms/json_update.php",
                		data: $form.serialize(),
                		dataType: "JSON",
        		        cache: false,
                		beforeSend: function() {
                			$(".btn-json").addClass("btn-progress");
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
                			$('.table-listjson').DataTable().ajax.reload();
            				$(".updateform").remove();
            				$(".btn-json").removeClass("btn-progress");
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
	})
	
	$(".table-listjson").on("click", ".btn-json-delete", function(e)
	{
		var hash = $(this).data("hash");

		var template_html = `<form class="deleteform" autocomplete="off">`
			                + `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                            + `<input type="hidden" name="submitted" value="json_delete">`
			                + `<input type="hidden" name="hash" value="`+hash+`">`
			                + `<p>Are you sure you want to delete?</p>`
			                + `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-jsondelete" tabindex="4">Confirm</button></div>`
			                + `</form>`;
		normal_modalize('Delete', template_html);
		
		var $form = $('.deleteform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/delete_json.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$(".btn-jsondelete").addClass("btn-progress");
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
        			$('.table-listjson').DataTable().ajax.reload();
    				$(".deleteform").remove();
    				$(".btn-jsondelete").removeClass("btn-progress");
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
