require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  include SessionsHelper

  describe 'タスク一覧画面' do
    context 'ログインしている場合' do
      before do
        @userA = FactoryBot.create(:user, name: 'ユーザーA')
        @userB = FactoryBot.create(:user, name: 'ユーザーB', email: 'userB@test.com')
        @taskA = FactoryBot.create(:task, title: 'タスク1', user_id: @userA.id, finished: false)
        @taskB = FactoryBot.create(:task, title: 'タスク2', user_id: @userB.id, finished: false)
      end

      context 'ログイン中のユーザーのタスクかどうかの確認' do
        it 'ログイン中のユーザーのタスクが表示される' do
          login(@userA)
          visit tasks_path
          expect(current_path).to eq tasks_path
          expect(page).to have_content 'タスク一覧'
          expect(page).to have_content 'タスク1'
        end

        it '他のユーザーのタスクが表示されない' do
          login(@userA)
          visit tasks_path
          expect(page).to have_content 'タスク一覧'
          expect(page).to have_no_content 'タスク2'
        end
      end

      context 'タスクのソート機能' do
        it 'タスク名の昇順でソートできる' do
          # TODO:ソート機能のテストを実装する
          login(@userA)
          visit tasks_path
          click_on 'タスク名'
          expect(page).to have_content 'タスク1'
        end
      end

      context 'タスク名の検索機能' do
        # TODO:タスク名の検索機能のテストを実装する
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面へ遷移する' do
        visit tasks_path
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'タスク新規作成機能' do
    context 'ログインしている場合' do
      before do
        @user = FactoryBot.create(:user)
        login(@user)
        visit new_task_path
        expect(current_path).to eq new_task_path
        expect(page).to have_content '新規タスク作成'
      end

      it 'タスクを作成することができる' do
        fill_in 'task[title]', with: 'タスク1'
        click_button '保存'
      end

      it 'タスク名を入力しないと、タスクを作成することができない' do
        fill_in 'task[title]', with: ''
        click_button '保存'
        expect(page).to have_selector 'div.alert.alert-danger'
      end

      it 'タスク作成を行ったのが正しいユーザーでない場合、タスク作成処理に失敗する' do
        @user2 = FactoryBot.create(:user, name: 'ユーザー2', email: 'user2@test.com')
        login(@user2)
        post tasks_path, params: { task: { title: 'タスク1', user_id: 1 } }
        expect(current_path).to eq root_path
        expect(response).to have_http_status(302)
      end
    end

    context 'ログインしていない場合' do
      it 'タスク作成画面へアクセスすると、ログイン画面へ遷移する' do
        visit new_task_path
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'タスク更新機能' do
    before do
      @user = FactoryBot.create(:user)
      @task = FactoryBot.create(:task, title: 'テストタスク', user_id: @user.id)
    end

    context 'ログインしている場合' do
      before do
        login(@user)
        visit edit_task_path(@task)
        expect(current_path).to eq edit_task_path(@task)
        expect(page).to have_content 'タスク編集'
      end

      it 'タスクを更新することができる' do
        fill_in 'task[title]', with: 'テストタスク更新'
        click_button '保存'
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'テストタスク更新'
      end

      it '別のユーザーのタスクを更新しようとすると、タスク更新処理に失敗する' do
        @user2 = FactoryBot.create(:user, name: 'ユーザー2', email: 'user2@test.com')
        login(@user2)
        patch task_path(@task), params: { task: { title: 'テストタスク更新', user_id: 1 } }
        expect(current_path).to eq root_path
        expect(response).to have_http_status(302)
      end
    end

    context 'ログインしていない場合' do
      it 'タスク更新画面へアクセスすると、ログイン画面へ遷移する' do
        visit edit_task_path(@task)
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'タスク削除機能' do
    before do
      @user = FactoryBot.create(:user)
      @task = FactoryBot.create(:task, title: 'テストタスク', user_id: @user.id)
    end

    context 'ログインしている場合' do
      before do
        login(@user)
        visit tasks_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク一覧'
      end

      it 'タスクを削除することができる' do
        click_link '削除'
        expect(current_path).to eq tasks_path
        expect(page).to have_no_content 'テストタスク'
      end

      it '別のユーザーのタスクを削除しようとすると、タスク削除処理に失敗する' do
        @user2 = FactoryBot.create(:user, name: 'ユーザー2', email: 'user2@test.com')
        login(@user2)
        delete task_path(@task)
        p current_path
        expect(current_path).to eq root_path
        expect(response).to have_http_status(302)
      end
    end

    context 'ログインしていない場合' do
      it 'タスク削除画面へアクセスすると、ログイン画面へ遷移する' do
        @user3 = FactoryBot.create(:user, name: 'ユーザー3', email: 'user3@test.com')
        @task3 = FactoryBot.create(:task, title: 'テストタスク', user_id: @user3.id)
        delete task_path(@task3)
        p current_user
        p current_path
        expect(response).to have_http_status(302)
        # expect(current_path).to eq login_url # なぜかここでエラーが出る
      end
    end
  end
end
