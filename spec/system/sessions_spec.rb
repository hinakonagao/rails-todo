require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  include SessionsHelper

  describe 'ログイン処理' do
    it 'ログインに成功する' do
      user = FactoryBot.create(:user)
      visit login_path
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      click_button 'Log in'
      expect(current_path).to eq root_path
    end

    it 'ログインに失敗する' do
      visit login_path
      fill_in 'session[email]', with: ''
      fill_in 'session[password]', with: ''
      click_button 'Log in'
      expect(current_path).to eq login_path
    end
  end

  describe 'ログアウト処理' do
    it 'ログアウトに成功する' do
      user = FactoryBot.create(:user)
      login(user)
      visit tasks_path
      click_link 'ログアウト'
      expect(current_path).to eq login_path
    end
  end
end
