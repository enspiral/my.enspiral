require 'spec_helper'

describe ProfilesController do
  before :each do
    @person = Person.make!(:staff)
    sign_in @person.user
  end

  it 'shows edit profile page' do
    get :edit
    response.should be_success
    response.should render_template :edit
  end

  it 'updates current users profile' do
    put :update, person: {first_name: 'bill'}
    response.should be_redirect
    assigns(:person).first_name.should == 'bill'
  end
end
