class PagesController < ApplicationController
  layout 'pages'
  skip_before_action :set_company

  def index
  end

end
