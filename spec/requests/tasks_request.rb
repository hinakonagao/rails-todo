require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'GET /tasks' do
    include SessionsHelper
    before { @user = FactoryBot.create(:user) }
    it 'works! (now write some real specs)' do
      log_in @user
      get tasks_path
      expect(response).to be_successful
    end
  end
end
