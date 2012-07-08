#In this section:

# 1. Create the profile controller
# 2. Create the REStful profile resource
# 3. Write some test for the controller (this will take a few minutes....)

#1. Create the Profile controller

	bundle exec rails g controller profiles
	
	
# 2. Create the route
# Our profiles resource belongs to user so it seems logical that we 'nest' our profile route inside our user route so
# that we access a profile for user with id 123 with /users/123/profile. Note that we only need the users id.

# 2.1 Nest our resources :profile to our existing users resource
# For this application we want to be able to edit, create and show so the only route we don't want is destroy.

    resources :users, :only => [:index] do
    	resource :profile, :except => [:destroy]
  	end
  	
# 2.2 Take a look at the routes:

   bundle exec rake routes
  
  
# 3. Write some tests for the controller

# 3.1 Add this helper so we can call file_fixture_upload in our Factory
# We want FactoryGirl to be able to include photos with our test profiles.

    include ActionDispatch::TestProcess	

#3.2 Create a profile and users Factory

    FactoryGirl.define do
	  factory :profile do
	    name 'steve test creedon'
	    description 'this is a test description'
	    photo {
	      fixture_file_upload(Rails.root.join('spec','photos','photo.jpg'),'image/jpeg')
	    }
	  end
	end
	
#3.3 Test and build the show action

    # create the show action in the app/controllers/profiles_controller.rb
    # the route /users/:user_id/profile add the :user_id part of the url to the params
    def show
      @profile = Profile.find(:first, :conditions => {:user_id => params[:user_id]})
    end

    # create an empty app/views/profiles/show.html.erb
    
    # in spec/controllers/profiles_controller_spec.rb
   	it 'should assign the profile based on the user_id provided' do
   
     # we'll create some objects for our test
  	 profile = FactoryGirl.create(:profile)
	   user = FactoryGirl.create(:user)
   
     # we'll use Rspec to rewire the User.find(id) so that it returns our test object
	   user.profile = profile
	   User.stub(:find).with(user.id).and_return(user)
   
     #call the controller
	   get :show, :user_id => user.id.to_s
   
     #make sure our controller has created an instance variable @profile and assigned our test object to it.
	   assigns(:profile).should == profile
	   
   end

#3.4 Test and build the new action
    
    #create the new action in app/controller/profiles_controller.rb
    def new
      @profile = Profile.new
      @profile.user = User.find(params[:user_id])
    end
    
    #create an empty view app/views/profiles/new.html.erb
    
    # in spec/controllers/profiles_controller_spec.rb
    it 'should assign a new profile with a user' do
  
      #create a FactoryGirl user and use RSpec to rewire User so that User.find(id) returns our FactoryGirl user
  	  user = FactoryGirl.create(:user)
	    User.stub(:find).with('1234').and_return(user)
  
      # call the action
	    get :new, :user_id => '1234'
  
      #make sure we have an @profile that's a new Profile with the user assigned.
	    assigns(:profile).is_a?(Profile).should be_true
	    assigns(:profile).new_record?.should be_true
	    assigns(:profile).user.should == user 
  
	end
	

#3.5 Test and build the create action

    

    #create the create action in the app/controllers/profiles_controller.rb
    def create

      user = User.find(params[:user_id])
      @profile = Profile.new(params[:profile])
      @profile.user = user

      if @profile.save
        redirect_to user_profile_path(params[:user_id])
      else
        flash[:alert] = @profile.errors.full_messages.join(",")
        render :template => "profiles/new"
      end

    end
    
    # we don't need to create an empty create view because when the action succeeds we redirect to the show view.
    
    # in spec/controllers/profiles_controller_spec.rb
    it 'should create a new profile with valid data' do
      
      #we need a test photo and a name as a minimum to create a new profile
    	photo_path = File.join('/','photos', 'photo.jpg')
    	photo = fixture_file_upload(photo_path,'image/jpeg')
    	name = 'test name'
    	
    	#we also need a user we can assign the profile to
    	user = FactoryGirl.create(:user)
    	User.stub(:find).with(user.id.to_s).and_return(user)
    
      #this post should create a profile in our test database so let's just see if it chages the count.
    	lambda do
      		post :create, :user_id => user.id.to_s, :profile => {:photo => photo, :name => name}
    	end.should change(Profile, :count).by(1)
  	end


  
	it 'should redirect to the profile show action when the profile is successfuly saved' do
	    # we don't care about the parameters, we just want the profile to return true on save  
	    Profile.any_instance.stub(:save).and_return(true)
	    User.stub(:find).with('1234').and_return(FactoryGirl.create(:user))
    
	    post :create, :user_id => "1234", :profile => {}
    
	    response.should redirect_to(user_profile_path('1234'))
	end
  
	it 'should render the new template when the profile is not successfuly saved' do
	    # we don't care about the parameters, we just want the profile to return false on save     
	    Profile.any_instance.stub(:save).and_return(false)
	    User.stub(:find).with('1234').and_return(FactoryGirl.create(:user))
    
	    post :create, :user_id => "1234", :profile => {}
    
	    response.should render_template("new")
	end

    
