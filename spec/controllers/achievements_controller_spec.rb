require 'rails_helper'

RSpec.describe AchievementsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:achievement) { create(:achievement, user: user) }

    before { login(user) }

    before { get :index }

    it 'assigns a new achievement to @achievements' do
      expect(assigns(:achievements)).to match_array(user.achievements)
    end
  end
end
