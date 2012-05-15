class GenerateSlugs < ActiveRecord::Migration
  def up
    User.find_each(&:save)
    Company.find_each(&:save)
    Project.find_each(&:save)
  end
end
