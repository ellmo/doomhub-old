require 'spec_helper'

describe NewsController do
  context 'GET index' do
    shared_context 'news #index' do
      before do
        3.times { FactoryGirl.create :news }
        sign_in user
        get :index
      end
      it 'and is successful' do
        expect(response).to be_success
      end
      it 'and @news are assigned properly' do
        expect(assigns :news).to eq News.all
        expect(assigns(:news).count).to eq 3
      end
    end

    context 'when not logged in' do
      let(:user) { User.new }
      it_behaves_like 'news #index'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :user }
      it_behaves_like 'news #index'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :admin }
      it_behaves_like 'news #index'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :superadmin }
      it_behaves_like 'news #index'
    end
  end

  context 'GET show' do
    shared_context 'news #show' do
      before do
        sign_in user
        get :show, id: news.id
      end
      it 'and is successful' do
        expect(response).to be_success
      end
      it 'and @news are assigned properly' do
        expect(assigns :news).to eq News.last
      end
    end

    let(:news) { FactoryGirl.create :news }

    context 'when not logged in' do
      let(:user) { User.new }
      it_behaves_like 'news #show'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :user }
      it_behaves_like 'news #show'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :admin }
      it_behaves_like 'news #show'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :superadmin }
      it_behaves_like 'news #show'
    end
  end

  context 'GET new' do
    shared_context 'news #new' do
      before do
        sign_in user
        get :new
      end

      it 'and is successful' do
        expect(response).to be_success
      end
      it 'and @news are assigned properly' do
        expect(response).to render_template :new
        expect(assigns(:news).new_record?).to be_true
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        get :new
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    context 'when not logged in' do
      before { sign_in_nobody }
      it 'throws a hissy fit' do
        expect{ get :new }.to raise_exception("uncaught throw :warden")
      end
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :user }
      it_behaves_like 'access denial'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :admin }
      it_behaves_like 'news #new'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :superadmin }
      it_behaves_like 'news #new'
    end
  end

  context 'GET edit' do
    shared_context 'news #edit' do
      before do
        sign_in user
        get :edit, id: news.id
      end
      it 'and is successful' do
        expect(response).to be_success
      end
      it 'and @news is assigned properly' do
        expect(assigns :news).to eq news
      end
      it 'and renders proper view' do
        expect(response).to render_template :edit
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        get :edit, id: news.id
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    let(:news) { FactoryGirl.create :news }

    context 'when not logged in' do
      before { sign_in_nobody }
      it 'throws a hissy fit' do
        expect{ get :edit, id: news.id }.to raise_exception("uncaught throw :warden")
      end
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :user }
      it_behaves_like 'access denial'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :admin }
      it_behaves_like 'news #edit'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :superadmin }
      it_behaves_like 'news #edit'
    end
  end

  context 'POST create' do
    shared_context 'news #create' do
      before do
        sign_in user
        post :create, news: attributes
      end
      it 'and is successful' do
        expect(response).to be_redirect
      end
      it 'and news are created' do
        news = News.last
        expect(news.title).to eq attributes[:title]
        expect(news.content).to eq attributes[:content]
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        post :create, news: attributes
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    let(:attributes) {{ title: 'title', content: 'content' }}

    context 'when not logged in' do
      before { sign_in_nobody }
      it 'throws a hissy fit' do
        expect{ post :create, news: attributes }.to raise_exception("uncaught throw :warden")
      end
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :user }
      it_behaves_like 'access denial'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :admin }
      it_behaves_like 'news #create'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :superadmin }
      it_behaves_like 'news #create'
    end
  end

  context 'POST update' do
    shared_context 'news #update' do
      before do
        sign_in user
        post :update, id: news.id, news: attributes
      end
      it 'and is successful' do
        expect(response).to be_redirect
      end
      it 'and news are updated' do
        expect(news.reload.title).to eq attributes[:title]
        expect(news.reload.content).to eq attributes[:content]
      end
    end

    shared_context 'access denial' do
      before do
        sign_in user
        post :update, id: news.id, news: attributes
      end
      it 'is denied' do
        expect(response.status).to eq 403
      end
    end

    let(:news) { FactoryGirl.create :news }
    let(:attributes) {{ title: 'new_title', content: 'new_content' }}

    context 'when not logged in' do
      before { sign_in_nobody }
      it 'throws a hissy fit' do
        expect{ post :update, id: news.id, news: attributes }.to raise_exception("uncaught throw :warden")
      end
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :user }
      it_behaves_like 'access denial'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :admin }
      it_behaves_like 'news #update'
    end

    context 'when logged in as user' do
      let(:user) { FactoryGirl.create :superadmin }
      it_behaves_like 'news #update'
    end
  end
end