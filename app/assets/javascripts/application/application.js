(function($) {
  $(document).ready(function() {
    $('.flash.notice').delay('3000').slideUp('slow');
    //Ajax listeners
    
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
        jQuery.get('/people/get_cities/' + country_id, function(data) {
          $('select#person_city_id').html(data);
        });
      }
    });
    
    $('form#services_search').bind('ajax:success', function(data, status, xhr) {
      $('#services_list').html(status);
      return false;
    });
  });
})(jQuery);

function remove_fields(link) {
  $(link).previous("input[type=hidden]").value = "1";
  $(link).up(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).up().insert({
    before: content.replace(regexp, new_id)
  });
}
