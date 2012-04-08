Enspiral.Views ||= {}

class Enspiral.Views.LeftNavView extends Backbone.View
  events:
    'keyup input#search' : 'getResults'
    'blur input#search' : 'clearText'
    'click ul a, input#search' : 'highlightSelection'

  el: '.left_nav'

  initialize: (options)->
    @options = options

  getResults: (e)->
    $target = $(e.currentTarget)
    val = $target.val().toLowerCase()
    result_set = _.filter @options.people, (p)=>
      name_string = (p.first_name + p.last_name).toLowerCase()
      regex = new RegExp(val, "i")
      name_string.match(regex) != null

    people = new Enspiral.Collections.PeopleCollection()
    people.reset result_set
    console.log people
    @view = new Enspiral.Views.People.IndexView(people: people)
    $("#people").html(@view.render().el)

  clearText: (e)->
    $(e.currentTarget).val('')
    
  highlightSelection: (e)->
    console.log e
    $('.left_nav a').removeClass()
    $target = $(e.currentTarget)
    $target.addClass('selected')

