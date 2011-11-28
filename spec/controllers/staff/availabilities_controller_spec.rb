require 'spec_helper'

describe Staff::AvailabilitiesController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @availability = Availability.make!

    log_in @user
    controller.stub(:current_person) { @person }
  end

  describe "GET index" do
    it "assigns all availabilities as @availabilities" do
      get :index
      assigns(:availabilities).should eq(@person.availabilities.upcoming)
      assigns(:projects).should eq(@person.projects)
      assigns(:person).should eq(@person)

    end
  end

  describe "GET show" do
    it "assigns the requested availability as @availability" do
      get :show, :id => @availability.id
      assigns(:availability).should eq(@availability)
    end
  end

  describe "GET new" do
    it "assigns a new availability as @availability" do
      get :new
      assigns(:availability).should be_a_new(Availability)
    end
  end

  describe "GET edit" do
    it "assigns the requested availability as @availability" do
      get :edit, :id => @availability.id
      assigns(:availability).should eq(@availability)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Availability" do
        expect {
          post :create, :availability => @availability.attributes
        }.to change(Availability, :count).by(1)
      end

      it "assigns a newly created availability as @availability" do
        post :create, :availability => @availability.attributes
        assigns(:availability).should be_a(Availability)
        assigns(:availability).should be_persisted
      end

      it "redirects to the created availability" do
        post :create, :availability => @availability.attributes
        response.should redirect_to(staff_availability_path(Availability.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved availability as @availability" do
        # Trigger the behavior that occurs when invalid params are submitted
        Availability.any_instance.stub(:save).and_return(false)
        post :create, :availability => {}
        assigns(:availability).should be_a_new(Availability)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Availability.any_instance.stub(:save).and_return(false)
        post :create, :availability => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested availability" do
        # Assuming there are no other availabilities in the database, this
        # specifies that the Availability created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Availability.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @availability.id, :availability => {'these' => 'params'}
      end

      it "assigns the requested availability as @availability" do
        put :update, :id => @availability.id, :availability => @availability.attributes
        assigns(:availability).should eq(@availability)
      end

      it "redirects to the availability" do
        put :update, :id => @availability.id, :availability => @availability.attributes
        response.should redirect_to(staff_availability_path(@availability))
      end
    end

    describe "with invalid params" do
      it "assigns the availability as @availability" do
        # Trigger the behavior that occurs when invalid params are submitted
        Availability.any_instance.stub(:save).and_return(false)
        put :update, :id => @availability.id, :availability => {}
        assigns(:availability).should eq(@availability)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Availability.any_instance.stub(:save).and_return(false)
        put :update, :id => @availability.id, :availability => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested availability" do
      expect {
        delete :destroy, :id => @availability.id
      }.to change(Availability, :count).by(-1)
    end

    it "redirects to the availabilities list" do
      delete :destroy, :id => @availability.id
      response.should redirect_to(staff_availabilities_url)
    end
  end

end

