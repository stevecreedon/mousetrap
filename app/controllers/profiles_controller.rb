class ProfilesController < ApplicationController
  
  def show
    @profile = Profile.find(:first, :conditions => {:user_id => params[:user_id]})
  end
  
  def new
    @profile = Profile.new
    @profile.user = User.find(params[:user_id])
  end
  
  def create

    user = User.find(params[:user_id])
    @profile = Profile.new(params[:profile])
    @profile.user = user
        
    if @profile.save
      redirect_to user_profile_path(params[:user_id])
    else
      flash[:alert] = @profile.errors.full_messages.join(",")
      render :template => "profiles/new"
    end
    
  end
  
  def edit
    user = User.find(params[:user_id])
    @profile = user.profile
  end
  
  def update
    @profile = Profile.find_by_user_id params[:user_id]
    if @profile.update_attributes(params[:profile])
      redirect_to user_profile_path(params[:user_id])
    else
      flash[:alert] = @profile.errors.full_messages.join(",")
      render :template => "profiles/edit"
    end
    
  end
  
end
