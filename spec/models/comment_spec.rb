require 'spec_helper'

describe Comment do
  context '::create' do
    let(:first_user) { FactoryGirl.create :user }
    let(:first_project) { FactoryGirl.create :project, creator: first_user }
    let(:other_user) { FactoryGirl.create :user }

    context 'on project' do
      let(:comment) { FactoryGirl.build :comment, commentable: first_project, user: other_user }

      it 'is valid and saves' do
        expect(comment.valid?).to be_true
        expect(comment.save).to be_true
        expect(Comment.count).to eq 1
      end
    end

    context 'on map' do
      let(:first_map) { FactoryGirl.create :map, author: first_user, project: first_project }
      let(:comment) { FactoryGirl.build :comment, commentable: first_map, user: other_user }

      it 'is valid and saves' do
        expect(comment.valid?).to be_true
        expect(comment.save).to be_true
        expect(Comment.count).to eq 1
      end
    end
  end

  context '#update' do
    let(:first_user) { FactoryGirl.create :user }
    let(:first_project) { FactoryGirl.create :project, creator: first_user }
    let(:other_user) { FactoryGirl.create :user }
    let(:old_content) { 'old content' }
    let(:new_content) { 'new content' }

    context 'on project' do
      let(:comment) { FactoryGirl.create :comment, commentable: first_project, user: other_user, content: old_content }

      context 'author is updating' do
        before do
          comment.update_attribute :content, new_content
        end

        it 'CommentEdition is added' do
          expect(comment.editions).to_not be_empty
        end

        it 'assigns new content' do
          expect(comment.content).to eq new_content
        end

        it 'is in `edited` scope' do
          expect(Comment.edited).to include comment
        end

        it 'is not in `bumped` scope' do
          expect(Comment.bumped).not_to include comment
        end
      end
    end
  end
end
