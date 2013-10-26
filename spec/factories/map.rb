FactoryGirl.define do
  factory :map do
    association :author, factory: :user
    project { create :project, creator: author }
    name { generate :map_name }
  end
end
