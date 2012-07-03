class BehemothCleanup < ActiveRecord::Migration
  class Company < ActiveRecord::Base
    has_many :company_memberships, dependent: :delete_all
    has_many :people, through: :company_memberships

    has_many :featured_items, as: :resource

    has_many :company_admin_memberships,
             class_name: 'CompanyMembership',
             conditions: {admin: true}

    has_many :admins, through: :company_admin_memberships, source: :person

    has_many :accounts
    has_many :customers
    has_many :projects
    has_many :invoices
    has_many :funds_transfer_templates

    has_many :skills
    has_many :groups
    belongs_to :country
    belongs_to :city
    belongs_to :support_account, class_name: 'Account'
    belongs_to :income_account, class_name: 'Account'

    has_one :blog
  end
  def up

    create_table :accounts_people, :force => true do |t|
      t.references :account
      t.references :person
      t.string :role
      t.timestamps
    end

    create_table :funds_transfers, :force => true do |t|
      t.integer :author_id
      t.decimal :amount
      t.integer :source_account_id
      t.integer :destination_account_id
      t.integer :source_transaction_id
      t.integer :destination_transaction_id
      t.string :description
      t.timestamps
    end

    create_table :companies, :force => true do |t|
      t.string :name
      t.integer :income_account_id
      t.integer :support_account_id
      t.integer :default_commission
      t.timestamps
    end

    add_column :companies, :slug, :string
    add_column :companies, :image_uid, :string
    add_column :companies, :active, :boolean, null: false, default: true
    add_column :companies, :country_id, :integer
    add_column :companies, :about, :text
    add_column :companies, :website, :string
    add_column :companies, :twitter, :string
    add_column :companies, :facebook, :string
    add_column :companies, :linkedin, :string
    add_column :companies, :city_id, :integer
    add_column :companies, :contact_name, :string
    add_column :companies, :contact_phone, :string
    add_column :companies, :contact_email, :string
    add_column :companies, :contact_skype, :string
    add_column :companies, :blog_url, :string
    add_column :companies, :address, :text
    add_column :companies, :tagline, :string
    change_column :companies, :default_commission, :decimal, :precision => 10, :scale => 2, :default => 0.2

    add_index :companies, :slug, :unique => true
    add_index :companies, :active

    create_table :company_memberships, :force => true do |t|
      t.integer :company_id
      t.integer :person_id
      t.boolean :admin

      t.timestamps
    end
    add_column :company_memberships, :role, :string

    add_index :company_memberships, :company_id
    add_index :company_memberships, :person_id

    create_table :payments, :force => true do |t|
      t.decimal :amount, :precision => 10, :scale => 2
      t.date :paid_on
      t.integer :invoice_id
      t.timestamps
    end

    add_column :payments, :author_id, :integer
    add_column :payments, :transaction_id, :integer

    add_column :customers, :company_id, :integer unless column_exists? :customers, :company_id

    add_column :people, :profile_image, :string
    add_column :people, :image_uid, :string
    add_column :people, :slug, :string
    add_column :people, :rate, :decimal
    add_column :people, :about_me, :text
    add_column :people, :blog_feed_url, :string
    add_column :people, :facebook, :string
    add_column :people, :linkedin, :string
    add_column :people, :published, :boolean
    add_column :people, :account_id, :integer
    add_column :people, :tagline, :string
    add_index :people, :slug, :unique => true

    add_column :accounts, :name, :string unless column_exists? :accounts, :name
    add_column :accounts, :category, :string
    add_column :accounts, :project_id, :integer unless column_exists? :accounts, :project_id
    add_column :accounts, :active, :boolean, :default => true unless column_exists? :accounts, :active
    add_column :accounts, :public, :boolean, null: false, default: false
    add_column :accounts, :closed, :boolean, :default => false, :null => false
    add_column :accounts, :min_balance, :decimal, default: 0, null: false
    add_column :accounts, :company_id, :integer

    add_column :invoice_allocations, :account_id, :integer unless column_exists? :invoice_allocations, :account_id
    add_column :projects, :account_id, :integer
    add_column :projects, :company_id, :integer
    add_column :projects, :slug, :string
    add_column :projects, :image_uid, :string
    add_column :projects, :tagline, :string
    add_index :projects, :slug, :unique => true

    add_column :invoices, :project_id, :integer
    add_column :invoices, :xero_reference, :string
    add_column :invoice_allocations, :company_commission, :integer
    add_column :invoices, :disbursed, :boolean, null: false, default: false
    add_column :invoices, :company_id, :integer

    change_column :invoices, :paid, :boolean, :null => false, :default => false
    change_column :invoice_allocations, :disbursed, :boolean, null: false, default: false

    add_column :users, :reset_password_sent_at, :datetime

    create_table :featured_items, force: true do |t|
      t.boolean :published, default: false, null: false
      t.integer :resource_id
      t.string :resource_type
      t.timestamps
    end

    create_table :people_groups do |t|
      t.integer :group_id
      t.integer :person_id
      t.timestamps
    end

    create_table :groups do |t|
      t.string :name
      t.timestamps
    end

    @enspiral = Company.create!(name:'Enspiral', default_commission: 0.20)
    @enspiral.customers = Customer.all
    @enspiral.invoices = Invoice.all
    @enspiral.people = Person.all
    @enspiral.accounts = Account.all
    Project.all.each do |p|
      # some projects dont have customers, which make them invalid.. so just do this..
      p.update_attribute(:company_id, @enspiral.id)
    end
    @enspiral.save

    Account.where('person_id is not null').each do |a|
      if p = Person.where(id: a.person_id).first
        p.accounts << a
        a.update_attribute(:name, "#{p.name}'s Enspiral Account")
      end
    end
    puts 'migrated accounts'

    InvoiceAllocation.all.each do |allocation|
      if allocation.person_id.present?
        person = Person.find(allocation.person_id)
        allocation.update_attribute(:account_id, person.accounts.first.id)
      else
        puts "no account for #{allocation.person.name}"
      end
    end
    puts 'migrated invoice allocations'

    User.all.each do |u|
      u.update_attribute(:email, u.email.downcase)
    end
    puts 'downcased emails'

    InvoiceAllocation.all.each do |ia|
      ia.update_attribute(:disbursed, false) if ia.disbursed.nil?
    end
    puts 'invoice allocatsion'

    Person.all.each do |p|
      p.update_attribute(:email, p.email.downcase)
      p.accounts.first.update_attribute(:active, p.active)
      p.email = p.email.downcase
    end
    puts 'updated person'

    admin_emails = %w[joshua@enspiral.com rob@enspiral.com allansideas@gmail.com alanna@enspiral.com]

    admin_emails.each do |email|
      person = Person.find_by_email(email)
      if person
        cm = CompanyMembership.find_by_person_id(person.id)
        cm.update_attribute(:admin, true)
      end
    end
    puts 'created initial admins'


    change_column :accounts, :company_id, :integer, null: false

    rename_column :people, :about_me, :about
    remove_column :people, :featured
    remove_column :people, :account_id
    remove_column :people, :blog_feed_url
    remove_column :projects, :image
    remove_column :companies, :blog_url

    if column_exists? :users, :remember_token
      remove_column :users, :remember_token
    end

    drop_table :badges
    drop_table :badge_ownerships
    drop_table :goals if table_exists? :goals
    drop_table :account_permissions if table_exists? :account_permissions
    drop_table :comments if table_exists? :comments
    drop_table :notices if table_exists? :notices
    remove_column :accounts, :project_id
    remove_column :accounts, :person_id

    if table_exists? :project_people
      remove_index :project_people, :person_id if index_exists? :project_people, :person_id
      remove_index :project_people, :project_id if index_exists? :project_people, :project_id
      drop_table :project_people 
    end
  end
end
