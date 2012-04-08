SortableCollectionMixin = sortedBy: (comparator) ->
  sortedCollection = new @constructor(@models)
  sortedCollection.comparator = comparator
  sortedCollection.sort()
  return sortedCollection

FilterableCollectionMixin = filtered: (criteriaFunction) ->
  return new @constructor(@select(criteriaFunction))

class Enspiral.Models.Person extends Backbone.Model
  paramRoot: 'person'

  created_at_timestamp: ()->
    created_at = Date.parse(@get('created_at'))*1000
    return created_at

  isFullTime: ->
    @get('desired_employment_status') == 'Full time'

  isPartTime: ->
    @get('desired_employment_status') == 'Part time'

class Enspiral.Collections.PeopleCollection extends Backbone.Collection
  model: Enspiral.Models.Person
  url: '/people'

  comparator: (person)->
    return person.attributes.first_name


  byNewest: ()->
    @sortedBy((person)->
      -person.created_at_timestamp()
    )

  byOldest: ()->
    @sortedBy((person)->
      person.created_at_timestamp()
    )
   
  fullTime: ()->
    @filtered((person)->
      person.isFullTime()
    )

  partTime: ()->
    @filtered((person)->
      person.isPartTime()
    )
    


_.extend(Enspiral.Collections.PeopleCollection.prototype, SortableCollectionMixin)
_.extend(Enspiral.Collections.PeopleCollection.prototype, FilterableCollectionMixin)
