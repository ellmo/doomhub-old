# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :map do
    association :author, factory: :user
    project { create :project, creator: author }
    name { generate :map_name }
  end
end
