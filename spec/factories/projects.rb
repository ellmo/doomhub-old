# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "MyString"
    url_name "MyString"
    description "MyText"
    game_id 1
    source_port_id 1
  end
end
