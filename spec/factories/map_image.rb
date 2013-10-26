include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :map_image do
    map
    user
    name { |mw| mw.map.name }
    image { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'ellmo.png')) }

    trait :png do
      image { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'ellmo.png')) }
    end

    trait :jpg do
      image { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'ellmo.jpg')) }
    end

    trait :tiff do
      image { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'ellmo.tiff')) }
    end

    factory :map_image_png, traits: [:png]
    factory :map_image_jpg, traits: [:jpg]
    factory :map_image_tiff, traits: [:tiff]
  end
end
