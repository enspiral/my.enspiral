require 'spec_helper'

describe Admin::SkillsController do
  it 'requires an admin' do
    @person = Person.make!(:staff)
    sign_in @person.user
    get :index
    response.should be_redirect
  end


  describe 'a system admin' do
    before(:each) do
      @person = Person.make!(:admin)
      @skill = Skill.make!(description: "description")
      sign_in @person.user
    end

    it 'indexes skills' do
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns(:skills).should_not be_nil
    end

    it 'shows a new skill form' do
      get :new
      response.should be_success
      response.should render_template :new
    end

    it 'shows a edit skill form' do
      get :edit, id: @skill.id
      response.should be_success
      response.should render_template :edit
    end

    it 'creates skills' do
      lambda{
      post :create, skill: {description: 'mcdonalds'}
      }.should change(Skill, :count).by(1)
      response.should be_redirect
    end

    it 'updates skills' do
      put :update, id: @skill.id, skill: {description: 'figgyies'}
      response.should be_redirect
      assigns(:skill).description.should == 'figgyies'
    end
  end
end
