#why is this not working
SortableCollectionMixin = sortedBy: (comparator) ->
  sortedCollection = new @constructor(@models)
  sortedCollection.comparator = comparator
  sortedCollection.sort()
  return sortedCollection

FilterableCollectionMixin = filtered: (criteriaFunction) ->
  return new @constructor(@select(criteriaFunction))
