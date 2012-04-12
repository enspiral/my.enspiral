class Enspiral.Routers.PeopleRouter extends Backbone.Router
  initialize: (options) ->
    @people = new Enspiral.Collections.PeopleCollection()
    @people.reset options.people
    @options = options

  routes:
    "index"    : "index"
    "newest"   : "newest"
    "oldest"   : "oldest"
    "full_time"   : "fullTime"
    "part_time"   : "partTime"
    ".*"        : "index"

  index: ->
    @people.reset @options.people
    @view = new Enspiral.Views.People.IndexView(people: @people)
    $("#people").html(@view.render().el)

  newest: ->
    @people = @people.byNewest()
    @view = new Enspiral.Views.People.IndexView(people: @people)
    $("#people").html(@view.render().el)

  oldest: ->
    @people = @people.byOldest()
    @view = new Enspiral.Views.People.IndexView(people: @people)
    $("#people").html(@view.render().el)

  fullTime: ()->
    @people.reset @options.people
    @people = @people.fullTime()
    @view = new Enspiral.Views.People.IndexView(people: @people)
    $("#people").html(@view.render().el)

  partTime: ()->
    @people.reset @options.people
    @people = @people.partTime()
    @view = new Enspiral.Views.People.IndexView(people: @people)
    $("#people").html(@view.render().el)
