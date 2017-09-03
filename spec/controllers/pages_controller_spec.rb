require 'rails_helper'

describe PagesController do
  describe 'GET index' do
    it 'renders' do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template('pages/index')
    end
  end
end
