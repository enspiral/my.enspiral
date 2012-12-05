require 'spec_helper'

describe Admin::GroupsController do
  before(:each) do
    @person = Enspiral::CompanyNet::Person.make! :admin
    sign_in @person.user
  end

  it 'index' do
    get :index
    response.should be_success
    response.should render_template(:index)
    assigns(:groups).should_not be_nil
  end

  it 'new' do
    get :new
    response.should be_success
    response.should render_template :new
  end

  it 'create' do
    lambda{
      post :create, group: {name: 'mcdonalds'}
    }.should change(Group, :count).by(1)
    response.should be_redirect
  end

  context 'a group' do
    before :each do
      @group = Group.make!
    end
    it 'shows' do
      get :show, id: @group.id
    end
    it 'edits' do
      get :edit, id: @group.id
      response.should be_success
      response.should render_template :edit
    end
    it 'updates' do
      put :update, id: @group.id, group: {name: 'figgyies'}
      response.should be_redirect
      assigns(:group).name.should == 'figgyies'
    end

    it 'destroys' do
      delete :destroy, id: @group.id
      assigns(:group).should_not be_persisted
      response.should be_redirect
    end
  end
end
