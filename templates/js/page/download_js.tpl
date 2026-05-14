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

function downbold(url) {
  const a = document.createElement('a')
  a.href = url
  a.download = url.split('/').pop()
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
  $(".normal-modalize").modal('hide');
  setTimeout(function () {
        history.go(0);
      }, 3000);
}
	
function view_app(u) {
	$.ajax({
        url: "{$base_url}serverside/data/get_appinf.php",
        data: "id="+u,
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            var template_html =  `<div class="card-body" id="xxapp">
                                    <div class="text-center">
                                      `+data.app_image+`
                                      <div class="clearfix"></div>
                                    </div>
                                    <div class="author-box-details mt-3">
                                      <div class="author-box-name text-center">
                                        <a href="#"><h4>`+data.app_title+`</h4></a>
                                      </div>
                                      <div class="author-box-job text-center">Downloads: `+data.app_downloads+`</div><hr>
                                      <div class="author-box-description" style="text-align: justify;">
                                        <p>`+data.app_description+`</p>
                                      </div>
                                      
                                      <hr>
                                      <div class="text-center">
                                      <button type="button" onclick="downbold('{$base_url}dl?id=`+data.app_id+`')" class="btn btn-primary btn-download mr-1" id="btn-download">
                                        <i class="fa fa-download" aria-hidden="true"></i> Download
                                      </button>
                                      <button type="button" class="btn btn-primary btn-xcopy" data-clipboard-text="{$base_url}dl?id=`+data.app_id+`">
                                        <i class="far fa-copy"></i> Copy
                                      </button>
                                      </div>
                                      <div class="w-100 d-sm-none"></div>
                                    </div>
                                  </div>`;
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
</script>
