require 'spec_helper'

describe FundsTransferTemplatesController do
  before :each do
    @company = Enspiral::CompanyNet::Company.make!
    @person = Person.make!(:staff)
    Enspiral::CompanyNet::CompanyMembership.create(company: @company, person: @person, admin: true)
    @allans_account = Enspiral::MoneyTree::Account.make! company: @company, min_balance: -100
    @coffee_club_account = Enspiral::MoneyTree::Account.make! company: @company
    sign_in @person.user
  end

  it 'indexs ftts for a company' do
    @ftt = Enspiral::MoneyTree::FundsTransferTemplate.create! company: @company, name: 'name', description: 'd'
    get :index, enspiral_company_net_company_id: @company.id
    response.should be_success
    assigns(:funds_transfer_templates).should include @ftt
  end

  it 'shows new ftt form' do
    get :new, enspiral_company_net_company_id: @company.id
    response.should be_success
  end

  it 'shows edit ftt form' do
    @ftt = Enspiral::MoneyTree::FundsTransferTemplate.create! company: @company, name: 'name', description: 'd'
    get :edit, enspiral_company_net_company_id: @company.id, id: @ftt.id
    response.should be_success
    assigns(:funds_transfer_template).should be_valid
  end

  it 'creates ftt' do
    post :create, enspiral_company_net_company_id: @company.id,
      funds_transfer_template: {
        name: 'coffeeclub',
        description: 'monthly membership fee',
        lines_attributes: {
          '0' => {
            source_account_id: @allans_account.id,
            destination_account_id: @coffee_club_account.id,
            amount: '10.00'}
        }
      }

    ftt = assigns(:funds_transfer_template)
    ftt.should be_persisted
    ftt.lines.size.should == 1
  end

  it 'updates ftt' do
    @ftt = Enspiral::MoneyTree::FundsTransferTemplate.make!(company: @company)
    put :update, id: @ftt.id, enspiral_company_net_company_id: @company.id,
      funds_transfer_template: { name: 'coffeeclub2' }
    assigns(:funds_transfer_template).name.should == 'coffeeclub2'
  end

  it 'generates fundstransfers' do
    @ftt = Enspiral::MoneyTree::FundsTransferTemplate.create(company: @company,
                                        name: 'coffeeclub',
                                        description: 'monthly membership fee')
    @ftt.lines.create(source_account: @allans_account,
                      destination_account: @coffee_club_account,
                      amount: '10.00')
    lambda{
      post :generate, enspiral_company_net_company_id: @company, id: @ftt.id
    }.should change(Enspiral::MoneyTree::FundsTransfer, :count).by(1)
    response.should be_success

  end

end
