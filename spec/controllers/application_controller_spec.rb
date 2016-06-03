require "rails_helper"

describe ApplicationController do
  describe '#current_user' do
    context 'ユーザがログインしていない時' do
      it 'nil が返ること' do
        expect(subject.current_user).to be_nil
      end
    end

    context 'ユーザがログインしている時' do
      before do
        user = create(:user)
        session[:user_id] = user.id
      end
      it 'ログインユーザのインスタンスが返る' do
        expect(subject.current_user.id).to eq(session[:user_id])
      end
    end
  end
end