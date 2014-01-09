require 'spec_helper'

describe ResourcesController do

  context 'resources for a Project' do
    describe "GET 'index'" do
      shared_context 'resource #index' do
        before do
          sign_in user
          get :index, project_id: project.slug
        end
        it 'is successful' do
          expect(response).to be_success
        end
        it "@project is assigned properly" do
          expect(assigns :project).to eq project
        end
      end
      shared_context 'access denial' do
        before do
          sign_in user
          get :index, project_id: project.slug
        end
        it 'is denied' do
          expect(response.status).to eq 403
        end
      end

      context 'public project' do
        let(:project) { FactoryGirl.create :project }

        context 'when not logged in' do
          let(:user) { User.new }
          it_behaves_like 'resource #index'
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'resource #index'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'resource #index'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'resource #index'
        end
      end

      context 'private project' do
        let(:project) { FactoryGirl.create :project_private }

        context 'when not logged in' do
          let(:user) { User.new }
          it_behaves_like 'access denial'
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'resource #index'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'resource #index'
        end
      end

      context 'owned private project' do
        let(:user) { FactoryGirl.create :user }
        let(:project) { FactoryGirl.create :project_private, creator: user }

        context 'when logged in as user' do
          it_behaves_like 'resource #index'
        end
      end
    end
  end

  context 'resources for a Map' do
    describe "GET 'index'" do
      shared_context 'resource #index' do
        before do
          sign_in user
          get :index, project_id: project.slug, map_id: map.slug
        end
        it 'is successful' do
          expect(response).to be_success
        end
        it "@project is assigned properly" do
          expect(assigns :map).to eq map
          expect(assigns :project).to eq project
        end
      end
      shared_context 'access denial' do
        before do
          sign_in user
          get :index, project_id: project.slug, map_id: map.slug
        end
        it 'is denied' do
          expect(response.status).to eq 403
        end
      end

      context 'public project' do
        let(:project) { FactoryGirl.create :project }
        let(:map) { FactoryGirl.create :map, project: project, authorable: project.creator }

        context 'when not logged in' do
          let(:user) { User.new }
          it_behaves_like 'resource #index'
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'resource #index'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'resource #index'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'resource #index'
        end
      end

      context 'private project' do
        let(:project) { FactoryGirl.create :project_private }
        let(:map) { FactoryGirl.create :map, project: project, authorable: project.creator }

        context 'when not logged in' do
          let(:user) { User.new }
          it_behaves_like 'access denial'
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'resource #index'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'resource #index'
        end
      end

      context 'owned private project' do
        let(:user) { FactoryGirl.create :user }
        let(:project) { FactoryGirl.create :project_private, creator: user }
        let(:map) { FactoryGirl.create :map, project: project, authorable: project.creator }

        context 'when logged in as user' do
          it_behaves_like 'resource #index'
        end
      end
    end
  end

  # describe "GET 'new'" do
  #   shared_context 'resource #new' do
  #     before do
  #       sign_in user
  #       get :new, project_id: project.slug
  #     end
  #     it 'is successful' do
  #       expect(response).to be_success
  #     end
  #     it "@project is assigned properly" do
  #       expect(assigns :project).to eq project
  #     end
  #   end
  #   shared_context 'access denial' do
  #     before do
  #       sign_in user
  #       get :new, project_id: project.slug
  #     end
  #     it 'is denied' do
  #       expect(response.status).to eq 403
  #     end
  #   end

  #   context 'public project' do
  #     let(:project) { FactoryGirl.create :project }

  #     context 'when not logged in' do
  #       let(:user) { User.new }
  #       it_behaves_like 'access denial'
  #     end

  #     context 'when logged in as user' do
  #       let(:user) { FactoryGirl.create :user }
  #       it_behaves_like 'resource #new'
  #     end

  #     context 'when logged in as admin' do
  #       let(:user) { FactoryGirl.create :admin }
  #       it_behaves_like 'resource #new'
  #     end

  #     context 'when logged in as superadmin' do
  #       let(:user) { FactoryGirl.create :superadmin }
  #       it_behaves_like 'resource #new'
  #     end
  #   end
  # end

end
