class PagesController < ApplicationController
  layout 'pages'
  skip_before_action :set_organization

  def index
    if user_signed_in?
      redirect_to terminals_path
    end
  end

end
