In this section:

# 1. Create a user model using devise generators.
# 2. Secure the home page of our app with devise.
# 3. Run our app and sign-up.
# 4. Add a link to sign-out.

# 1. Create a User model with devise

	rails generate devise user
	
	
# 1.1 Take a look at what it's created:

   # invoke  active_record
   #   create    db/migrate/20120629090415_devise_create_users.rb
   #   create    app/models/user.rb
   #   invoke    rspec
   #   create      spec/models/user_spec.rb
   #   insert    app/models/user.rb
   #   route  devise_for :users

# 1.2 Run the migration

  bundle exec rake db:migrate

# 2. Now let's secure the home page with Devise:

	before_filter :authenticate_user!
	
# 3. Run the app and Sign up

# 4. Create the logout link in application.html.erb

<% if user_signed_in? %>
   <div><%= link_to "sign-out", destroy_user_session_path, :method => :delete  %></div>
<% end %>

