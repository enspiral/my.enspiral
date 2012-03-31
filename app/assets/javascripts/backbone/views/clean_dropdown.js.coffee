Enspiral.Views ||= {}

class Enspiral.Views.CleanDropDown extends Backbone.View
  events:
    'click .expander' : 'toggle'

  initialize: (options)->
    @options = options

  toggle: (e)->
    $target = $(e.currentTarget)
    $(@el).find('.expandee').toggle()
