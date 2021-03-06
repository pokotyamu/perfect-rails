require 'rails_helper'

RSpec.feature "EditEvent", type: :feature do
  describe '「編集」ボタン以外の方法でイベント編集ページにアクセスした時' do
    let(:event) { create(:future_event) }
    before do
      allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
      visit edit_event_path(id: event.id)
    end

    context 'かつ、ログインユーザがそのイベントの主催者でない時' do
      it 'トップページに遷移すること' do
        expect(page).to have_content /イベント一覧/
      end

      it '「そのイベントは存在しません」が表示されていること' do
        expect(page).to have_content /そのイベントは存在しません/
      end
    end
  end

  describe '詳細画面で、ユーザが"イベントを編集する"をクリックした時' do
    let(:user) { create(:user) }
    let(:user_event) { create(:future_event, owner_id: user.id) }

    before do
      login(user)
      visit event_path(id: user_event.id)
      click_link 'イベントを編集する'
    end

    it 'イベント編集画面に遷移すること' do
      expect(page).to have_content /イベント編集/
    end

    context 'かつ、更新ボタンを押した時に、イベントの属性に不備があった時' do
      before do
        fill_in "event_name", with: "テストイベント"
        fill_in "event_place", with: "テスト開催場所"
        fill_in "event_content", with: "テスト説明文"
        select '2017', from: 'event_start_time_1i'
        select '9月', from: 'event_start_time_2i'
        select '10', from: 'event_start_time_3i'
        select '00', from: 'event_start_time_4i'
        select '00', from: 'event_start_time_5i'
        select "#{user_event.start_time.year - 1}", from: 'event_end_time_1i'
        select '9月', from: 'event_end_time_2i'
        select '11', from: 'event_end_time_3i'
        select '00', from: 'event_end_time_4i'
        select '00', from: 'event_end_time_5i'
        click_button '更新'
      end

      it 'イベント編集画面に遷移すること' do
        expect(page).to have_content /イベント編集/
      end

      it 'エラーの内容が表示されていること' do
        expect(page).to have_content /開始時間は終了時間よりも前に設定してください/
      end
    end

    context 'かつ、作成ボタンを押した時に、不備なくイベントの属性が入力されている時' do
      before do
        fill_in "event_name", with: "テストイベント"
        fill_in "event_place", with: "テスト開催場所"
        fill_in "event_content", with: "テスト説明文"
        select '2017', from: 'event_start_time_1i'
        select '9月', from: 'event_start_time_2i'
        select '10', from: 'event_start_time_3i'
        select '00', from: 'event_start_time_4i'
        select '00', from: 'event_start_time_5i'
        select '2017', from: 'event_end_time_1i'
        select '9月', from: 'event_end_time_2i'
        select '11', from: 'event_end_time_3i'
        select '00', from: 'event_end_time_4i'
        select '00', from: 'event_end_time_5i'
        click_button '更新'
      end

      it '更新したイベントの詳細ぺージに遷移していること' do
        expect(page).to have_content /テストイベント/
      end

      it '"更新しました"というアラートが表示されること' do
        expect(page).to have_content /更新しました/
      end
    end
  end
end
