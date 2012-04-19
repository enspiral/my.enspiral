Enspiral.Views ||= {}

class Enspiral.Views.SimpleFilterSearch extends Backbone.View
  events:
    'blur input#search' : 'clearText'
    'click .filter' : 'filterSet'

  initialize: (options)->
    @options = options
    delay = (->
      timer = 0
      (callback, ms) ->
        clearTimeout timer
        timer = setTimeout(callback, ms)
    )()
    $('input#search').on('keydown', (e)=>
      delay((=>@searchSet(e)), 150)
    )
    $('input#search').focus()

  filterSet: (e)->
    $('.filter').removeClass('active')
    $(@el).find('tbody tr').hide()
    $target = $(e.currentTarget)
    filter_val = $target.text().toLowerCase()
    if filter_val == "all"
      $(@el).find("tbody tr").show()
    else
      $(@el).find("tbody tr.#{filter_val}").show()
    $target.addClass('active')
    e.preventDefault()
    return false


  searchSet: (e)->
    keyCode = e.keyCode || e.which
    $target = $(e.currentTarget)
    val = $target.val().toLowerCase()
    $('.filter').removeClass('active')
    @result_set = @getResults(val)


  getResults: (val)->
    result_set = _.filter $(@el).find('tbody tr'), (c)=>
      $(c).hide()
      val = val.replace(' ', '')
      comparison = $(c).find('.text_filter').text().toLowerCase()
      regex = new RegExp(val, "ig")
      comparison.match(regex) != null
    $(result_set).show()
   #return collection_set

  clearText: (e)->
    $(e.currentTarget).val('')
    

