require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  include SessionsHelper

  describe 'GET /tasks #index' do
    context 'ログインしている場合' do
      before do
        @userA = FactoryBot.create(:user, name: 'ユーザーA')
        @taskA = FactoryBot.create(:task, title: 'タスク1', user_id: @userA.id, finished: false)
      end

      it 'ログイン中のユーザーのタスクが表示される' do
        login(@userA)
        visit tasks_path
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content 'タスク1'
      end

      it '他のユーザーのタスクが表示されない' do
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面へ遷移する' do
        visit tasks_path
        expect(current_path).to eq login_path
      end
    end
  end
end
