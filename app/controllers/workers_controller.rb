class WorkersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_worker, only: [:profile, :show, :profile, :geo, :account, :settings, :destroy]

  def index
    @workers = User.workers(current_user).page(params[:page])
  end

  def new
    @worker_form = WorkerForm.new
  end

  def create
    if params[:worker].blank?
      @worker_form = WorkerForm.new
      flash.now[:alert] = 'Email required'
      render 'new', status: :bad_request
      return
    end

    @worker_form = WorkerForm.new

    if @worker_form.submit(params)
      flash[:success] = "Email sent to <strong>#{@worker_form.email}</strong>."
      redirect_to worker_path(@worker_form.worker)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @profile = ProfileForm.new(@worker)
    @geo = GeoForm.new(@worker)
  end

  def profile
    @profile = ProfileForm.new(@worker)

    respond_to do |format|
      if @profile.update(params)
        format.js
      else
        format.js
      end
    end
  end

  def geo
    @geo = GeoForm.new(@worker)

    respond_to do |format|
      if @geo.update(params)
        format.js
      else
        format.js
      end
    end
  end

  def account
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
