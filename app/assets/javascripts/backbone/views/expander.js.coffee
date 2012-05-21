Enspiral.Views ||= {}

class Enspiral.Views.Expander extends Backbone.View
  events:
    'click .expander' : 'toggle'
    'click .expandee .close' : 'toggle'

  initialize: (options)->
    @options = options

  toggle: (e)->
    $(@el).find('.expandee').toggle()
