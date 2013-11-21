FactoryGirl.define do
  factory :map do
    association :authorable, factory: :user
    project { create :project, creator: authorable }
    name { generate :map_name }
  end
end
