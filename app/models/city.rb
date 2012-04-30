class City < ActiveRecord::Base
  has_many :people, :dependent => :nullify
  belongs_to :country, :dependent => :destroy
  validates_presence_of :country_id, :name
  validates_uniqueness_of :name, :scope => :country_id
  default_scope order(:country_id).order(:name)
end
