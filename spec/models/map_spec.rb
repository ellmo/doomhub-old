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
end
