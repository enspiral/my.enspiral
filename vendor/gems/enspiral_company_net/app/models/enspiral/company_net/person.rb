module Enspiral
  module CompanyNet
    class Person < ActiveRecord::Base
      include Gravtastic
      require 'net/http'
      require 'digest/md5'

      gravtastic :rating => 'PG'
      image_accessor :image

      has_many :project_memberships, dependent: :delete_all
      has_many :projects, through: :project_memberships
      has_many :project_bookings, through: :project_memberships

      has_many :project_leaderships, class_name: 'ProjectMembership', conditions: {is_lead: true}
      has_many :lead_projects, class_name: 'Project', through: :project_leaderships, source: :project

      has_many :customers, through: :projects

      has_many :notices
      has_many :comments

      has_many :people_skills, dependent: :delete_all
      has_many :people_groups, dependent: :delete_all
      has_many :skills, :through => :people_skills
      has_many :groups, :through => :people_groups

      has_many :accounts_people, class_name: 'Enspiral::MoneyTree::AccountsPerson'
      has_many :accounts, through: :accounts_people

      has_many :featured_items, as: :resource
      has_many :funds_transfers, foreign_key: :author_id, class_name: "Enspiral::MoneyTree::FundsTransfer"

      belongs_to :user, dependent: :destroy
      belongs_to :team
      belongs_to :country
      belongs_to :city

      has_one :blog

      has_many :company_memberships, dependent: :delete_all
      has_many :companies, through: :company_memberships, source: :company
      has_many :company_adminships, class_name: 'CompanyMembership', conditions: {admin: true}
      has_many :admin_companies, through: :company_adminships, source: :company

      accepts_nested_attributes_for :user, :blog

      validates_presence_of :user, :first_name, :last_name

      validates :baseline_income, :ideal_income, :rate,
                :numericality => true, :allow_blank => true

      validate :only_publish_with_pic

      before_save :create_slug
      after_initialize { build_blog unless self.blog }

      default_scope order(:first_name)

      scope :active, where(:active => true)
      scope :public, active.where(:public => true)
      scope :private, active.where(:public => false)
      scope :contacts, active.where(:contact => true)
      scope :published, active.where(:published => true)
      scope :not_featured, lambda { published.includes(:featured_items).size == 0 }

      delegate :username, to: :user
      delegate :email, to: :user
      delegate :allocated_total, to: :account
      delegate :pending_total, to: :account
      delegate :disbursed_total, to: :account

      define_index do
        indexes [first_name, last_name], :as => :name
        indexes skills(:description), as: :skills
        indexes projects(:name), as: :person_projects_name
        indexes customers(:name), as: :person_customers_name
        has :active
      end

      delegate :admin?, to: :user

      def default_hours_available
        self[:default_hours_available] || 0
      end
      def has_gravatar?
        has_gravatar
      end

      def name
        "#{first_name} #{last_name}"
      end

      def deactivate
        raise "balance of all accounts is not 0" unless accounts.sum(:balance) == 0
        accounts.each do |a|
          a.closed = true
          a.save!
        end
        update_attribute(:active, false)
        user.update_attribute(:active, false)
      end

      def activate
        update_attribute(:active, true)
        user.update_attribute(:active, true)
      end

      def account_for_company(company)
        accounts.where(company_id: company.id).first
      end

      def create_slug
        self.slug = self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      end
      private

      def as_json(options = {})
        options ||= {}
        super(options.merge(
          :methods => [ :gravatar_url ],
          :include => {
            :accounts => {
              :methods => [:pending_total]
              #:include => {
                ##:invoice_allocations => {
                  ##:methods => [:pending]
                ##}
               #}
            }
          }
        ))
      end

      def only_publish_with_pic
        if published && image_uid.nil?
          errors.add(:published, 'Can not publish profile without a picture')
        end
      end

    end
  end
end