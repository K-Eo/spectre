class Api::V1::AlertsController < Api::V1::ApiControllerBase

  def create
    @alert = AlertForm.new(current_user)

    if @alert.update(permitted_attributes(Alert))
      render json: '', status: :created
    else
      head :unprocessable_entity
    end
  end
end
