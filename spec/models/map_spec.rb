require 'spec_helper'

describe Map do
  context 'when creating new' do
    context 'attrs are valid' do
      before do
        FactoryGirl.create :map
      end

      it 'should create the map' do
        Map.count.should eq 1
      end

      it 'should create another map' do
        FactoryGirl.create :map
        Map.count.should eq 2
        User.count.should eq 2
      end

      it 'should create another map for the same user' do
        user = User.first
        FactoryGirl.create :map, author: user
        User.count.should eq 1
        Project.count.should eq 2
        Map.count.should eq 2
      end

      it 'should create another map for the same user' do
        user = User.first
        project = Project.last
        FactoryGirl.create :map, author: user, project: project
        User.count.should eq 1
        Project.count.should eq 1
        Map.count.should eq 2
      end
    end
  end

  context 'when using default lumpname' do
    context 'creating a doom1 map' do
      before do
        FactoryGirl.create :project, game: Game.find_by_name('Doom')
        FactoryGirl.create :map, project: Project.last, author: User.last
      end

      let(:map) { Map.last }

      it 'doom lumpname should default to E1M1' do
        map.lump.should eq 'E1M1'
      end
    end

    context 'creating a doom2 map' do
      before do
        FactoryGirl.create :project, game: Game.find_by_name('Doom 2')
        FactoryGirl.create :map, project: Project.last, author: User.last
      end

      let(:map) { Map.last }

      it 'doom lumpname should default to MAP01' do
        map.lump.should eq 'MAP01'
      end
    end

    context 'creating a heretic map' do
      before do
        FactoryGirl.create :project, game: Game.find_by_name('Heretic')
        FactoryGirl.create :map, project: Project.last, author: User.last
      end

      let(:map) { Map.last }

      it 'doom lumpname should default to E1M1' do
        map.lump.should eq 'E1M1'
      end
    end

    context 'creating a hexen map' do
      before do
        FactoryGirl.create :project, game: Game.find_by_name('Hexen')
        FactoryGirl.create :map, project: Project.last, author: User.last
      end

      let(:map) { Map.last }

      it 'doom lumpname should default to MAP01' do
        map.lump.should eq 'MAP01'
      end
    end

    context 'creating a strife map' do
      before do
        FactoryGirl.create :project, game: Game.find_by_name('Strife')
        FactoryGirl.create :map, project: Project.last, author: User.last
      end

      let(:map) { Map.last }

      it 'doom lumpname should default to MAP01' do
        map.lump.should eq 'MAP01'
      end
    end
  end

  context 'when using custom lumpname' do
    context 'creating a doom map' do
      before do
        FactoryGirl.create :project, game: Game.find_by_name('Doom')
        FactoryGirl.create :map, project: Project.last, author: User.last, lump: 'E1M7'
      end

      let(:map) { Map.last }

      it 'doom lumpname should to E1M7' do
        map.lump.should eq 'E1M7'
      end
    end
  end
end
