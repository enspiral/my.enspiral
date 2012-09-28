# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if ($("body.metrics.new").length > 0) || ($("body.metrics.edit").length > 0)
    $("#metric_for_date_3i").hide()
