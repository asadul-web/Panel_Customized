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
	var table = $('.table-listnotification').dataTable({
        "bProcessing": false,
        "bServerSide": true,
        "ajax": {
            "url": "/notification-serverside",
            "type": "POST"
        },
		"order": [[ 0, "desc" ]],
		"language": {                
                "infoFiltered": ""
            },
		responsive: true,
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
	
	var $form = $('.add-notification');
	$form.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/add_notification.php",
		data: $form.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".btn-add-notification").addClass("btn-progress")
		},
		success: function(data){
			if(data.response == 1){
    			normalMessage('success', 'Success', data.msg);
    			$(".add-notification").trigger("reset");
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
			$(".btn-add-notification").removeClass("btn-progress")
		}
	});
	
	$(".btn-reset").click(function(){
		$(".add-notification").trigger("reset");
		$(".summernote-simple").summernote("code", "");
	})
	
	
	
	$(".table-listnotification").on("click", ".btn-notification-view", function(){
        var id = $(this).data("id");
		
		$.ajax({
            url: "{$base_url}serverside/data/read_notification.php",
            data: "id="+id,
            type: "GET",
            dataType: "JSON",
    		cache: false,
            success: function(data)
            {
    			if(data.response == 1){
        			normal_modalize('Read', data.content);
        		}
        		if(data.response == 2){
        			modalMessage('danger','Error', data.msg);
        		}
        		if(data.response == 3){
        			modalMessage('danger','Error', data.errormsg);
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
	
	$(".table-listnotification").on("click", ".btn-notification-delete", function(e)
	{
		var id = $(this).data("id");
		var template_html = `<form class="deleteform" autocomplete="off">` 
                    		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                    		+ `<input type="hidden" name="submitted" value="delete_notification">`
                    		+ `<input type="hidden" name="id" value="`+id+`">` 
                    		+ `<p>Are you sure you want to delete?</p>` 
                    		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-notificationdelete" tabindex="4">Confirm</button></div>` 
                    		+ `</form>`;
        normal_modalize('Delete', template_html);
		
		var $form = $('.deleteform');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/delete_notification.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$(".btn-notificationdelete").addClass("btn-progress");
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
        			$('.table-listnotification').DataTable().ajax.reload();
    				$(".deleteform").remove();
    				$(".btn-notificationdelete").removeClass("btn-progress");
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