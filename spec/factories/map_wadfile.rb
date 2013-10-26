include ActionDispatch::TestProcess
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :map_wadfile do
    map
    name { |mw| mw.map.name }
    author { |mw| mw.map.author }
    wadfile { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'wadfile.zip'), 'application/zip') }

    trait :zip do
      wadfile { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'wadfile.zip'), 'application/zip') }
    end

    trait :rar do
      wadfile { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'wadfile.rar'), 'application/x-rar-compressed') }
    end

    trait :'7z' do
      wadfile { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'wadfile.zip'), 'application/x-7z-compressed') }
    end

    factory :map_wadfile_zip, traits: [:zip]
    factory :map_wadfile_rar, traits: [:rar]
    factory :map_wadfile_7z, traits: [:'7z']
  end
end
