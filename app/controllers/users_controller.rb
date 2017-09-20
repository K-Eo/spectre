class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_worker, only: [:profile, :show, :profile, :geo, :account, :settings, :destroy]

  def index
    @users = policy_scope(User).page(params[:page])
    @users.each { |u| authorize u, :index? }
  end

  def new
    @worker_form = UserForm.new
    authorize @worker_form
  end

  def create
    if params[:user].blank?
      @worker_form = UserForm.new
      flash.now[:alert] = 'Email required'
      render 'new', status: :bad_request
      return
    end

    @worker_form = UserForm.new(User.new(company_id: current_company.id))

    if @worker_form.submit(params)
      flash[:success] = "Email sent to <strong>#{@worker_form.email}</strong>."
      redirect_to user_path(@worker_form.user)
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
