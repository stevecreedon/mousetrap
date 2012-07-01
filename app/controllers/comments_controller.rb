class CommentsController < ApplicationController
  
  def create
    user = User.find(params[:user_id])
    user.profile.comments.create(params[:comment]) #we don't care if it fails...
    redirect_to user_profile_path(user)
  end
  
end
