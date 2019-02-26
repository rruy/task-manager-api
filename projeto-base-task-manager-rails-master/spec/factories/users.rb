FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    email 
    password '123456'
    password_confirmation '123456'
  end
end