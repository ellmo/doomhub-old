require 'spec_helper'

describe Project do
  context '::create' do
    context 'name and url_name are unique' do
      before do
        FactoryGirl.create :project
      end

      it 'should succeed' do
        expect(Project.count).to eq 1
      end
      it 'should succeed for two different projects' do
        FactoryGirl.create :project
        expect(Project.count).to eq 2
      end
    end

    context 'name and/or url_name are not unique' do
      let!(:existing_project) { FactoryGirl.create :project }

      context 'name is in use' do
        context 'name uses the same case' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :project, name: existing_project.name }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add project' do
            expect(Project.count).to eq 1
          end
        end

        context 'name is upcased' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :project, name: existing_project.name.upcase }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add Project' do
            expect(Project.count).to eq 1
          end
        end

        context 'name is capitalized' do
          it "should raise RecordInvalid" do
            expect { FactoryGirl.create :project, name: existing_project.name.capitalize }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add Project' do
            expect(Project.count).to eq 1
          end
        end
      end

      context 'name is in use by destroyed project' do
        let!(:deleted_project) { existing_project.destroy }

        it 'should raise RecordInvalid' do
          expect { FactoryGirl.create :project, name: deleted_project.name }.to raise_error(ActiveRecord::RecordInvalid)
        end
        it 'should not add Project' do
          expect(Project.count).to eq 0
          expect(Project.unscoped.count).to eq 1
        end
      end

      context 'url_name is in use' do
        context 'url_name uses the same case' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :project, url_name: existing_project.url_name }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add Project' do
            expect(Project.count).to eq 1
          end
        end

        context 'url_name is upcased' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :project, url_name: existing_project.url_name.upcase }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add Project' do
            expect(Project.count).to eq 1
          end
        end

        context 'url_name is capitalized' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :project, url_name: existing_project.url_name.capitalize }.to raise_error(ActiveRecord::RecordInvalid)
          end
          it 'should not add Project' do
            expect(Project.count).to eq 1
          end
        end
      end

      context 'url_name is in use by destroyed project' do
        let!(:deleted_project) { existing_project.destroy }

        it 'should raise RecordInvalid' do
          expect { FactoryGirl.create :project, url_name: deleted_project.url_name }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'should not add Project' do
          expect(Project.count).to eq 0
          expect(Project.unscoped.count).to eq 1
        end
      end

      context 'both url_name and name are in use' do
        context 'they use the same case' do
          it 'should raise RecordInvalid' do
            expect { FactoryGirl.create :project, name: existing_project.name, url_name: existing_project.url_name }.to raise_error ActiveRecord::RecordInvalid
          end
          it 'should not add Project' do
            expect(Project.count).to eq 1
          end
        end
      end
    end
  end

  context 'when generating slug' do
    context 'no url_name given' do
      let!(:existing_project) { FactoryGirl.create :project, name: 'cold ass * Hell % & 12' }

      it 'properly generate a slug from name' do
        expect(existing_project.url_name).to eq existing_project.name
        expect(existing_project.slug).to eq existing_project.name.parameterize
      end

      context 'when trying to create project with the same name' do
        it 'should raise invalid record error' do
          expect { FactoryGirl.create :project, name: existing_project.name }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'url_name given' do
      let!(:existing_project) { FactoryGirl.create :project, name: 'cold ass * Hell % & 12', url_name: '# asdf ... , @#$ 234' }

      it 'properly generate a slug from url_name' do
        expect(existing_project.url_name).to_not eq existing_project.name
        expect(existing_project.slug).to eq existing_project.url_name.parameterize
      end

      context 'when trying to create project with the same url_name' do
        it 'should raise invalid record error' do
          expect { FactoryGirl.create :project, url_name: existing_project.url_name }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
