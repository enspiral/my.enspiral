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
    
    $('select#person_country_id').change(function(e) {
      country_id = $(this).val();
      if (country_id == '') {
        $('select#person_city_id').html('<option value=""></option>');
      } else {
        jQuery.get('/update_profile/get_cities/' + country_id, function(data) {
          $('select#person_city_id').html(data);
        });
      }
    });
  });
})(jQuery);
