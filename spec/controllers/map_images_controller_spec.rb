require 'spec_helper'

describe MapImagesController do

  describe "GET new" do
    shared_context 'map_image #new' do
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

    context 'public view project' do
      let(:project) { FactoryGirl.create :project }
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
        it_behaves_like 'map_image #new'
      end

      context 'when logged in as superadmin' do
        let(:user) { FactoryGirl.create :superadmin }
        it_behaves_like 'map_image #new'
      end
    end

    # context 'private project' do
    #   let(:project) { FactoryGirl.create :project_private }
    #   let(:map) { FactoryGirl.create :map, project: project }

    #   context 'when not logged in' do
    #     let(:user) { User.new }
    #     it_behaves_like 'access denial'
    #   end

    #   context 'when logged in as user' do
    #     let(:user) { FactoryGirl.create :user }
    #     it_behaves_like 'access denial'
    #   end

    #   context 'when logged in as admin' do
    #     let(:user) { FactoryGirl.create :admin }
    #     it_behaves_like 'map #show'
    #   end

    #   context 'when logged in as superadmin' do
    #     let(:user) { FactoryGirl.create :superadmin }
    #     it_behaves_like 'map #show'
    #   end
    # end

    # context 'owned private project' do
    #   let(:user) { FactoryGirl.create :user }
    #   let(:project) { FactoryGirl.create :project_private, creator: user }
    #   let(:map) { FactoryGirl.create :map, project: project }

    #   context 'when logged in as user' do
    #     it_behaves_like 'map #show'
    #   end
    # end
  end

end