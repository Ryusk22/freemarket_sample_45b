class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :Set_api_for_payjp, only: :create
  before_action :payment_check, only: :new

  def new
    @payment = Payment.new
  end

  def create
    customer = Payjp::Customer.create(card: params[:payjpToken])
    @payment = Payment.new(user_id: current_user.id, customer_id: customer.id, card_token: params[:payjpToken])
    if @payment.save
      redirect_to root_path, notice: '会員登録は全て完了しました'
    else
      redirect_to new_payment_path
    end
  end

  private
  def payment_check
    redirect_to root_path unless Payment.where(user_id: current_user.id).blank?
  end

end
