require 'spec_helper'

describe CompanyMembershipsController do

  before :each do
    @company = Enspiral::CompanyNet::Company.make!
    @person = Enspiral::CompanyNet::Person.make!
    sign_in @person.user
  end

  context 'a non company administator' do
    it 'raises an error when loading a company' do
      lambda{
        get :index, enspiral_company_net_company_id: @company.id
      }.should raise_error
    end
  end

  context 'as company administrator' do
    before :each do
      @membership = @company.company_memberships.create(person: @person, admin: true)
    end

    it 'indexes memberships' do
      get :index, enspiral_company_net_company_id: @company.id
      response.should be_success
      response.should render_template('index')
      assigns(:memberships).should include @membership
    end

    it 'shows new membership form' do
      get :new, enspiral_company_net_company_id: @company.id
      response.should be_success
      response.should render_template('new')
    end

    it 'shows edit membership form' do
      get :edit, id: @membership.id, enspiral_company_net_company_id: @company.id
      response.should be_success
      response.should render_template('edit')
    end

    it 'can create memberships', focus: true do
      @newguy = Enspiral::CompanyNet::Person.make!
      lambda{
        post :create, company_membership: {person_id: @newguy.id}, enspiral_company_net_company_id: @company.id
      }.should change(Enspiral::CompanyNet::CompanyMembership, :count).by(1)
      response.should redirect_to enspiral_company_net_company_company_memberships_path(@company)
      @newguy.reload
      @newguy.accounts.last.company.should == @company
      assigns(:membership).should be_valid
    end
    
    context 'createing membership for a new person' do
      before :each do
        lambda{
          post :create, company_membership: {
            person_attributes: 
              {first_name: 'joe', 
               last_name: 'beaglehole', 
               user_attributes: {email: 'joe@beaglehole.com'}
               }
              }, 
            enspiral_company_net_company_id: @company.id
        }.should change(Enspiral::CompanyNet::CompanyMembership, :count).by(1)
      end
      it 'creates the person' do
        assigns(:membership).person.should be_persisted
      end

      it 'creates an account for that person and company' do
        assigns(:membership).person.accounts.where(:company_id => @company.id).count.should == 1
      end

      it 'is a nice thing' do
        response.should redirect_to enspiral_company_net_company_company_memberships_path(@company)
        assigns(:membership).should be_valid
      end
    end

    it 'can update memberships' do
      put :update, id: @membership.id, company_membership:{admin: 'false'},
          enspiral_company_net_company_id: @company.id
      response.should be_redirect
      assigns(:membership).admin.should be_false
      flash[:notice].should =~ /Membership updated/
    end

    it 'can update person_attributes' do
      put :update, id: @membership.id, company_membership: {
          admin: 'false',
          person_attributes: {
              first_name: 'joe', 
              last_name: 'beaglehole', 
              rate: 400, 
              user_attributes: {email: 'joe@beaglehole.com'}
          }
        },
        enspiral_company_net_company_id: @company.id
      response.should be_redirect
      assigns(:membership).person.rate.should == 400
      flash[:notice].should =~ /Membership updated/
    end

    it 'can destroy memberships' do
      delete :destroy, id: @membership.id, enspiral_company_net_company_id: @company.id
      assigns(:membership).should_not be_persisted
    end
  end
end
