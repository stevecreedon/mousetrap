# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    name 'steve test creedon'
    description 'this is a test description'
    photo fixture_file_upload(Rails.root.join('spec','photos','photo.jpg'))
  end
end
