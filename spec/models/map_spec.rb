require 'spec_helper'

describe Map do
  context 'creation' do
    context 'with valid attributes' do
      before do
        FactoryGirl.create :map
      end

      it 'should succeed' do
        Map.count.should eq 1
      end

      it 'should succeed twice' do
        FactoryGirl.create :map
        Map.count.should eq 2
        User.count.should eq 2
      end

      it 'should succeed when creating 2 maps for the same user' do
        user = User.first
        FactoryGirl.create :map, author: user
        User.count.should eq 1
        Project.count.should eq 2
        Map.count.should eq 2
      end

      it 'should succeed when creating 2 maps within the same project' do
        user = User.first
        project = Project.last
        FactoryGirl.create :map, author: user, project: project
        User.count.should eq 1
        Project.count.should eq 1
        Map.count.should eq 2
      end
    end

    context 'when using default lumpname' do
      context 'within a doom1 project' do
        before do
          FactoryGirl.create :project, game: Game.find_by_name('Doom')
          FactoryGirl.create :map, project: Project.last, author: User.last
        end

        let(:map) { Map.last }

        it 'lumpname should default to E1M1' do
          map.lump.should eq 'E1M1'
        end
      end

      context 'within a doom2 project' do
        before do
          FactoryGirl.create :project, game: Game.find_by_name('Doom 2')
          FactoryGirl.create :map, project: Project.last, author: User.last
        end

        let(:map) { Map.last }

        it 'lumpname should default to MAP01' do
          map.lump.should eq 'MAP01'
        end
      end

      context 'within a heretic project' do
        before do
          FactoryGirl.create :project, game: Game.find_by_name('Heretic')
          FactoryGirl.create :map, project: Project.last, author: User.last
        end

        let(:map) { Map.last }

        it 'lumpname should default to E1M1' do
          map.lump.should eq 'E1M1'
        end
      end

      context 'within a hexen project' do
        before do
          FactoryGirl.create :project, game: Game.find_by_name('Hexen')
          FactoryGirl.create :map, project: Project.last, author: User.last
        end

        let(:map) { Map.last }

        it 'lumpname should default to MAP01' do
          map.lump.should eq 'MAP01'
        end
      end

      context 'within a strife project' do
        before do
          FactoryGirl.create :project, game: Game.find_by_name('Strife')
          FactoryGirl.create :map, project: Project.last, author: User.last
        end

        let(:map) { Map.last }

        it 'lumpname should default to MAP01' do
          map.lump.should eq 'MAP01'
        end
      end
    end

    context 'when using custom lumpname' do
      before do
        FactoryGirl.create :project, game: Game.find_by_name('Doom')
        FactoryGirl.create :map, project: Project.last, author: User.last, lump: 'E1M7'
      end

      let(:map) { Map.last }

      it 'lumpname should be whtaver was passed' do
        map.lump.should eq 'E1M7'
      end
    end
  end

  context 'adding WADFILES' do
    before do
      FactoryGirl.create :map
      5.times { FactoryGirl.create :map_wadfile, map: map }
    end

    let(:map) { Map.last }

    context 'adding no more than five' do
      it 'should be valid' do
        map.valid?.should be_true
        map.errors[:base].should be_empty
        map.map_wadfiles.count.should eq 5
      end
    end

    context 'adding more than five' do
      it "should raise RecordInvalid" do
        expect do
          FactoryGirl.create :map_wadfile, map: map
        end.to raise_error(ActiveRecord::RecordInvalid)
        map.valid?.should be_true
        map.map_wadfiles.count.should eq 5
      end
    end

    context 'adding new after deleting old' do
      before do
        map.map_wadfiles.last.destroy
      end

      it 'should respect paranoid entries' do
        map.map_wadfiles.count.should eq 4
        map.map_wadfiles.unscoped.count.should eq 5
      end

      it 'should be valid when new wadfile is added' do
        FactoryGirl.create :map_wadfile, map: map
        map.map_wadfiles.count.should eq 5
        map.map_wadfiles.unscoped.count.should eq 6
        map.valid?.should be_true
      end
    end
  end

  context "recovering WADFILES" do
    before do
      FactoryGirl.create :map
      5.times { FactoryGirl.create :map_wadfile, map: map }
    end

    let(:map) { Map.last }

    context 'restoring destroyed file ' do
      before do
        map.map_wadfiles.last.destroy
      end

      it 'should be possible' do
        map.reload.map_wadfiles.count.should eq 4
        map.map_wadfiles.only_deleted.last.recover.should be_true
        map.reload.map_wadfiles.unscoped.count.should eq 5
        map.map_wadfiles.only_deleted.count.should eq 0
        map.map_wadfiles.count.should eq 5
        map.valid?.should be_true
      end
    end

    context 'restoring destroyed file when there are 5 wadfiles already' do
      before do
        map.map_wadfiles.last.destroy
        FactoryGirl.create :map_wadfile, map: map
      end

      it 'should not be possible' do
        map.reload.map_wadfiles.count.should eq 5
        map.map_wadfiles.only_deleted.last.recover.should be_false
        map.reload.map_wadfiles.unscoped.count.should eq 6
        map.map_wadfiles.only_deleted.count.should eq 1
        map.map_wadfiles.count.should eq 5
        map.valid?.should be_true
      end
    end
  end
end
