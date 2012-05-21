Enspiral.Mixins ||= {}

Enspiral.Mixins.SortableCollectionMixin = sortedBy: (comparator) ->
  sortedCollection = new @constructor(@models)
  sortedCollection.comparator = comparator
  sortedCollection.sort()
  return sortedCollection

Enspiral.Mixins.FilterableCollectionMixin = filtered: (criteriaFunction) ->
  return new @constructor(@select(criteriaFunction))

