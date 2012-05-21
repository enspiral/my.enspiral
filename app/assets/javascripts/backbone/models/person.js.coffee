class Enspiral.Models.Person extends Backbone.Model
  paramRoot: 'person'

  created_at_timestamp: ()->
    created_at = Date.parse(@get('created_at'))*1000
    return created_at

  isActive: ->
    @get('active') == true

  isInactive: ->
    @get('active') == false

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

  active: ()->
    @filtered((person)->
      person.isActive()
    )

  inactive: ()->
    @filtered((person)->
      person.isInactive()
    )
   
  fullTime: ()->
    @filtered((person)->
      person.isFullTime()
    )

  partTime: ()->
    @filtered((person)->
      person.isPartTime()
    )
    
_.extend(Enspiral.Collections.PeopleCollection.prototype, Enspiral.Mixins.SortableCollectionMixin)
_.extend(Enspiral.Collections.PeopleCollection.prototype, Enspiral.Mixins.FilterableCollectionMixin)
