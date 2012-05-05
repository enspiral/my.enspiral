require 'spec_helper'

describe CompanyMembershipsController do

  before :each do
    @company = Company.make!
    @person = Person.make!
    sign_in @person.user
  end

  context 'a non company administator' do
    it 'raises an error when loading a company' do
      lambda{
        get :index, company_id: @company.id
      }.should raise_error
    end
  end

  context 'as company administrator' do
    before :each do
      @membership = @company.company_memberships.create(person: @person, admin: true)
    end

    it 'indexes memberships' do
      get :index, company_id: @company.id
      response.should be_success
      response.should render_template('index')
      assigns(:memberships).should include @membership
    end

    it 'shows new membership form' do
      get :new, company_id: @company.id
      response.should be_success
      response.should render_template('new')
    end

    it 'shows edit membership form' do
      get :edit, id: @membership.id, company_id: @company.id
      response.should be_success
      response.should render_template('edit')
    end

    it 'can create memberships' do
      @newguy = Person.make
      @newguy.save
      lambda{
        post :create, company_membership: {person_id: @newguy.id}, company_id: @company.id
      }.should change(CompanyMembership, :count).by(1)
      response.should redirect_to company_company_memberships_path(@company)
      flash[:notice].should =~ /Membership created/
      assigns(:membership).should be_valid
    end
    
    it 'can create memberships for a new person' do
      lambda{
        post :create, company_membership: {
          person_attributes: 
            {first_name: 'joe', 
             last_name: 'beaglehole', 
             user_attributes: {email: 'joe@beaglehole.com'}
             }
            }, 
          company_id: @company.id
      }.should change(CompanyMembership, :count).by(1)
      assigns(:membership).person.should be_persisted
      assigns(:membership).person.account.should be_persisted
      assigns(:membership).person.account.companies.should include @company
      response.should redirect_to company_company_memberships_path(@company)
      flash[:notice].should =~ /Membership created/
      assigns(:membership).should be_valid
    end


    it 'can update memberships' do
      put :update, id: @membership.id, company_membership:{admin: 'false'},
          company_id: @company.id
      response.should be_redirect
      assigns(:membership).admin.should be_false
      flash[:notice].should =~ /Membership updated/
    end

    it 'can update person_attributes' do
      put :update, id: @membership.id,  company_membership:{admin: 'false'},
        person_attributes: 
          {first_name: 'joe', 
           last_name: 'beaglehole', 
           rate: 400, 
           user_attributes: {email: 'joe@beaglehole.com'}
           },
        company_id: @company.id
      response.should be_redirect
      #puts assigns(:membership).inspect
      #assigns(:membership).person.rate.should == 400
      flash[:notice].should =~ /Membership updated/
    end

    it 'can destroy memberships' do
      delete :destroy, id: @membership.id, company_id: @company.id
      assigns(:membership).should_not be_persisted
    end
  end
end
