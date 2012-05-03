$(document).ready(function() {
	
	$(".clear_field").focus(function() {
      	$(this).val('');
      	$(this).css('color','black');
      	$(this).css('font-style','normal');
      	});
	
	$("#addmoreemails").click(function() {
		$(".email_add_block").append('<p class="address"><input id="emails_" name="emails[]" type="text" /></p>');
		});
	
	});