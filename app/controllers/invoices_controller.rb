class InvoicesController < IntranetController
  before_filter :load_invoiceable
  before_filter :load_invoice, only: [:edit, :show, :update, :destroy, :close, :approve, :reconcile]
  before_filter :load_company, only: [:projects]

  def index
    @invoices = @invoiceable.invoices.paginate(:page => params[:page]).per_page(20)
    @pending_invoices = @invoiceable.invoices.unapproved
    @unallocated_invoices = Invoice.get_unallocated_invoice @invoiceable.invoices
    @search_type = get_search_type params
  end

  def projects
    if params[:created_begin]
      @created_begin = params[:created_begin].to_date
    else
      @created_begin = 1.month.ago.at_beginning_of_month.to_date
    end
    if params[:created_end]
      @created_end = params[:created_end].to_date
    else
      @created_end = today_in_zone(@company)
    end
    @projects = @company.projects.active.where(created_at: @created_begin..@created_end)
    @total_quoted = 0
    @total_invoiced = 0
    @total_paid = 0
    @projects.each do |p|
      @total_quoted += p.amount_quoted ? p.amount_quoted : 0
      @total_invoiced += p.invoices.sum(:amount)
      @total_paid +=  p.invoices.paid.sum(:amount)
    end
  end


  def closed
    @invoices = @invoiceable.invoices.closed.paginate(:page => params[:page]).per_page(20)
    render :index
  end

  def imported
    @invoices = @invoiceable.invoices.where(:imported => true).paginate(:page => params[:page]).per_page(20)
  end

  def search
    if params[:type] == "opened"
      @invoices = @invoiceable.invoices.not_closed.paginate(:page => params[:page]).per_page(20)
    elsif params[:type] == "closed"
      @invoices = @invoiceable.invoices.closed.paginate(:page => params[:page]).per_page(20)
    elsif params[:type] == "pending"
      @invoices = @invoiceable.invoices.unapproved.paginate(:page => params[:page]).per_page(20)
    elsif params[:type] == "unallocated"
      @invoices = Invoice.get_unallocated_invoice @invoiceable.invoices
      @invoices = @invoices.paginate(:page => params[:page]).per_page(20)
    elsif params[:type] == "overdue"
      @invoices = @invoiceable.invoices.where("date < ?", Date.current).paginate(:page => params[:page]).per_page(20)
    elsif params[:type] == "approved"
      @invoices = @invoiceable.invoices.where(:approved => true).paginate(:page => params[:page]).per_page(20)
    else
      @invoices = @invoiceable.invoices.paginate(:page => params[:page]).per_page(20)
    end

    if !params[:from].empty? && !params[:to].empty?
      @invoices = @invoiceable.invoices.where(:date => params[:from].to_date..params[:to].to_date).paginate(:page => params[:page]).per_page(20)
    elsif !params[:from].empty?
      @invoices = @invoiceable.invoices.where(:date => params[:from]).paginate(:page => params[:page]).per_page(20)
    elsif !params[:to].empty?
      @invoices = @invoiceable.invoices.where(:date => params[:to]).paginate(:page => params[:page]).per_page(20)
    end

    if !params[:find].empty?
      by_year = []
      by_month_year = []
      by_ref = @invoiceable.invoices.where("xero_reference like '%#{params[:find]}%'").paginate(:page => params[:page]).per_page(20)
      # by_id = @invoiceable.invoices.where(:id => params[:find]).paginate(:page => params[:page]).per_page(20)
      by_customer = @invoiceable.invoices.where(customer_id: Customer.select("id").where("lower(name) like '%#{params[:find].downcase}%'")).paginate(:page => params[:page]).per_page(20)
      by_project = @invoiceable.invoices.where(project_id: Project.select("id").where("lower(name) like '%#{params[:find].downcase}%'")).paginate(:page => params[:page]).per_page(20)
      by_amount = @invoiceable.invoices.where('amount = ? and id != ?', params[:find].to_i, by_ref.map(&:id)).paginate(:page => params[:page]).per_page(20)
      if params[:find].length == 4
        if Invoice.is_numeric params[:find]
          from = "1/1/#{params[:find]}".to_date.beginning_of_month
          to = "1/12/#{params[:find]}".to_date.end_of_month
          by_year = @invoiceable.invoices.where(:date => from..to).paginate(:page => params[:page]).per_page(20)
        end
      end

      if params[:find].include? "/"
        from = "1/#{params[:find]}".to_date.beginning_of_month
        to = "1/#{params[:find]}".to_date.end_of_month
        by_month_year = @invoiceable.invoices.where(:date => from..to).paginate(:page => params[:page]).per_page(20)
      end
      @invoices = by_ref.concat(by_customer).concat(by_project).concat(by_amount).concat(by_year).concat(by_month_year)

    end
    @from = params[:from]
    @to = params[:to]
    @search_type = get_search_type params
    @pending_invoices = @invoiceable.invoices.unapproved
    @unallocated_invoices = Invoice.get_unallocated_invoice @invoiceable.invoices
    @find_text = params[:find]
    @type = params[:type]
    render :index
  end

  def new
    if @project
      @invoice = Invoice.new(project_id: @project.id, customer_id: @project.customer.id)
    elsif @customer
      @invoice = Invoice.new(customer_id: @customer.id)
    else
      @invoice = Invoice.new
    end
    @team_accounts = @invoiceable.accounts.not_closed.where("name like ?", "%TEAM%")
    @personal_accounts = @invoiceable.accounts.not_closed.where("id not in (?)", @team_accounts.map(&:id))
  end

  def edit
  end

  def close
    unless @invoice.paid?
      @invoice.close!(current_person)
      redirect_to [@invoiceable, :invoices], notice: 'Paid and closed invoice'
    else
      redirect_to [@invoiceable, :invoices], alert: 'invoice already paid'
    end
  end

  def reconcile
    @invoice.reconcile!
    redirect_to [@invoiceable, :invoices], alert: 'Invoice has been successfuly reconciled'
  end

  def approve
    unless @invoice.approved?
      @invoice.approve!
      redirect_to [@invoiceable, :invoices], notice: 'Invoice has been successfuly approved'
    else
      redirect_to [@invoiceable, :invoices], alert: 'Invoice already approved'
    end
  end

  def reverse
    invoice = Invoice.find(params[:id])

    begin
      invoice.reverse_all_payments!
      flash[:alert] = "Payment reversed successfully."
    rescue => e
      puts e.message
      flash[:error] = "Could not reverse. Please check the minimum balance of each account."
    end

    redirect_to [@invoiceable, invoice]
  end

  def create
    params[:invoice][:amount].gsub! ',', '' if params[:invoice][:amount].include?(',')
    if params[:invoice][:allocations_attributes]
      params[:invoice][:allocations_attributes].each_pair do |key, attrs|
        attrs[:contribution] = attrs[:contribution].to_f / 100.0
      end
    end
    @invoice = @invoiceable.invoices.build(params[:invoice])
    if @invoice.save
      redirect_to [@invoiceable, @invoice]
    else
      @team_accounts = @invoiceable.accounts.not_closed.where("name like ?", "%TEAM%")
      @personal_accounts = @invoiceable.accounts.not_closed.where("id not in (?)", @team_accounts.map(&:id))
      render :new
    end
  end

  def update
    if params[:invoice] && params[:invoice][:amount]
      params[:invoice][:amount].gsub! ',', '' if params[:invoice][:amount].include?(',')
    end
    if params[:invoice]
      if params[:invoice][:allocations_attributes]
        params[:invoice][:allocations_attributes].each_pair do |key, attrs|
          attrs[:contribution] = attrs[:contribution].to_f / 100.0
        end
      end
      if params[:invoice][:payments_attributes]
        params[:invoice][:payments_attributes].each_pair do |key, attrs|
          attrs[:author_id] = current_person.id
        end
      end
    end
    @invoice.update_attributes(params[:invoice])
    if @invoice.save
      redirect_to [@invoiceable, @invoice]
    else
      @team_accounts = @invoiceable.accounts.not_closed.where("name like ?", "%TEAM%")
      @personal_accounts = @invoiceable.accounts.not_closed.where("id not in (?)", @team_accounts.map(&:id))
      #puts "new cash error: " + @invoice.payments.last.new_cash_transaction.errors.inspect
      #puts "renumeration ft error:" + @invoice.payments.last.renumeration_funds_transfer.errors.inspect
      #puts "contribution ft error:" + @invoice.payments.last.contribution_funds_transfer.errors.inspect
      render :edit
    end
  end

  def show
    @payment = Payment.new
  end

  def pay_and_disburse
    @payment = @invoice.payments.create!(amount: @invoice.amount_owing, paid_on: Date.current)
    success = @invoice.disburse!(current_person)

    if success
      flash[:notice] = "Successfully paid and disbursed invoice"
    else
      flash[:alert] = 'Unable to disburse'
    end

    redirect_to [@invoiceable, Invoice]
  end

  def disburse
    if params[:invoice_allocation_id]
      @allocation = @invoice.allocations.find params[:invoice_allocation_id]
      type = 'allocation'
      success = @allocation.disburse!(current_person)
    else
      type = 'all allocations'
      success = @invoice.disburse!(current_person)
    end
    if success
      flash[:notice] = "Successfully disbursed #{type}"
    else
      flash[:alert] = 'Unable to disburse'
    end
    redirect_to [@invoiceable, @invoice]
  end

  def destroy
    if @invoice.destroy
      flash[:notice] = "Invoice successfully destroyed"
    else
      flash[:error] = "Could not destroy invoice"
    end
    redirect_to [@invoiceable, Invoice]
  end

  def get_search_type params
    if params[:project_id] && params[:company_id]
      type = "company_project"
    elsif params[:project_id]
      type = "project"
    elsif params[:customer_id]
      type = "customer"
    else
      type = "company"
    end
    return type
  end

  private
  def load_company
    @company = Company.find(:company_id)
  end

  def load_invoice
    @invoice = @invoiceable.invoices.where(id: params[:id]).first
    @team_accounts = @invoiceable.accounts.not_closed.where("name like ?", "%TEAM%")
    @personal_accounts = @invoiceable.accounts.not_closed.where("id not in (?)", @team_accounts.map(&:id))
    unless @invoice
      flash[:notice] = 'invoice not found'
      redirect_to [@invoiceable, Invoice]
    end
  end

  def load_invoiceable
    @invoiceable = (@customer || @project || @company)
  end


end
