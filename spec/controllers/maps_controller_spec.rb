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
      let(:map) { FactoryGirl.create :map, project: project }

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
      let(:map) { FactoryGirl.create :map, project: project }

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
      let(:map) { FactoryGirl.create :map, project: project }

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
      it "@map is assigned properly" do
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
      let(:map) { FactoryGirl.create :map, project: project }

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
      let(:map) { FactoryGirl.create :map, project: project }

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
        expect(project.reload.maps.count).to eq 1
      end
      it '@map gets proper attributes' do
        expect(assigns(:map).name).to eq attributes['name']
      end
      it 'redirects to map`s show' do
        expect(response).to redirect_to project_map_path(project, map)
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
      let(:attributes) { FactoryGirl.build(:map).attributes.reject {|k,v| v.nil?}  }

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

end