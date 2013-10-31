require 'spec_helper'

describe MapWadfile do
  context '::create' do
    let(:first_user) { FactoryGirl.create :user }
    let(:first_project) { FactoryGirl.create :project, creator: first_user }
    let(:first_map) { FactoryGirl.create :map, author: first_user, project: first_project }

    context 'allowed mimetypes' do
      context 'zip archive' do
        let(:map_wadfile) { FactoryGirl.build :map_wadfile, map: first_map, author: first_user }

        it 'succeeds when valid' do
          expect(map_wadfile.valid?).to be_true
          expect(map_wadfile.save).to be_true
          expect(MapWadfile.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments map_wadfile, 'wadfile', size: 2.megabytes

          expect(map_wadfile.valid?).to be_false
          expect(map_wadfile.save).to be_false
          expect(MapWadfile.count).to eq 0
          expect(map_wadfile.errors[:wadfile]).to include "File must not be over 1 MB"
        end
      end

      context 'rar archive' do
        let(:map_wadfile) { FactoryGirl.build :map_wadfile_rar, map: first_map, author: first_user }

        it 'succeeds when valid' do
          expect(map_wadfile.valid?).to be_true
          expect(map_wadfile.save).to be_true
          expect(MapWadfile.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments map_wadfile, 'wadfile', size: 2.megabytes

          expect(map_wadfile.valid?).to be_false
          expect(map_wadfile.save).to be_false
          expect(MapWadfile.count).to eq 0
          expect(map_wadfile.errors[:wadfile]).to include "File must not be over 1 MB"
        end
      end

      context '7z archive' do
        let(:map_wadfile) { FactoryGirl.build :map_wadfile_7z, map: first_map, author: first_user }

        it 'succeeds when valid' do
          expect(map_wadfile.valid?).to be_true
          expect(map_wadfile.save).to be_true
          expect(MapWadfile.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments map_wadfile, 'wadfile', size: 2.megabytes

          expect(map_wadfile.valid?).to be_false
          expect(map_wadfile.save).to be_false
          expect(MapWadfile.count).to eq 0
          expect(map_wadfile.errors[:wadfile]).to include "File must not be over 1 MB"
        end
      end
    end

    context 'unallowed mimetypes' do
      context 'size is within limit' do
        let(:map_wadfile) { FactoryGirl.build :map_wadfile, map: first_map, author: first_user }

        it 'does not succeed' do
          mock_attachments map_wadfile, 'wadfile', mime_type: 'application/bullshit'

          expect(map_wadfile.valid?).to be_false
          expect(map_wadfile.save).to be_false
          expect(MapWadfile.count).to eq 0
          expect(map_wadfile.errors[:wadfile]).to include "File must be a valid zip / rar / 7z achive"
        end
      end

      context 'size exceeds limit' do
        let(:map_wadfile) { FactoryGirl.build :map_wadfile, map: first_map, author: first_user }

        it 'does not succeed' do
          mock_attachments map_wadfile, 'wadfile', mime_type: 'application/bullshit', size: 2.megabytes

          expect(map_wadfile.valid?).to be_false
          expect(map_wadfile.save).to be_false
          expect(MapWadfile.count).to eq 0
          expect(map_wadfile.errors[:wadfile]).to include "File must be a valid zip / rar / 7z achive"
          expect(map_wadfile.errors[:wadfile]).to include "File must not be over 1 MB"
        end
      end
    end
  end
end
