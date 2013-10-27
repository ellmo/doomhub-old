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
end

=begin
  describe "GET show" do
    it "assigns the requested project as @project" do
      project = Project.create! valid_attributes
      get :show, :id => project.id
      assigns(:project).should eq(project)
    end
  end

  describe "GET new" do
    it "assigns a new project as @project" do
      get :new
      assigns(:project).should be_a_new(Project)
    end
  end

  describe "GET edit" do
    it "assigns the requested project as @project" do
      project = Project.create! valid_attributes
      get :edit, :id => project.id
      assigns(:project).should eq(project)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, :project => valid_attributes
        }.to change(Project, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, :project => valid_attributes
        assigns(:project).should be_a(Project)
        assigns(:project).should be_persisted
      end

      it "redirects to the created project" do
        post :create, :project => valid_attributes
        response.should redirect_to(Project.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project as @project" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, :project => {}
        assigns(:project).should be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, :project => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested project" do
        project = Project.create! valid_attributes
        # Assuming there are no other projects in the database, this
        # specifies that the Project created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Project.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => project.id, :project => {'these' => 'params'}
      end

      it "assigns the requested project as @project" do
        project = Project.create! valid_attributes
        put :update, :id => project.id, :project => valid_attributes
        assigns(:project).should eq(project)
      end

      it "redirects to the project" do
        project = Project.create! valid_attributes
        put :update, :id => project.id, :project => valid_attributes
        response.should redirect_to(project)
      end
    end

    describe "with invalid params" do
      it "assigns the project as @project" do
        project = Project.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        put :update, :id => project.id, :project => {}
        assigns(:project).should eq(project)
      end

      it "re-renders the 'edit' template" do
        project = Project.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        put :update, :id => project.id, :project => {}
        response.should render_template("edit")
      end
    end
  end

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

end
=end