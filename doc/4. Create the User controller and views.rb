# In this section

# 1. Create a user controller with rspec
# 2. Setup the user as a RESTful resource
# 3. Create the RESTful GET /users index action and view
# 4. Write some Rspec tests for the controller
# 5. Secure the controller with Devise
# 6. Fix any tests that are breaking



# 1. Create a user controller with rspec.

    bundle exec rails g controller users
    
# rspec puts the controller in app/controllers/users_controller.rb and also creates us an empty spec/controllers/users_controller_spec.rb for our tests 


# 2. make the user a RESTful resource

# A SHORT INTRO TO REST, Resources and Rails routing

# Rails 3 uses the concept of RESTful resources for routing web requests to our controllers and their methods.

# A resource is a single unit of our application, possibly a user, a profile or a comment. Typically the most we ever want to do
# with resources is create, update, show and destroy them. REST just describes this in a consistent manner so that all
# of our controllers start to look similar so understanding our application remains simple.
 
# REST isn't a strict specificationbut this is how Rails would use Rest for a theoretical resource we'll call profile:

# GET /profiles - maps to the index method in our controller and returns a list of all profiles.
# GET /profile/123 - maps to the show method in our controler and returns the profile with id 123.
# POST /profiles - maps to the create method in our controller and creates a new profile with the data POSTed to it.
# PUT /profiles/456 - maps to the update method in our controller and updates the profile with id 456.
# DELETE /profiles/567 - maps to the destroy method in our controiller and destroys the profile with id 567.

# RAILS also adds these pseudo REST methods
# GET /profiles/579/new - maps to the new method in our controller and typically used for creating a new, empty form so that we can create our profile.
# GET /PROFILES/478/edit - maps to the edit method in our controller and typically we'd use this to populate and edit form for our profile.

#2.1 in config/routes.rb
# In our case we are using Devise to create users and we don't want to update or destroy them. We only want to list them. 
   resources :users, :only => [:index]

# The :only => [:index] stops Rails creating routes such as show (GET /profiles/123) to methods we don't need so won't build. 
# We'll be using more REST methods later in this app.

# 2.2 View this in console by running:

   bundle exec rake routes
   
   # you should see 
   users GET    /users(.:format)                                    users#index
   
   
# 3. Create the GET /users index action and view.

   #in app/controllers/users_controller
   def index
     
   end
   
   #create the file
   app/views/users/index.html.erb


# 4. Write some tests for the user controller using FactoryGirl to give us users to play withå


# 4.1 First we create the FactoryGirl user factory 

# in spec/factories/users.rb

    require 'factory_girl'

    FactoryGirl.define do
      sequence :email do |n|
          "person#{n}@example.com"
      end

      factory :user do
        email
        password "xyz123"
      end
    end

# 4.2  Write some tests
# in spec/controllers/users_controller_spec

   it 'should assign all users to @users' do
     user1 = FactoryGirl.create(:user)
     user2 = FactoryGirl.create(:user)
     users = [user1, user2]

     User.should_receive(:all).and_return(users)

     get :index

     assigns(:users).should == users
   end

   it 'should render the users#index template' do
     get :index

     response.should render_template("index")
   end
   
# 4.3 Run the tests in console:

    bundle exec rake spec
    
    #you should see some test output, hopefully including the line 'Failures 0'
   

# 5. Secure the user controller with Devise

    # in app/controllers/users_controllers.rb
    before_filter :authenticate_user!

# 6. Fix the breaking tests
    #the tests should now be breaking because we've locked down the controller with Devise.

    bundle exec rake spec

# 6.1 Add the devise test helpers to the spec_helper configuration

	  config.include Devise::TestHelpers, :type => :controller
	
# 6.2 add the devise sign in helper

    # in spec/controllers/users_controller_spec.rb
   	before(:each) do
   		sign_in Factory.create(:user)
 	  end
 	  
# 6.3 run the tests again.

   bundle exec rake spec