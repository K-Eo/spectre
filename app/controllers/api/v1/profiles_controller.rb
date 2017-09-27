class Api::V1::ProfilesController < Api::V1::ApiControllerBase
  def show
  end

  def update
    @profile = ProfileForm.new(current_user)

    if @profile.update(permitted_attributes(Profile))
      render status: :ok
    else
      head :unprocessable_entity
    end
  end
end
