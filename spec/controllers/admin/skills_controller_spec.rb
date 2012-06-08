require 'spec_helper'

describe Admin::SkillsController do
  before(:each) do
    @person = Person.make! :admin
    sign_in @person.user
  end

  it 'index' do
    get :index
    response.should be_success
    response.should render_template(:index)
    assigns(:skills).should_not be_nil
  end

  it 'new' do
    get :new
    response.should be_success
    response.should render_template :new
  end

  it 'create' do
    lambda{
      post :create, skill: {name: 'mcdonalds'}
    }.should change(Skill, :count).by(1)
    response.should be_redirect
  end

  context 'a skill' do
    before :each do
      @skill = Skill.make!
    end
    it 'shows' do
      get :show, id: @skill.id
    end
    it 'edits' do
      get :edit, id: @skill.id
      response.should be_success
      response.should render_template :edit
    end
    it 'updates' do
      put :update, id: @skill.id, skill: {name: 'figgyies'}
      response.should be_redirect
      assigns(:skill).name.should == 'figgyies'
    end

    it 'destroys' do
      delete :destroy, id: @skill.id
      assigns(:skill).should_not be_persisted
      response.should be_redirect
    end
  end
end
