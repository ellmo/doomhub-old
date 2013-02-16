require "#{::Rails.root}/spec/support/fg.rb"

FactoryGirl.define do
  sequence :login do |n|
    "user_#{n}"
  end

  factory :user do
    login
    email {|u| "#{u.login}@doomhub.com"}
    password 'asdasd'
  end
end