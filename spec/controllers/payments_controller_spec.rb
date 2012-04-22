require 'spec_helper'

describe PaymentsController do
  before :each do
    @invoice = Invoice.make!
    @company = @invoice.company
    @person = Person.make!(:staff)
    sign_in @person.user
    CompanyMembership.make!(company:@company, person:@person, admin:true)
  end

  context 'recording a payment' do
    it "creates payments for an invocie" do
      post :create, payment: {amount: '4.5', paid_on: '2012-02-02'},
        company_id: @company.id, invoice_id: @invoice.id
      response.should redirect_to [@company, @invoice]
      flash[:notice].should =~ /Payment Created/
      assigns(:payment).amount.should == 4.5
      assigns(:payment).invoice.should == @invoice
    end

    it 'creates cash in the incoming account' do
      lambda{
        post :create, payment: {amount: '4.5', paid_on: '2012-02-02'},
        company_id: @company.id, invoice_id: @invoice.id
      }.should change(Transaction, :count).by(1)

      @company.income_account.balance.should == 4.5
    end

  end
end
