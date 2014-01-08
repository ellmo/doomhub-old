require 'spec_helper'

describe FileLinksController do

  describe "GET new" do
    ## FileLink attached to a Project
    context 'when file_linkable is a project' do
      shared_context 'file_link #new' do
        before do
          sign_in user
          get :new, project_id: project.slug
        end
        it 'is successful' do
          expect(response).to be_success
        end
        it "stuff is assigned properly" do
          expect(assigns :project).to eq project
        end
        it "renders :new template" do
          expect(response).to render_template :new
        end
      end
      shared_context 'access denial' do
        before do
          sign_in user
          get :new, project_id: project.slug
        end
        it 'is denied' do
          expect(response.status).to eq 403
        end
      end

      context '(public join)' do
        let(:project) { FactoryGirl.create :project_public }
        context 'and user is not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ get :new, project_id: project.slug }.to raise_exception("uncaught throw :warden")
          end
        end
        context 'and user is logged in' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'file_link #new'
        end
        context 'and admin is logged in' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'file_link #new'
        end
        context 'and superadmin is logged in' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'file_link #new'
        end
      end

      context '(private join)' do
        let(:project) { FactoryGirl.create :project_private }
        context 'and user is not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ get :new, project_id: project.slug }.to raise_exception("uncaught throw :warden")
          end
        end
        context 'and user is logged in' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end
        context 'and owner is logged in' do
          let(:user) { project.creator }
          it_behaves_like 'file_link #new'
        end
        context 'and admin is logged in' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'file_link #new'
        end
        context 'and superadmin is logged in' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'file_link #new'
        end
      end
    end

    ## FileLink attached to a Map
    context 'when file_linkable is a map' do
      shared_context 'file_link #new' do
        before do
          sign_in user
          get :new, project_id: project.slug, map_id: map.slug
        end
        it 'is successful' do
          expect(response).to be_success
        end
        it "stuff is assigned properly" do
          expect(assigns :map).to eq map
          expect(assigns :project).to eq project
        end
        it "renders :new template" do
          expect(response).to render_template :new
        end
      end
      shared_context 'access denial' do
        before do
          sign_in user
          get :new, project_id: project.slug, map_id: map.slug
        end
        it 'is denied' do
          expect(response.status).to eq 403
        end
      end

      context '(public join)' do
        let(:project) { FactoryGirl.create :project_public }
        let(:map) { FactoryGirl.create :map, project: project }
        context 'and user is not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ get :new, project_id: project.slug, map_id: map.slug }.to raise_exception("uncaught throw :warden")
          end
        end
        context 'and user is logged in' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'file_link #new'
        end
        context 'and admin is logged in' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'file_link #new'
        end
        context 'and superadmin is logged in' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'file_link #new'
        end
      end

      context '(private join)' do
        let(:project) { FactoryGirl.create :project_private }
        let(:map) { FactoryGirl.create :map, project: project, authorable: project.creator }
        context 'and user is not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ get :new, project_id: project.slug }.to raise_exception("uncaught throw :warden")
          end
        end
        context 'and user is logged in' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end
        context 'and owner is logged in' do
          let(:user) { project.creator }
          it_behaves_like 'file_link #new'
        end
        context 'and admin is logged in' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'file_link #new'
        end
        context 'and superadmin is logged in' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'file_link #new'
        end
      end
    end
  end
end
