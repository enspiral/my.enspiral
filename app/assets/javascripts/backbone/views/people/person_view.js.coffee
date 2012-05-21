Enspiral.Views.People ||= {}

class Enspiral.Views.People.PersonView extends Backbone.View
  template: JST["backbone/templates/people/person"]

  tagName: 'tr'

  className: 'person'

  render: ->
    $(@el).append JST["backbone/templates/people/person"]({person: @model.toJSON()})
    $(@el).find('.actions a').tooltip()
    return this
