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
    tmp = {"Bank Balance" => [bank_balance]}
    result << tmp

    staff_accounts = self.accounts.not_closed.not_expense
    from = date_from.to_date
    to = date_to.to_date
    sa_balance = 0
    staff_accounts.each do |sa|
      sa_balance = sa_balance + sa.transactions.where("date <= ?", to).sum(:amount)
    end
    staff_account = sa_balance
    tmp = {"Staff Accounts" => [staff_account]}
    result << tmp

    from = date_from.to_date
    to = date_to.to_date
    type = AccountType.find_by_name("Tax Paid")
    tax_paid = self.accounts.find_by_account_type_id(type.id) ? self.accounts.find_by_account_type_id(type.id).transactions.where("date <= ?", to).sum(:amount) : 0
    tmp = {'- JV "Tax Paid" Account' => [tax_paid]}
    result << tmp

    from = date_from.to_date
    to = date_to.to_date
    type = AccountType.find_by_name("Collective Funds")
    collective_fund = self.accounts.find_by_account_type_id(type.id) ? self.accounts.find_by_account_type_id(type.id).transactions.where("date <= ?", to).sum(:amount) : 0
    tmp = {'- "Collective Funds" Account' => [collective_fund]}
    result << tmp

    from = date_from.to_date
    to = date_to.to_date
    type = AccountType.find_by_name("Bucket")
    bucket_accounts = self.accounts.where(:account_type_id => type.id)
    b_balance = 0
    bucket_accounts.each do |ba|
      b_balance = b_balance + ba.transactions.where("date <= ?", to).sum(:amount)
    end
    bucket_account = b_balance
    tmp = {'- "Bucket" Accounts' => [bucket_account]}
    result << tmp

    from = date_from.to_date
    to = date_to.to_date
    type = AccountType.find_by_name("Team")
    team_accounts = self.accounts.where(:account_type_id => type.id)
    team_account = 0
    team_accounts.each do |ta|
      team_account = team_account + ta.transactions.where("date <= ?", to).sum(:amount)
    end
    team_balance = team_account
    tmp = {'- "Team" Accounts' => [team_balance]}
    result << tmp

    net_staff_account = staff_account - tax_paid - collective_fund - bucket_account - team_balance
    tmp = {"Net Staff Accounts" => [net_staff_account]}
    result << tmp

    fund_after_paid_out = bank_balance - net_staff_account
    tmp = {"Funds after staff paid out" => [fund_after_paid_out]}
    result << tmp

    from = "01/04/#{date_from.to_date.year}".to_date
    to = date_to.to_date
    ytd_net_profit = self.xero.ProfitAndLoss.get(:fromDate => from, :toDate => to).rows.last.rows.last.cells.last.value
    tmp = {"YTD Net Profit" => [ytd_net_profit]}
    result << tmp

    tmp = {"- Net Staff Accounts" => [net_staff_account]}
    result << tmp

    net_profit = ytd_net_profit - net_staff_account
    tmp = {"Net Profit/(Loss)" => [net_profit]}
    result << tmp

    tax_to_date = net_profit - 72850.51 < 0 ? 0 : (net_profit - 72850.51) * 0.28
    tmp = {"Tax to date" => [tax_to_date]}
    result << tmp 

    # result
    result = result.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}

  end

  def generate_montly_cash_position range_month
    result = []
    bank_balance = []
    range_month.each do |rm|
      from = rm.to_date.beginning_of_month
      to = rm.to_date.end_of_month
      tmp_result = self.xero.BankSummary.get(:fromDate => from, :toDate => to).rows.last.rows.last.cells.last.value
      bank_balance << tmp_result if tmp_result
    end
    tmp = {"Bank Balance" => bank_balance}
    result << tmp

    staff_accounts = self.accounts.not_closed.not_expense
    staff_account = []
    range_month.each do |rm|
      from = rm.to_date.beginning_of_month
      to = rm.to_date.end_of_month
      sa_balance = 0
      staff_accounts.each do |sa|
        sa_balance = sa_balance + sa.transactions.where("date <= ?", to).sum(:amount)
      end
      staff_account << sa_balance
    end
    tmp = {"Staff Accounts" => staff_account}
    result << tmp

    tax_paid = []
    range_month.each do |rm|
      from = rm.to_date.beginning_of_month
      to = rm.to_date.end_of_month
      type = AccountType.find_by_name("Tax Paid")
      tmp_result = self.accounts.find_by_account_type_id(type.id) ? self.accounts.find_by_account_type_id(type.id).transactions.where("date <= ?", to).sum(:amount) : 0
      tax_paid << tmp_result
    end
    tmp = {'- JV "Tax Paid" Account' => tax_paid}
    result << tmp

    collective_fund = []
    range_month.each do |rm|
      from = rm.to_date.beginning_of_month
      to = rm.to_date.end_of_month
      type = AccountType.find_by_name("Collective Funds")
      tmp_result = self.accounts.find_by_account_type_id(type.id) ? self.accounts.find_by_account_type_id(type.id).transactions.where("date <= ?", to).sum(:amount) : 0
      collective_fund << tmp_result
    end
    tmp = {'- "Collective Funds" Account' => collective_fund}
    result << tmp

    bucket_account = []
    type = AccountType.find_by_name("Bucket")
    bucket_accounts = self.accounts.where(:account_type_id => type.id)
    range_month.each do |rm|
      b_balance = 0
      from = rm.to_date.beginning_of_month
      to = rm.to_date.end_of_month
      bucket_accounts.each do |ba|
        b_balance = b_balance + ba.transactions.where("date <= ?", to).sum(:amount)
      end
      bucket_account << b_balance
    end
    tmp = {'- "Bucket" Accounts' => bucket_account}
    result << tmp

    team_balance = []
    type = AccountType.find_by_name("Team")
    team_accounts = self.accounts.where(:account_type_id => type.id)
    range_month.each do |rm|
      team_account = 0
      from = rm.to_date.beginning_of_month
      to = rm.to_date.end_of_month
      team_accounts.each do |ta|
        team_account = team_account + ta.transactions.where("date <= ?", to).sum(:amount)
      end
      # craftwork_devops = self.accounts.find_by_name("Craftworks Devops") ? self.accounts.find_by_name("Craftworks Devops").transactions.where("date <= ?", to).sum(:amount) : 0
      # craftwork_insighter = self.accounts.find_by_name("Craftworks Insighter") ? self.accounts.find_by_name("Craftworks Insighter").transactions.where("date <= ?", to).sum(:amount) : 0
      # tmp_balance = team_account + craftwork_devops + craftwork_insighter
      tmp_balance = team_account
      team_balance << tmp_balance
    end
    tmp = {'- "Team" Accounts' => team_balance}
    result << tmp

    net_staff_account = []
    range_month.each_with_index do |rm, index|
      tmp_balance = staff_account[index] - tax_paid[index] - collective_fund[index] - bucket_account[index] - team_balance[index]
      net_staff_account << tmp_balance
    end
    tmp = {"Net Staff Accounts" => net_staff_account}
    result << tmp

    fund_after_paid_out = []
    range_month.each_with_index do |rm, index|
      tmp_balance = bank_balance[index] - net_staff_account[index]
      fund_after_paid_out << tmp_balance
    end
    tmp = {"Funds after staff paid out" => fund_after_paid_out}
    result << tmp

    ytd_net_profit = []
    range_month.each do |rm|
      # from = rm.to_date.beginning_of_month
      from = "01/04/#{rm.to_date.year}".to_date.beginning_of_month
      to = rm.to_date.end_of_month
      tmp_result = self.xero.ProfitAndLoss.get(:fromDate => from, :toDate => to).rows.last.rows.last.cells.last.value
      ytd_net_profit << tmp_result if tmp_result
    end
    tmp = {"YTD Net Profit" => ytd_net_profit}
    result << tmp

    tmp = {"- Net Staff Accounts" => net_staff_account}
    result << tmp

    net_profit = []
    range_month.each_with_index do |rm, index|
      tmp_balance = ytd_net_profit[index] - net_staff_account[index]
      net_profit << tmp_balance
    end
    tmp = {"Net Profit/(Loss)" => net_profit}
    result << tmp

    tax_to_date = []
    range_month.each_with_index do |rm, index|
      # tmp_balance = net_profit[index] - 72850.51 < 0 ? 0 : (net_profit[index] - 72850.51) * 0.28
      tmp_balance = net_profit[index] < 0 ? 0 : net_profit[index] * 0.28
      tax_to_date << tmp_balance
    end
    tmp = {"Estimated Tax" => tax_to_date}
    result << tmp 

    result = result.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
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
