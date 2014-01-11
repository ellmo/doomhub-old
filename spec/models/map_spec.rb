require 'spec_helper'

describe Map do
  context '::create' do
    context 'with valid attributes' do
      before do
        FactoryGirl.create :map
      end

      let(:user) { User.first }
      let(:project) { Project.last }

      it 'should succeed' do
        expect(Map.count).to eq 1
      end
      it 'should succeed for two different users and maps' do
        FactoryGirl.create :map
        expect(Map.count).to eq 2
        expect(User.count).to eq 2
      end
      it 'should succeed when creating 2 maps for the same user' do
        FactoryGirl.create :map, authorable: user
        expect(User.count).to eq 1
        expect(Project.count).to eq 2
        expect(Map.count).to eq 2
      end
      it 'should succeed when creating 2 maps within the same project' do
        FactoryGirl.create :map, authorable: user, project: project
        expect(User.count).to eq 1
        expect(Project.count).to eq 1
        expect(Map.count).to eq 2
      end
    end

    context 'when using default lumpname' do
      context 'within a doom1 project' do
        let!(:project) { FactoryGirl.create :project_public, game: Game.find_by_name('Doom') }
        let!(:map) { FactoryGirl.create :map, project: project }

        it 'lumpname should default to E1M1' do
          expect(map.lump).to eq 'E1M1'
        end
      end

      context 'within a doom2 project' do
        let!(:project) { FactoryGirl.create :project_public, game: Game.find_by_name('Doom 2') }
        let!(:map) { FactoryGirl.create :map, project: project }

        it 'lumpname should default to MAP01' do
          expect(map.lump).to eq 'MAP01'
        end
      end

      context 'within a heretic project' do
        let!(:project) { FactoryGirl.create :project_public, game: Game.find_by_name('Heretic') }
        let!(:map) { FactoryGirl.create :map, project: project }

        it 'lumpname should default to E1M1' do
          expect(map.lump).to eq 'E1M1'
        end
      end

      context 'within a hexen project' do
        let!(:project) { FactoryGirl.create :project_public, game: Game.find_by_name('Hexen') }
        let!(:map) { FactoryGirl.create :map, project: project }

        it 'lumpname should default to E1M1' do
          expect(map.lump).to eq 'MAP01'
        end
      end

      context 'within a strife project' do
        let!(:project) { FactoryGirl.create :project_public, game: Game.find_by_name('Strife') }
        let!(:map) { FactoryGirl.create :map, project: project }

        it 'lumpname should default to E1M1' do
          expect(map.lump).to eq 'MAP01'
        end
      end
    end

    context 'when using custom lumpname' do
      let!(:project) { FactoryGirl.create :project_public, game: Game.find_by_name('Doom') }
      let!(:map) { FactoryGirl.create :map, project: project, authorable: User.last, lump: 'E1M7' }

      it 'lumpname should default to E1M7' do
        expect(map.lump).to eq 'E1M7'
      end
    end
  end

  context 'adding WADFILES' do
    before do
      FactoryGirl.create :map
      5.times { FactoryGirl.create :upload, map: map }
    end

    let(:map) { Map.last }

    context 'adding no more than five' do
      it 'should be valid' do
        expect(map.valid?).to be_true
        expect(map.errors[:base]).to be_empty
        expect(map.uploads.count).to eq 5
      end
    end

    context 'adding more than five' do
      it 'should raise RecordInvalid' do
        expect { FactoryGirl.create :upload, map: map }.to raise_error(ActiveRecord::RecordInvalid)
        expect(map.valid?).to be_true
        expect(map.uploads.count).to eq 5
      end
    end

    context 'adding new after deleting old' do
      before { map.uploads.last.destroy }

      it 'should respect paranoid entries' do
        expect(map.uploads.count).to eq 4
        expect(map.uploads.unscoped.count).to eq 5
      end

      it 'should be valid when new upload is added' do
        FactoryGirl.create :upload, map: map
        expect(map.uploads.count).to eq 5
        expect(map.uploads.unscoped.count).to eq 6
        expect(map.valid?).to be_true
      end
    end
  end

  context 'recovering WADFILES' do
    before do
      FactoryGirl.create :map
      5.times { FactoryGirl.create :upload, map: map }
    end

    let(:map) { Map.last }

    context 'when less than 5 uploads' do
      before { map.uploads.last.destroy }

      it 'should be possible' do
        expect(map.reload.uploads.count).to eq 4
        expect(map.uploads.only_deleted.last.recover).to be_true
        expect(map.reload.uploads.unscoped.count).to eq 5
        expect(map.uploads.only_deleted.count).to eq 0
        expect(map.uploads.count).to eq 5
        expect(map.valid?).to be_true
      end
    end

    context 'when there are 5 uploads already' do
      before do
        map.uploads.last.destroy
        FactoryGirl.create :upload, map: map
      end

      it 'should not be possible' do
        expect(map.reload.uploads.count).to eq 5
        expect(map.uploads.only_deleted.last.recover).to be_false
        expect(map.reload.uploads.unscoped.count).to eq 6
        expect(map.uploads.only_deleted.count).to eq 1
        expect(map.uploads.count).to eq 5
        expect(map.valid?).to be_true
      end
    end
  end
end
