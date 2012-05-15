class RemoveIncorrectAndRedundantFields < ActiveRecord::Migration
  def change
    #misnamed or old image field on project
    #adding image is in DowncaseExistingEmails
    remove_column :projects, :image
    #usurped feed_url on people + companies, now have blog object
    remove_column :people, :blog_feed_url
    remove_column :companies, :blog_url
  end
end
