require 'spec_helper'

describe CommentEdition do
  context '::create' do
    let!(:first_user) { FactoryGirl.create :user }
    let!(:first_project) { FactoryGirl.create :project, creator: first_user }
    let!(:other_user) { FactoryGirl.create :user }
    let(:old_content) { 'old content' }
    let(:new_content) { 'new content' }
    let!(:comment) { FactoryGirl.create :comment, commentable: first_project, user: other_user, content: old_content }
    let(:last_edition) { CommentEdition.last }

    before do
      comment.update_attribute :content, new_content
    end

    it 'edition`s user is the author' do
      expect(last_edition.user).to eq other_user
    end

    it 'assigns new content' do
      expect(comment.content).to eq new_content
    end

    it 'stores old content in edition' do
      expect(last_edition.content_was).to eq old_content
    end
  end
end
