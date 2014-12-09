class Company < ActiveRecord::Base
  attr_accessible :default_contribution, :income_account_id,
    :name, :support_account_id, :contact_name, :contact_email, :contact_phone,
    :contact_skype, :address, :country_id, :city_id, :tagline, :remove_image,
    :website, :twitter, :about, :image, :retained_image, :blog_attributes, :visible,
    :show_projects, :xero_consumer_key, :xero_consumer_secret

  scope :active, where(active: true)
  scope :visible, where(visible: true)

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
  has_many :approved_customers,
            class_name: 'Customer',
            conditions: {approved: true}
  has_many :invoices
  has_many :funds_transfer_templates
  has_many :metrics

  belongs_to :country
  belongs_to :city
  belongs_to :support_account, class_name: 'Account'
  belongs_to :income_account, class_name: 'Account'
  belongs_to :outgoing_account, class_name: 'Account'

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

  def self.for_select
    Company.all.map do |company|
      [company, company.customers.approved.map { |c| [c.name, c.id] }]
    end
  end

  def xero?
    xero_consumer_key.present? && xero_consumer_secret.present?
  end

  def xero
   @xero ||= Xeroizer::PrivateApplication.new(xero_consumer_key, xero_consumer_secret, "#{Rails.root}/config/xero/privatekey.pem", :rate_limit_sleep => 3)
  end

  def create_slug
    self.slug = self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def get_invoice_from_xero_and_update
      # from = Invoice.where("xero_reference <> ''").first.date.beginning_of_day.to_s.split(" ")[0..1].join("T")
      xero_ref = Invoice.where(:imported => true).first.xero_reference
      xero_invoice = self.xero.Invoice.find("INV-#{xero_ref}")
      if xero_invoice
        xero_date = (xero_invoice.date - 1.month).beginning_of_month
      end
      invoices = self.xero.Invoice.all(:where => {:date_is_greater_than_or_equal_to => xero_date, :type => "ACCREC"})
      Invoice.insert_new_invoice invoices
  end

  def check_invoice_and_update
      xero_ref = Invoice.where(:imported => true).first.xero_reference
      xero_invoice = self.xero.Invoice.find("INV-#{xero_ref}")
      if xero_invoice
        xero_date = (xero_invoice.date - 2.month).beginning_of_month
      end
      invoices = self.xero.Invoice.all(:where => {:date_is_greater_than_or_equal_to => xero_date, :type => "ACCREC", :status => "AUTHORISED"})
      Invoice.update_existed_invoice invoices
  end

  def get_single_invoice_from_xero xero_ref
    invoices = self.xero.Invoice.find("INV-#{xero_ref}")
    # invoices = self.xero.Invoice.all(:where => {:invoice_number => "INV-#{xero_ref}"})
    Invoice.insert_single_invoice invoices
  end

  def approved_all_paid_invoices
    self.invoices.paid.each do |inv|
      if inv.approved == false
        inv.approved = true
        inv.save!
      end
    end
  end

  def get_top_customer range_month
    top_customers = []
    range_month.each do |rm|
      top_customer = {}
      result = {}
      from = rm.to_date.beginning_of_month
      to = rm.to_date.end_of_month
      # invoices = Company.find(1).xero.Invoice.all(:where => {:date_is_greater_than_or_equal_to => from, :date_is_less_than_or_equal_to => to, :type => "ACCREC"})
      # invoices.each do |el|
        # if result["#{el.contact.name}"]
          # result["#{el.contact.name}"] = result["#{el.contact.name}"] + el.attributes[:sub_total]
        # else
          # result["#{el.contact.name}"] = el.attributes[:sub_total]
        # end
      # end
      invoices = Invoice.where(:date => from..to)
      invoices.each do |el|
        if result["#{el.customer.name}"]
          result["#{el.customer.name}"] = result["#{el.customer.name}"] + el.amount
        else
          result["#{el.customer.name}"] = el.amount
        end
      end
      sort_result = result.sort_by { |name, amount| amount }
      desc_result = sort_result.reverse
      desc_result[0..9].each do |el|
        top_customer["#{el[0]}"] = el[1]
      end
      top_customers << top_customer
    end
    top_customers
  end

  def generate_manual_cash_position date_from, date_to
    result = []
    from = date_from.to_date
    to = date_to.to_date

    bank_balance = self.xero.BankSummary.get(:fromDate => from, :toDate => to).rows.last.rows.last.cells.last.value
    result << {"Bank Balance" => [bank_balance]}

    staff_accounts = self.accounts.not_closed.not_expense
    staff_accounts_balance = balance_for_accounts(staff_accounts, to)

    positive_accounts = staff_accounts.select {|ac| ac.balance > 0}
    positive_accounts_balance = balance_for_accounts(positive_accounts, to)
    result << {"Positive Accounts" => [positive_accounts_balance]}

    negative_accounts = staff_accounts.select {|ac| ac.balance < 0}
    negative_accounts_balance = balance_for_accounts(negative_accounts, to)
    result << {"- Negative Accounts" => [negative_accounts_balance * -1]}

    net_staff_accounts_balance = staff_accounts_balance
    ["Tax Paid", "Collective Funds", "Bucket", "Team"].each do |type_name|
      balance = balance_for_account_type(staff_accounts, type_name, to)
      net_staff_accounts_balance -= balance
      result << {" - '#{type_name}' Accounts" => [balance]}
    end

    result << {"Net Staff Accounts" => [net_staff_accounts_balance]}

    fund_after_paid_out = bank_balance - net_staff_accounts_balance
    result << {"Funds after staff paid out" => [fund_after_paid_out]}

    ytd_net_profit = self.xero.ProfitAndLoss.get(:fromDate => beginning_of_financial_year(date_from), :toDate => to).rows.last.rows.last.cells.last.value
    result << {"YTD Net Profit" => [ytd_net_profit]}

    result << {"- Net Staff Accounts" => [net_staff_accounts_balance]}

    net_profit = ytd_net_profit - net_staff_accounts_balance
    result << {"Net Profit/(Loss)" => [net_profit]}

    tax_to_date = net_profit - 72850.51 < 0 ? 0 : (net_profit - 72850.51) * 0.28
    result << {"Tax to date" => [tax_to_date]}

    # result
    result = result.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
  end

  def generate_montly_cash_position range_month
    results = {}
    range_month.each do |rm|
      from = rm.to_date.beginning_of_month
      to = rm.to_date.end_of_month
      monthly_position = generate_manual_cash_position from, to
      monthly_position.each_with_index do |line, index|
        results[line[0]] ||= []
        results[line[0]] << line[1][0]
      end
    end
    return results
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

  def beginning_of_financial_year(date)
    if date.to_date.month < 4
      year = date.to_date.year - 1
    else
      year = date.to_date.year
    end
    "01/04/#{year}".to_date
  end

  def balance_for_accounts(accounts, to)
    accounts.inject(0) { |sum, ac| sum += ac.balance_at(to) }
  end

  def balance_for_account_type(accounts, type_name, to)
    type = AccountType.find_by_name(type_name)
    balance_for_accounts accounts.where(:account_type_id => type.id), to
  end
end
