# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :map_image do
    map_id 1
    author_id 1
    author_type "MyString"
    name "MyString"
  end
end
