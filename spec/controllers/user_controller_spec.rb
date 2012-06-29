require 'spec_helper'

describe UsersController do
  
  before(:each) do
    sign_in FactoryGirl.create(:user)
  end
  
  it 'should assign all users to @users' do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    users = [user1, user2]
    
    User.should_receive(:all).and_return(users)
    
    get :index
    
    assigns(:users).should == users
  end
  
  it 'should render the users#index template' do
    get :index
    
    response.should render_template("index")
  end

end
