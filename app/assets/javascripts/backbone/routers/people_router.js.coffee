class Enspiral.Routers.PeopleRouter extends Backbone.Router
  initialize: (options) ->
    @people = new Enspiral.Collections.PeopleCollection()
    @people.reset options.view_collection
    @options = options

  routes:
    "index"    : "index"
    "newest"   : "newest"
    "oldest"   : "oldest"
    "full_time"   : "fullTime"
    "part_time"   : "partTime"
    "active"   : "active"
    "inactive"   : "inactive"
    ".*"        : "index"

  index: ->
    @resetNav()
    $('.table_actions li.filter-all').addClass('active')
    @people.reset @options.view_collection
    @view = new Enspiral.Views.People.IndexView(view_collection: @people)
    $("#people").html(@view.render().el)

  active: ()->
    @resetNav()
    $('.table_actions li.filter-active').addClass('active')
    @people.reset @options.view_collection
    @people = @people.active()
    @view = new Enspiral.Views.People.IndexView(view_collection: @people)
    $("#people").html(@view.render().el)

  inactive: ()->
    @resetNav()
    $('.table_actions li.filter-inactive').addClass('active')
    @people.reset @options.view_collection
    @people = @people.inactive()
    @view = new Enspiral.Views.People.IndexView(view_collection: @people)
    $("#people").html(@view.render().el)

  newest: ->
    @people = @people.byNewest()
    @view = new Enspiral.Views.People.IndexView(view_collection: @people)
    $("#people").html(@view.render().el)

  oldest: ->
    @people = @people.byOldest()
    @view = new Enspiral.Views.People.IndexView(view_collection: @people)
    $("#people").html(@view.render().el)

  fullTime: ()->
    @people.reset @options.view_collection
    @people = @people.fullTime()
    @view = new Enspiral.Views.People.IndexView(view_collection: @people)
    $("#people").html(@view.render().el)

  partTime: ()->
    @people.reset @options.view_collection
    @people = @people.partTime()
    @view = new Enspiral.Views.People.IndexView(view_collection: @people)
    $("#people").html(@view.render().el)

  resetNav: ()->
    if $('.table_actions').length
      $('.table_actions li.filter').removeClass('active')
