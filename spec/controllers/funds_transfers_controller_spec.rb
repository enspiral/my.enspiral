require 'spec_helper'

describe FundsTransfersController do
  before :each do
    @company = Company.make!
    @person = Person.make!(:staff)
    @personal_account = Account.make!(company: @company)
    @personal_account.transactions.create!(amount: 50,
                                           description: 'pocket money',
                                           date: Date.current)
    CompanyMembership.make!(company:@company, person:@person, admin: true)
    @person.accounts << @personal_account

    @company_account = Account.make!(company: @company)
    @company_account.transactions.create!(amount: 50,
                                           description: 'pocket money',
                                           date: Date.current)

    @destination_account = Account.make!(company: @company)
    sign_in @person.user
  end

  it 'shows new funds transfer form' do
    get :new, company_id: @company.id
    response.should be_success
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
    regular_person = Person.make!(:staff)
    CompanyMembership.make!(company:@company, person:regular_person, admin: false)
    sign_in regular_person.user

    #huhuuh lets steal someones money
    post :create, company_id: @company.id,
      :funds_transfer => 
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
