FactoryGirl.define do
  factory :comment do
    user
    commentable { create :project, creator: FactoryGirl.create(:user) }
    content 'comment content'
  end
end
