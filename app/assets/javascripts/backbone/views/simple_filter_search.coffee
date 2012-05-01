Enspiral.Views ||= {}

class Enspiral.Views.SimpleFilterSearch extends Backbone.View
  events:
    'click .filter' : 'filterSet'
    'focus input#search' : 'readySearch'
    'click .sorter' : 'sorterSet'

  initialize: (options)->
    @options = options
    @options.targetClass ||= 'tbody tr'
    @options.containerClass ||= 'tbody'
    @targetClass = @options.targetClass
    @startingSet = $(@el).find(@targetClass)
    delay = (->
      timer = 0
      (callback, ms) ->
        clearTimeout timer
        timer = setTimeout(callback, ms)
    )()
    $('input#search').on('keydown', (e)=>
      delay((=>@searchSet(e)), 250)
    )
    $('input#search').focus()

  sorterSet: (e)->
    $('.sorter').removeClass('selected')
    $container = $(@options.containerClass)
    $target = $(e.currentTarget)
    targetClasses = $target.attr('class')
    $set = $container.find(@targetClass)
    #Sorter name must always be last
    sorter_name = targetClasses.split(' ').pop()
    if sorter_name =="sorter-name"
      $result_set = _.sortBy($set, (item)->
        return $(item).find('.text_filter').text().trim().toUpperCase()
      )
      if $target.hasClass('sort-down')
        $result_set = $result_set.reverse()
        $target.attr('class', "sort-up #{targetClasses}")
        $target.removeClass('sort-down')
      else
        $target.attr('class', "sort-down #{targetClasses}")
        $target.removeClass('sort-up')
    else if sorter_name =="sorter-clear"
      $('.sorter').removeClass('sort-up sort-down')
      .removeClass('sort-up sort-down')
      $result_set = @startingSet
    else
      $('.sorter').removeClass('sort-up sort-down')

    targetClasses = $target.attr('class')
    $target.attr('class', "selected #{targetClasses}")
    $container.html($result_set)
    @animateIn($($result_set).not(":hidden"))
    e.preventDefault()
    return false

  filterSet: (e)->
    $('.filter').removeClass('active')
    $target = $(e.currentTarget)
    targetClasses = $target.attr('class')
    $set = $(@el).find(@targetClass)
    $set.hide()
    #Filter name must always be last
    filter_name = targetClasses.split(' ').pop()
    if filter_name == "filter-all"
      @clearText()
      @animateIn($set)
    else
      $target.removeClass('sort-up sort-down')
      @animateIn($(@el).find("#{@targetClass}.#{filter_name}"))
    $target.addClass('active')
    $('.tw-tooltip').tooltip()
    $('.tw-popover').popover()
    e.preventDefault()
    return false

  readySearch: ()->
    $container = $(@options.containerClass)
    $container.html(@startingSet)

  searchSet: (e)->
    keyCode = e.keyCode || e.which
    $target = $(e.currentTarget)
    val = $target.val().toLowerCase()
    $('.sorter').removeClass('selected sort-up sort-down')
    $('.filter').removeClass('selected')
    $(@el).find('.filter').removeClass('sort-up sort-down')
    @result_set = @getResults(val)


  getResults: (val)->
    $set = $(@el).find(@targetClass)
    $set.hide()
    $matches = $('')
    result_set = _.filter $set, (c)=>
      val = val.replace(' ', '')
      name = $(c).find('.text_filter').text().toLowerCase()
      match = name
      if $(@targetClass).find('td.skills').length
        skills = $(c).find('td.skills .label').text().toLowerCase()
        match = name + skills
      regex = new RegExp(val, "ig")
      match.match(regex) != null
    #$(result_set).show()
    @animateIn($(result_set))
    $('.tw-tooltip').tooltip()
    $('.tw-popover').popover()
   #return collection_set

  clearText: ()->
    $('#search').val('')
    
  animateIn: ($elements)->
    return if $('html').hasClass('ie7')
    return if $('html').hasClass('ie8')
    $.each $elements, (i, el) =>
      $el = $(el)
      $el.fadeTo(0, 0).delay(i * 40).fadeTo(100, 1)
      return
    return


