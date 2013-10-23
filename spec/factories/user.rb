FactoryGirl.define do
  factory :user do
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