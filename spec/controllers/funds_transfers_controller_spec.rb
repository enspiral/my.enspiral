require 'spec_helper'

describe FundsTransfersController do
  before :each do
    @company = Company.make!
    @person = Person.make!(:staff)
    @personal_account = Enspiral::MoneyTree::Account.make!(company: @company)
    @personal_account.transactions.create!(amount: 50,
                                           description: 'pocket money',
                                           date: Date.today)
    CompanyMembership.make!(company:@company, person:@person, admin: true)
    @person.accounts << @personal_account

    @company_account = Enspiral::MoneyTree::Account.make!(company: @company)
    @company_account.transactions.create!(amount: 50,
                                           description: 'pocket money',
                                           date: Date.today)

    @destination_account = Enspiral::MoneyTree::Account.make!(company: @company)
    sign_in @person.user
  end

  it 'shows new funds transer form' do
    get :new
    response.should be_success
  end

  it 'creates a funds transfer for a personal account' do
    post :create, :funds_transfer =>
      { :source_account_id => @personal_account.id,
        :destination_account_id => @destination_account.id,
        :description => 'test transfer',
        :amount => '12.50'}
    @funds_transfer = assigns(:funds_transfer)
    @funds_transfer.should be_valid
    @funds_transfer.author.should == @person
    response.should be_redirect
  end

  it 'creates a funds transfer for a company account' do
    post :create, :company_id => @company.id,
      :funds_transfer =>
      { :source_account_id => @company_account.id,
        :destination_account_id => @destination_account.id,
        :description => 'test transfer',
        :amount => '12.50'}
    @funds_transfer = assigns(:funds_transfer)
    @funds_transfer.should be_valid
    @funds_transfer.author.should == @person
    response.should be_redirect
  end

  it 'requires the current user is source account owner' do
    #huhuuh lets steal someones money
    post :create, :funds_transfer => 
      { :source_account_id => @destination_account.id,
        :destination_account_id => @personal_account.id,
        :description => 'test transfer',
        :amount => '12.50'}

    # foiled again
    @funds_transfer = assigns(:funds_transfer)
    @funds_transfer.should_not be_persisted
    flash[:alert].should =~ /not a source account administator/
  end
end
