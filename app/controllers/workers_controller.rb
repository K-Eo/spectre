class WorkersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_worker, only: [:profile, :update_profile, :update_geo, :account, :settings, :destroy]

  def index
    @workers = User.workers(current_user).page(params[:page])
  end

  def new
    @worker_form = WorkerForm.new
  end

  def create
    @workers = User.workers(current_user).page(params[:page])

    if params[:worker].blank?
      @worker_form = WorkerForm.new
      flash.now[:alert] = 'Email required'
      render 'index', status: :bad_request
      return
    end

    @worker_form = WorkerForm.new

    if @worker_form.submit(params)
      flash.now[:success] = "Email sent to <strong>#{@worker_form.email}</strong>."
      @worker_form = WorkerForm.new
      @workers.reload
      render 'index', status: :created
    else
      render 'index', status: :unprocessable_entity
    end
  end

  def profile
    @profile = ProfileForm.new(@worker)
  end

  def update_profile
    @profile = ProfileForm.new(@worker)
    if @profile.update(params)
      flash.now[:success] = 'Perfil actualizado correctamente.'
      render 'profile'
    else
      flash.now[:alert] = 'No se ha podido actualizar el perfil. Intente nuevamente.'
      render 'profile'
    end
  end

  def update_geo
    @geo_form = GeoForm.new(@worker)

    if @geo_form.update(params)
      flash.now[:success] = 'Perfil actualizado correctamente.'
    else
      flash.now[:alert] = 'No se ha podido actualizar el perfil. Intente nuevamente.'
    end

    render 'settings'
  end

  def account
  end

  def settings
    @geo_form = GeoForm.new(@worker)
  end

  def destroy
    @worker.destroy
    redirect_to workers_path
  end

private

  def worker_params
    params.require(:worker).permit(:email)
  end

  def set_worker
    @worker = User.find(params[:id])
  end

end
