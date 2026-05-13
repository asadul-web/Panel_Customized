<script>
function normalMessage(type,title,message)
{
	$(".errors").html('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><button class="close" data-dismiss="alert"><span>&times;</span></button><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
}

function get_credits()
{
    $.ajax({
        url: "{$base_url}serverside/data/get_credits.php",
        type: "GET",
        dataType: "JSON",
		cache: false,
        success: function(data)
        {
            $('.mycred').val(data.mycredit);
			$('.credits').val(data.mycredit);
			$('.prefix').val(data.prefix);
        },
        error: function (jqXHR, textStatus, errorThrown)
        {
            Swal.fire({
                    title: "Error",
                    icon: "error",
                    html: "Failed getting data from ajax.<br><b></b>",
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
    });
}

$(document).ready( function () {

get_credits()

    var $form = $('.addreseller');
	$form.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/reseller/add_reseller.php",
		data: $form.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".btn-addreseller").addClass("btn-progress")
		},
		success: function(data){
			if(data.response == 1){
    			Swal.fire({
                  title: "Success",
                  html: data.msg,
                  icon: "success",
                  allowOutsideClick: false,
                  allowEscapeKey: false,
                  showCancelButton: false,
                  showConfirmButton: false
                });
                $(".addreseller").trigger("reset");
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
		    gen_user()
			Swal.fire({
                    title: "Error",
                    icon: "error",
                    html: "Failed getting data from ajax.<br><b></b>",
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
			$(".btn-addreseller").removeClass("btn-progress")
			get_credits()
		}
	});
	
	
	var $form2 = $('.transfercredit');
	$form2.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/reseller/transfer_credit.php",
		data: $form2.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
		    $(".btn-transfercredit").addClass("btn-progress");
		},
		success: function(data){
			if(data.response == 1){
    			Swal.fire({
                  title: "Success",
                  html: data.msg,
                  icon: "success",
                  allowOutsideClick: false,
                  allowEscapeKey: false,
                  confirmButtonText: "Confirm",
                  didOpen: function () {
                    Swal.getConfirmButton().blur()
                  },
                  customClass: {
                    confirmButton: 'swal2-confirm btn btn-primary swal2-styled'
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
                  confirmButtonText: "Confirm",
                  didOpen: function () {
                    Swal.getConfirmButton().blur()
                  },
                  customClass: {
                    confirmButton: 'swal2-confirm btn btn-primary swal2-styled'
                  }
                });
    		}
    		if(data.response == 3){
    			Swal.fire({
                  title: "Failed",
                  html: data.errormsg,
                  icon: "error",
                  allowOutsideClick: false,
                  allowEscapeKey: false,
                  confirmButtonText: "Confirm",
                  didOpen: function () {
                    Swal.getConfirmButton().blur()
                  },
                  customClass: {
                    confirmButton: 'swal2-confirm btn btn-primary swal2-styled'
                  }
                });
    		}
		},
		error: function(jqXHR, textStatus, errorThrown) {
			Swal.fire({
                    title: "Error",
                    icon: "error",
                    html: "Failed getting data from ajax.<br><b></b>",
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
			$(".btn-transfercredit").removeClass("btn-progress")
			$(".transfercredit").trigger("reset");
			get_credits()
		}
	});
	
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