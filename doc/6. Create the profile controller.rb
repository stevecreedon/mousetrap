#In this section:

1. Create the profile controller
2. Create the REStful profile resource
3. Write some test for the controller (this will take a few minutes....)
4. Create the views  

#1. Create the Profile controller

	bundle exec rails g controller :profiles
	
#2. Create the nested route

#2.1 Nest our resources :profile to our existing users resource

    resources :users, :only => [:index] do
    	resource :profile
  	end
  	
#2.2 Take a look at the routes:

   bundle exec rake routes
  
#3. Write some tests for the controller

#3.1 Add this helper so we can call file_fixture_upload in our Factory

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

    # create the show action in the profiles_controller
    
    def show
      @profile = Profile.find(:first, :conditions => {:user_id => params[:user_id]})
    end

    # create an empty profiles/show.html.erb
    
    # in spec/controllers/profiles_controller_spec.rb

   	it 'should assign the profile based on the user_id provided' do
   
  	 profile = FactoryGirl.create(:profile)
	   user = FactoryGirl.create(:user)
   
	   user.profile = profile
   
	   User.stub(:find).with(user.id).and_return(user)
   
	   get :show, :user_id => user.id.to_s
   
	   assigns(:profile).should == profile
   end

#3.4 Test and build the new action
    
    #create the new action in the profiles_controller
    
    def new
      @profile = Profile.new
      @profile.user = User.find(params[:user_id])
    end
    
    #create an empty profiles/new.html.erb
    
    # in spec/controllers/profiles_controller_spec.rb

    it 'should assign a new profile with a user' do
  
  	  user = FactoryGirl.create(:user)
	  User.stub(:find).with('1234').and_return(user)
  
	  get :new, :user_id => '1234'
  
	  assigns(:profile).is_a?(Profile).should be_true
	  assigns(:profile).new_record?.should be_true
	  assigns(:profile).user.should == user 
  
	end
	

#3.5 Test and build the create action

    

    #create the create action in the profiles_controller
    
    def create

      user = User.find(params[:user_id])
      @profile = Profile.new(params[:profile])
      @profile.user = user

      if @profile.save
        redirect_to user_profile_path(params[:user_id])
      else
        render :template => "profiles/new"
      end

    end
    
    # when the action succeeds we redirect so there is no create view
    
    # in spec/controllers/profiles_controller_spec.rb

    it 'should create a new profile with valid data' do
    	photo_path = File.join('/','photos', 'photo.jpg')
    	photo = fixture_file_upload(photo_path,'image/jpeg')
    	name = 'test name'
    	user = FactoryGirl.create(:user)
    	User.stub(:find).with(user.id.to_s).and_return(user)
    
    	lambda do
      		post :create, :user_id => user.id.to_s, :profile => {:photo => photo, :name => name}
    	end.should change(Profile, :count).by(1)
  	end


  
	it 'should redirect to the profile show action when the profile is successfuly saved' do   
	    Profile.any_instance.stub(:save).and_return(true)
	    User.stub(:find).with('1234').and_return(FactoryGirl.create(:user))
    
	    post :create, :user_id => "1234", :profile => {}
    
	    response.should redirect_to(user_profile_path('1234'))
	end
  
	it 'should render the new template when the profile is not successfuly saved' do   
	    Profile.any_instance.stub(:save).and_return(false)
	    User.stub(:find).with('1234').and_return(FactoryGirl.create(:user))
    
	    post :create, :user_id => "1234", :profile => {}
    
	    response.should render_template("new")
	end

    
#3.6 Test and build the edit action

   # create the edit action in the profiles_controller
   
   def edit
     user = User.find(params[:user_id])
     @profile = user.profile
   end
  
   #create an empty edit.html.erb
   
   # in spec/controllers/profiles_controller_spec.rb

   	it 'should assign the specified users profile' do

      profile = FactoryGirl.create(:profile)
      user = FactoryGirl.create(:user)
      user.profile = profile
 
      user.stub(:find).with(user.id.to_s).and_return(user)
 
 	    get :edit, :user_id => user.id.to_s
 
	    assigns(:profile).should == profile
	  end
		

#3.7 Test and build the update action


  # create the update action in the profiles_controller
  
  def update
     @profile = Profile.find_by_user_id params[:user_id]

     if @profile.update_attributes(params[:profile])
       redirect_to user_profile_path(params[:user_id])
     else
       render :template => "profiles/edit"
     end

   end

  # we redirect so there is no update view
 
  # in spec/controllers/profiles_controller_spec.rb

  it 'should update the specified users profile' do
  	  profile = FactoryGirl.create(:profile, :user_id => 1234)
	    profile.should_receive(:update_attributes).with("some attributes")
  
	    Profile.stub(:find_by_user_id).with("1234").and_return(profile)
  
	    put :update, :user_id => 1234, :profile => "some attributes"
	end

	it 'should redirect to the profile show action when the profile update is successful' do   
	    profile = FactoryGirl.create(:profile, :user_id => 1234)
	    profile.should_receive(:update_attributes).with("some attributes").and_return(true)
  
	    Profile.stub(:find_by_user_id).with("1234").and_return(profile)
  
	    put :update, :user_id => 1234, :profile => "some attributes"
  
	    response.should redirect_to(user_profile_path('1234'))
	end

	it 'should render the new template when the profile update is not successful' do   
	    profile = FactoryGirl.create(:profile, :user_id => 1234)
	    profile.should_receive(:update_attributes).with("some attributes").and_return(false)
  
	    Profile.stub(:find_by_user_id).with("1234").and_return(profile)
  
	    put :update, :user_id => 1234, :profile => "some attributes"

	    response.should render_template("edit")
	end

# 4. Create the views

# 4.1 Create the form partial and add it to new and edit 

   <%= form_for @profile, :url => user_profile_path(@profile.user), :multipart => true do |form| %>
	  <div>
  		<%= form.label :name %><br/>
  		<%= form.text_field :name %>
  	</div>
  	<div>
  		<%= form.label :description %><br/>
  		<%= form.text_area :description %>
  	</div>
  	<div>
  		<%= form.label :photo %><br/>
  		<%= form.file_field :photo %>
  	</div>
  	<div>
  		<%= form.submit %>
  	</div>
  <% end %>

                                                                                > (ignore this line)
  
# 4.2 in new.html.erb and add the form to it
  
  <%= render :partial => 'form' %>

                                                                                > (ignore this line)
 
# 4.3 in edit.html.erb and add the form to it   

  <%= render :partial => 'form' %>


                                                                                > (ignore this line)
# 4.4 Link to them both from the users index

  <% if user.profile %>
		<%= link_to "edit profile", edit_user_profile_path(user) %>
		<%= link_to "show profile", user_profile_path(user) %>
	<% else %>
		<%= link_to "new profile", new_user_profile_path(user) %>
	<% end %> 

# 4.5 Create the show partial

  # in show.html.erb

  <h1>Profile</h1>

  <%= link_to "back to users", users_path %>

  <div><%= @profile.name %></div>
  <div><%= @profile.description %></div>
  <div><%= image_tag @profile.photo.url(:medium) %></div>

  <div><%= link_to "edit profile", edit_user_profile_path(@profile.user) %></div>
  
#5. Take a look at our running app

    bundle exec rails s