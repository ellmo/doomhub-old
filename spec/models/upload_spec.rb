require 'spec_helper'

describe Upload do
  context '::create' do
    let(:first_user) { FactoryGirl.create :user }
    let(:first_project) { FactoryGirl.create :project, creator: first_user }
    let(:first_map) { FactoryGirl.create :map, authorable: first_user, project: first_project }

    context 'allowed mimetypes' do
      context 'zip archive' do
        let(:upload) { FactoryGirl.build :upload, map: first_map, authorable: first_user }

        it 'succeeds when valid' do
          expect(upload.valid?).to be_true
          expect(upload.save).to be_true
          expect(Upload.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments upload, 'archive', size: 2.megabytes

          expect(upload.valid?).to be_false
          expect(upload.save).to be_false
          expect(Upload.count).to eq 0
          expect(upload.errors[:archive]).to include "File must not be over 1 MB"
        end
      end

      context 'rar archive' do
        let(:upload) { FactoryGirl.build :upload_rar, map: first_map, authorable: first_user }

        it 'succeeds when valid' do
          expect(upload.valid?).to be_true
          expect(upload.save).to be_true
          expect(Upload.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments upload, 'archive', size: 2.megabytes

          expect(upload.valid?).to be_false
          expect(upload.save).to be_false
          expect(Upload.count).to eq 0
          expect(upload.errors[:archive]).to include "File must not be over 1 MB"
        end
      end

      context '7z archive' do
        let(:upload) { FactoryGirl.build :upload_7z, map: first_map, authorable: first_user }

        it 'succeeds when valid' do
          expect(upload.valid?).to be_true
          expect(upload.save).to be_true
          expect(Upload.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments upload, 'archive', size: 2.megabytes

          expect(upload.valid?).to be_false
          expect(upload.save).to be_false
          expect(Upload.count).to eq 0
          expect(upload.errors[:archive]).to include "File must not be over 1 MB"
        end
      end
    end

    context 'unallowed mimetypes' do
      context 'size is within limit' do
        let(:upload) { FactoryGirl.build :upload, map: first_map, authorable: first_user }

        it 'does not succeed' do
          mock_attachments upload, 'archive', mime_type: 'application/bullshit'

          expect(upload.valid?).to be_false
          expect(upload.save).to be_false
          expect(Upload.count).to eq 0
          expect(upload.errors[:archive]).to include "File must be a valid zip / rar / 7z achive"
        end
      end

      context 'size exceeds limit' do
        let(:upload) { FactoryGirl.build :upload, map: first_map, authorable: first_user }

        it 'does not succeed' do
          mock_attachments upload, 'archive', mime_type: 'application/bullshit', size: 2.megabytes

          expect(upload.valid?).to be_false
          expect(upload.save).to be_false
          expect(Upload.count).to eq 0
          expect(upload.errors[:archive]).to include "File must be a valid zip / rar / 7z achive"
          expect(upload.errors[:archive]).to include "File must not be over 1 MB"
        end
      end
    end
  end
end
