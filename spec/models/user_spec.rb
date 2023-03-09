require 'rails_helper'

RSpec.describe User, type: :model do
  it '名前、メール、パスワードがある場合、有効である' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it '名前がない場合、無効である' do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
  end

  it '名前が50文字を超える場合、無効である' do
    user = FactoryBot.build(:user, name: 'a' * 51)
    user.valid?
  end

  it 'メールアドレスがない場合、無効である' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
  end

  it 'メールアドレスが255文字を超える場合、無効である' do
    user = FactoryBot.build(:user, email: 'a' * 244 + '@example.com')
    user.valid?
  end

  it '重複したメールアドレスの場合、無効である' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.build(:user)
    user2.valid?
  end

  it 'パスワードがない場合、無効である' do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
  end

  it 'パスワードが4文字未満の場合、無効である' do
    user = FactoryBot.build(:user, password: 'a' * 3)
    user.valid?
  end
end
