module Api
  module V1
    class AlertsController < ApiController
      before_action :authenticate

      def index
        render json: '', status: :ok
      end

    end
  end
end
