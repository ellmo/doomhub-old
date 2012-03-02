# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :author do
    authorable_id 1
    authorable_type "MyString"
  end
end
