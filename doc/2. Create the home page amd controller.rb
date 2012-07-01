# In this section we are going to

1. Set up the home controller
2. Run the app
3. Set up the home page


# 1. Set up the home controller
# 1.1 Create the home controller

    bundle exec rails g controller home
    
# 1.2 create the default root path in config/routes.rb

    root :to => "home#index"
     
# 2. Start the app

    rails s

# 2.1 Remove the welcome to Rails screen 

    # Delete the file
    
    public/index.html

# 3. Set up the home page

# 3.1 Add the homepage index view to views/home

    #create the file: 
    
    app/views/home/index.html.erb

# 3.2. Put something on the home page

    <h1>Mousetrap Dashboard</h1>

# 3.3 Let's include the recommendations from the Devise notice:

    #in app/views/layouts/application.html.erb

    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>    