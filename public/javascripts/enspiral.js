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
    //Ajax listeners
    //Staff Page
    $('#check-gravatar-again').bind("ajax:success", function (data, status, xhr) {
      response = jQuery.parseJSON(status);
      $('#bollocks').html("render :partial => 'gravatar_sucess'");
    });

    });
})(jQuery);
