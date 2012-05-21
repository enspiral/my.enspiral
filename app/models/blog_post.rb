class BlogPost < ActiveRecord::Base
  attr_accessible :post_id, :author, :blog_id, :content, :posted_at, :summary, :title, :url
  validates_uniqueness_of :post_id, :scope => :blog_id
  belongs_to :blog
  default_scope :order => "posted_at DESC"
end
