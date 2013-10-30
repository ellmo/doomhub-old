require 'spec_helper'

describe ProjectsController do

  describe "GET index" do
    before do
      3.times { FactoryGirl.create :project }
      2.times { FactoryGirl.create :project_private }
      2.times { FactoryGirl.create :project_public }
    end

    context 'when not logged in' do
      before do
        sign_in_nobody
        get :index
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it "@projects are public projects" do
        projects = Project.readable_by User.new
        expect(projects.count).to eq 5
        expect(assigns :projects).to eq projects
      end

      it "@projects does not include private" do
        expect(assigns :projects).not_to include Project.private_view
      end
    end

    context 'when logged in as user' do
      let!(:user) { FactoryGirl.create :user }

      context 'user has no projects' do
        before do
          sign_in user
          get :index
        end

        it 'is successful' do
          expect(response).to be_success
        end

        it "@projects are public projects" do
          projects = Project.readable_by user
          expect(projects.count).to eq 5
          expect(assigns :projects).to eq projects
        end

        it "@projects does not include private" do
          expect(assigns :projects).not_to include Project.private_view
        end
      end

      context 'user has their own projects' do
        let!(:users_private_poject) { FactoryGirl.create :project_private, creator: user }

        before do
          FactoryGirl.create :project, creator: user
          sign_in user
          get :index
        end

        it 'is successful' do
          expect(response).to be_success
        end

        it "@projects are public AND user`s projects" do
          projects = Project.readable_by user
          expect(projects.count).to eq 7
          expect(assigns :projects).to eq projects
          expect(projects).to include users_private_poject
        end
      end
    end

    context 'when logged in as admin' do
      let!(:admin) { FactoryGirl.create :admin }

      context 'admin has no projects' do
        before do
          sign_in admin
          get :index
        end

        it 'is successful' do
          expect(response).to be_success
        end

        it "@projects admin readable projects" do
          projects = Project.readable_by admin
          expect(projects.count).to eq 7
          expect(assigns :projects).to eq projects
        end

        it "admin sees private projects" do
          expect(assigns :projects).to include *Project.private_view
        end

        it "admin sees ALL projects" do
          expect(assigns :projects).to eq Project.all
        end
      end

      context 'admin has their own projects' do
        let!(:users_private_poject) { FactoryGirl.create :project_private, creator: admin }

        before do
          FactoryGirl.create :project, creator: admin
          sign_in admin
          get :index
        end

        it 'is successful' do
          expect(response).to be_success
        end

        it "@projects are public AND user`s projects" do
          projects = Project.readable_by admin
          expect(projects.count).to eq 9
          expect(assigns :projects).to eq projects
          expect(projects).to include users_private_poject
          expect(projects).to include *Project.private_view
        end

        it "admin sees ALL projects" do
          expect(assigns :projects).to eq Project.all
        end
      end
    end

    context 'when logged in as superadmin' do
      let!(:superadmin) { FactoryGirl.create :superadmin }

      context 'superadmin has no projects' do
        before do
          sign_in superadmin
          get :index
        end

        it 'is successful' do
          expect(response).to be_success
        end

        it "@projects superadmin readable projects" do
          projects = Project.readable_by superadmin
          expect(projects.count).to eq 7
          expect(assigns :projects).to eq projects
        end

        it "superadmin sees private projects" do
          expect(assigns :projects).to include *Project.private_view
        end

        it "superadmin sees ALL projects" do
          expect(assigns :projects).to eq Project.all
        end
      end

      context 'superadmin has their own projects' do
        let!(:users_private_poject) { FactoryGirl.create :project_private, creator: superadmin }

        before do
          FactoryGirl.create :project, creator: superadmin
          sign_in superadmin
          get :index
        end

        it "@projects are public AND user`s projects" do
          projects = Project.readable_by superadmin
          expect(projects.count).to eq 9
          expect(assigns :projects).to eq projects
          expect(projects).to include users_private_poject
          expect(projects).to include *Project.private_view
        end

        it "superadmin sees ALL projects" do
          expect(assigns :projects).to eq Project.all
        end
      end
    end
  end

  describe "GET show" do
    let!(:public_project) { FactoryGirl.create :project_public }
    let!(:private_project) { FactoryGirl.create :project_private }

    context 'when not logged in' do
      before { sign_in_nobody }

      context 'viewing public project' do
        before { get :show, id: public_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq public_project
        end
      end

      context 'viewing private project' do
        before { get :show, id: private_project.slug }

        it 'denies access' do
          expect(response.status).to eq 403
        end
      end
    end

    context 'when logged as user' do
      let!(:user) { FactoryGirl.create :user }
      let!(:users_private_project) { FactoryGirl.create :project, creator: user }
      before { sign_in user }

      context 'viewing public project' do
        before { get :show, id: public_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq public_project
        end
      end

      context 'viewing private project' do
        before { get :show, id: private_project.slug }

        it 'denies access' do
          expect(response.status).to eq 403
        end
      end

      context 'viewing private project' do
        before { get :show, id: users_private_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq users_private_project
        end
      end
    end

    context 'when logged as admin' do
      let!(:admin) { FactoryGirl.create :admin }
      let!(:admins_private_project) { FactoryGirl.create :project, creator: admin }
      before { sign_in admin }

      context 'viewing public project' do
        before { get :show, id: public_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq public_project
        end
      end

      context 'viewing private project' do
        before { get :show, id: private_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq private_project
        end
      end

      context 'viewing private project' do
        before { get :show, id: admins_private_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq admins_private_project
        end
      end
    end

    context 'when logged as superadmin' do
      let!(:superadmin) { FactoryGirl.create :superadmin }
      let!(:superadmins_private_project) { FactoryGirl.create :project, creator: superadmin }
      before { sign_in superadmin }

      context 'viewing public project' do
        before { get :show, id: public_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq public_project
        end
      end

      context 'viewing private project' do
        before { get :show, id: private_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq private_project
        end
      end

      context 'viewing private project' do
        before { get :show, id: superadmins_private_project.slug }

        it 'is successful' do
          expect(response).to be_success
        end

        it '@project assigns public project' do
          expect(assigns :project).to eq superadmins_private_project
        end
      end
    end
  end

  describe "GET new" do
    context 'when not logged in' do
      before { sign_in_nobody }

      context 'creating project' do
        it_behaves_like 'authentication redirector', 'get', :new
      end
    end

    context 'when logged as user' do
      let!(:user) { FactoryGirl.create :user }
      before { sign_in user }

      context 'trying to create' do
        before { get :new }

        it 'is success' do
          expect(response).to be_success
        end
      end
    end

    context 'when logged as admin' do
      let!(:admin) { FactoryGirl.create :admin }
      before { sign_in admin }

      context 'trying to create' do
        before { get :new }

        it 'is success' do
          expect(response).to be_success
        end
      end
    end

    context 'when logged as superadmin' do
      let!(:superadmin) { FactoryGirl.create :superadmin }
      before { sign_in superadmin }

      context 'trying to create' do
        before { get :new }

        it 'is success' do
          expect(response).to be_success
        end
      end
    end
  end

  describe "POST create" do
    let(:valid_attributes) { FactoryGirl.build(:project).attributes }
    let(:invalid_attributes) { {name: '', game_id: '5'} }

    context "with valid attributes" do
      context 'when not logged in' do
        before { sign_in_nobody }

        context 'creating project' do
          it 'denies access' do
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
          it 'denies access' do
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
      let!(:user) { FactoryGirl.create :user }
      before { sign_in user }

      context 'trying to edit public project' do
        let(:public_project) { FactoryGirl.create :project }

        before { get :edit, id: public_project.id }

        it 'throws 403' do
          expect(response.status).to eq 403
        end
      end

      context 'trying to edit private project' do
        let(:private_project) { FactoryGirl.create :project_private }

        before { get :edit, id: private_project.id }

        it 'throws 403' do
          expect(response.status).to eq 403
        end
      end

      context 'trying to edit user`s public project' do
        let(:users_project) { FactoryGirl.create :project, creator: user }

        before { get :edit, id: users_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end

      context 'trying to edit user`s public project' do
        let(:users_project) { FactoryGirl.create :project_private, creator: user }

        before { get :edit, id: users_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'when logged as admin' do
      let!(:admin) { FactoryGirl.create :admin }
      before { sign_in admin }

      context 'trying to edit public project' do
        let(:public_project) { FactoryGirl.create :project }

        before { get :edit, id: public_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end

      context 'trying to edit private project' do
        let(:private_project) { FactoryGirl.create :project_private }

        before { get :edit, id: private_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end

      context 'trying to edit admin`s public project' do
        let(:users_project) { FactoryGirl.create :project, creator: admin }

        before { get :edit, id: users_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end

      context 'trying to edit admin`s public project' do
        let(:users_project) { FactoryGirl.create :project_private, creator: admin }

        before { get :edit, id: users_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'when logged as superadmin' do
      let!(:superadmin) { FactoryGirl.create :superadmin }
      before { sign_in superadmin }

      context 'trying to edit public project' do
        let(:public_project) { FactoryGirl.create :project }

        before { get :edit, id: public_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end

      context 'trying to edit private project' do
        let(:private_project) { FactoryGirl.create :project_private }

        before { get :edit, id: private_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end

      context 'trying to edit superadmin`s public project' do
        let(:users_project) { FactoryGirl.create :project, creator: superadmin }

        before { get :edit, id: users_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end

      context 'trying to edit superadmin`s public project' do
        let(:users_project) { FactoryGirl.create :project_private, creator: superadmin }

        before { get :edit, id: users_project.id }

        it 'is successful' do
          expect(response).to be_success
        end

        it 'renders :edit' do
          expect(response).to render_template :edit
        end
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
        shared_context 'authentication redirector' do
          it 'throws uncaught :warden' do
            expect{ post :update, id: project.id, project: valid_attributes }.to raise_exception("uncaught throw :warden")
          end
        end

        before { sign_in_nobody }

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
        let!(:user) { FactoryGirl.create :user }
        before { sign_in user }

        context 'trying to update public project' do
          let(:public_project) { FactoryGirl.create :project }

          before { post :update, id: public_project.id, project: valid_attributes }

          it_behaves_like 'unauthorized'
        end

        context 'trying to edit private project' do
          let(:private_project) { FactoryGirl.create :project_private }

          before { post :update, id: private_project.id, project: valid_attributes }

          it_behaves_like 'unauthorized'
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
        let!(:admin) { FactoryGirl.create :admin }
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
        let!(:superadmin) { FactoryGirl.create :superadmin }
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
        let!(:user) { FactoryGirl.create :user }
        before { sign_in user }

        context 'trying to update public project' do
          let(:project) { FactoryGirl.create :project }

          before { post :update, id: project.id, project: invalid_attributes }

          it 'throws 403' do
            expect(response.status).to eq 403
          end
        end

        context 'trying to edit private project' do
          let(:private_project) { FactoryGirl.create :project_private }

          before { post :update, id: private_project.id, project: invalid_attributes }

          it 'throws 403' do
            expect(response.status).to eq 403
          end
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
        let!(:admin) { FactoryGirl.create :admin }
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
        let!(:superadmin) { FactoryGirl.create :superadmin }
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

end

=begin
  describe "DELETE destroy" do
    it "destroys the requested project" do
      project = Project.create! valid_attributes
      expect {
        delete :destroy, :id => project.id
      }.to change(Project, :count).by(-1)
    end

    it "redirects to the projects list" do
      project = Project.create! valid_attributes
      delete :destroy, :id => project.id
      response.should redirect_to(projects_url)
    end
  end
=end