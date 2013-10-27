FactoryGirl.define do
  factory :project do
    creator
    name { generate :project_name }
    game { Game.first }
    source_port { SourcePort.first }
    public_view true
    public_join false

    trait :private_view do
      public_view false
    end

    trait :public_join do
      public_view true
    end

    factory :project_private, traits: [:private_view]
    factory :project_public, traits: [:public_join]
  end
end
