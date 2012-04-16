#= require_self
#= require_tree ./mixins
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Enspiral =
  Mixins: {}
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  init: (options) ->
    Enspiral.options = options

