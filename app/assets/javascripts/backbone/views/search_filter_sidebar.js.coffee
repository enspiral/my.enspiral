Enspiral.Views ||= {}

class Enspiral.Views.SearchFilterSidebar extends Backbone.View
  events:
    'blur input#search' : 'clearText'
    'click ul a, input#search' : 'highlightSelection'

  initialize: (options)->
    _.bindAll(@)
    @options = options
    @collection = "#{@options.collection_name}Collection"
    @lc_collection = @options.collection_name.toLowerCase()
    delay = (->
      timer = 0
      (callback, ms) ->
        clearTimeout timer
        timer = setTimeout(callback, ms)
    )()
    #catch tab
    $('body').on('keydown', (e)->
      keyCode = e.keyCode || e.which
      if keyCode == 9
        e.preventDefault()
        return false
      if $('#detail').length
        if keyCode == 49 or keyCode == 57
          e.preventDefault()
          return false
    )
    $('input#search').on('keydown', (e)=>
      delay((=>@searchSet(e)), 150)
    )
    $('input#search').focus()

  searchSet: (e)->
    keyCode = e.keyCode || e.which
    $target = $(e.currentTarget)
    val = $target.val().toLowerCase()
    @result_set = @getResults(val)
    if @result_set.length == 1
      result = @result_set.first()
      if @lc_collection == 'people'
        if keyCode == 13 and e.shiftKey or keyCode == 49
          window.location = "/admin/people/#{result.id}/edit"
        else if keyCode == 9
          e.preventDefault()
          if $('#detail').length == 1
            $('#detail').remove()
          else
            @showDetail(result)
        #else if keyCode == 57
          #window.location = "/people/#{result.id}/deactivate"



  getResults: (val)->
    result_set = _.filter @options.collection_data, (p)=>
      val = val.replace(' ', '')
      name_string = (p.first_name + p.last_name).toLowerCase()
      regex = new RegExp(val, "ig")
      name_string.match(regex) != null

    collection_set = new Enspiral.Collections[@collection]()
    collection_set.reset result_set
    @view = new Enspiral.Views[@options.collection_name].IndexView(view_collection: collection_set)
    $("##{@lc_collection}").html(@view.render().el)
    return collection_set

  showDetail: (view_collection)->
    @view_collection = view_collection
    $('.secondary_result').append JST["backbone/templates/"+@lc_collection+"/detail"]({view_collection: @view_collection.toJSON()})

  clearText: (e)->
    $(e.currentTarget).val('')
    
  highlightSelection: (e)->
    $('.left_nav a').removeClass()
    $target = $(e.currentTarget)
    $target.addClass('selected')

