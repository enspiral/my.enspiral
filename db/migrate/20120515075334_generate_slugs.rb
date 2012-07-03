class GenerateSlugs < ActiveRecord::Migration
  def up
    create_all_slugs(Person)
    create_all_slugs(Company)
    create_all_slugs(Project)
  end

  def create_all_slugs(collection)
    collection.find_each do |item|
      item.update_attribute(:slug, item.create_slug)
    end
  end
end
