(function($) {
  $(document).ready(function() {
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
    if ($("#contact-form").length) {
      $("#contact-form #submit").click(function(e){
      var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
      if(emailReg.test($("#contact-form #email").val()) == false ) {
        e.preventDefault();
        $("#email").after('<span class="error">  Enter a valid email address.</span>');
        return false;
      } else {
        if($("#contact-form #email").val() == ""){
          e.preventDefault();
          if($("#contact-form .error").length){
            return false;
          } else {
            $("#email").after('<span class="error">  Enter a valid email address.</span>');
            return false;
          }
        } else {
          $("#contact-form form").submit();
        }
      }
      });
    }
    
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
    
    $('#people_list').tablesorter({
      headers: {
        0: { sorter: false }
      }
    });

  });
})(jQuery);
