$(()->
  $('.delayed-hide').delay('3000').slideUp('slow')
  $('.datepicker').kalendae
    months: 2
    format: 'YYYY-MM-DD'
    viewStartDate: Kalendae.moment().subtract({M:1})
    subscribe: 
     'change': ()->
       this.input.blur()
  $('a[rel="tooltip"], a.tw-tooltip').tooltip()
)
