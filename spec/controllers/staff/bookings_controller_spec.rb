require 'spec_helper'

describe Staff::BookingsController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @project = Project.make!

    @booking = Booking.make! :person => @person, :project => @proeject


    log_in @user
    controller.stub(:current_person) { @person }
  end

  describe "GET index" do
    it "assigns all staff_bookings as @staff_bookings" do
      get :index
      assigns(:bookings).should eq([@booking])
    end
  end

  describe "GET show" do
    it "assigns the requested staff_booking as @staff_booking" do
      get :show, :id => @booking.id
      assigns(:booking).should eq(@booking)
    end
  end

  describe "GET new" do
    it "assigns a new staff_booking as @staff_booking" do
      get :new
      assigns(:booking).should be_a_new(Booking)
    end
  end

  describe "GET edit" do
    it "assigns the requested staff_booking as @staff_booking" do
      get :edit, :id => @booking.id
      assigns(:booking).should eq(@booking)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Staff::Booking" do
        expect {
          post :create, :booking => @booking.attributes
        }.to change(Booking, :count).by(1)
      end

      it "assigns a newly created staff_booking as @booking" do
        post :create, :booking => @booking.attributes
        assigns(:booking).should be_a(Booking)
        assigns(:booking).should be_persisted
      end

      it "redirects to the created staff_booking" do
        post :create, :booking => @booking.attributes
        response.should redirect_to(staff_booking_path(Booking.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved staff_booking as @staff_booking" do
        # Trigger the behavior that occurs when invalid params are submitted
        Booking.any_instance.stub(:save).and_return(false)
        post :create, :booking => {}
        assigns(:booking).should be_a_new(Booking)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Booking.any_instance.stub(:save).and_return(false)
        post :create, :booking => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested staff_booking" do
        # Assuming there are no other staff_bookings in the database, this
        # specifies that the Staff::Booking created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Booking.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @booking.id, :booking => {'these' => 'params'}
      end

      it "assigns the requested staff_booking as @staff_booking" do
        put :update, :id => @booking.id, :booking => @booking.attributes
        assigns(:booking).should eq(@booking)
      end

      it "redirects to the staff_booking" do
        put :update, :id => @booking.id, :booking => @booking.attributes
        response.should redirect_to(staff_booking_path(@booking))
      end
    end

    describe "with invalid params" do
      it "assigns the staff_booking as @staff_booking" do
        # Trigger the behavior that occurs when invalid params are submitted
        Booking.any_instance.stub(:save).and_return(false)
        put :update, :id => @booking.id, :booking => {}
        assigns(:booking).should eq(@booking)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Booking.any_instance.stub(:save).and_return(false)
        put :update, :id => @booking.id, :booking => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested staff_booking" do
      expect {
        delete :destroy, :id => @booking.id
      }.to change(Booking, :count).by(-1)
    end

    it "redirects to the staff_bookings list" do
      delete :destroy, :id => @booking.id
      response.should redirect_to(staff_bookings_url)
    end
  end
  
  describe "GET batch_edit" do
    it "assigns all upcoming bookings as @bookings" do
      get :batch_edit, :id => @project.id
     end
  end

  describe "PUT batch_update" do
    before(:each) do
      @booking1 = Booking.make! :person => @person, :project => @project, :week => Date.today + 8
      @booking2 = Booking.make! :person => @person, :project => @project, :week => Date.today + 16
    end

    it "updates a batch of given availabilities" do
      before_time = @booking2.time
      put :batch_update, :bookings => [{:id => @booking1.id, :time => @booking1.time}, {:id => @booking2.id, :time => before_time + 5}]
      Booking.last.time.should == before_time + 5
    end

    it "redirects to the availabilities list" do
      put :batch_update, :bookings => [{:id => @booking1.id, :time => @booking1.time}, {:id => @booking2.id, :time => @booking2.time}]
      response.should redirect_to(staff_availabilities_url)
    end
  end
end
