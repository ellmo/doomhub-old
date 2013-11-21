require 'spec_helper'

describe MapsController do

  describe "GET show" do
    shared_context 'map #show' do
      before do
        sign_in user
        get :show, project_id: project.slug, id: map.id
      end
      it 'is successful' do
        expect(response).to be_success
      end
      it "@map is assigned properly" do
        expect(assigns :map).to eq map
        expect(assigns :project).to eq project
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        get :show, project_id: project.slug, id: map.id
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
        it_behaves_like 'map #show'
      end

      context 'when logged in as user' do
        let(:user) { FactoryGirl.create :user }
        it_behaves_like 'map #show'
      end

      context 'when logged in as admin' do
        let(:user) { FactoryGirl.create :admin }
        it_behaves_like 'map #show'
      end

      context 'when logged in as superadmin' do
        let(:user) { FactoryGirl.create :superadmin }
        it_behaves_like 'map #show'
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
        it_behaves_like 'map #show'
      end

      context 'when logged in as superadmin' do
        let(:user) { FactoryGirl.create :superadmin }
        it_behaves_like 'map #show'
      end
    end

    context 'owned private project' do
      let(:user) { FactoryGirl.create :user }
      let(:project) { FactoryGirl.create :project_private, creator: user }
      let(:map) { FactoryGirl.create :map, project: project, authorable: project.creator }

      context 'when logged in as user' do
        it_behaves_like 'map #show'
      end
    end
  end

  describe "GET new" do
    shared_context 'map #new' do
      before do
        sign_in user
        get :new, project_id: project.slug
      end
      it 'is successful' do
        expect(response).to be_success
      end
      it "@project is assigned properly" do
        expect(assigns :project).to eq project
      end
      it 'renders :new template' do
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

    context 'public join project' do
      let(:project) { FactoryGirl.create :project_public }

      context 'when not logged in' do
        before { sign_in_nobody }
        it 'throws a hissy fit' do
          expect{ get :new, project_id: project.slug }.to raise_exception("uncaught throw :warden")
        end
      end

      context 'when logged in as user' do
        let(:user) { FactoryGirl.create :user }
        it_behaves_like 'map #new'
      end

      context 'when logged in as admin' do
        let(:user) { FactoryGirl.create :admin }
        it_behaves_like 'map #new'
      end

      context 'when logged in as superadmin' do
        let(:user) { FactoryGirl.create :superadmin }
        it_behaves_like 'map #new'
      end
    end

    context 'private join project' do
      let(:project) { FactoryGirl.create :project_private }

      context 'when not logged in' do
        before { sign_in_nobody }
        it 'throws a hissy fit' do
          expect{ get :new, project_id: project.slug }.to raise_exception("uncaught throw :warden")
        end
      end

      context 'when logged in as user' do
        let(:user) { FactoryGirl.create :user }
        it_behaves_like 'access denial'
      end

      context 'when logged in as admin' do
        let(:user) { FactoryGirl.create :admin }
        it_behaves_like 'map #new'
      end

      context 'when logged in as superadmin' do
        let(:user) { FactoryGirl.create :superadmin }
        it_behaves_like 'map #new'
      end
    end

    context 'owned private join project' do
      let(:user) { FactoryGirl.create :user }
      let(:project) { FactoryGirl.create :project_private, creator: user }

      context 'when logged in as user' do
        it_behaves_like 'map #new'
      end
    end
  end

  describe "POST create" do
    shared_context 'map #create' do
      before do
        sign_in user
        post :create, project_id: project.slug, map: attributes
      end
      let(:map) { Map.last }
      it "@map is assigned properly" do
        expect(assigns :map).to eq map
      end
      it 'creates map' do
        expect(project.maps.count).to eq 1
      end
      it '@map gets proper attributes' do
        expect(assigns(:map).name).to eq attributes[:name]
      end
      it 'redirects to map`s show' do
        expect(response).to redirect_to project_map_path(project, map.reload)
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        post :create, project_id: project.slug, map: attributes
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    context 'valid attributes' do
      let(:attributes) { { name: 'a new great map'} }

      context 'public join project' do
        let(:project) { FactoryGirl.create :project_public }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ post :create, project_id: project.slug, map: attributes }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'map #create'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map #create'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map #create'
        end
      end

      context 'private join project' do
        let(:project) { FactoryGirl.create :project_private }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ post :create, project_id: project.slug, map: attributes }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map #create'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map #create'
        end
      end

      context 'private owned project' do
        let(:user) { FactoryGirl.create :user }
        let(:project) { FactoryGirl.create :project_private, creator: user }

        context 'when logged in as user' do
          it_behaves_like 'map #create'
        end
      end
    end
  end

  describe "GET edit" do
    shared_context 'map #edit' do
      before do
        sign_in user
        get :edit, project_id: project.slug, id: map.id
      end
      it 'is successful' do
        expect(response).to be_success
      end
      it "@project is assigned properly" do
        expect(assigns :project).to eq project
      end
      it "@map is assigned properly" do
        expect(assigns :map).to eq map
      end
      it 'renders :new template' do
        expect(response).to render_template :edit
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        get :edit, project_id: project.slug, id: map.id
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    context 'public join project' do
      let(:project) { FactoryGirl.create :project_public }
      let(:map) { FactoryGirl.create :map, project: project, authorable: project.creator }

      context 'when not logged in' do
        before { sign_in_nobody }
        it 'throws a hissy fit' do
          expect{ get :edit, project_id: project.slug, id: map.id }.to raise_exception("uncaught throw :warden")
        end
      end

      context 'when logged in as user' do
        let(:user) { FactoryGirl.create :user }

        context 'not owned map' do
          let(:map) { FactoryGirl.create :map, project: project }
          it_behaves_like 'access denial'
        end

        context 'owned map' do
          let(:map) { FactoryGirl.create :map, project: project, authorable: user }
          it_behaves_like 'map #edit'
        end
      end

      context 'when logged in as admin' do
        let(:user) { FactoryGirl.create :admin }
        it_behaves_like 'map #edit'
      end

      context 'when logged in as superadmin' do
        let(:user) { FactoryGirl.create :superadmin }
        it_behaves_like 'map #edit'
      end
    end

    context 'private join project' do
      let(:project) { FactoryGirl.create :project_private }
      let(:map) { FactoryGirl.create :map, project: project, authorable: project.creator }

      context 'when not logged in' do
        before { sign_in_nobody }
        it 'throws a hissy fit' do
          expect{ get :edit, project_id: project.slug, id: map.id }.to raise_exception("uncaught throw :warden")
        end
      end

      context 'when logged in as user' do
        let(:user) { FactoryGirl.create :user }
        it_behaves_like 'access denial'
      end

      context 'when logged in as admin' do
        let(:user) { FactoryGirl.create :admin }
        it_behaves_like 'map #edit'
      end

      context 'when logged in as superadmin' do
        let(:user) { FactoryGirl.create :superadmin }
        it_behaves_like 'map #edit'
      end
    end

    context 'owned private join project' do
      let(:user) { FactoryGirl.create :user }
      let(:project) { FactoryGirl.create :project_private, creator: user }
      let(:map) { FactoryGirl.create :map, project: project, authorable: user }
      it_behaves_like 'map #edit'
    end
  end

  describe "POST update" do
    shared_context 'map #update' do
      before do
        sign_in user
        post :update, project_id: project.slug, id: map.id, map: attributes
      end
      it "@map is assigned properly" do
        expect(assigns :map).to eq map.reload
      end
      it 'updates map' do
        expect(assigns(:map).updated_at).not_to be nil
      end
      it '@map gets proper attributes' do
        expect(assigns(:map).name).to eq attributes[:name]
      end
      it 'redirects to map`s show' do
        expect(response).to redirect_to project_map_path(project, map.reload)
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        post :update, project_id: project.slug, id: map.id, map: attributes
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    context 'valid attributes' do
      let(:attributes) { {name: 'updated_map'} }

      context 'public join project' do
        let(:project) { FactoryGirl.create :project_public }
        let(:map) { FactoryGirl.create :map, project: project }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ post :update, project_id: project.slug, id: map.id, map: attributes }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          context 'not owned map' do
            let(:map) { FactoryGirl.create :map, project: project }
            it_behaves_like 'access denial'
          end
          context 'owned map' do
            let(:map) { FactoryGirl.create :map, project: project, authorable: user }
            it_behaves_like 'map #update'
          end
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map #update'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map #update'
        end
      end

      context 'private join project' do
        let(:project) { FactoryGirl.create :project_private }
        let(:map) { FactoryGirl.create :map, project: project, authorable: project.creator }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ post :update, project_id: project.slug, id: map.id, map: attributes }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map #update'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map #update'
        end
      end

      context 'private owned project' do
        let(:user) { FactoryGirl.create :user }
        let(:project) { FactoryGirl.create :project_private, creator: user }
        let(:map) { FactoryGirl.create :map, project: project, authorable: user }

        context 'when logged in as user' do
          context 'owned map' do
            it_behaves_like 'map #update'
          end
        end
      end
    end
  end

end