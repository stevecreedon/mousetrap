# In this section

1. Create a user controller with rspec
2. Setup the user as a RESTful resource
3. Create the RESTful GET /users index action and view
4. Write some Rspec tests for the controller
5. Secure the controller with Devise
6. Fix any tests that are breaking
7. Add some stuff to the users index view
8. Link the home page and the users page.


# 1. Create a user controller with rspec.

    bundle exec rails g controller users


# 2. make the user a RESTful resource 

  #2.1 in config/routes.rb
   
   resources :users, :only => [:index]


# 2.2 View this in rake routes

   bundle exec rake routes


# 3. Create the GET /users index action and view.

   #in app/controllers/users_controller
   
   def index
     
   end
   
   #create the file
   
   app/views/users/index.html.erb


# 4. Write some tests for the user controller


# 4.1 Create the user FactoryGirl factory 

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
   
# 4.3 Run tests

    bundle exec rake spec
   

# 5. Secure the user with Devise

    before_filter :authenticate_user!

# 6. Fix the breaking tests

    bundle exec rake spec #the tests shopuld be broking

# 6.1 add the devise test helpers to the spec_helper configuration

	config.include Devise::TestHelpers, :type => :controller
	
# 6.2 add the devise sign in helper

   	before(:each) do
   		sign_in Factory.create(:user)
 	  end
 	  
# 6.3 run the tests again.

   bundle exec rake spec

# 7. Now the test are passing let's list users in the users index view

  <table>
	<tr><th>Id.</th><th>Email</th><th>signed in</th><th>ip</th>
	<% @users.each do |user| %>
	<tr>
		<td><%= user.id %></td>
		<td><%= user.email %></td>
		<td><%= user.current_sign_in_at %></td>
		<td><%= user.current_sign_in_ip %></td>
		<td>
		<% if user.profile %>
			<%= link_to "edit profile", edit_user_profile_path(user) %>&nbsp;
			<%= link_to "show profile", user_profile_path(user) %>
		<% else %>
			<%= link_to "new profile", new_user_profile_path(user) %>
		<% end %>
		</td>
	</tr>
	<% end %>
  </table>

# 8. Now lets add some basic navigation:

# 8.1 a link from the home page to the users page:

  # in app/views/home/index.html.erb

  <%= link_to "users", users_path %>

# 8.2 And also link back to dashboard from the users page:

   # in app/views/users/index.html.erb

  <%= link_to "dashboard", root_path %>       