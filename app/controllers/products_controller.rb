class ProductsController < ApplicationController
  before_action :set_form_data, only: [:new, :edit]
  before_action :Set_api_for_payjp, only: :buy

  def index
    @ladies = Category.find_by(name: "レディース")
    @ladies_products = search_product(@ladies)
    @mens = Category.find_by(name: "メンズ")
    @mens_products = search_product(@mens)
    @baby = Category.find_by(name: "ベビー・キッズ")
    @baby_products = search_product(@baby)
    @beauty = Category.find_by(name: "コスメ・香水・美容")
    @beauty_products = search_product(@beauty)
  end

  def show
    @product = Product.find(params[:id])
    @user = User.find(@product.seller_id)
    @comment = Comment.new
    @category = @product.category
    if @category.depth == 2
      @parent_category = @category.root.name
      @child_category = @category.parent.name
      @grandchild_category = @category.name
    elsif @category.depth == 1
      @parent_category = @category.root.name
      @child_category = @category.name
      @grandchild_category = "none"
    end
  end


  def new
    @product = Product.new
    1.times { @product.images.build }
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      redirect_to new_product_path, flash: {miss: "必須項目をすべて選択してください"}
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy if product.seller_id == current_user.id
    redirect_to root_path, notice: '商品を削除しました'
  end

  def edit
    @product = Product.find_by(id: params[:id])
    @seller = ShippingMethod.seller
    @buyer = ShippingMethod.buyer
    @category = @product.category
    @child_categories = Category.where('ancestry = ?', "#{@category.root_id}")
    @grandchild_categories = Category.where('ancestry LIKE ?', "%/#{@category.parent_id}")
  end

  def update
    product = Product.find(params[:id])
    product.update(update_product_params) if product.seller_id == current_user.id
    redirect_to product_path(params[:id])
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
    if params[:postage] == "送料込み(出品者負担)"
      @seller = ShippingMethod.seller
    else
      @buyer = ShippingMethod.buyer
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def buy
    # 顧客カードデータ取得
    customer = Payment.find_by(user_id: current_user.id)
    customer_id = Payjp::Customer.retrieve(customer.customer_id)
    @customer = customer_id.cards.data[0]
    @product = Product.find(params[:id])
  end

  def search
    @product = Product.where('name LIKE ?', "%#{params[:keyword]}%").limit(49)
  end

  private
  def product_params
    params.require(:product).permit(:name, :detail, :category_id, :condition, :postage_id, :shipping_method_id, :prefecture_id, :date, :price, images_attributes: [:image_path]).merge(seller_id: current_user.id);
  end

  def update_product_params
    params.require(:product).permit(:name, :detail, :category_id, :condition, :postage_id, :shipping_method_id, :prefecture_id, :date, :price, images_attributes: [:image_path, :_destroy, :id]).merge(seller_id: current_user.id);
  end

  def set_form_data
    @postage = Postage.all
    @prefecture = Prefecture.all
    @category_root = Category.find(1).siblings
  end

  def search_product(category)
    return Product.where(category_id: category.subtree_ids).limit(4).order("created_at DESC")
  end

end
