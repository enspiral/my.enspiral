class ExternalAccountsController < IntranetController

  def index
    if @company.present?
      @accounts = @company.external_accounts.all
    end
  end
end
