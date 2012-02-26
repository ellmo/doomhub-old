# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :map do
    project_id 1
    name "MyString"
    desc "MyText"
    lump "MyString"
  end
end
