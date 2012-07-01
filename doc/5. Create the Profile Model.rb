#Our profile model is going to have a name, a description and an attached photo. For the photo we need the paperclip gem:

# In this Section we are going to

  1. Install paperclip gem so that we can upload image files
  2. Create the Profile model
  3. Write some tests for the Profile model before we create it
  4. Create a migration for the Profile model.
  5. Make the Rspec tests pass
  6. Associate our profile to a user


#1. install the paperclip gem (and ImageMagick)

   gem 'paperclip'

   bundle install

#2. Create the profile model:

    bundle exec rails g model profile

#3. Write some tests:

#3.1 

	let :profile do
		photo = File.new(File.join(Rails.root, 'spec', 'photos', 'photo.jpg'))
		Profile.new(:name => 'steve', :description => 'this is a test description', :photo => photo)
	end

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

# 3.2 Add a photo to spec/fixtures/photos/photo.jpg

# 3.3 Run rake spec - we should see migration pending - this migration is empty


# 4. Create and run the migration

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

# 5.1 Run rake spec again - we should see that our attributes are hidden.

# Make the attributes accessible

    attr_accessible :name, :description, :photo


# 5.2 Run rake spec again - we should get a papaerlclip error as we have no photo attribute 
# so add the paperclip attribute

   has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }

# 5.3 At this stage we shouldn't be getting Runtime errors, our specs will be failing
# because we haven't created any validations. 

# Add the validations so that our tests pass.
    
  validates :name, :presence => true
  
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => [ 'image/jpeg']
  validates_attachment_size :photo, :less_than => 10.megabytes


# 5.4 Run rake spec - MAKE SURE EVERYTHING IS PASSING !!!!!!

# 6. Associate our profile to a user

# 6.1 Define the associations:

 # in app/models/user.rb

   has_one :profile
 
 # in app/models/profile.rb

   belongs_to :user

# 6.2 Create the association migration

  rails g migration add_user_id_to_profile

  add_column :profiles, :user_id, :integer

#6.3 Run the migration

  bundle exec rake db:migrate
  
# 6.4 We can test this in the Rails console to see that we have .profile and .user associations

  bundle exec rails c
  
  user = User.first
  user.profile  #should return nil as we haven't actually created a profile yet
  Profile.new.user #similarly should be nil