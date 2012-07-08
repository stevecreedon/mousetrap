# 1. Create the profile form partial
# 2. Create the new.html.erb using the form    
# 3. Create the edit.html.erb using the form
# 4. Create the show.html.erb
# 5. Link to these from the users index.html.erb


# 1. The profile form partial we'll be using in new and edit

# 1.1 Create the partial app/views/profiles/_form.html.erb

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
  
# 1.2 when rails validations fail they place a 'field_with_errors' class into the form. It won't be pretty but we'll just highlight those in red for this app

in app/assets/application.css

.field_with_errors{
	border: 2px solid red;
}

                                                                               
  
# 2 add the form to partial to app/views/profiles/new.html.erb, add the form to it
  
  <%= render :partial => 'form' %>

                                                                               
 
# 3 add the form partial to app/views/profiles/edit.html.erb.  

  <%= render :partial => 'form' %>

# Notice that new and edit both render the exact same thing. Rails uses the @profile in

 <%= form_for @profile, :url => user_profile_path(@profile.user)
 
# to find out if the profile is new. If the profile is not new, in other words we're editing an existing profile, it adds this hidden field:

<input name="_method" type="hidden" value="put">
 
# which tells Rails to conside this a PUT request not a POST.
                                                                                


# 4 Create the show partial app/views/profiles/show.html.erb

  # in show.html.erb

  <h1>Profile</h1>

  <%= link_to "back to users", users_path %>

  <div><%= @profile.name %></div>
  <div><%= @profile.description %></div>
  <div><%= image_tag @profile.photo.url(:medium) %></div>

  <div><%= link_to "edit profile", edit_user_profile_path(@profile.user) %></div>
 
  
# 5 Link to them both from the users index page app/views/users/index.html.erb

  # NOTE the use of:

  # 1. user_profile_path => GET /profiles/:profile_id =>  
  # 2. new_user_profile_path = GET /profiles/new
  # 3. edit_user_profile_path = GET /profiles/:profile_id/edit

  #these dynamic routing methods return the urls we need to build these links.

    <% if user.profile %>
  		<%= link_to "edit profile", edit_user_profile_path(user) %>
  		<%= link_to "show profile", user_profile_path(user) %>
  	<% else %>
  		<%= link_to "new profile", new_user_profile_path(user) %>
  	<% end %>  
  	
  
#6. Take a look at our running app

    bundle exec rails s