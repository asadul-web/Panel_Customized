<script>
/* Firenet Philippines */
$(function(){if("true"==$.cookie("remember")){var e=$.cookie("username"),o=$.cookie("password");$(".username").val(e),$(".password").val(o)}$(".form-signin").submit(function(){if($(".remember").is(":checked")){var e=$(".username").val(),o=$(".password").val();$.cookie("username",e,{expires:14}),$.cookie("password",o,{expires:14}),$.cookie("remember",!0,{expires:14})}else $.cookie("username",null),$.cookie("password",null),$.cookie("remember",null)})});
</script>
