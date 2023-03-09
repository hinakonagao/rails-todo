require 'rails_helper'

RSpec.describe Task, type: :model do
  before { @user = FactoryBot.create(:user) }

  it 'ユーザーid、タイトル、終了フラグ、ある場合、有効である' do
    task = FactoryBot.build(:task, user_id: @user.id, finished: true)
    expect(task).to be_valid
  end

  it 'ユーザーidがない場合、無効である' do
    task = FactoryBot.build(:task)
    task.valid?
  end

  it 'タイトルがない場合、無効である' do
    task = FactoryBot.build(:task, user_id: @user.id, title: nil)
    task.valid?
  end

  it 'タイトルが50文字を超える場合、無効である' do
    task = FactoryBot.build(:task, user_id: @user.id, title: 'a' * 51)
    task.valid?
  end

  it '終了フラグがない場合、無効である' do
    task = FactoryBot.build(:task, user_id: @user.id, finished: nil)
    task.valid?
  end

  it '終了フラグがtrueでもfalseでもない場合、無効である' do
    task = FactoryBot.build(:task, user_id: @user.id, finished: 9)
    task.valid?
  end
end
