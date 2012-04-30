class Country < ActiveRecord::Base
  has_many :cities, :order => 'name', :dependent => :destroy
  has_many :people, :dependent => :nullify
  validates_presence_of :name
  validates_uniqueness_of :name
  default_scope order(:name)
end
