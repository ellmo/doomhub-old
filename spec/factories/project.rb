# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name { generate :project_name }
    url_name {|p| p.name }
    game { Game.first }
    source_port { SourcePort.first }
  end
end
