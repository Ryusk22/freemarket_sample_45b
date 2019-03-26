require 'rails_helper'

describe ProductsController, type: :controller do
  let(:user) {create(:user)}
  let(:product) {create(:product, seller_id: user.id)}

  describe 'GET #new' do
    it "has a 200 status code" do
      get :new
      expect(response).to render_template :new
      expect(response).to have_http_status(:ok)
    end
  end


  describe 'GET #show' do
    it "has a 200 status code" do
      get :show, params: { id: product.id }
      expect(response).to render_template :show
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Product" do
        params = { images_attributes: [ attributes_for( :image ) ] }
        expect {
          post :create,
          product: build( :product ).merge( params )
          }.to change( Product, :count ).by( 1 ).and change( Image, :count ).by( 1 )
      end
    end
  end

  describe '#destroy' do
    context 'destroy from product table' do
      before do
        login_user user
      end
      it 'delete from product table' do
        product = create(:product, :image, seller_id: user.id)
        expect{
          delete :destroy, params: {id: product.id}
        }.to change(Product, :count).by(-1)
      end
      it 'redirect after destroy' do
        product = create(:product, :image, seller_id: user.id)
        delete :destroy, params: {id: product.id}
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
