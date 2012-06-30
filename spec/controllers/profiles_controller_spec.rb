require 'spec_helper'

describe ProfilesController do
  
  describe "show" do
    
    it 'should assign the profile based on the user_id provided' do
      profile = FactoryGirl.create(:profile)
      user = FactoryGirl.create(:user)

      user.profile = profile

      Profile.stub(:find).with(:first, :conditions => {:user_id => user.id.to_s}).and_return(profile)

      get :show, :user_id => user.id.to_s

      assigns(:profile).should == profile
    end
    
  end
  
  describe "new" do
    
    it 'should assign an empty profile' do
      
      get :new, :user_id => '1234'
      
      assigns(:profile).is_a?(Profile).should be_true
      assigns(:profile).new_record?.should be_true 
      
    end
    
  end
  
  describe "create" do
    
    it 'should create a new profile with valid profile data' do
      photo_path = File.join('/','photos', 'photo.jpg')
      photo = fixture_file_upload(photo_path,'image/jpeg')
      name = 'test name'
      user = FactoryGirl.create(:user)
      User.stub(:find).with(user.id.to_s).and_return(user)

      lambda do
        post :create, :user_id => user.id.to_s, :profile => {:photo => photo, :name => name}
      end.should change(Profile, :count).by(1)
    end

    it 'should redirect to the profile show action when the profile is successfuly saved' do   
      Profile.any_instance.stub(:save).and_return(true)
      User.stub(:find).with('1234').and_return(FactoryGirl.create(:user))

      post :create, :user_id => "1234", :profile => {}

      response.should redirect_to(user_profile_path('1234'))
    end

    it 'should render the new template when the profile is not successfuly saved' do   
      Profile.any_instance.stub(:save).and_return(false)
      User.stub(:find).with('1234').and_return(FactoryGirl.create(:user))

      post :create, :user_id => "1234", :profile => {}

      response.should render_template("new")
    end
    
  end
  
  describe "edit" do
    
    it 'should assign the specified users profile' do

      profile = FactoryGirl.create(:profile)
      user = FactoryGirl.create(:user)
      user.profile = profile
      
      user.stub(:find).with(user.id.to_s).and_return(user)
      
      get :edit, :user_id => user.id.to_s
      
      assigns(:profile).should == profile
    end
    
  end
  
  describe "update" do
    
    it 'should update the specified users profile' do
      user = FactoryGirl.create(:user)
      user.profile = FactoryGirl.create(:profile)
      Profile.any_instance.should_receive(:update_attributes).with("some attributes")
      
      user.stub(:find).with(user.id.to_s).and_return(user)
      
      put :update, :user_id => user.id, :profile => "some attributes"
    end
    
    it 'should redirect to the profile show action when the profile update is successful' do   
      user = FactoryGirl.create(:user)
      user.profile = FactoryGirl.create(:profile)
      user.profile.stub(:update_attributes).with("some attributes").and_return(true)
      User.stub(:find).with(user.id.to_s).and_return(user)
      
      put :update, :user_id => user.id, :profile => "some attributes"
      
      response.should redirect_to(user_profile_path(user.id))
    end

    it 'should render the new template when the profile update is not successful' do   
      user = FactoryGirl.create(:user)
      user.profile = FactoryGirl.create(:profile)
      user.profile.stub(:update_attributes).with("some attributes").and_return(false)
      User.stub(:find).with(user.id.to_s).and_return(user)
      

      put :update, :user_id => user.id, :profile => "some attributes"

      response.should render_template("edit")
    end
    
  end
  
  

end
