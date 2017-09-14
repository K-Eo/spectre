module Api
  module V1
    class AlertsController < ApiController

      def index
        render json: '', status: :ok
      end

      def create
        @alert = AlertForm.new(current_user)

        if @alert.update(params)
          render json: '', status: :created
        else
          head :unprocessable_entity
        end
      end

    end
  end
end
