FactoryGirl.define do
  factory :project do
    game
    source_port
    name {project_name}
  end
end