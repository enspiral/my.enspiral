class CreateProjectServices < ActiveRecord::Migration
  def self.up
	
#	create_table :table_name, {table_options} do |t|
	
	create_table :projects_services, :id => false do |t|
      t.integer :project_id
	  t.integer :service_id
	end
  end

  def self.down
	drop_table :projects_services
  end
end
