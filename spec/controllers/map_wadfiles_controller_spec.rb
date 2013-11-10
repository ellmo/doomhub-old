require 'spec_helper'

describe MapWadfilesController do

  def file_attachment(fixture_file='wadfile.zip', mime='application/zip')
    file_path = "#{Rails.root}/spec/fixtures/#{fixture_file}"
    Rack::Test::UploadedFile.new(file_path, mime)
  end

  describe "GET new" do
    shared_context 'map_wadfile #new' do
      before do
        sign_in user
        get :new, project_id: project.slug, map_id: map.slug
      end
      it 'is successful' do
        expect(response).to be_success
      end
      it "@map_image is assigned properly" do
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

    context 'public join project' do
      let(:project) { FactoryGirl.create :project_public }

      context 'not owned map' do
        let(:map) { FactoryGirl.create :map, project: project }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ get :new, project_id: project.slug, map_id: map.slug }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #new'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #new'
        end
      end

      context 'owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: user }

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'map_wadfile #new'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #new'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #new'
        end
      end
    end

    context 'private join project' do
      let(:project) { FactoryGirl.create :project_public }

      context 'not owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: project.creator }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ get :new, project_id: project.slug, map_id: map.slug }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #new'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #new'
        end
      end
    end

    context 'owned private join project' do
      let(:user) { FactoryGirl.create :user }
      let(:project) { FactoryGirl.create :project_public, creator: user }
      let(:map) { FactoryGirl.create :map, project: project, author: user }

      it_behaves_like 'map_wadfile #new'
    end
  end

  describe 'POST create' do
    shared_context 'map_wadfile #create' do
      before do
        sign_in user
        post :create, project_id: project.slug, map_id: map.slug, map_wadfile: attribtues
      end
      it 'is successful' do
        expect(response).to redirect_to project_map_path(project, map)
      end
      it 'attaches the image' do
        expect(map.reload.map_wadfiles).not_to be_empty
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        post :create, project_id: project.slug, map_id: map.slug, map_wadfile: attribtues
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    let(:attribtues) { {wadfile: file_attachment} }

    context 'public join project' do
      let(:project) { FactoryGirl.create :project_public }

      context 'not owned map' do
        let(:map) { FactoryGirl.create :map, project: project }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ post :create, project_id: project.slug, map_id: map.slug, map_wadfile: attribtues }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #create'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #create'
        end
      end

      context 'owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: user }

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'map_wadfile #create'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #create'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #create'
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
            expect{ post :create, project_id: project.slug, map_id: map.slug, map_image: attribtues }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #create'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #create'
        end
      end

      context 'owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: user }

        context 'when logged in as user' do
          let(:user) { project.creator }
          it_behaves_like 'map_wadfile #create'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #create'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #create'
        end
      end
    end
  end

  describe 'POST destroy' do
    shared_context 'map_wadfile #destroy' do
      before do
        sign_in user
        post :destroy, project_id: project.slug, map_id: map.slug, id: map_wadfile.id
      end
      it 'is successful' do
        expect(response).to redirect_to project_map_path(project, map)
      end
      it 'attaches the image' do
        expect(map.reload.map_wadfiles).to be_empty
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        post :destroy, project_id: project.slug, map_id: map.slug, id: map_wadfile.id
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    let(:map_wadfile) { FactoryGirl.create :map_wadfile, map: map, author: map.author }

    context 'public join project' do
      let(:project) { FactoryGirl.create :project_public }

      context 'not owned map' do
        let(:map) { FactoryGirl.create :map, project: project }

        context 'when not logged in' do
          before { sign_in_nobody }
          it 'throws a hissy fit' do
            expect{ post :destroy, project_id: project.slug, map_id: map.slug, id: map_wadfile.id }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #destroy'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #destroy'
        end
      end

      context 'owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: user }

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'map_wadfile #destroy'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #destroy'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #destroy'
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
            expect{ post :destroy, project_id: project.slug, map_id: map.slug, id: map_wadfile.id }.to raise_exception("uncaught throw :warden")
          end
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'access denial'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #destroy'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #destroy'
        end
      end

      context 'owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: user }

        context 'when logged in as user' do
          let(:user) { project.creator }
          it_behaves_like 'map_wadfile #destroy'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #destroy'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #destroy'
        end
      end
    end
  end

  describe 'GET download' do
    shared_context 'map_wadfile #download' do
      before do
        sign_in user
        get :download, project_id: project.slug, map_id: map.slug, id: map_wadfile.id
      end
      it 'it redirects to wadfile url' do
        expect(response).to redirect_to(map_wadfile.wadfile.url)
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        get :download, project_id: project.slug, map_id: map.slug, id: map_wadfile.id
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    let(:map_wadfile) { FactoryGirl.create :map_wadfile, map: map, author: map.author }

    context 'public join project' do
      let(:project) { FactoryGirl.create :project_public }

      context 'not owned map' do
        let(:map) { FactoryGirl.create :map, project: project }

        context 'when not logged in' do
          let(:user) { User.new }
          it_behaves_like 'map_wadfile #download'
        end

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'map_wadfile #download'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #download'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #download'
        end
      end

      context 'owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: user }

        context 'when logged in as user' do
          let(:user) { FactoryGirl.create :user }
          it_behaves_like 'map_wadfile #download'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #download'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #download'
        end
      end
    end

    context 'private join project' do
      let(:project) { FactoryGirl.create :project_private }

      context 'not owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: project.creator }

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
          it_behaves_like 'map_wadfile #download'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #download'
        end
      end

      context 'owned map' do
        let(:map) { FactoryGirl.create :map, project: project, author: user }

        context 'when logged in as user' do
          let(:user) { project.creator }
          it_behaves_like 'map_wadfile #download'
        end

        context 'when logged in as admin' do
          let(:user) { FactoryGirl.create :admin }
          it_behaves_like 'map_wadfile #download'
        end

        context 'when logged in as superadmin' do
          let(:user) { FactoryGirl.create :superadmin }
          it_behaves_like 'map_wadfile #download'
        end
      end
    end
  end
end
