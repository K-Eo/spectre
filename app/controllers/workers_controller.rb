class WorkersController < ApplicationController
  before_action :authenticate_user!

  def index
    @worker_form = WorkerForm.new
    @workers = User.all
  end

  def create
    @worker_form = WorkerForm.new
    @workers = User.all

    if params[:worker].blank?
      flash.now[:alert] = 'Email required'
      render 'index'
      return
    end

    if @worker_form.submit(params.require(:worker))
      @worker_form.email = ''
      flash.now[:success] = 'Invitation sent'
      render 'index'
    else
      render 'index'
    end
  end

end
