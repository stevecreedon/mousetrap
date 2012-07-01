# In this section

1. Create the comment model
2. Add attributes to the migration and run it
3. Define the comment model


# 1. Create the model

    bundle exec rails g model comment

# 2. Add our attributes to the migration created in db/migrate/{timestamp}_create_comments.rb

    create_table :comments do |t|
        t.integer :profile_id
        t.string :text
        t.timestamps
    end 

# Run the migration

  bundle exec rake db:migrate
    
# 3. Define the comment model

# 3.1 Set up the profile <> comments has_many association

# in app/models/profiles.rb

  has_many :comments
  
# in app/models/comments.rb

  belongs_to :profile
  
# 3.2 Make the comment model's text attribute public

  attr_accessible :text
  
# 3.3 Add the validation

  validates :text, :presence => true
  


  

   