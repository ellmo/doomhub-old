require 'spec_helper'

describe FileLink do
  context '::create' do
    context 'when .authorable is User' do
      let(:user) { FactoryGirl.create :user }
      let(:project) { FactoryGirl.create :project, creator: user }
      context 'and when .file_linkable is a Project' do
        context 'and url is valid' do
          let(:file_link) { FactoryGirl.build :file_link }
          it 'is valid' do
            expect(file_link.valid?).to be_true
          end
        end
        context 'and url is invalid' do
          let(:file_link) { FactoryGirl.build :file_link, url: 'BAD_LINK@COMM.com' }
          it 'is invalid' do
            expect(file_link.valid?).to be_false
          end
        end
      end
      context 'and when .file_linkable is a Map' do
        let(:map) { FactoryGirl.create(:map, project: project, authorable: user) }
        let(:file_link) { FactoryGirl.build(:file_link, file_linkable: map) }
        it 'is valid' do
          expect(file_link.valid?).to be_true
        end
      end
    end
    context 'authorable is Author' do
      let(:author) { FactoryGirl.create :author }
      let(:user) { FactoryGirl.create :user }
      let(:project) { FactoryGirl.create :project, creator: user }
      context 'and when .file_linkable is a Project' do
        context 'and url is valid' do
          let(:file_link) { FactoryGirl.build :file_link, file_linkable: project, authorable: author }
          it 'is valid' do
            expect(file_link.valid?).to be_true
          end
        end
        context 'and url is invalid' do
          let(:file_link) { FactoryGirl.build :file_link, url: 'BAD_LINK@COMM.com' }
          it 'is invalid' do
            expect(file_link.valid?).to be_false
          end
        end
      end
      context 'and when .file_linkable is a Map' do
        let(:map) { FactoryGirl.create(:map, project: project, authorable: user) }
        let(:file_link) { FactoryGirl.build(:file_link, file_linkable: map, authorable: author) }
        it 'is valid' do
          expect(file_link.valid?).to be_true
        end
      end
    end
  end
end
