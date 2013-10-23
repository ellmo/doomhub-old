# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:creator] do
    login
    email {|u| "#{u.login}@doomhub.com"}
    password 'asdasd'
  end

  factory :admin, parent: :user do
    role { UserRole.find 2 }
  end

  factory :superadmin, parent: :user do
    role { UserRole.find 1 }
  end
end
