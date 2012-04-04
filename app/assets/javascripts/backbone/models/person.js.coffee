class Enspiral.Models.Person extends Backbone.Model
  paramRoot: 'person'

class Enspiral.Collections.PeopleCollection extends Backbone.Collection
  model: Enspiral.Models.Person
  url: '/people'
