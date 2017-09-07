class WorkersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_worker, only: [:profile, :account, :settings, :destroy]

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
  end

  def account
  end

  def settings
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
