require 'spec_helper'

describe Project do
  context 'creating new' do
    context 'neither name nor slug are in use' do
      before do
        FactoryGirl.create :project
      end

      it 'should create the project' do
        Project.count.should eq 1
      end

      it 'should create another project' do
        FactoryGirl.create :project
        Project.count.should eq 2
      end
    end

    context 'name is in use but slug is different' do
      before do
        FactoryGirl.create :project
      end

      let(:existing_project) { Project.first }

      context 'name is in the same case' do
        it 'should raise invalid record error' do
          expect do
            FactoryGirl.create :project, name: existing_project.name, url_name: 'something_else'
          end.to raise_error(ActiveRecord::RecordInvalid)
          Project.count.should eq 1
        end
      end

      context 'name tries to use different case' do
        it 'should raise invalid record error' do
          expect do
            FactoryGirl.create :project, name: existing_project.name.capitalize, url_name: 'something_else'
          end.to raise_error(ActiveRecord::RecordInvalid)
          expect do
            FactoryGirl.create :project, name: existing_project.name.upcase, url_name: 'something_else'
          end.to raise_error(ActiveRecord::RecordInvalid)
          Project.count.should eq 1
        end
      end
    end

    context 'email is in use but login isn`t' do
      before do
        FactoryGirl.create :project
      end

      let(:existing_project) { Project.first }

      context 'email is in the same case' do
        it 'should raise invalid record error' do
          expect do
            FactoryGirl.create :project, url_name: existing_project.url_name, name: 'something_else'
          end.to raise_error(ActiveRecord::RecordInvalid)
          Project.count.should eq 1
        end
      end

      context 'email tries to use different case' do
        it 'should raise invalid record error' do
          expect do
            FactoryGirl.create :project, url_name: existing_project.url_name.capitalize, name: 'something_else'
          end.to raise_error(ActiveRecord::RecordInvalid)
          expect do
            FactoryGirl.create :project, url_name: existing_project.url_name.upcase, name: 'something_else'
          end.to raise_error(ActiveRecord::RecordInvalid)
          Project.count.should eq 1
        end
      end
    end

    context 'both email AND login are in use' do
      before do
        FactoryGirl.create :project
      end

      let(:existing_project) { Project.first }

      context 'email and login are both in the same case' do
        it 'should raise invalid record error' do
          expect do
            FactoryGirl.create :project, url_name: existing_project.url_name, name: existing_project.name
          end.to raise_error(ActiveRecord::RecordInvalid)
          Project.count.should eq 1
        end
      end

      context 'either login or email try to use different case' do
        it 'should raise invalid record error' do
          expect do
            FactoryGirl.create :project, url_name: existing_project.url_name.upcase, name: existing_project.name
          end.to raise_error(ActiveRecord::RecordInvalid)
          expect do
            FactoryGirl.create :project, url_name: existing_project.url_name, name: existing_project.name.capitalize
          end.to raise_error(ActiveRecord::RecordInvalid)
          Project.count.should eq 1
        end
      end
    end
  end
end
