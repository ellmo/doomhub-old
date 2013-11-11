require 'spec_helper'

describe CommentsController do

  context 'when commenting a project' do
    describe "POST create" do
      shared_context 'comment #create' do
        before do
          sign_in user
          post :create, project_id: project.slug, comment: attributes, format: 'json'
        end
        it 'is successful' do
          expect(response).to be_success
        end
        it 'creates a comment' do
          expect(assigns(:comment).errors).to be_empty
          expect(project.reload.comments).not_to be_empty
          expect(assigns(:comment).content).to eq attributes[:content]
        end
      end
      shared_context 'access denial' do
        before do
          sign_in user
          get :new, project_id: project.slug, format: 'json'
        end
        it 'is denied' do
          expect(response.status).to eq 403
        end
      end

      let(:attributes) { {content:'asdfa asdfa'} }

      context 'public view project' do
        let(:project) { FactoryGirl.create :project }
        context 'not owned map' do
          let(:map) { FactoryGirl.create :map, project: project }

          context 'when not logged in' do
            before { sign_in_nobody }
            it 'throws a hissy fit' do
              expect{ post :create, project_id: project.slug, comment: attributes, format: 'json' }.to raise_exception("uncaught throw :warden")
            end
          end
          context 'when logged in as user' do
            let(:user) { FactoryGirl.create :user }
            it_behaves_like 'comment #create'
          end
          context 'when logged in as admin' do
            let(:user) { FactoryGirl.create :admin }
            it_behaves_like 'comment #create'
          end
          context 'when logged in as superadmin' do
            let(:user) { FactoryGirl.create :superadmin }
            it_behaves_like 'comment #create'
          end
        end

        context 'owned map' do
          let(:map) { FactoryGirl.create :map, project: project, author: user }

          context 'when logged in as user' do
            let(:user) { FactoryGirl.create :user }
            it_behaves_like 'comment #create'
          end

          context 'when logged in as admin' do
            let(:user) { FactoryGirl.create :admin }
            it_behaves_like 'comment #create'
          end

          context 'when logged in as superadmin' do
            let(:user) { FactoryGirl.create :superadmin }
            it_behaves_like 'comment #create'
          end
        end
      end

      context 'public join project' do
        let(:project) { FactoryGirl.create :project_public }
        context 'not owned map' do
          let(:map) { FactoryGirl.create :map, project: project }

          context 'when not logged in' do
            before { sign_in_nobody }
            it 'throws a hissy fit' do
              expect{ post :create, project_id: project.slug, comment: attributes, format: 'json' }.to raise_exception("uncaught throw :warden")
            end
          end
          context 'when logged in as user' do
            let(:user) { FactoryGirl.create :user }
            it_behaves_like 'comment #create'
          end
          context 'when logged in as admin' do
            let(:user) { FactoryGirl.create :admin }
            it_behaves_like 'comment #create'
          end
          context 'when logged in as superadmin' do
            let(:user) { FactoryGirl.create :superadmin }
            it_behaves_like 'comment #create'
          end
        end

        context 'owned map' do
          let(:map) { FactoryGirl.create :map, project: project, author: user }

          context 'when logged in as user' do
            let(:user) { FactoryGirl.create :user }
            it_behaves_like 'comment #create'
          end

          context 'when logged in as admin' do
            let(:user) { FactoryGirl.create :admin }
            it_behaves_like 'comment #create'
          end

          context 'when logged in as superadmin' do
            let(:user) { FactoryGirl.create :superadmin }
            it_behaves_like 'comment #create'
          end
        end
      end

      context 'private join project' do
        let(:project) { FactoryGirl.create :project_private }
        context 'not owned map' do
          let(:map) { FactoryGirl.create :map, project: project, author: project.creator }

          context 'when not logged in' do
            before { sign_in_nobody }
            it 'throws a hissy fit' do
              expect{ post :create, project_id: project.slug, comment: attributes, format: 'json' }.to raise_exception("uncaught throw :warden")
            end
          end
          context 'when logged in as user' do
            let(:user) { FactoryGirl.create :user }
            it_behaves_like 'access denial'
          end
          context 'when logged in as admin' do
            let(:user) { FactoryGirl.create :admin }
            it_behaves_like 'comment #create'
          end
          context 'when logged in as superadmin' do
            let(:user) { FactoryGirl.create :superadmin }
            it_behaves_like 'comment #create'
          end
        end

        context 'owned map' do
          let(:map) { FactoryGirl.create :map, project: project, author: user }

          context 'when logged in as user' do
            let(:user) { FactoryGirl.create :user }
            it_behaves_like 'access denial'
          end

          context 'when logged in as admin' do
            let(:user) { FactoryGirl.create :admin }
            it_behaves_like 'comment #create'
          end

          context 'when logged in as superadmin' do
            let(:user) { FactoryGirl.create :superadmin }
            it_behaves_like 'comment #create'
          end
        end
      end
    end
  end
end