class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_product

  def create
    @comment = @product.comments.new(comment_params)
    if @comment.save
      redirect_to product_path(@product)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end
  def set_product
    @product = Product.find(params[:product_id])
  end
end
