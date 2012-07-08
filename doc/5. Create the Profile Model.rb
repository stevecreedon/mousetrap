#Our profile model is going to have a name, a description and an attached photo. For the photo we need the paperclip gem:

# In this Section we are going to

#  1. Install paperclip gem so that we can upload image files
#  2. Create the Profile model
#  3. Write some tests for the Profile model before we create it
#  4. Create a migration for the Profile model.
#  5. Make the Rspec tests pass
#  6. Associate our profile to a user


#1. install the paperclip gem (and ImageMagick)

   gem 'paperclip'

   bundle install

#2. Create the profile model:

    bundle exec rails g model profile

#3. Write some tests:

#3.1 In spec/models/profile_spec.rb 

  # let is an Rspec helper that will create an instance of Profile for us with the variable 'profile'.
  # you'll need to add a test photo image in spec/photos/photo.jpg. Any jpeg will do. 
	let :profile do
		photo = File.new(File.join(Rails.root, 'spec', 'photos', 'photo.jpg'))
		Profile.new(:name => 'steve', :description => 'this is a test description', :photo => photo)
	end

  # Our prodile model extends ActiveRecord::Base which has a valid? method and an errors collection for
  # anything that fails validation. We'll be adding validations soon so that these tests can pass.
	it 'should not be valid if the profile name is nil' do
		profile.name = nil
		profile.valid?.should be_false
		profile.errors.full_messages.should == ["Name can't be blank"]
	end

	it 'should not be valid if the profile name is a blank string' do
		profile.name = ''
		profile.valid?.should be_false
		profile.errors.full_messages.should == ["Name can't be blank"]
	end

	it 'should not be valid if the profile has no photo' do
		profile.photo = nil
		profile.valid?.should be_false
		profile.errors.full_messages.should == ["Photo can't be blank"]
	end

	it 'should be valid if the profile has no description' do
		profile.description = nil
		profile.valid?.should be_true
	end

# 3.2 Run rake spec

  budle exec rake spec
  
  # we should see Rspec warn us that we have a migration pending. When we created the profile model the generator 
  # created an empty migration for us. Our database contains a table called 'schema_migrations' that gets updated when
  # we run rake db:migrate. Rspec has detected that there's at least one migration in the db/migrate folder that isn't 
  # in the schema_migrations table.
  

# 4. Create and run the migration
  
  # The migration contains the definition for the table containing our profile. At this stage it's empty so we'll add the columns
  # we need for our profile and then run the migration. Don't worry if you've jumped the gun and already run this migration (it would have 
  # created a profiles table with no profile columns) just run rake db:rolback and the table will be dropped.

# 4.1 in db/migrate/{timestamp}_create_profiles - (this was created in 2. above) 

def change
	create_table :profiles do |t|

	  t.timestamps
	  t.string :name
	  t.string :description, :length => 255
	  t.has_attached_file :photo
	end
end

# 4.2. Run the migration

  bundle exec rake db:migrate
  
  

# 5. Make the RSpec tests pass
# There's two stages to getting our tests to pass: 
# Intitally our profile won't have the name, description and photo attributes we need so our tests will be raising
# runtime errors.
# Once we've fixed this our test won't raise errors but they will fail becaise our profile isn't performing in the way we expect.

# FIX THE RUNTIME ERRORS

# 5.1 Run rake spec again - we should see an errors something like 'cannot mass-assign attributes....'
# We get this because in Rails 3, by default ActiveRecord attributes are private so we need to make our profile's 
# name, description and photo attribute public. 

    attr_accessible :name, :description, :photo


# 5.2 Run rake spec again - we should now get a papaerlclip error as we have no photo attribute 
# so add the paperclip attribute

   has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }


# MAKE OUR PROFILE BEHAVE AS WE EXPECT

# 5.3 At this stage we shouldn't be getting Runtime errors but our specs will still be failing
# because we haven't created any validations. Rails ActiveModel gives us many validations out of the box. These are just a few.

# Add the validations so that our tests pass.
    
  validates :name, :presence => true
  
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => [ 'image/jpeg', 'image/jpg']
  validates_attachment_size :photo, :less_than => 10.megabytes


# 5.4 Run rake spec - MAKE SURE EVERYTHING IS PASSING !!!!!!


# 6. Associate our profile to a user.
# We want our user object to have one profile. To do this we use ActiveRecord Associations.

# 6.1 Define the associations:

 # in app/models/user.rb

   has_one :profile
 
 # in app/models/profile.rb

   belongs_to :user

# 6.2 Create the association migration
# Having stated that a user has one profile in our code we need to connect them together in our data. To do this we'll add a user_id column to our profile
# model so that a profile with user_id=123 belongs to the user model with id=123. By convention ActiveRecord assumes that if a model belongs_to something it will
# have a 'something_id' column. So, let's create a migration to add this user_id column to our profile.

  rails g migration add_user_id_to_profile

  #add this to the migration youve just created. It will be in db/migrate
  add_column :profiles, :user_id, :integer

#6.3 Run the migration

  bundle exec rake db:migrate
  
# 6.4 We can test this in the Rails console to see that we have user.profile and profile.user associations

  bundle exec rails c
  
  user = User.first
  user.profile  #should return nil as we haven't actually created a profile yet
  Profile.new.user #similarly should be nil