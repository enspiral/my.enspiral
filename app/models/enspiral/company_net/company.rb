module Enspiral
  module CompanyNet
    class Company < ActiveRecord::Base
      attr_accessible :default_contribution, :income_account_id,
        :name, :support_account_id, :contact_name, :contact_email, :contact_phone,
        :contact_skype, :address, :country_id, :city_id, :tagline, :remove_image,
        :website, :twitter, :about, :image, :retained_image, :blog_attributes, :visible

      scope :active, where(active: true)
      scope :visible, where(visible: true)

      has_many :company_memberships, dependent: :delete_all
      has_many :people, through: :company_memberships

      has_many :featured_items, as: :resource

      has_many :company_admin_memberships,
               class_name: 'CompanyMembership',
               conditions: {admin: true}

      has_many :admins, through: :company_admin_memberships, source: :person

      has_many :accounts, class_name: "Enspiral::MoneyTree::Account"
      has_many :customers
      has_many :projects
      has_many :invoices, class_name: "Enspiral::MoneyTree::Invoice"
      has_many :funds_transfer_templates, class_name: "Enspiral::MoneyTree::FundsTransferTemplate"
      has_many :metrics

      belongs_to :country
      belongs_to :city
      belongs_to :support_account, class_name: 'Enspiral::MoneyTree::Account'
      belongs_to :income_account, class_name: 'Enspiral::MoneyTree::Account'
      belongs_to :outgoing_account, class_name: 'Enspiral::MoneyTree::Account'

      has_one :blog

      validates_numericality_of :default_contribution,
                                greater_than_or_equal_to: 0,
                                less_than_or_equal_to: 1
      validates_presence_of :name, :default_contribution

      accepts_nested_attributes_for :blog

      after_create :ensure_main_accounts
      before_save :create_slug
      after_initialize { build_blog unless self.blog }

      scope :active, where(active: true)

      image_accessor :image


      def create_slug
        self.slug = self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      end

      private
      
        def ensure_main_accounts
          unless self.income_account.present?
            build_income_account(name: "#{name} Income Account")
            self.income_account.company = self
            self.income_account.save!
          end

          unless self.support_account.present?
            build_support_account(name: "#{name} Support Account")
            self.support_account.company = self
            self.support_account.save!
          end

          accounts << income_account
          accounts << support_account
          self.save!
        end
    end
  end
end