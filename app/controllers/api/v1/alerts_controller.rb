class Api::V1::AlertsController < Api::V1::ApiControllerBase

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
