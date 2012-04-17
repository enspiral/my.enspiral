$(()->
  $('.delayed-hide').delay('3000').slideUp(100)
  $('.datepicker').kalendae
    months: 2
    format: 'YYYY-MM-DD'
    viewStartDate: Kalendae.moment().subtract({M:1})
    subscribe: 
     'change': ()->
       this.input.blur()

  $('a[rel="tooltip"], .tw-tooltip').tooltip()

  $('.tw-popover').popover();
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
)
