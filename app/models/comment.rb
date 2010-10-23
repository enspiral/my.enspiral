class Comment < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :commentable, :polymorphic => true
  
  has_many :comments, :as => :commentable, :order => 'created_at'
  
  validates_presence_of :person_id, :commentable_id, :text
  
  def notice
    return self.commentable if self.commentable.is_a?(Notice)
    return self.commentable.notice
  end
  
end
