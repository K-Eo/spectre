class Api::V1::LocationsController < Api::V1::ApiControllerBase

  def show
  end

  def update
    @location_form = LocationForm.new(current_user)

    if @location_form.update(permitted_attributes(Location))
      render status: :ok
    else
      head :unprocessable_entity
    end
  end
end
