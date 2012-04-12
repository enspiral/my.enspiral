#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Enspiral =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Mixins: {}

  init: (options) ->
      Enspiral.options = options

