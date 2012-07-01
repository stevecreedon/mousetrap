class Comment < ActiveRecord::Base
  attr_accessible :text
  
  validates :text, :presence => true
  
  belongs_to :user
  
  after_create :notify
  
  private
  
  def notify
    rc = RemoteComment.new(:text => self.text)
    rc.save
  end
  
  handle_asynchronously :notify  
end