#3.6 Test and build the edit action

   # create the edit action in the profiles_controller
   # remember that the user_id comes from the url /users/123/profile/edit
   def edit
     user = User.find(params[:user_id])
     @profile = user.profile
   end
  
   #create an empty edit.html.erb
   
   # in spec/controllers/profiles_controller_spec.rb
   	it 'should assign the specified users profile' do

      # create the FactoryGirl user and profile
      profile = FactoryGirl.create(:profile)
      user = FactoryGirl.create(:user)
      user.profile = profile
 
      # Rewire the User.find(id) so that it returns our test user
      User.stub(:find).with(user.id.to_s).and_return(user)
 
 	    get :edit, :user_id => user.id.to_s
 
      #let's make sure our controller has created an @profile variable and assigned our profile to it.
	    assigns(:profile).should == profile
	  end
		

#3.7 Test and build the update action


  # create the update action in the app/controllers/profiles_controller.rb
  def update
     @profile = Profile.find_by_user_id params[:user_id]

     if @profile.update_attributes(params[:profile])
       redirect_to user_profile_path(params[:user_id])
     else
       flash[:alert] = @profile.errors.full_messages.join(",")
       render :template => "profiles/edit"
     end

   end

  # we redirect so there is no update view
 
  # in spec/controllers/profiles_controller_spec.rb

  it 'should update the specified users profile' do
      # create our FactoryGirl test object
  	  profile = FactoryGirl.create(:profile, :user_id => 1234)
  	  
  	  #set an expectation that it should receive update_attributes with our test parameters (we don't care what the parameters are)
	    profile.should_receive(:update_attributes).with("some attributes")
  
      #Use RSpec to rewire Profile.find_by_user_id so that it returns our test profile object
	    Profile.stub(:find_by_user_id).with("1234").and_return(profile)
  
	    put :update, :user_id => 1234, :profile => "some attributes"
	end

	it 'should redirect to the profile show action when the profile update is successful' do
	    # create our FactoryGirl test object   
	    profile = FactoryGirl.create(:profile, :user_id => 1234)
	    
	    # make sure our profile update is a success
	    profile.stub(:update_attributes).with("some attributes").and_return(true)
  
      #Use RSpec to rewire Profile.find_by_user_id so that it returns our test profile object
	    Profile.stub(:find_by_user_id).with("1234").and_return(profile)
  
	    put :update, :user_id => 1234, :profile => "some attributes"
  
      # the save has succeeded so we want the user to see their new profile
	    response.should redirect_to(user_profile_path('1234'))
	end

	it 'should render the new template when the profile update is not successful' do
	    # create our FactoryGirl test object      
	    profile = FactoryGirl.create(:profile, :user_id => 1234)
	    
	    # make sure our profile update is a failure
	    profile.should_receive(:update_attributes).with("some attributes").and_return(false)
  
      #Use RSpec to rewire Profile.find_by_user_id so that it returns our test profile object
	    Profile.stub(:find_by_user_id).with("1234").and_return(profile)
  
	    put :update, :user_id => 1234, :profile => "some attributes"

      #the save has failed so we want the user to be back in edit mode
	    response.should render_template("edit")
	end

