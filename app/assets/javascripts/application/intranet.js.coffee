$(()->
  $('.delayed-hide').delay('3000').slideUp(100)

  cal_options =
    months: 2
    format: 'YYYY-MM-DD'
    viewStartDate: Kalendae.moment().subtract({M:1})
    subscribe: 
     'change': ()->
       this.input.blur()
  $('.datepicker').kalendae cal_options

  $('body').on('keyup', (e)->
    unless $("input:focus").length
      console.log "meme"
      keyCode = e.keyCode || e.which
      if keyCode == 191
        $('.search-query').select()
  )

  $('body').bind 'insertion-callback', (e)->
    $('.datepicker').kalendae cal_options

  $('a[rel="tooltip"], .tw-tooltip').tooltip()

  $('.tw-popover').popover()
  $('.czn-select').chosen()

  $('select#person_country_id').change((e)->
    country_id = $(this).val()
    if country_id == ''
      $('select#person_city_id').html('<option value=""></option>')
    else
      $.get('/people/get_cities/' + country_id, (data)-> 
        $('select#person_city_id').html(data)
      )
  )


  $('#accounts_people, #accounts_companies').bind 'insertion-callback', ->
    $('form').find('.czn-select').chosen()

  $('#pending_allocations').bind 'insertion-callback', ->
    v = $('#pending_allocations').data('default_commission')
    $('#pending_allocations').parent().find('.czn-select').last().chosen()
    $('#pending_allocations').parent().find('.uses_default_commission').last().attr('value', v)
)
