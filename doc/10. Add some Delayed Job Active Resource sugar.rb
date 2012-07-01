1. Install Delayed Job
2. Add DelayedJob to comment create callback
3. Create an ActiveResource Comment object
4. Create a Sintra App to read these

# 1. Install delayed job

# 1.1 Add the gem to the Gemfile

  gem "delayed_job", "~> 3.0.3"
  gem 'delayed_job_active_record'

# 1.2 Install the gem

  bundle install
  
# 1.3 Create the migration

  rails generate delayed_job:active_record
  
# 1.4 run the migration

  bundle exec rake db:migrate
  
# 2 create a Notify active resource class

# 2.1 create file app/models/remote_comment.rb
  
# 2.2 Add the code

class RemoteComment < ActiveResource::Base
  
  site "http://localhost:4567"
  
end  
  

# 3 Add the callback when a comment is created

# 3.1 in app/models/comment.rb

after_create :notify

private

def notify
  RemoteComment.new(:text => self.text).save
end

handle_asynchronously :notify


# 4 Create the Sinatra App

# Create a new app called comment_consumer

# 4.1 Gemfile

source 'http://rubygems.org'

gem "sinatra", :require => "sinatra/base"
gem 'activeresource', '3.2.3'

# install the gems

bundle install

# 4.2 create the file server.rb

require 'sinatra'
require 'active_resource'
require 'json'

class RemoteComment < ActiveResource::Base
  
  self.site = ""
  
end

get '/test' do
  "Hello World"
end

post '/remote_comments.json' do
  data = JSON.parse request.env["rack.input"].read
  rc = RemoteComment.new(data)
  puts "Sintra says:"
  puts rc.text
end


# 4.3 run the server

    bundle exec ruby server.rb
    
# 4.4 With the rails app running in one console & sinatra in another open a third console in the mousetrap
# root and run bundle exec rake jobs:work. Add some comments in the rails app, they'll be put into the 
# delayed job queue and sent to the remote comments sinatra app
 