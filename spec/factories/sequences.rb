FactoryGirl.define do
  sequence(:login) {|n| "user_#{n}" }
  sequence(:project_name) {|n| "project_#{n}" }
end