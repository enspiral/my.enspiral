require 'spec_helper'

describe Admin::GroupsController do
  it 'requires an admin' do
    @person = Person.make!(:staff)
    sign_in @person.user
    get :index
    response.should be_redirect
  end


  describe 'a system admin' do
    before(:each) do
      @person = Person.make!(:admin)
      @group = Group.make!(name: "name")
      sign_in @person.user
    end

    it 'indexes groups' do
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns(:groups).should_not be_nil
    end

    it 'shows a new group form' do
      get :new
      response.should be_success
      response.should render_template :new
    end

    it 'shows a edit group form' do
      get :edit, id: @group.id
      response.should be_success
      response.should render_template :edit
    end

    it 'creates groups' do
      lambda{
      post :create, group: {name: 'mcdonalds'}
      }.should change(Group, :count).by(1)
      response.should be_redirect
    end

    it 'updates groups' do
      put :update, id: @group.id, group: {name: 'figgyies'}
      response.should be_redirect
      assigns(:group).description.should == 'figgyies'
    end
  end

end
