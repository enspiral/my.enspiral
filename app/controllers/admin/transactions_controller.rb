class Admin::TransactionsController < Admin::Base
  def index
    @transactions = Transaction.limit(50).order('created_at DESC')
  end
end
