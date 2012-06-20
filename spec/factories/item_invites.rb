# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_invite do
    user_id 1
    invitable_id 1
    invitable_type "MyString"
  end
end
