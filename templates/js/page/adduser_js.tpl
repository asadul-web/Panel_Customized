<script>
function normalMessage(type,title,message)
{
	$(".errors").html('<div class="alert alert-'+type+' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><button class="close" data-dismiss="alert"><span>&times;</span></button><div class="alert-title">'+title+'</div>'+message+'</div></div>').slideDown();
}

function gen_user()
{
    $.ajax({
        url: "{$base_url}serverside/data/gen_user.php",
        type: "GET",
        dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".gen-user").addClass("btn-progress")
		},
        success: function(data)
        {

			$('.username').val(data.ran_user);
			$('.password').val(data.ran_pass);
			$('.trialclass').html(data.tri_dur);

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
			$(".gen-user").removeClass("btn-progress")
		}
    });
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
			$('.credits').val(data.mycredit);
			$('.prefix').val(data.prefix);
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
    });
}

$(document).ready( function () {

gen_user()
get_credits()

    var $form = $('.adduser-single');
	$form.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/user/add_user.php",
		data: $form.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".btn-adduser-single").addClass("btn-progress")
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
                  showConfirmButton: false,
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
		    gen_user()
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
			$(".btn-adduser-single").removeClass("btn-progress")
			gen_user()
			get_credits()
		}
	});
	
	var $form2 = $('.adduser-bulk');
	$form2.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/user/add_bulk.php",
		data: $form2.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
		    $(".btn-adduser-bulk").addClass("btn-progress");
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
                $('.amount').val('0');
                get_credits()
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
		    gen_user()
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
			$(".btn-adduser-bulk").removeClass("btn-progress")
			gen_user()
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