require 'spec_helper'

describe "Staff::Customer" do
  
  before(:each) do
    @user = User.make!
    @person = Person.make! :user => @user
    login(@user)
  end

  describe "user viewing the customer index page" do
    it 'should load the management page and display a list of customers' do
      customer = Customer.make!

      visit staff_customers_url

      page.should have_content(customer.name)
      page.should have_link('Edit')
      page.should have_link(customer.name)
      page.should have_link('Destroy')
    end
  end

  describe 'user creating a customer' do

  end

  describe 'user viewing a customer' do
    it 'should show customer details' do
      customer = Customer.make!

      visit staff_customer_url(customer)

      page.should have_content(customer.name)
    end
  end

  describe 'user editing a customer' do
    it 'should allow editing of the customer details' do
      customer = Customer.make!

      visit edit_staff_customer_url(customer)

      fill_in 'customer_name', :with => 'edited_name'
      fill_in 'customer_description', :with => 'edtited_description'

      click_button 'Update'
      page.should have_content('success')
      Customer.last.name.should == 'edited_name'
      Customer.last.description.should == 'edtited_description'
    end
  end

  describe 'user deleting a customer' do
    it 'should destory a customer record' do
      customer = Customer.make!

      visit staff_customers_url

      click_link 'Destroy'

      Customer.last.should eq(nil)
    end
  end
end
