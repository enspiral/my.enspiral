require 'spec_helper'

describe CustomersController do
  before(:each) do
    @user = User.make!
    @person = Person.make! :user => @user

    @customer = Customer.make!

    log_in @user
  end

  describe "GET index" do
    it "assigns all customers as @customers" do
      get :index
      assigns(:customers).should eq([@customer])
    end
  end

  describe "GET new" do
    it "assigns a new customer as @customer" do
      get :new
      assigns(:customer).should be_a_new(Customer)
    end
  end

  describe "GET show" do
    it "assigns the requested customer as @customer" do
      get :show, :id => @customer.id
      assigns(:customer).should eq(@customer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Staff::Customer" do
        expect {
          post :create, :cusotmer => Customer.make.attributes
        }.to change(Customer, :count).by(1)
      end

      it "assigns a newly created customer as @customer" do
        post :create, :customer =>  Customer.make.attributes
        assigns(:customer).should be_a(Customer)
        assigns(:customer).should be_persisted
      end

      it "redirects to the created staff_customer_url" do
        post :create, :customer =>  Customer.make.attributes
        response.should redirect_to(staff_customers_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved staff_project_membership as @project_membership" do
        # Trigger the behavior that occurs when invalid params are submitted
        Customer.any_instance.stub(:save).and_return(false)
        post :create, :customer => {}
        assigns(:customer).should be_a_new(Customer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Customer.any_instance.stub(:save).and_return(false)
        post :create, :customer => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested customer" do
        put :update, :id => @customer.id, :customer => {'name' => 'name'}
        Customer.last.name.should eq('name')
      end

      it "assigns the requested customer as @customer" do
        put :update, :id => @customer.id
        assigns(:customer).should == @customer
      end

      it "redirects to the customer" do
        put :update, :id => @customer.id
        response.should redirect_to(staff_customer_url(@customer))
      end
    end

    describe "with invalid params" do
      it "assigns the country as @country" do
        # Trigger the behavior that occurs when invalid params are submitted
        Customer.any_instance.stub(:save).and_return(false)
        put :update, :id => @customer.id, :customer => {}
        assigns(:customer).should == @customer
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Customer.any_instance.stub(:save).and_return(false)
        put :update, :id => @customer, :customer => {}
        response.should render_template("edit")
      end
    end

  end


  describe 'GET edit' do
    it "assigns the requested country as @country" do
      get :edit, :id => @customer.id
      assigns(:customer).should == @customer
    end 
  end

  describe "DELETE destroy" do
    it "destroys the requested Customer" do
      expect {
        delete :destroy, :id => @customer.id
      }.to change(Customer, :count).by(-1)
    end

    it "redirects to the staff_customer_path list" do
      delete :destroy, :id => @customer.id
      response.should redirect_to(staff_customers_url)
    end
  end

  
end
