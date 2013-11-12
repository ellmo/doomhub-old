FactoryGirl.define do
  sequence(:login) {|n| "user_#{n}" }
  sequence(:project_name) {|n| "project_#{n}" }
  sequence(:map_name) {|n| "map_#{n}" }
  sequence(:title) {|n| "title_#{n}" }
  sequence(:content) {|n| "content_#{n}" }
end