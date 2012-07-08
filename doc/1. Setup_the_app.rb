# In this first section we are going to

1. Create the application
2. Add Rspec testing gem
3. Add Devise authentication gem
4. Add FactoryGirl mockstures gem


# 1. Create the application

	rails new mousetrap
	
# 1.1 Take a look at what its created.

# IMPORTANT FOLDERS
# the app folder is where all the code will go.
# app is for our code.
# config/database.yaml - database connection (by default sqlite3). Note that Rails assumes three environments, Development, Test, Production 
# config/routes.rb - connecting web requests to controllers and actions.  
# db is where our database migrations will go when we create them.
# doc is for documentation.
# public contains static html files (including the default home page index.html).
# public/system - used by rails for local storage of files like the uploaded images we'll be adding later with paperclip.
# lib is for code not specific to our application.
# log is where the Rails logger writes to

# LESS IMPORTANT FOLDERS
# test - test unit code. We're using Rspec so we can ignore this and we'll get a spec folder for tests once we've installed rspec
# tmp - used by rails for storing temp files like session data, cookie data, PIDs etc.
# vendor - we can ignore this. it's used for the obsolete rails plugins used before gems were invented.  
# script - scripts provided by Rails and gems we install to start the app, generate code etc. Normally we don't add or edit things in this folder.


# 2. Add the Rspec gem
# Out of the box Rails gives us a testing framework called Test Unit. Test unit is very similar to testing frameworks in other languages
# so we typically write test code like:

    assert_equal(user.email, 'steve@sometestdomain.com')
    assert_true(user.signed_in?)

# Rspec allows us to make our test more expressive thus easier to understand in 6 months time when we need to upgrade our code
# typically we'd write this in Rspec

    user.email.should == 'steve@sometestdomain.com'
    user.signed_in?.should be_true 

# 2.1 Take a look at Rspec-rails on github and read the docs.


# 2.2 Add the rspec-rails gem to bundler's Gemfile in the test and development groups only so that it's not needed on production

	group :test, :development do
		gem 'rspec-rails', "~> 2.0"
	end
	
# 2.3 Install the gem

	bundle install

# 2.4 Install Rspec in our application.
# Most gems don't need any specific install operations they just seamlessly integrate themselves after running bundle install
# but some of the more fundamental ones such as Rspec will add extra code, files and folders so we need to expliciltly run an 
# install command for this to happen.

	bundle exec rails generate rspec:install
	
# 2.5 Take a look at the files it's created
# You should see a spec folder and the spec_helper.rb file that loads the test Rails environment and creates
# the test database configured in config/database.yml

	
# 3. Add the Devise gem
# Devise gives us authentication out-of-the-box. We'll be getting devise to build us an authenticating user class
# and the views to allow users to sign up, sign-in and handle forgotten passwords.

# 3.1 add the devise gem to bundlers Gemfile

	gem 'devise'
	
# 3.2 install devise
# Like Rspec, Devise is one of those few gems that needs explicit installations so that it can install some helpful
# scripts and helpers into our application. 

  rails generate devise:install
  
# Don't worry if Devise prints all this stuff below to console, it's just giving you some clues as what to do next.
#
# 
# Some setup you must do manually if you haven't yet:
# 
#   1. Ensure you have defined default url options in your environments files. Here 
#      is an example of default_url_options appropriate for a development environment 
#      in config/environments/development.rb:
# 
#        config.action_mailer.default_url_options = { :host => 'localhost:3000' }
# 
#      In production, :host should be set to the actual host of your application.
# 
#   2. Ensure you have defined root_url to *something* in your config/routes.rb.
#      For example:
# 
#        root :to => "home#index"
# 
#   3. Ensure you have flash messages in app/views/layouts/application.html.erb.
#      For example:
# 
#        <p class="notice"><%= notice %></p>
#        <p class="alert"><%= alert %></p>
# 
#   4. If you are deploying Rails 3.1 on Heroku, you may want to set:
# 
#        config.assets.initialize_on_precompile = false
# 
#      On config/application.rb forcing your application to not access the DB
#      or load models when precompiling your assets.
# 
# ===============================================================================


# 3.3 look at the files devise has created and read the notes:
#
#       create  config/initializers/devise.rb
#       create  config/locales/devise.en.yml


#3.4 Generate the Rails views
# Devise comes with optional views (web pages). They're all we need to sign-up, sign-in and handle forgotten passwords.
# Of course we can create our own but for this app we'll save ourselves a lot of effort and install these optional views.

rails generate devise:views

#3.5 take a look at what they've created

# invoke  Devise::Generators::SharedViewsGenerator
# create    app/views/devise/shared
# create    app/views/devise/shared/_links.erb
# invoke  form_for
# create    app/views/devise/confirmations
# create    app/views/devise/confirmations/new.html.erb
# create    app/views/devise/passwords
# create    app/views/devise/passwords/edit.html.erb
# create    app/views/devise/passwords/new.html.erb
# create    app/views/devise/registrations
# create    app/views/devise/registrations/edit.html.erb
# create    app/views/devise/registrations/new.html.erb
# create    app/views/devise/sessions
# create    app/views/devise/sessions/new.html.erb
# create    app/views/devise/unlocks
# create    app/views/devise/unlocks/new.html.erb
# invoke  erb
# create    app/views/devise/mailer
# create    app/views/devise/mailer/confirmation_instructions.html.erb
# create    app/views/devise/mailer/reset_password_instructions.html.erb
# create    app/views/devise/mailer/unlock_instructions.html.erb


#4. Add Factory Girl
# Factory Girl is a gem that we use inside testing code to create objects for our tests.
# They're not quite mocks because FactoryGirl creates real objects from our models. 

#4.1 Add the factory girl to the Gemfile.
# We don't want FactoryGirl on our production server as we only use it in testing so we'll add it
# to the development and test groups in our Gemfile so that bundler will ignore on a production deploy.

    group :test, :development do
        gem 'factory_girl_rails'
	    gem 'rspec-rails', "~> 2.0"
    end

#4.2 Install the gem

    bundle install



    