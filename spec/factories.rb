# require "#{::Rails.root}/spec/support/fg.rb"

# FactoryGirl.define do
#   sequence(:login) {|n| "user_#{n}" }
#   sequence(:game) {|n| "game_#{n}" }
#   sequence(:source_port) {|n| "engine_#{n}" }
#   sequence (:project_name) {|n| "project_#{n}" }

#   factory :user do
#     login
#     email {|u| "#{u.login}@doomhub.com"}
#     password 'asdasd'
#   end

#   factory :project do
#     game
#     source_port
#     name {project_name}
#   end
# end