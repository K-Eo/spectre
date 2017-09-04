require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do

  describe 'GET show' do
    context 'when logged in' do
      it 'renders show template' do
        sign_in create(:user)
        get :show
        expect(response).to have_http_status(:success)
        expect(response).to render_template('dashboards/show')
      end
    end

    context 'when logged out' do
      it 'redirects to login' do
        get :show
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
