class ReportsController < IntranetController
	def index
		@company = Company.find(params[:company_id])
		redirect_to cash_position_company_reports_path(@company)
	end

	def search
		account = Account.find_by_name("#{APP_CONFIG[:collective_funds]}")
		@from = params[:from]
		@to = params[:to]
    @reports = account.get_contribution_reports params[:from], params[:to], Company.find(params[:company_id]).id
		render :index
	end

	def cash_position
		@title = "Enspiral Service: Monthly Cash Position"
		@company = Company.find(params[:company_id])
		@from = params[:from] ? params[:from] : Time.now.beginning_of_month.strftime("%d-%m-%Y")
		@to = params[:to] ? params[:to] : Time.now.end_of_month.strftime("%d-%m-%Y")
		date_from  = Date.parse(@from)
		date_to    = Date.parse(@to)
		if date_from <= date_to
			date_range = date_from..date_to
			date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq
			range_month = date_months.map {|d| d.strftime "%d-%m-%Y" }
			@date = date_months.map {|d| d.strftime "%B/%Y" }
			@reports = @company.generate_montly_cash_position range_month
		else
			@reports = []
			flash[:error] = "End date should be greater or equal to start date"
		end
		render :index
	end

	def top_customers
		@title = "Enspiral Service: Top 10 Customers"
		@company = Company.find(params[:company_id])
		@from = params[:from] ? params[:from] : Time.now.beginning_of_month.strftime("%d-%m-%Y")
		@to = params[:to] ? params[:to] : Time.now.end_of_month.strftime("%d-%m-%Y")
		date_from  = Date.parse(@from)
		date_to    = Date.parse(@to)
		date_range = date_from..date_to
		date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq
		range_month = date_months.map {|d| d.strftime "%d-%m-%Y" }
		@date = date_months.map {|d| d.strftime "%B/%Y" }
		@top_customers = @company.get_top_customer range_month
		render :index
	end

	def manual_cash_position
		# @reports = []
		if params[:commit] == "Reset"
			$global_report = []
			$global_date = []
		end
		$global_date = $global_date.nil? ? []:$global_date
		$global_report = $global_report.nil? ? []:$global_report
		@title = "Enspiral Service: Comparing Monthly Cash Position"
		@company = Company.find(params[:company_id])
		@from = params[:from] ? params[:from] : Time.now.beginning_of_month.strftime("%d-%m-%Y")
		@to = params[:to] ? params[:to] : Time.now.end_of_month.strftime("%d-%m-%Y")
		date_from  = Date.parse(@from)
		date_to    = Date.parse(@to)
		@date = []
		@date << "#{date_from} To #{date_to}"
		# date_range = date_from..date_to
		# date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq
		# range_month = date_months.map {|d| d.strftime "%d-%m-%Y" }
		# @date = date_months.map {|d| d.strftime "%B/%Y" }
		# @reports = @company.generate_montly_cash_position range_month
		@reports = @company.generate_manual_cash_position date_from, date_to
		$global_date << @date

		if $global_report.empty?
			$global_report << @reports
		else
			$global_report[0].each do |type, value|
				$global_report[0]["#{type}"] << @reports["#{type}"][0]
			end
		end
		# binding.pry
		# @reports << report
		render :index
	end

	def contribution
		@type = params[:type] ? params[:type] : "Collective Funds"
		@title = "Monthly Contribution to #{@type}"
		@from = params[:from] ? params[:from] : Time.now.beginning_of_month.strftime("%d-%m-%Y")
		@to = params[:to] ? params[:to] : Time.now.end_of_month.strftime("%d-%m-%Y")
		date_from  = Date.parse(@from)
		date_to    = Date.parse(@to)
		date_range = date_from..date_to
		date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq
		range_month = date_months.map {|d| d.strftime "%d-%m-%Y" }
		@date = date_months.map {|d| d.strftime "%B/%Y" }
    company = Company.find params[:company_id]
		if params[:type] == "Collective Funds"
			@reports = Account.get_contribution_reports  @from, @to, company
		else
			@reports = Account.get_team_contribution_reports params[:type], @from, @to
		end
		respond_to do |format|
		    format.html {render :index}
		    format.csv { send_data Report.to_csv(@reports) }
	  	end
		# render :index
	end
end
