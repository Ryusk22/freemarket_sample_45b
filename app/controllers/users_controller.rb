class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:signout]
  before_action :set_user, only: [:show, :update]


  def logout
  end

  def show

  end

  def update
    @user.update(update_user_params) if @user.id == current_user.id
    redirect_to edit_user_registration_path
  end


  def registration_select
    if user_signed_in?
    redirect_to root_path, notice: 'すでにログインしています。'
    end
  end

  private
  def update_user_params
    params.require(:user).permit(:nickname, :self_introduction)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
