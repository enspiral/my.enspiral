Enspiral.Views.People ||= {}

class Enspiral.Views.People.IndexView extends Backbone.View
  template: JST["backbone/templates/people/index"]

  initialize: () ->
    @options.people.bind('reset', @addAll)

  addAll: () =>
    @options.people.each(@addOne)

  addOne: (person) =>
    view = new Enspiral.Views.People.PersonView({model : person})
    @$(".pictoral_list").append(view.render().el)

  render: =>
    $(@el).html(@template(people: @options.people.toJSON() ))
    @addAll()
    @animateIn()

    return this

  animateIn: () ->
    return if $('html').hasClass('ie7')
    return if $('html').hasClass('ie8')
    $.each @$('.pictoral_list_item'), (i, item) =>
      $item = $(item)
      $item.fadeTo(0, 0).delay(i * 90).fadeTo(100, 1)
      return
    return
