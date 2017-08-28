require 'rails_helper'

describe PagesController do
  describe 'GET index' do
    it 'shows welcome page' do
      get :index

      expect(response).to have_http_status(200)
      expect(response).to render_template('pages/index')
    end
  end
end
