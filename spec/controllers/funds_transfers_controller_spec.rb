require 'spec_helper'

describe FundsTransfersController do
  before :each do
    @person = Person.make!(:staff)
    sign_in @person.user
    @source_account = Account.make!
    @destination_account = Account.make!
    @person.accounts << @source_account
  end

  it 'shows new funds transer form' do
    get :new
    response.should be_success
  end

  it 'creates a funds transfer' do
    post :create, :funds_transfer => 
      { :source_account_id => @source_account.id,
        :destination_account_id => @destination_account.id,
        :amount => '12.50'}
    response.should be_redirect
    @funds_transfer = assigns(:funds_transfer)
    @funds_transfer.should be_valid
    @funds_transfer.author.should == @person
  end

  it 'requires the current user is source account owner' do
    #huhuuh lets steal someones money
    post :create, :funds_transfer => 
      { :source_account_id => @destination_account.id,
        :destination_account_id => @source_account.id,
        :amount => '12.50'}

    # foiled again
    @funds_transfer = assigns(:funds_transfer)
    @funds_transfer.should_not be_valid
    @funds_transfer.should have(1).errors_on(:source_account)
  end
end
