class Enspiral.Routers.PeopleRouter extends Backbone.Router
  initialize: (options) ->
    @people = new Enspiral.Collections.PeopleCollection()
    @people.reset options.people

  routes:
    "/index"    : "index"
    ".*"        : "index"

  index: ->
    console.log @people
    @view = new Enspiral.Views.People.IndexView(people: @people)
    $("#people").html(@view.render().el)

