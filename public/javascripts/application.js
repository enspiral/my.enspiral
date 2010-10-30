(function($) {
    $(document).ready(function() {
        $('a.notice_summary').toggle(
            function() {
                notice_text = $(this).parent().find('div.notice_text');
                notice_text.fadeIn();
                notice_text.slideDown();
            },
            function() {
                notice_text = $(this).parent().find('div.notice_text');
                notice_text.fadeOut();
                notice_text.slideUp();
            }
            );
    $('.flash.notice').delay('3000').slideUp('slow');
    //Ajax listeners
    //Staff Page
    $('#check-gravatar-again').live('click', function(event) {
      event.preventDefault();
      $(this).html("Checking...");
      var el = $(this),
          data_url = el.attr('href');
      $.ajax({
        type: "POST",
        url: data_url,
        dataType: 'text',
        success: function(data, status, req) {
          j = jQuery.parseJSON(data);
          if(j.status == "found_gravatar"){
            $('#gravatar-error').removeClass("error").addClass("notice").html(j.message).delay('2000').slideUp("slow");
          }
          else{
            $('#bollocks').html(j.message);
          }
        }
      });
  });

    });
})(jQuery);