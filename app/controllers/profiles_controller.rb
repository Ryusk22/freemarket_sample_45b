class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :profile_check, only: :new

  def new
    @profiles = Profile.new
  end

  def create
    @profiles = Profile.new(profile_params)
      if @profiles.save
        redirect_to new_payment_path, notice: '連絡先情報を登録しました'
      else
        flash.now[:alert] = '未入力項目があります'
        render :new
    end
  end

  private
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :first_name_kana, :last_name_kana, :birthdate, :zip_code, :prefecture, :city, :address1, :address2, :phone_number, ).merge(user_id: current_user.id)
  end

  def profile_check
    redirect_to root_path unless Profile.where(user_id: current_user.id).blank?
  end

end
