class ProductsController < ApplicationController

  def index
  end


  def show
  end


  def new
    @postage = Postage.all
    @prefecture = Prefecture.all
    @category_root = Category.find(1).siblings
    @product = Product.new
    1.times { @product.images.build }
  end

  def create
    @product = Product.new(product_params)
    binding.pry
    if @product.save
      redirect_to root_path
    else
      redirect_to new_product_path, flash: {miss: "必須項目をすべて選択してください"}
    end
  end

  def category
    if params[:parent]
      @child_categories = Category.where('ancestry = ?', "#{params[:parent]}")
    else
      @grandchild_categories = Category.where('ancestry LIKE ?', "%/#{params[:child]}")
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def postage
    if params[:postage] == "1"
      @seller = ShippingMethod.seller
    else
      @buyer = ShippingMethod.buyer
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :detail, :category_id, :condition, :postage_id, :shipping_method_id, :prefecture_id, :date, :price, images_attributes: {image: []}).merge(seller_id: current_user.id);
  end

end
