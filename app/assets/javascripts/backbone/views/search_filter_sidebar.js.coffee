Enspiral.Views ||= {}

class Enspiral.Views.SearchFilterSidebar extends Backbone.View
  events:
    'blur input#search' : 'clearText'
    'click ul a, input#search' : 'highlightSelection'

  initialize: (options)->
    _.bindAll(@)
    @options = options
    delay = (->
      timer = 0
      (callback, ms) ->
        clearTimeout timer
        timer = setTimeout(callback, ms)
    )()
    #catch tab
    $('body').on('keydown', (e)->
      keyCode = e.keyCode || e.which
      if keyCode == 9
        e.preventDefault()
        return false
    )
    $('input#search').on('keydown', (e)=>
      delay((=>@searchSet(e)), 150)
    )
    $('input#search').focus()

  searchSet: (e)->
    keyCode = e.keyCode || e.which
    $target = $(e.currentTarget)
    val = $target.val().toLowerCase()
    @result_set = @getResults(val)
    if @result_set.length == 1
      person = @result_set.first()
      if keyCode == 13 and e.shiftKey
        window.location = "/admin/people/#{person.id}"
      else if keyCode == 9
        e.preventDefault()
        if $('#detail').length == 1
          $('#detail').remove()
        else
          @showDetail(person)


  getResults: (val)->
    result_set = _.filter @options.people, (p)=>
      val = val.replace(' ', '')
      name_string = (p.first_name + p.last_name).toLowerCase()
      regex = new RegExp(val, "ig")
      name_string.match(regex) != null

    people = new Enspiral.Collections.PeopleCollection()
    people.reset result_set
    @view = new Enspiral.Views.People.IndexView(people: people)
    $("#people").html(@view.render().el)
    return people

  showDetail: (person)->
    @person = person
    $('.secondary_result').append JST["backbone/templates/people/detail"]({person: @person.toJSON()})

  clearText: (e)->
    $(e.currentTarget).val('')
    
  highlightSelection: (e)->
    $('.left_nav a').removeClass()
    $target = $(e.currentTarget)
    $target.addClass('selected')

