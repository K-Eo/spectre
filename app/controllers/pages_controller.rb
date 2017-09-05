class PagesController < ApplicationController
  layout 'pages'

  def index
    if !current_user.is_a?(GuestUser)
      redirect_to dashboard_path
    end
  end

end
