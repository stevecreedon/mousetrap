require 'factory_girl'

FactoryGirl.define do
  sequence :email do |n|
      "person#{n}@example.com"
  end
  
  factory :user do
    email
    password "xyz123"
  end
end