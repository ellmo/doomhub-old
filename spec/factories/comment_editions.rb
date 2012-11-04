# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment_edition do
    comment_id 1
    user_id 1
    previous_text "MyText"
  end
end
