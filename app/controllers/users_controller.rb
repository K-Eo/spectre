class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:account, :destroy, :geo, :profile, :settings, :show]

  def index
    authorize User
    @users = policy_scope(User).page(params[:page])
  end

  def new
    authorize User
    @user_form = UserForm.new
  end

  def create
    @user_form = UserForm.new(User.new(company_id: current_company.id))

    authorize @user_form

    if @user_form.submit(permitted_attributes(User))
      flash[:success] = "Email sent to <strong>#{@user_form.email}</strong>."
      redirect_to user_path(@user_form.user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    authorize @user, :show?
    @profile = ProfileForm.new(@user)
    @geo = GeoForm.new(@user)
  end

  def profile
    authorize @user
    @profile = ProfileForm.new(@user)

    respond_to do |format|
      if @profile.update(permitted_attributes(@user))
        format.js
      else
        format.js
      end
    end
  end

  def geo
    authorize @user
    @geo = GeoForm.new(@user)

    respond_to do |format|
      if @geo.update(params)
        format.js
      else
        format.js { render(status: :bad_request) }
      end
    end
  end

  def account
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path
  end

private

  def set_user
    @user = policy_scope(User).find(params[:id])
  end

end
