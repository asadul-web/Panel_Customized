<!-- Login -->
<script>
$(document).ready(function($){	
	$('.login-errors').addClass('d-none');
	$('form').formValidation
		({
        framework: 'bootstrap',
		excluded: ':disabled',
		icon: null,
		fields: 
		{		
			user_name:
			{				
				valid: true,
				message: 'Username is invalid',
				validators: 
				{
                    notEmpty: 
					{
                    message: 'Enter your username.'
                    }
                }
			},
			user_pass:
			{				
				valid: true,
				message: 'Password is invalid',
				validators: 
				{
					notEmpty: 
					{
                    message: 'Enter your password.'
                    },
					callback: 
					{
						callback: function(value, validator, $field) {
						var score = 0;

							if (value === '') {
								return {
									valid: true,
									score: null
								};
							}

							// Check the password strength
							score += ((value.length >= 8) ? 1 : -1);

							// The password contains uppercase character
							if (/[A-Z]/.test(value)) {
								score += 1;
							}

							// The password contains uppercase character
							if (/[a-z]/.test(value)) {
								score += 1;
							}

							// The password contains number
							if (/[0-9]/.test(value)) {
								score += 1;
							}

							// The password contains special characters
							if (/[!#$%&^~*_]/.test(value)) {
								score += 1;
							}

							return {
								valid: true,
								score: score    // We will get the score later
							};
						}
					}
                }
            }
        }
    })
        .on('success.validator.fv', function(e, data) {
			
            // The password passes the callback validator
            if (data.field === 'user_pass' && data.validator === 'callback') {
                // Get the score
                var score = data.result.score,
                    $bar  = $('#signinpwdMeter').find('.progress-bar');

                switch (true) {
                    case (score === null):
                        $bar.html('').css('width', '0%').removeClass().addClass('progress-bar');
                        break;

                    case (score <= 0):
                        $bar.html('Very weak').css('width', '25%').removeClass().addClass('progress-bar progress-bar-danger');
                        break;

                    case (score > 0 && score <= 2):
                        $bar.html('Weak').css('width', '50%').removeClass().addClass('progress-bar progress-bar-warning');
                        break;

                    case (score > 2 && score <= 4):
                        $bar.html('Medium').css('width', '75%').removeClass().addClass('progress-bar progress-bar-info');
                        break;

                    case (score > 4):
                        $bar.html('Strong').css('width', '100%').removeClass().addClass('progress-bar progress-bar-success');
                        break;

                    default:
                        break;
                }
            }			
        })
		
        .on('success.form.fv', function(e, data) {
          // Reset the message element when the form is valid
          $('.login-errors').html(data);
        })

        .on('err.field.fv', function(e, data) {
          // data.fv     --> The FormValidation instance
          // data.field  --> The field name
          // data.element --> The field element
          $('.login-errors').removeClass('d-none');

          // Get the messages of field
          var messages = data.fv.getMessages(data.element);

          // Remove the field messages if they're already available
          $('.login-errors').find('li[data-field="' + data.field +
            '"]').remove();

          // Loop over the messages
          for (var i in messages) {
            // Create new 'li' element to show the message
            $('<li/>')
              .attr('data-field', data.field)
              .wrapInner(
                $('<div/>')
                // .addClass('alert alert-danger alert-dismissible')
                .html(messages[i])
                .on('click', function(e) {
                  // Focus on the invalid field
                  data.element.focus();
                })
              ).appendTo('.alert-body > ul');
          }

          // Hide the default message
          // $field.data('fv.messages') returns the default element containing the messages
          data.element
            .data('fv.messages')
            .find('.help-block[data-fv-for="' + data.field + '"]')
            .hide();
        })

        .on('success.field.fv', function(e, data) {
          // Remove the field messages
          $('.alert-body > ul').find('li[data-field="' + data.field +
            '"]').remove();
          if ($('form').data('formValidation').isValid()) {
            $('.login-errors').addClass('d-none');
          }
        });
/*
	$('form').keypress(function(e){
		if(e.keyCode=='13') //Keycode for "Return"
		$('#submitLogin').click();
	});	
*/	
});
</script>
<!-- Login End -->
