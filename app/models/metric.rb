class Metric < ActiveRecord::Base
  belongs_to :company, class_name: 'Enspiral::CompanyNet::Company'
  attr_accessible :company, :active_users, :for_date, :people, :external_revenue, :internal_revenue
  validates_uniqueness_of :for_date, scope: :company_id
  validates_presence_of :company

  default_scope order('for_date desc')

  def revenue_pp
    people.present? ? (external_revenue + internal_revenue) / people : nil
  end

  #return the metric in the same month as date
  def self.in_month date
    self.where("for_date >= '#{date.beginning_of_month}' AND for_date <= '#{date.end_of_month}'").first
  end
end
