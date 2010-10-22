(function($) {
  $(document).ready(function() {
    $('a.notice_summary').toggle(
      function() {
        notice_text = $(this).parent().find('span.notice_text');
        notice_text.fadeIn();
        notice_text.slideDown();
      },
      function() {
        notice_text = $(this).parent().find('span.notice_text');
        notice_text.fadeOut();
        notice_text.slideUp();
      }
    );
  });
})(jQuery);
