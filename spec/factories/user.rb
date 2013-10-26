FactoryGirl.define do
  factory :user, aliases: [:creator] do
    login
    email {|u| "#{u.login}@doomhub.com"}
    password 'asdasd'

    trait :admin do
      role { UserRole.find 2 }
    end
    trait :superadmin do
      role { UserRole.find 1 }
    end

    factory :admin, traits: [:admin]
    factory :superadmin, traits: [:superadmin]
  end
end
