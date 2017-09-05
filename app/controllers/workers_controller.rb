class WorkersController < ApplicationController
  before_action :authenticate_user!

  def index
    @worker_form = WorkerForm.new
    @workers = User.all
  end

  def create
    @workers = User.all

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

private

  def worker_params
    params.require(:worker).permit(:email)
  end

end
