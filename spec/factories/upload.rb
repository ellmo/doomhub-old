include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :upload do
    map
    name { |mw| mw.map.name }
    authorable { |mw| mw.map.authorable }
    archive { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'wadfile.zip')) }

    trait :zip do
      archive { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'wadfile.zip')) }
    end

    trait :rar do
      archive { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'wadfile.rar')) }
    end

    trait :'7z' do
      archive { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'wadfile.zip')) }
    end

    factory :upload_zip, traits: [:zip]
    factory :upload_rar, traits: [:rar]
    factory :upload_7z, traits: [:'7z']
  end
end
