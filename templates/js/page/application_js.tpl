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

function normalMessage(type,title,message)
{
	$(".errors").html('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><button class="close" data-dismiss="alert"><span>&times;</span></button><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
}

function delete_app(u) {
	$.ajax({
        url: "serverside/data/get_appinfo.php",
        data: "id="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            var template_html = `<form class="deleteapp" autocomplete="off">`
                        		+ `<input type="hidden" name="_key" value="{$firenet_encrypt}">`
                        		+ `<input type="hidden" name="id" value="`+u+`">`
                        		+ `<input type="hidden" name="submitted" value="delete_app">`
                        		+ `<p class="text-center">Do you want to delete <code>`+data.app_title+`</code>?</p>`
                        		+ `<div class="form-group"><button type="submit" class="btn btn-danger btn-lg btn-block btn-deleteapp" id="btn-deleteapp" tabindex="4">Confirm</button></div>`
                        		+ `</form>`;
    		normal_modalize('Delete Application', template_html);
    		
    		var $form = $('.deleteapp');
            	$form.ajaxForm({
            		type: "POST",
            		url: "serverside/forms/application/delete_application.php",
            		data: $form.serialize(),
            		dataType: "JSON",
    		        cache: false,
            		beforeSend: function() {
            			$("#btn-deleteapp").addClass("btn-progress");
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
                        
                        $(".normal-modalize").modal('hide');
            		},
            		complete: function(){
            			$('.table-application').DataTable().ajax.reload();
        				$(".deleteapp").remove();
        				$("#btn-deleteapp").removeClass("btn-progress");
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
}

function update_app(u) {
	$.ajax({
        url: "serverside/data/get_appinfo.php",
        data: "id="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            var template_html = `<div class="form-group updateform">
						            <div class="card profile-widget">
                                      <div class="profile-widget-header">
                                        `+data.app_image+`
                                        <div class="profile-widget-items">
                                          <div class="profile-widget-item">
                                            <div class="profile-widget-item-label">Downloads</div>
                                            <div class="profile-widget-item-value">`+data.app_downloads+`</div>
                                          </div>
                                        </div>
                                      </div>
                                      
                                    <form class="updateapp" autocomplete="off">
                            		    <input type="hidden" name="_key" value="{$firenet_encrypt}">
                            		    <input type="hidden" name="id" value="`+u+`">
                            		    <input type="hidden" name="submitted" value="update_app">
                            		    
                                        <div class="form-group">
                                            <label for="imidz">Logo</label>
                                            <input type="file" id="imidz" name="imidz" class="input-file2">
                                            <div class="input-group">
                                                <input type="text" class="form-control" disabled placeholder="Upload Logo" tabindex="1">
                                                <div class="input-group-append">
                                                    <button class="btn btn-primary upload-field2" type="button"><i class="fa fa-search"></i> Browse</button>
                                                </div>
                                            </div>
                                            <small class="text-danger">Allowed Extension: JPEG, JPG, PNG</small><br>
                                            <small class="text-danger">Allowed File Size: 5MB Max</small><br>
                                            <small class="text-danger">Allowed Resolution: 300 X 300</small>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="title">Title</label>
                                            <input id="title" type="text" class="form-control title" name="title" tabindex="1" value="`+data.app_title+`">
                                        </div>
                                        <div class="form-group">
                                            <label for="version">Version</label>
                                            <input id="version" type="number" class="form-control version" name="version" tabindex="1" value="`+data.app_version+`">
                                        </div>
                                        <div class="form-group">
                                            <label for="subscription">Description</label>
                                            <textarea id="description" class="form-control" rows="5" style="min-width: 100%;height: 100%" name="description">`+data.app_description+`</textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="appfile">File</label>
                                            <input type="file" id="appfile" name="appfile" class="input-file2">
                                            <div class="input-group">
                                                <input type="text" class="form-control" disabled placeholder="Upload File" tabindex="1">
                                                <div class="input-group-append"> 
                                                    <button class="btn btn-primary upload-field2" type="button"><i class="fa fa-search"></i> Browse</button>
                                                </div>
                                            </div>
                                            <small class="text-danger">Allowed Extension: APK</small><br>
                                            <small class="text-danger">Allowed File Size: 100MB Max</small><br>
                                        </div>  
                                        <hr>
                                        <div class="progress2 mt-1 mb-1 d-none">
                                            <div class="bar2 progress-bar" data-height="10">0%</div>
                                        </div>
                                        <div class="form-group">
                            		        <button type="submit" class="btn btn-primary btn-lg btn-block btn-modal-updateapp" id="btn-updateapp" tabindex="4">Confirm</button>
                            	        </div>
                            	    </form>
                                </div>`
			normal_modalize('Update Application', template_html);
    		
    		var $form = $('.updateapp');
            	$form.ajaxForm({
            		type: "POST",
            		url: "serverside/forms/application/update_application.php",
            		data: $form.serialize(),
            		dataType: "JSON",
    		        cache: false,
            		beforeSend: function() {
            			$("#btn-updateapp").addClass("btn-progress");
            			$('.progress2').removeClass('d-none');
            			$('.bar2').addClass('progress-bar');
                        var percentVal2 = '0%';
                        $('.bar2').width(percentVal2);
                        $('.bar2').html(percentVal2);
            		},
            		uploadProgress: function(event, position, total, percentComplete) {
                        var percentVal2 = percentComplete + '%';
                        $('.bar2').width(percentVal2);
                        $('.bar2').html(percentVal2);
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
        				
        				$(".updateform").remove();
            		},
            		error: function(jqXHR, textStatus, errorThrown) {
            			swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
                            button: false,
                            closeOnClickOutside: false,
                            timer: 3000
                        }).then(() => {
                            location.reload()
                        });
                        
                        $(".normal-modalize").modal('hide');
            		},
            		complete: function(){
            		    $('.progress2').addClass('d-none');
            			$('.table-application').DataTable().ajax.reload();
        				$("#btn-updateapp").removeClass("btn-progress");
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
}

$(document).ready( function () {
    
    $.fn.dataTable.ext.errMode = () => swal(`Failed`, `Failed getting data from AJAX.`, `warning`, {
        button: false,
        closeOnClickOutside: false,
        timer: 3000
    }).then(() => {
        location.reload()
    });
	var table = $('.table-application').dataTable({
        "bProcessing": false,
        "bServerSide": true,
        "responsive": true,
        "ajax": {
            "url": "/application-serverside",
            "type": "POST"
        },
        "order": [[ 0, "desc" ]],
        "language": {                
                "infoFiltered": ""
        },
	});
	
    var $form = $('.add-application');
    var bar = $('.bar');
    
	$form.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/application/create_application.php",
		data: $form.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".btn-create-application").addClass("btn-progress")
			$('.progress').removeClass('d-none');
            var percentVal = '0%';
            $('.bar').width(percentVal);
            $('.bar').html(percentVal);
		},
		uploadProgress: function(event, position, total, percentComplete) {
            var percentVal = percentComplete + '%';
            $('.bar').width(percentVal);
            $('.bar').html(percentVal);
        },
		success: function(data){
			if(data.response == 1){
    			normalMessage('success', 'Success', data.msg);
    			$(".add-application").trigger("reset");
    		}
    		if(data.response == 2){
    			normalMessage('danger','Error', data.msg);
    		}
    		if(data.response == 3){
    			normalMessage('danger','Errors', data.errormsg);
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
		    $('.progress').addClass('d-none');
		    $('.table-application').DataTable().ajax.reload();
			$(".btn-create-application").removeClass("btn-progress")
		}
	});
	
});

</script>