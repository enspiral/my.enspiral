$(()->
  $('.flash.notice').delay('3000').slideUp('slow')
  $('.datepicker').kalendae
    months: 2
    format: 'YYYY-MM-DD'
    viewStartDate: Kalendae.moment().subtract({M:1})
    subscribe: 
     'change': ()->
       this.input.blur()
)
