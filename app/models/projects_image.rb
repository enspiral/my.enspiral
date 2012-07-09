class ProjectsImage < ActiveRecord::Base
  image_accessor :image
  
  belongs_to :project
end
