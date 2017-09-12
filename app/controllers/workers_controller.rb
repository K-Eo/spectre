class WorkersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_worker, only: [:profile, :update_profile, :update_geo, :account, :settings, :destroy]

  def index
    @worker_form = WorkerForm.new
    @workers = User.page(params[:page])
  end

  def create
    @workers = User.page(params[:page])

    if params[:worker].blank?
      @worker_form = WorkerForm.new
      flash.now[:alert] = 'Email required'
      render 'index'
      return
    end

    @worker_form = WorkerForm.new(worker_params)

    if @worker_form.submit
      flash.now[:success] = "Email sent to <strong>#{@worker_form.email}</strong>."
      render 'index'
    else
      render 'index'
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
