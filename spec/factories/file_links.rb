FactoryGirl.define do
  factory :file_link do
    association :authorable, factory: :user
    # authorable { create :user }
    file_linkable {|fl| FactoryGirl.create(:project, creator: fl.authorable) }
    url 'http://www.mediafire.com/download/1234567890/example.zip'
  end
end
