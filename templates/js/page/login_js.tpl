<script>
function normalMessage(type, title, message) {
    $(".errors").html('<div class="alert alert-' + type + ' alert-has-icon"><div class="alert-icon"><i class="far fa-lightbulb"></i></div><div class="alert-body"><button class="close" data-dismiss="alert"><span>&times;</span></button><div class="alert-title">' + title + '</div>' + message + '</div></div>').slideDown();
}

$('document').ready(function()
{
    var $form = $('.authenticate');
	$form.ajaxForm({
		type: "POST",
		url: "{$base_url}serverside/forms/login.php",
		data: $form.serialize(),
		dataType: "JSON",
		cache: false,
		beforeSend: function() {
			$(".btn-submit").addClass("btn-progress");
		},
		success: function(data){
			if(data.response == 1){
			    $('.btn-submit').addClass("disabled");
    			Swal.fire({
                        title: "Success",
                        icon: "success",
                        html: data.msg,
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
                                if(timer) timer.textContent = `${
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
    		if(data.response == 4){
    		    $('.btn-submit').prop("disabled", true);
    			Swal.fire({
                        title: "Success",
                        icon: "success",
                        html: data.msg,
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
                                if(timer) timer.textContent = `${
                                    Swal.getTimerLeft()
                                }`;
                            }, 100);
                        },
                        willClose: () => {
                            clearInterval(timerInterval);
                        }
                    }).then((result) => {
                        if (result.dismiss === Swal.DismissReason.timer) {
                            location.href = "confirmation?id=" + data.id
                        }
                    });
    		}
		},
		error: function(jqXHR, textStatus, errorThrown) {
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
                                if(timer) timer.textContent = `${
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
			$(".btn-submit").removeClass("btn-progress");
		}
	});
	
	const passwordField = document.getElementById("user_pass");
    const togglePassword = document.querySelector(".password-toggle-icon i");

    togglePassword.addEventListener("click", function () {
      if (passwordField.type === "password") {
        passwordField.type = "text";
        togglePassword.classList.remove("fa-eye");
        togglePassword.classList.add("fa-eye-slash");
      } else {
        passwordField.type = "password";
        togglePassword.classList.remove("fa-eye-slash");
        togglePassword.classList.add("fa-eye");
      }
    });
});
</script>
