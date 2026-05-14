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

$('document').ready(function()
{
    $.fn.dataTable.ext.errMode = () => swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
        button: false,
        closeOnClickOutside: false,
        timer: 3000
    }).then(() => {
        location.reload()
    });
	table = $('.table-bulk').dataTable({
        "bProcessing": false,
        "bServerSide": true,
        responsive: true,
        "ajax": {
            "url": "/log-bulk-serverside",
            "type": "POST"
        },
		order: [[0, 'desc']],
		"language": {                
                "infoFiltered": ""
            },
		columnDefs: [
            {
              width: '10%',
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
              orderable: false,
              targets: 4,
            },
        ],
	});
	
	//User Delete
    $(".table-bulk").on("click", ".btn-delete-bulk", function(e)
	{
		var ugroup = $(this).data("group");
		var prefix = $(this).data("prefix");

		var template_html = `<form class="deletebulk" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="group" value="`+ugroup+`">`
                        		+ `<input type="hidden" name="submitted" value="delete_bulk">`
                        		+ `<div class="form-group"><p>This will permanently delete all bulk user with <code>`+prefix+`</code> prefix.</p><strong style="font-color: red"><i class="far fa-lightbulb"></i> This cannot be undone or retrieve.</strong></div>`
                        		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-deletebulk" id="btn-deletebulk" tabindex="4">Confirm</button></div>`
                        		+ `</form>`;
		normal_modalize('DELETE BULK', template_html);
		
		var $form = $('.deletebulk');
        	$form.ajaxForm({
        		type: "POST",
        		url: "{$base_url}serverside/forms/delete_bulk.php",
        		data: $form.serialize(),
        		dataType: "JSON",
		        cache: false,
        		beforeSend: function() {
        			$("#btn-deletebulk").addClass("btn-progress");
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
        			swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                        button: false,
                        closeOnClickOutside: false,
                        timer: 3000
                    }).then(() => {
                        location.reload()
                    });
        		},
        		complete: function(){
        			$('.table-bulk').DataTable().ajax.reload();
    				$(".deletebulk").remove();
    				$("#btn-deletebulk").removeClass("btn-progress");
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
