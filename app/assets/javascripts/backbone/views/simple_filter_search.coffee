Enspiral.Views ||= {}

class Enspiral.Views.SimpleFilterSearch extends Backbone.View
  events:
    'blur input#search' : 'clearText'
    'click .filter' : 'filterSet'

  initialize: (options)->
    @options = options
    @options.targetClass ||= 'tbody tr'
    @options.containerClass ||= 'tbody tr'
    @targetClass = @options.targetClass
    console.log @targetClass
    delay = (->
      timer = 0
      (callback, ms) ->
        clearTimeout timer
        timer = setTimeout(callback, ms)
    )()
    $('input#search').on('keydown', (e)=>
      delay((=>@searchSet(e)), 150)
    )
    $('input#search').focus()

  filterSet: (e)->
    $container = $(@options.containerClass)
    $set = $(@el).find(@targetClass)
    $('.filter').removeClass('selected')
    $set.hide()
    $target = $(e.currentTarget)
    targetClasses = $target.attr('class')
    #Filter name must always be last
    filter_name = targetClasses.split(' ').pop()
    if filter_name == "filter-all"
      $set.show()
    else if filter_name =="sorter-name"
      $result_set = _.sortBy($set, (item)->
        console.log $(item).find('.text_filter').text().trim().toUpperCase()
        return $(item).find('.text_filter').text().trim().toUpperCase()
      )
      if $target.hasClass('sort-up')
        $result_set = $result_set.reverse()
        $target.attr('class', "sort-down #{targetClasses}")
        $target.removeClass('sort-up')
      else
        $target.attr('class', "sort-up #{targetClasses}")
        $target.removeClass('sort-down')
      $container.html($result_set)
      @animateIn($result_set)
    else
      $(@el).find("#{@targetClass}.#{filter_name}").show()
    $target.addClass('selected')
    e.preventDefault()
    return false


  searchSet: (e)->
    keyCode = e.keyCode || e.which
    $target = $(e.currentTarget)
    val = $target.val().toLowerCase()
    $('.filter').removeClass('selected')
    @result_set = @getResults(val)


  getResults: (val)->
    result_set = _.filter $(@el).find(@targetClass), (c)=>
      $(c).hide()
      val = val.replace(' ', '')
      name = $(c).find('.text_filter').text().toLowerCase()
      match = name
      if $(@targetClass).find('td.skills').length
        skills = $(c).find('td.skills .label').text().toLowerCase()
        match = name + skills
      regex = new RegExp(val, "ig")
      match.match(regex) != null
    console.log result_set
    @animateIn($(result_set))
   #return collection_set

  clearText: (e)->
    $(e.currentTarget).val('')
    
  animateIn: ($elements)->
    return if $('html').hasClass('ie7')
    return if $('html').hasClass('ie8')
    $.each $elements, (i, el) =>
      $el = $(el)
      $el.fadeTo(0, 0).delay(i * 40).fadeTo(100, 1)
      return
    return


