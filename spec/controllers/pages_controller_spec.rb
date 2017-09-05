require 'rails_helper'

describe PagesController do
  describe 'GET index' do
    context 'when logged in' do
      it 'redirects to dashboard' do
        sign_in create(:user)
        get :index
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when logged out' do
      it 'renders' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template('pages/index')
      end
    end
  end
end
