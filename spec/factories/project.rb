FactoryGirl.define do
  factory :project do
    creator
    name { generate :project_name }
    game { Game.first }
    source_port { SourcePort.first }
  end
end
