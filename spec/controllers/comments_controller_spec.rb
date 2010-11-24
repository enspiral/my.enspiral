require 'spec_helper'

describe CommentsController do
  before(:each) do
    @user = User.make
    @user.save!
    @person = Person.make :user => @user
    @person.save!
    @notice = Notice.make :person => @person
    @notice.save
    @n_comment = Comment.make :person => @person, :commentable => @notice
    @n_comment.save!
    login_as @user
  end

  def mock_comment(stubs={})
    (@mock_comment ||= mock_model(Comment).as_null_object).tap do |comment|
      comment.stub(stubs) unless stubs.empty?
    end
  end

  # describe "GET index" do
  #   it "assigns all comments as @comments" do
  #     Comment.stub(:all) { [mock_comment] }
  #     get :index
  #     assigns(:comments).should eq([mock_comment])
  #   end
  # end

  # describe "GET show" do
  #   it "assigns the requested comment as @comment" do
  #     Comment.stub(:find).with("37") { mock_comment }
  #     get :show, :id => "37"
  #     assigns(:comment).should be(mock_comment)
  #   end
  # end

  describe "GET new" do
    it "should redirect with no @commentable retrieved" do
      get :new
      response.should redirect_to(notices_url)
    end
    
    it "assigns a new comment as @comment for notice" do
      Comment.stub(:new) { mock_comment }
      get :new, :notice_id => @notice.id
      assigns(:commentable).should eql(@notice)
      assigns(:comment).should be(mock_comment)
    end
    
    it "assigns a new comment as @comment for comment" do
      Comment.stub(:new) { mock_comment }
      get :new, :comment_id => @n_comment.id
      assigns(:commentable).should eql(@n_comment)
      assigns(:comment).should be(mock_comment)
    end
  end

  # describe "GET edit" do
  #   it "assigns the requested comment as @comment" do
  #     Comment.stub(:find).with("37") { mock_comment }
  #     get :edit, :id => "37"
  #     assigns(:comment).should be(mock_comment)
  #   end
  # end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created comment as @comment for notice" do
        Comment.stub(:new).with({'person_id' => @person.id, 'text' => 'text'}) { mock_comment(:save => true) }
        post :create, :comment => {'text' => 'text'}, :notice_id => @notice.id
        assigns(:commentable).should eql(@notice)
        assigns(:comment).should be(mock_comment)
      end

      it "redirects to the notice of the created comment for notice" do
        Comment.stub(:new).with({'person_id' => @person.id, 'text' => 'text'}) { mock_comment(:save => true) }
        post :create, :comment => {'text' => 'text'}, :notice_id => @notice.id
        response.should redirect_to(notice_url(@notice))
      end
      
      it "assigns a newly created comment as @comment for comment" do
        Comment.stub(:new).with({'person_id' => @person.id, 'text' => 'text'}) { mock_comment(:save => true) }
        post :create, :comment => {'text' => 'text'}, :comment_id => @n_comment.id
        assigns(:commentable).should eql(@n_comment)
        assigns(:comment).should be(mock_comment)
      end

      it "redirects to the notice of the created comment for comment" do
        Comment.stub(:new).with({'person_id' => @person.id, 'text' => 'text'}) { mock_comment(:save => true) }
        post :create, :comment => {'text' => 'text'}, :comment_id => @n_comment.id
        response.should redirect_to(notice_url(@notice))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        Comment.stub(:new).with({'person_id' => @person.id, 'these' => 'params'}) { mock_comment(:save => false) }
        post :create, :comment => {'these' => 'params'}, :notice_id => @notice.id
        assigns(:comment).should be(mock_comment)
      end

      it "re-renders the 'new' template" do
        Comment.stub(:new) { mock_comment(:save => false) }
        post :create, :comment => {}, :notice_id => @notice.id
        response.should render_template("new")
      end
    end

  end

  # describe "PUT update" do

    # describe "with valid params" do
    #   it "updates the requested comment" do
    #     Comment.should_receive(:find).with("37") { mock_comment }
    #     mock_comment.should_receive(:update_attributes).with({'these' => 'params'})
    #     put :update, :id => "37", :comment => {'these' => 'params'}
    #   end
    # 
    #   it "assigns the requested comment as @comment" do
    #     Comment.stub(:find) { mock_comment(:update_attributes => true) }
    #     put :update, :id => "1"
    #     assigns(:comment).should be(mock_comment)
    #   end
    # 
    #   it "redirects to the comment" do
    #     Comment.stub(:find) { mock_comment(:update_attributes => true) }
    #     put :update, :id => "1"
    #     response.should redirect_to(comment_url(mock_comment))
    #   end
    # end

    # describe "with invalid params" do
    #   it "assigns the comment as @comment" do
    #     Comment.stub(:find) { mock_comment(:update_attributes => false) }
    #     put :update, :id => "1"
    #     assigns(:comment).should be(mock_comment)
    #   end
    # 
    #   it "re-renders the 'edit' template" do
    #     Comment.stub(:find) { mock_comment(:update_attributes => false) }
    #     put :update, :id => "1"
    #     response.should render_template("edit")
    #   end
    # end

  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested comment" do
  #     Comment.should_receive(:find).with("37") { mock_comment }
  #     mock_comment.should_receive(:destroy)
  #     delete :destroy, :id => "37"
  #   end
  # 
  #   it "redirects to the comments list" do
  #     Comment.stub(:find) { mock_comment }
  #     delete :destroy, :id => "1"
  #     response.should redirect_to(comments_url)
  #   end
  # end

end
