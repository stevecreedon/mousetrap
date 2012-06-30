class Profile < ActiveRecord::Base
  attr_accessible :name, :description, :photo
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  validates :name, :presence => true
  
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => [ 'image/jpeg']
  validates_attachment_size :photo, :less_than => 1.megabytes
  
end
