require 'spec_helper'

describe MapImage do
  context '::create' do
    let(:first_user) { FactoryGirl.create :user }
    let(:first_project) { FactoryGirl.create :project, creator: first_user }
    let(:first_map) { FactoryGirl.create :map, author: first_user, project: first_project }

    context 'allowed mimetypes' do
      context 'png image' do
        let(:map_image) { FactoryGirl.build :map_image, map: first_map, user: first_user }

        it 'succeeds when valid' do
          expect(map_image.valid?).to be_true
          expect(map_image.save).to be_true
          expect(MapImage.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments map_image, 'image', size: 2.megabytes

          expect(map_image.valid?).to be_false
          expect(map_image.save).to be_false
          expect(MapImage.count).to eq 0
          expect(map_image.errors[:image]).to include "File must not be over 1 MB"
        end
      end

      context 'jpg image' do
        let(:map_image) { FactoryGirl.build :map_image_jpg, map: first_map, user: first_user }

        it 'succeeds when valid' do
          expect(map_image.valid?).to be_true
          expect(map_image.save).to be_true
          expect(MapImage.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments map_image, 'image', size: 2.megabytes

          expect(map_image.valid?).to be_false
          expect(map_image.save).to be_false
          expect(MapImage.count).to eq 0
          expect(map_image.errors[:image]).to include "File must not be over 1 MB"
        end
      end

      context 'tiff image' do
        let(:map_image) { FactoryGirl.build :map_image_tiff, map: first_map, user: first_user }

        it 'succeeds when valid' do
          expect(map_image.valid?).to be_true
          expect(map_image.save).to be_true
          expect(MapImage.count).to eq 1
        end

        it 'fails when too big' do
          mock_attachments map_image, 'image', size: 2.megabytes

          expect(map_image.valid?).to be_false
          expect(map_image.save).to be_false
          expect(MapImage.count).to eq 0
          expect(map_image.errors[:image]).to include "File must not be over 1 MB"
        end
      end
    end

    context 'unallowed mimetypes' do
      context 'size is within limit' do
        let(:map_image) { FactoryGirl.build :map_image, map: first_map, user: first_user }

        it 'does not succeed' do
          mock_attachments map_image, 'image', mime_type: 'image/bullshit'

          expect(map_image.valid?).to be_false
          expect(map_image.save).to be_false
          expect(MapImage.count).to eq 0
          expect(map_image.errors[:image]).to include "File must be a valid JPG / PNG / TIFF image"
        end
      end

      context 'size exceeds limit' do
        let(:map_image) { FactoryGirl.build :map_image, map: first_map, user: first_user }

        it 'does not succeed' do
          mock_attachments map_image, 'image', mime_type: 'image/bullshit', size: 2.megabytes

          expect(map_image.valid?).to be_false
          expect(map_image.save).to be_false
          expect(MapImage.count).to eq 0
          expect(map_image.errors[:image]).to include "File must be a valid JPG / PNG / TIFF image"
          expect(map_image.errors[:image]).to include "File must not be over 1 MB"
        end
      end
    end
  end
end
