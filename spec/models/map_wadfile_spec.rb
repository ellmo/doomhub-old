require 'spec_helper'

describe MapWadfile do
  context '::create' do
    let!(:first_user) { FactoryGirl.create :user }
    let!(:first_project) { FactoryGirl.create :project, creator: first_user }
    let!(:first_map) { FactoryGirl.create :map, author: first_user, project: first_project }

    context 'with valid attributes' do
      context 'zip archive' do
        it 'should succeed' do
          FactoryGirl.create :map_wadfile, map: first_map, author: first_user
        end
      end

      context 'rar archive' do
        it 'should succeed' do
          FactoryGirl.create :map_wadfile_rar, map: first_map, author: first_user
        end
      end

      context '7z archive' do
        it 'should succeed' do
          FactoryGirl.create :map_wadfile_7z, map: first_map, author: first_user
        end
      end
    end
  end
end
