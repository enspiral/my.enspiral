$(()->
  $('.delayed-hide').delay('3000').slideUp(100)
  $('#contact_form').bind('ajax:beforeSend', ()->
    $('#message').show().text('Sending')
  ).bind('ajax:success', (evt, data, status, xhr)->
    $('#message').attr('class', 'alert alert-success').addClass('alert-success').text($.parseJSON(xhr.responseText).message).fadeOut(5000)
  ).bind('ajax:error', (evt, xhr, status, error)->
    $('#message').removeClass('alert-notice').addClass('alert-error').text($.parseJSON(xhr.responseText).message)
  )
)

