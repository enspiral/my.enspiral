require 'spec_helper'

describe PasswordsController do
  before(:each) do
    login_as User.make
  end

  it "should fail validation on wrong current password" do
    post :create, :current_password => 'wrong password'
    
    flash[:notice].should be_blank
    flash[:error].should_not be_blank
    flash[:error].should eql('Password incorrect')
  end
  
  it "should fail validation on password confirmation not equal" do
    post :create, :current_password => 'secret', :user => { :password => 'new secret', :password_confirmation => 'not new secret' }
    
    flash[:notice].should be_blank
    flash[:error].should_not be_blank
    flash[:error].should eql("Password doesn't match confirmation")
  end
  
  it "should change password" do
    post :create, :current_password => 'secret', :user => { :password => 'new secret', :password_confirmation => 'new secret' }
    
    flash[:notice].should_not be_blank
    flash[:error].should be_blank
    response.should redirect_to(staff_dashboard_path)
  end
  
  it "should change password for admin" do
    login_as User.make(:admin)
    post :create, :current_password => 'secret', :user => { :password => 'new secret', :password_confirmation => 'new secret' }
    
    flash[:notice].should_not be_blank
    flash[:error].should be_blank
    response.should redirect_to(admin_dashboard_path)
  end
end
