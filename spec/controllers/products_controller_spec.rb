require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:category) { create(:category)}
  let(:user) { create(:user)}
  def signed_in
    request.session[:user_id] = user.id
  end

  describe '#index' do
    it 'renders products_path' do
      get :index
      expect(response).to render_template(:index)
    end
    it 'gets products list' do
      10.times {FactoryGirl.create :product}
      get :index
      expect(Product.count).to eq(10)
    end
  end

  describe '#show' do
    it 'renders the show template' do
      product = create(:product)
      get :show, params: { id: product.id }
      expect(response).to render_template(:show)
    end
    it 'sets an instance variable with the product whose id is passed' do
      product = create(:product)
      get :show, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
    end
  end

  describe '#destroy' do
    it 'redirects to products' do
      signed_in
      product = FactoryGirl.create :product
      delete :destroy, params:{id: product.id}
      expect(response).to redirect_to(products_path)
    end
    it 'removes a record from the database' do
      signed_in
      product = FactoryGirl.create :product
      count_before = Product.count
      delete :destroy, params: {id: product.id}
      count_after = Product.count
      expect(count_after).to eq(count_before - 1)
    end
  end

  describe '#new' do
    it 'renders the new template' do
      signed_in
      get :new
      expect(response).to render_template(:new)
    end

    it 'instantiates a new product object' do
      signed_in
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end
  end

  describe '#create' do
    context 'with valid params' do
      def valid_request
        signed_in
        post :create, params: { product: attributes_for(:product, category_id: category.id)}
      end
      it 'saves a record to the database' do
        count_before = Product.count
        valid_request
        count_after = Product.count
        expect(count_after).to eq(count_before + 1)
      end
      it 'redirects to the product show page' do
        valid_request
        expect(response).to redirect_to(product_path(Product.last))
      end
    end
    context 'with invalid params' do
      def invalid_request
        signed_in
        post :create, params: { product: attributes_for(:product, title: nil)}
      end
      it 'doesn\'t save a record to the database' do
        count_before = Product.count
        invalid_request
        count_after = Product.count
        expect(count_after).to eq(count_before)
      end
      it 'renders the new template' do
        invalid_request
        expect(response).to render_template(:new)
      end
    end
  end
  describe '#update' do
    context 'with valid params' do
      def valid_update
        signed_in
        product = FactoryGirl.create :product
        patch :update, params: { id: product.id, product: {title: 'New title!', description: product.description, price: product.price}}
        product
      end
      it 'updates a record to the database' do
        valid_update
        expect(Product.last.title).to eq('New title!')
      end

      it 'redirects to the product show page' do
        product = valid_update
        expect(response).to redirect_to(product_path(product[:id]))
      end
    end
    context 'with invalid params' do
      def invalid_request
        signed_in
        post :create, params: { product: attributes_for(:product, title: nil)}
      end
      it 'doesn\'t update a record to the database' do
        count_before = Product.count
        invalid_request
        count_after = Product.count
        expect(count_after).to eq(count_before)
      end
      it 'renders the edit template' do
        invalid_request
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#edit' do
    def valid_request
      signed_in
      product = create(:product)
      get :edit, params: { id: product.id }
      product
    end
    it 'renders edit page' do
      valid_request
      expect(response).to render_template(:edit)
    end
    it 'sets an instance variable with the product whose id is passed' do
      product = valid_request
      expect(assigns(:product)).to eq(product)
    end
  end

end
