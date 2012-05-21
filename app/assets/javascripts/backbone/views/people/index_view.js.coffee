Enspiral.Views.People ||= {}

class Enspiral.Views.People.IndexView extends Backbone.View
  template: JST["backbone/templates/people/index"]

  el: 'tbody'

  initialize: () ->
    @options.view_collection.bind('reset', @addAll)

  addAll: () =>
    @options.view_collection.each(@addOne)

  addOne: (person) =>
    view = new Enspiral.Views.People.PersonView({model : person})
    $(@el).append(view.render().el)

  render: =>
    $(@el).html(@template(people: @options.view_collection.toJSON() ))
    @addAll()
    @animateIn()

    return this

  animateIn: () ->
    return if $('html').hasClass('ie7')
    return if $('html').hasClass('ie8')
    $.each @$('tr.person'), (i, item) =>
      $item = $(item)
      $item.fadeTo(0, 0).delay(i * 10).fadeTo(100, 1)
      return
    return

