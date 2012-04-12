Enspiral.Views ||= {}

class Enspiral.Views.AutoCompleteView extends Backbone.View
  events:
    'keyup' : 'getResults'
    'blur' : 'clearText'
    'click .left_nav a' : 'highlightSelection'

  el: '#search'

  initialize: (options)->
    @options = options

  getResults: (e)->
    $target = $(e.currentTarget)
    val = $target.val().toLowerCase()
    result_set = _.filter @options.people, (p)=>
      name_string = (p.first_name + p.last_name).toLowerCase()
      regex = new RegExp( "^" + val, "i")
      name_string.match(regex) != null

    people = new Enspiral.Collections.PeopleCollection()
    people.reset result_set
    console.log people
    @view = new Enspiral.Views.People.IndexView(people: people)
    $("#people").html(@view.render().el)

  clearText: (e)->
    $(e.currentTarget).val('')
    
