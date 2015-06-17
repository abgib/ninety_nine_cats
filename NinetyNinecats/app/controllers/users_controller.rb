class UsersController < ApplicationController
  before_action :not_logged_in, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to cats_url
      login!(@user)
    else
      render :new
    end
  end

  def show
    render :show
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def not_logged_in
    unless current_user.nil?
      redirect_to cats_url
    end
  end
end
