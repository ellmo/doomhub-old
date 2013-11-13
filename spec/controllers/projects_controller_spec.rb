require 'spec_helper'

describe ProjectsController do

  describe "GET index" do
    shared_context 'projects index' do |project_count, user_type, private_projects|
      before do
        sign_in user
        get :index
      end

      it 'is successful' do
        expect(response).to be_success
      end
      it "@projects are assigned properly" do
        projects = Project.readable_by user
        expect(assigns(:projects).count).to eq project_count
        expect(assigns(:projects) - projects).to be_empty
      end
      if user_type > 0 and private_projects
        it "@projects include users private project" do
          expect(assigns :projects).to include *user.projects.private_view
        end
      end
      if user_type > 1
        it "@projects include private" do
          expect(assigns :projects).to include *Project.private_view
        end
        it "admin sees ALL projects" do
          expect(assigns :projects).to eq Project.all
        end
      end
    end

    before do
      3.times { FactoryGirl.create :project }
      2.times { FactoryGirl.create :project_private }
      2.times { FactoryGirl.create :project_public }
    end

    context 'when not logged in' do
      let(:user) { User.new }
      it_behaves_like 'projects index', 5, 0, false
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :user }
      it_behaves_like 'projects index', 5, 1, false

      context 'user has their own projects' do
        before { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'projects index', 6, 1, true
      end
    end

    context 'when logged in as admin' do
      let(:user) { FactoryGirl.create :admin }
      it_behaves_like 'projects index', 7, 2, false

      context 'admin has their own projects' do
        before { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'projects index', 8, 2, true
      end
    end

    context 'when logged in as superadmin' do
      let(:user) { FactoryGirl.create :superadmin }
      it_behaves_like 'projects index', 7, 3, false

      context 'superadmin has their own projects' do
        before { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'projects index', 8, 3, true
      end
    end
  end

  describe "GET show" do

    shared_context 'project show' do
      before { get :show, id: project.slug }
      it 'is successful' do
        expect(response).to be_success
      end
      it '@project assigns public project' do
        expect(assigns :project).to eq project
      end
    end

    context 'when not logged in' do
      before { sign_in_nobody }

      context 'viewing public project' do
        let(:project) { FactoryGirl.create :project_public }
        it_behaves_like 'project show'
      end

      context 'viewing private project' do
        let(:project) { FactoryGirl.create :project_private }
        before { get :show, id: project.slug }
        it_behaves_like 'access denial'
      end
    end

    context 'when logged as user' do
      let(:user) { FactoryGirl.create :user }
      before { sign_in user }

      context 'viewing public project' do
        let(:project) { FactoryGirl.create :project_public }
        it_behaves_like 'project show'
      end

      context 'viewing private project' do
        let(:project) { FactoryGirl.create :project_private }
        before { get :show, id: project.slug }
        it_behaves_like 'access denial'
      end

      context 'viewing owned private project' do
        let(:project) { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'project show'
      end
    end

    context 'when logged as admin' do
      let(:user) { FactoryGirl.create :admin }
      before { sign_in user }

      context 'viewing public project' do
        let(:project) { FactoryGirl.create :project_public }
        it_behaves_like 'project show'
      end

      context 'viewing private project' do
        let(:project) { FactoryGirl.create :project_private }
        it_behaves_like 'project show'
      end

      context 'viewing owned private project' do
        let(:project) { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'project show'
      end
    end

    context 'when logged as superadmin' do
      let(:user) { FactoryGirl.create :superadmin }
      before { sign_in user }

      context 'viewing public project' do
        let(:project) { FactoryGirl.create :project_public }
        it_behaves_like 'project show'
      end

      context 'viewing private project' do
        let(:project) { FactoryGirl.create :project_private }
        it_behaves_like 'project show'
      end

      context 'viewing owned private project' do
        let(:project) { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'project show'
      end
    end
  end

  describe "GET new" do

    shared_context 'project #new' do
      before do
        sign_in user
        get :new
      end
      it 'is success' do
        expect(response).to be_success
      end
    end

    context 'when not logged in' do
      before { sign_in_nobody }
      it_behaves_like 'authentication redirector', 'get', :new
    end

    context 'when logged as user' do
      let(:user) { FactoryGirl.create :user }
      it_behaves_like 'project #new'
    end

    context 'when logged as admin' do
      let(:user) { FactoryGirl.create :admin }
      it_behaves_like 'project #new'
    end

    context 'when logged as superadmin' do
      let(:user) { FactoryGirl.create :superadmin }
      it_behaves_like 'project #new'
    end
  end

  describe "POST create" do
    let(:valid_attributes) { FactoryGirl.build(:project).attributes }
    let(:invalid_attributes) { {name: '', game_id: '5'} }

    context "with valid attributes" do
      context 'when not logged in' do
        before { sign_in_nobody }

        context 'creating project' do
          it 'access denial' do
            expect{ post :create }.to raise_exception("uncaught throw :warden")
          end
        end
      end

      ['user', 'admin', 'superadmin'].each do |user_type|
        context 'when logged as user' do
          before { send "sign_in_#{user_type}" }

          include_context 'project creation'
        end
      end
    end

    context "with invalid attributes" do
      context 'when not logged in' do
        before { sign_in_nobody }

        context 'creating project' do
          it 'access denial' do
            expect{ post :create }.to raise_exception("uncaught throw :warden")
          end
        end
      end

      ['user', 'admin', 'superadmin'].each do |user_type|
        context 'when logged as user' do
          before { send "sign_in_#{user_type}" }

          include_context 'failed project creation'
        end
      end
    end
  end

  describe "GET edit" do
    shared_context 'project #edit' do
      before { get :edit, id: project.id }
      it 'is successful' do
        expect(response).to be_success
      end
      it 'renders :edit' do
        expect(response).to render_template :edit
      end
    end

    context 'when not logged in' do
      before { sign_in_nobody }

      context 'trying to edit public project' do
        let(:public_project) { FactoryGirl.create :project }
        it 'throws a hissy fit' do
          expect{ get :edit, id: public_project.id }.to raise_exception("uncaught throw :warden")
        end
      end

      context 'trying to edit private project' do
        let(:private_project) { FactoryGirl.create :project_private }
        it 'throws a hissy fit' do
          expect{ get :edit, id: private_project.id }.to raise_exception("uncaught throw :warden")
        end
      end
    end

    context 'when logged as user' do
      let(:user) { FactoryGirl.create :user }
      before { sign_in user }

      context 'trying to edit public project' do
        let(:public_project) { FactoryGirl.create :project }
        before { get :edit, id: public_project.id }
        it_behaves_like 'access denial'
      end

      context 'trying to edit private project' do
        let(:private_project) { FactoryGirl.create :project_private }
        before { get :edit, id: private_project.id }
        it_behaves_like 'access denial'
      end

      context 'trying to edit user`s public project' do
        let(:project) { FactoryGirl.create :project, creator: user }
        it_behaves_like 'project #edit'
      end

      context 'trying to edit user`s public project' do
        let(:project) { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'project #edit'
      end
    end

    context 'when logged as admin' do
      let(:user) { FactoryGirl.create :admin }
      before { sign_in user }

      context 'trying to edit public project' do
        let(:project) { FactoryGirl.create :project }
        it_behaves_like 'project #edit'
      end

      context 'trying to edit private project' do
        let(:project) { FactoryGirl.create :project_private }
        it_behaves_like 'project #edit'
      end

      context 'trying to edit admin`s public project' do
        let(:project) { FactoryGirl.create :project, creator: user }
        it_behaves_like 'project #edit'
      end

      context 'trying to edit admin`s public project' do
        let(:project) { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'project #edit'
      end
    end

    context 'when logged as superadmin' do
      let(:user) { FactoryGirl.create :superadmin }
      before { sign_in user }

      context 'trying to edit public project' do
        let(:project) { FactoryGirl.create :project }
        it_behaves_like 'project #edit'
      end

      context 'trying to edit private project' do
        let(:project) { FactoryGirl.create :project_private }
        it_behaves_like 'project #edit'
      end

      context 'trying to edit superadmin`s public project' do
        let(:project) { FactoryGirl.create :project, creator: user }
        it_behaves_like 'project #edit'
      end

      context 'trying to edit superadmin`s public project' do
        let(:project) { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'project #edit'
      end
    end
  end

  describe "POST update" do
    context 'with valid attributes' do
      let(:valid_attributes) do
        FactoryGirl.build(:project).attributes.reject {|k,v| v.nil?}
      end

      shared_context 'project update' do
        before { post :update, id: project.id, project: valid_attributes }
        it 'redirects to project`s show' do
          expect(response).to redirect_to project_path(project)
        end
        it 'updates project' do
          expect(assigns(:project).name).to eq valid_attributes['name']
        end
      end

      context 'when not logged in' do
        shared_examples 'authentication redirector' do
          before { sign_in_nobody }
          it 'throws uncaught :warden' do
            expect{ post :update, id: project.id, project: valid_attributes }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'trying to update public project' do
          let(:project) { FactoryGirl.create :project }
          it_behaves_like 'authentication redirector'
        end

        context 'trying to edit private project' do
          let(:project) { FactoryGirl.create :project_private }
          it_behaves_like 'authentication redirector'
        end
      end

      context 'when logged as user' do
        let(:user) { FactoryGirl.create :user }
        before { sign_in user }

        context 'trying to update public project' do
          let(:public_project) { FactoryGirl.create :project }
          before { post :update, id: public_project.id, project: valid_attributes }
          it_behaves_like 'access denial'
        end

        context 'trying to edit private project' do
          let(:private_project) { FactoryGirl.create :project_private }
          before { post :update, id: private_project.id, project: valid_attributes }
          it_behaves_like 'access denial'
        end

        context 'trying to edit user`s public project' do
          let(:project) { FactoryGirl.create :project, creator: user }
          it_behaves_like 'project update'
        end

        context 'trying to edit user`s public project' do
          let(:project) { FactoryGirl.create :project_private, creator: user }
          it_behaves_like 'project update'
        end
      end

      context 'when logged as admin' do
        let(:admin) { FactoryGirl.create :admin }
        before { sign_in admin }

        context 'trying to update public project' do
          let(:project) { FactoryGirl.create :project }
          it_behaves_like 'project update'
        end

        context 'trying to edit private project' do
          let(:project) { FactoryGirl.create :project_private }
          it_behaves_like 'project update'
        end

        context 'trying to edit admin`s public project' do
          let(:project) { FactoryGirl.create :project, creator: admin }
          it_behaves_like 'project update'
        end

        context 'trying to edit admin`s public project' do
          let(:project) { FactoryGirl.create :project_private, creator: admin }
          it_behaves_like 'project update'
        end
      end

      context 'when logged as superadmin' do
        let(:superadmin) { FactoryGirl.create :superadmin }
        before { sign_in superadmin }

        context 'trying to update public project' do
          let(:project) { FactoryGirl.create :project }
          it_behaves_like 'project update'
        end

        context 'trying to edit private project' do
          let(:project) { FactoryGirl.create :project_private }
          it_behaves_like 'project update'
        end

        context 'trying to edit superadmin`s public project' do
          let(:project) { FactoryGirl.create :project, creator: superadmin }
          it_behaves_like 'project update'
        end

        context 'trying to edit superadmin`s public project' do
          let(:project) { FactoryGirl.create :project_private, creator: superadmin }
          it_behaves_like 'project update'
        end
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { {name: '', game_id: '5'} }

      shared_context 'failed project update' do
        before { post :update, id: project.id, project: invalid_attributes }
        it 'returns project errors' do
          expect(assigns(:project).errors).not_to be_empty
        end
        it 'rerenders `edit` view' do
          expect(response).to render_template :edit
        end
      end

      context 'when not logged in' do
        before { sign_in_nobody }

        context 'trying to update public project' do
          let(:public_project) { FactoryGirl.create :project }
          it 'throws a hissy fit' do
            expect{ post :update, id: public_project.id, project: invalid_attributes }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'trying to edit private project' do
          let(:private_project) { FactoryGirl.create :project_private }
          it 'throws a hissy fit' do
            expect{ post :update, id: private_project.id, project: invalid_attributes }.to raise_exception("uncaught throw :warden")
          end
        end
      end

      context 'when logged as user' do
        let(:user) { FactoryGirl.create :user }
        before { sign_in user }

        context 'trying to update public project' do
          let(:project) { FactoryGirl.create :project }
          before { post :update, id: project.id, project: invalid_attributes }
          it_behaves_like 'access denial'
        end

        context 'trying to edit private project' do
          let(:private_project) { FactoryGirl.create :project_private }
          before { post :update, id: private_project.id, project: invalid_attributes }
          it_behaves_like 'access denial'
        end

        context 'trying to edit user`s public project' do
          let(:project) { FactoryGirl.create :project, creator: user }
          it_behaves_like 'failed project update'
        end

        context 'trying to edit user`s public project' do
          let(:project) { FactoryGirl.create :project_private, creator: user }
          it_behaves_like 'failed project update'
        end
      end

      context 'when logged as admin' do
        let(:admin) { FactoryGirl.create :admin }
        before { sign_in admin }

        context 'trying to update public project' do
          let(:project) { FactoryGirl.create :project }
          it_behaves_like 'failed project update'
        end

        context 'trying to edit private project' do
          let(:project) { FactoryGirl.create :project_private }
          it_behaves_like 'failed project update'
        end

        context 'trying to edit admin`s public project' do
          let(:project) { FactoryGirl.create :project, creator: admin }
          it_behaves_like 'failed project update'
        end

        context 'trying to edit admin`s public project' do
          let(:project) { FactoryGirl.create :project_private, creator: admin }
          it_behaves_like 'failed project update'
        end
      end

      context 'when logged as admin' do
        let(:superadmin) { FactoryGirl.create :superadmin }
        before { sign_in superadmin }

        context 'trying to update public project' do
          let(:project) { FactoryGirl.create :project }
          it_behaves_like 'failed project update'
        end

        context 'trying to edit private project' do
          let(:project) { FactoryGirl.create :project_private }
          it_behaves_like 'failed project update'
        end

        context 'trying to edit superadmin`s public project' do
          let(:project) { FactoryGirl.create :project, creator: superadmin }
          it_behaves_like 'failed project update'
        end

        context 'trying to edit superadmin`s public project' do
          let(:project) { FactoryGirl.create :project_private, creator: superadmin }
          it_behaves_like 'failed project update'
        end
      end
    end
  end

  describe "POST destroy" do
    shared_context 'project destruction' do
      before { post :destroy, id: project.id }
      it 'redirects to projects index' do
        expect(response).to redirect_to projects_path
      end
      it 'destroys project' do
        expect(Project.all).not_to include project
      end
      it 'puts project in deleted scope' do
        expect(Project.only_deleted).to include project
      end
    end

    context 'when not logged in' do
      shared_examples 'authentication redirector (destroy)' do
        it 'throws uncaught :warden' do
          expect{ post :destroy, id: project.id }.to raise_exception("uncaught throw :warden")
        end
      end

      before { sign_in_nobody }

      context 'trying to destroy public project' do
        let(:project) { FactoryGirl.create :project }
        it_behaves_like 'authentication redirector (destroy)'
      end

      context 'trying to destroy private project' do
        let(:project) { FactoryGirl.create :project_private }
        it_behaves_like 'authentication redirector (destroy)'
      end
    end

    context 'when logged as user' do
      let(:user) { FactoryGirl.create :user }
      before { sign_in user }

      context 'trying to destroy public project' do
        let(:public_project) { FactoryGirl.create :project }
        before { post :destroy, id: public_project.id }
        it_behaves_like 'access denial'
      end

      context 'trying to destroy private project' do
        let(:private_project) { FactoryGirl.create :project_private }
        before { post :destroy, id: private_project.id }
        it_behaves_like 'access denial'
      end

      context 'trying to edit user`s public project' do
        let(:project) { FactoryGirl.create :project, creator: user }
        it_behaves_like 'project destruction'
      end

      context 'trying to edit user`s public project' do
        let(:project) { FactoryGirl.create :project_private, creator: user }
        it_behaves_like 'project destruction'
      end
    end

    context 'when logged as admin' do
      let(:admin) { FactoryGirl.create :admin }
      before { sign_in admin }

      context 'trying to destroy public project' do
        let(:project) { FactoryGirl.create :project }
        it_behaves_like 'project destruction'
      end

      context 'trying to edit private project' do
        let(:project) { FactoryGirl.create :project_private }
        it_behaves_like 'project destruction'
      end

      context 'trying to edit admin`s public project' do
        let(:project) { FactoryGirl.create :project, creator: admin }
        it_behaves_like 'project destruction'
      end

      context 'trying to edit admin`s public project' do
        let(:project) { FactoryGirl.create :project_private, creator: admin }
        it_behaves_like 'project destruction'
      end
    end

    context 'when logged as superadmin' do
      let(:superadmin) { FactoryGirl.create :superadmin }
      before { sign_in superadmin }

      context 'trying to destroy public project' do
        let(:project) { FactoryGirl.create :project }
        it_behaves_like 'project destruction'
      end

      context 'trying to edit private project' do
        let(:project) { FactoryGirl.create :project_private }
        it_behaves_like 'project destruction'
      end

      context 'trying to edit superadmin`s public project' do
        let(:project) { FactoryGirl.create :project, creator: superadmin }
        it_behaves_like 'project destruction'
      end

      context 'trying to edit superadmin`s public project' do
        let(:project) { FactoryGirl.create :project_private, creator: superadmin }
        it_behaves_like 'project destruction'
      end
    end
  end
end