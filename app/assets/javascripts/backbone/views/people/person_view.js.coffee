Enspiral.Views.People ||= {}

class Enspiral.Views.People.PersonView extends Backbone.View
  template: JST["backbone/templates/people/person"]

  events:
    "click" : "test"

  className: 'pictoral_list_item col'

  test: ->
    console.log 'success'

  render: ->
    $(@el).append JST["backbone/templates/people/person"]({person: @model.toJSON()})
    return this
