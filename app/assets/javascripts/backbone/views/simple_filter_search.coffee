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
    filter_name = $target.attr('class').split(' ').pop()
    if filter_name == "filter-all"
      $(@el).find("tbody tr").show()
    else
      $(@el).find("tbody tr.#{filter_name}").show()
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
      name = $(c).find('.text_filter').text().toLowerCase()
      skills = $(c).find('td.skills .label').text().toLowerCase()
      match = name + skills
      regex = new RegExp(val, "ig")
      match.match(regex) != null
    $(result_set).show()
   #return collection_set

  clearText: (e)->
    $(e.currentTarget).val('')
    

