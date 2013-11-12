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
          post :create, project_id: project.slug, format: 'json'
        end
        it 'is denied' do
          expect(response.status).to eq 403
        end
      end

      let(:attributes) { {content:'asdfa asdfa'} }

      context 'public view project' do
        let(:project) { FactoryGirl.create :project }

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

      context 'public join project' do
        let(:project) { FactoryGirl.create :project_public }

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

      context 'private join project' do
        let(:project) { FactoryGirl.create :project_private }

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
    end

    describe "POST update" do
      shared_context 'comment #update' do
        before do
          sign_in user
          post :update, project_id: project.slug, id: comment.id, comment: attributes, format: 'json'
        end
        it 'is successful' do
          expect(response).to be_success
        end
        it 'edits a comment' do
          expect(assigns(:comment).errors).to be_empty
          expect(assigns(:comment).content).to eq attributes[:content]
          expect(assigns(:comment).updated_at).not_to be nil
        end
        it 'creates a comment edition' do
          expect(assigns(:comment).editions).not_to be_empty
          expect(assigns(:comment).editions.last.content_was).not_to eq assigns(:comment).content
        end
      end
      shared_context 'access denial' do
        before do
          sign_in user
          post :update, project_id: project.slug, id: comment.id, comment: attributes, format: 'json'
        end
        it 'is denied' do
          expect(response.status).to eq 403
        end
      end

      let(:attributes) { {content:'new_content'} }

      context 'owned comment' do
        let(:project) { FactoryGirl.create :project }
        let(:comment) { FactoryGirl.create :comment, commentable: project, user: user }

        context 'when not logged in' do
          let(:user) { User.new }
          before { sign_in user }
          it 'throws a hissy fit' do
            expect{ post :update, project_id: project.slug, id: comment.id, comment: attributes, format: 'json' }.to raise_exception("uncaught throw :warden")
          end
        end
        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'comment #update'
        end
        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'comment #update'
        end
        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'comment #update'
        end
      end

      context 'not owned comment' do
        let(:project) { FactoryGirl.create :project }
        let(:comment) { FactoryGirl.create :comment, commentable: project }

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end
        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'comment #update'
        end
        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'comment #update'
        end
      end
    end

    describe "POST destroy" do
      shared_context 'comment #destroy' do
        before do
          sign_in user
          post :destroy, project_id: project.slug, id: comment.id, format: 'json'
        end
        it 'is successful' do
          expect(response).to be_success
        end
        it 'destroys a comment' do
          expect(assigns(:project).comments).to be_empty
        end
        it 'treats comments as paranoid' do
          expect(comment.reload.deleted_at).not_to be_nil
          expect(comment.reload.deleted_at).not_to be_nil
        end
      end
      shared_context 'access denial' do
        before do
          sign_in user
          post :destroy, project_id: project.slug, id: comment.id, format: 'json'
        end
        it 'is denied' do
          expect(response.status).to eq 403
        end
      end

      context 'owned comment' do
        let(:project) { FactoryGirl.create :project }
        let(:comment) { FactoryGirl.create :comment, commentable: project, user: user }

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'comment #destroy'
        end
        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'comment #destroy'
        end
        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'comment #destroy'
        end
      end

      context 'not owned comment' do
        let(:project) { FactoryGirl.create :project }
        let(:comment) { FactoryGirl.create :comment, commentable: project }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ post :destroy, project_id: project.slug, id: comment.id, format: 'json' }.to raise_exception("uncaught throw :warden")
          end
        end
        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end
        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'comment #destroy'
        end
        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'comment #destroy'
        end
      end
    end
  end

  #TODO: context 'when commenting a map'
end