require 'rails_helper'

describe PagesController do
  describe 'GET index' do
    context 'when logged in' do
      it 'redirects to terminals' do
        sign_in create(:user, tenant: @tenant)
        get :index

        expect(response).to redirect_to(terminals_path)
      end
    end

    context 'when logged out' do
      it 'shows welcome page' do
        get :index

        expect(response).to have_http_status(200)
      end
    end
  end
end
