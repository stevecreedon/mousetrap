class Comment < ActiveRecord::Base
  attr_accessible :text
  
  validates :text, :presence => true
  
  belongs_to :user
end
