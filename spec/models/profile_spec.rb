require 'spec_helper'

describe Profile do
  
  let :profile do
    photo = File.new(File.join(Rails.root, 'spec','fixtures', 'photos', 'photo.jpg'))
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
  
end
