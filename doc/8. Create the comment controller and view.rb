
# 1. Create the controller

     bundle exec rails g controller comments
     
# 2. Nest the comments inside our profile for RESTful routing

# 2.1 in config/routes.rb

    resources :users, :only => [:index] do
      resource :profile do, :except => [:destroy]
        resources :comments, :only => [:create]
      end
    end
    
# 2.2 view these new routes

    bundle exec rake routes
    
# 2.3 TRY THIS AS AN FYI
# we only need a create for this app but comment out the , :only => [:create] 
# and run rake routes again to see all these nested routes.
# Note that :show & :update only need a user_id and id (id being comment id).
# No profile id is required because it's a has_one relationship between user and profile.

# 2.4 Create the create action

# in app/controllers/comments_controller.rb

def create
  user = User.find(params[:user_id])
  user.profile.comments.create(params[:comment]) #we don't care if it fails...
  redirect_to user_profile_path(user)
end

# 2.5 Create the new comment partial

# create the file app/views/_new.html.erb (note the underscore) 

# add this code

<div>
	<h3>Add a comment:</h3>
	<%= form_for comment, :url => user_profile_comments_path(@profile.user.id) do |form| %>
		<%= form.text_area :text %>
		<br/>
		<%= form.submit "add a comment" %>
	<% end %>
</div>


# 2.6 Create the show comment partial

# create the file app/views/_show.html.erb (note the underscore) 

# add this code

<div>
	<h3>comment:</h3>
	<%= comment.text %>
</div>

                                                                        >(ignore this line)
                                                                        
# 3. Update our profiles show  view to display and add comments:

# in app/views/profiles/show.html.erb

<h2>Comments</h2>

<% @profile.comments.each do |comment| %>
	<%= render :partial => 'comments/show', :locals => {:comment => comment} %>
<% end %>

<%= render :partial => "comments/new", :locals => {:comment => Comment.new } %>

                                                                        >(ignore this line)
                                                                        

# 4. Let's test the app

    rails s
                                                                        