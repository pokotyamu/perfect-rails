require 'rails_helper'

describe EventsController do
  describe 'GET #new' do
    context '未ログインユーザがアクセスした時' do
      before { get :new }

      it 'トップページにリダイレクトすること' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインユーザがアクセスした時' do
      before do
        user = create(:user)
        session[:user_id] = user.id
        get :new
      end

      it 'ステータスコードとして200が返ること' do
        expect(response.status).to eq(200)
      end

      it '@event に、新規Event オブジェクトが格納されていること' do
        expect(assigns(:event)).to be_a_new(Event)
      end

      it 'new テンプレートをrender していること' do
        expect(response).to render_template :new
      end
    end
  end
end
