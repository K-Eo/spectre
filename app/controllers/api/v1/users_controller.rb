module Api
  module V1
    class UsersController < ApiController
      before_action :authenticate

      def show
      end

    end
  end
end
