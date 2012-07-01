# In this first section we are going to

1. Create the application
2. Add Rspec testing gem
3. Add Devise authentication gem
4. Add FactoryGirl mockstures gem


# 1. Create the application

	rails new mousetrap
	
# 1.1 Take a look at what its created.



# 2. Add the Rspec gem

# 2.1 Take a look at Rspec-rails on github and read the docs.

# 2.2 Add the rspec-rails gem to bundler's Gemfile in the test and development groups only so that it's not needed on production

	group :test, :development do
		gem 'rspec-rails', "~> 2.0"
	end
	
# 2.3 Install the gem

	bundle install

# 2.4 Add rspec-rails generators

	bundle exec rails generate rspec:install
	
# 2.5 Take a look at the files it's created

	
	
# 3. Add the Devise gem

# 3.1 add the devise gem to bundlers Gemfile

	gem 'devise'
	
# 3.2 install devise

    rails generate devise:install

# 3.3 look at the files devise has created and read the notes:

#       create  config/initializers/devise.rb
#       create  config/locales/devise.en.yml
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


#3.4 Generate the Rails views

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

#Halfway between fixtures & mocks

#4.1 Add the factory girl gem to the Gemfile in the test & development group

    group :test, :development do
        gem 'factory_girl_rails'
	    gem 'rspec-rails', "~> 2.0"
    end

#4.2 Install the gem

    bundle install



    