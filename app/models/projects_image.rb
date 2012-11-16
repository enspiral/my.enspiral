class ProjectsImage < ActiveRecord::Base
  image_accessor :image
  
  belongs_to :project, class_name: 'Enspiral::CompanyNet::Project'
end
