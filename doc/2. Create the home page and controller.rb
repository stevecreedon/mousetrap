# In this section we are going to

# 1. Set up the home controller
# 2. Run the app
# 3. Set up the home page


# 1. Home controller
# The home controller will have the code that will respond to requests for the application home page - '/'

# 1.1 Create the home controller

    bundle exec rails g controller home
    
# Note that it's created a file app/controllers/home_controller.rb plus a matching file for writing tests in spec/controllers/home_controller_spec.rb
    
# 1.2 create the default root path in config/routes.rb

    root :to => "home#index"

# This will match a 'root' web request such as webrequest www.some-domain-or-other.com to the index method in our home controller.

     
# 2. Start the app

    rails s

# You should see the 'Welcome to Rails' home page which is in the public folder as index.html

# 2.1 Remove the welcome to Rails screen
# Rails will look for a physical file somewhere in the public folder before attempting to build a dynamic view in code.
# So if we want Rails to use the "home#index" route we defined in our code above we'll need to get rid of the physical index.html file first

    # Delete the file
    public/index.html
    
#Refresh the page and we should see an error

Unknown action

The action 'index' could not be found for HomeController


# 3. Set up our dynamic home page controller and view

# 3.1 Add the index action that could not be found in the home controller
# Add this method (or action) inside home controller:

def index
  
end

# Refresh the page and we should now see:

Template is missing

Missing template home/index, application/index with {:locale=>[:en], :formats=>[:html], :handlers=>[:erb, :builder, :coffee]}. Searched in: * "/Users/stephencreedon/devel/mousetrap/app/views" * "/Users/stephencreedon/.rbenv/versions/ruby-1.9.3-p0/lib/ruby/gems/1.9.1/gems/devise-2.1.2/app/views"


# 3.2 Add the missing homepage index view to views/home

    #create the file: 
    
    app/views/home/index.html.erb

# 3.3. Put something on the home page in index.html.erb

    <h1>Mousetrap Dashboard</h1>

# Refresh the page again and we should now see our Mousetrap home page