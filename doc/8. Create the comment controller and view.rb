1. Create the comments controller
2. Create the RESTful comments routes
3. Create the comments controller actions
4. Create the comments controller views
5. Add comments to our profile show view.


# 1. Create the controller

     bundle exec rails g controller comments
     
# 2. Nest the comments inside our profile for RESTful routing

# 2.1 in config/routes.rb

    resources :users, :only => [:index] do
      resource :profile, :except => [:destroy] do
        resources :comments, :only => [:create]
      end
    end
    
# 2.2 view these new routes

    bundle exec rake routes
    
# 3. Add the create action to the comments controller

# in app/controllers/comments_controller.rb

def create
  user = User.find(params[:user_id])
  user.profile.comments.create(params[:comment]) #we don't care if it fails...
  redirect_to user_profile_path(user)
end

# 4. Create the comments views

# We're going to embed comments in the profile's show.html.erb so we only need partials _new and _show

# 4.1 Create the new comment partial

# create the file app/views/comments/_new.html.erb (note the underscore) 

# add this code

<div>
	<h3>Add a comment:</h3>
	<%= form_for comment, :url => user_profile_comments_path(@profile.user.id) do |form| %>
		<%= form.text_area :text %>
		<br/>
		<%= form.submit "add a comment" %>
	<% end %>
</div>


# 4.2 Create the show comment partial

# create the file app/views/comments/_show.html.erb (note the underscore) 

# add this code

<div>
	<h3>comment:</h3>
	<%= comment.text %>
</div>

                                                                        
                                                                        
# 5. Update our profiles show  view to display and add comments:

# 5.1 in app/views/profiles/show.html.erb

<h2>Comments</h2>

<% @profile.comments.each do |comment| %>
	<%= render :partial => 'comments/show', :locals => {:comment => comment} %>
<% end %>

<%= render :partial => "comments/new", :locals => {:comment => Comment.new } %>

                                                                        
                                                                        

# 5.2 Let's test the app

    rails s
                                                                        